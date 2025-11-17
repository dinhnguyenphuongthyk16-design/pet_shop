from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any

import os
import json
from pathlib import Path

import numpy as np
import pandas as pd
import joblib

from scipy.sparse import load_npz
from sklearn.preprocessing import normalize as skl_normalize

# ---------------------------------------------------------
# FastAPI app + CORS
# ---------------------------------------------------------
app = FastAPI(title="Pet Shop Recommendation API (Item-kNN + Content + Hybrid)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TODO: restrict domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------
# Global model objects (CF + Content)
# ---------------------------------------------------------
MODEL_DIR: Path = Path(__file__).resolve().parent / "model"

item_sim_dense: Optional[np.ndarray] = None
item_popularity: Optional[np.ndarray] = None
user_encoder = None          # kept for possible future use
item_encoder = None
items_catalog: Optional[pd.DataFrame] = None

vectorizer = None
X_tfidf = None               # sparse matrix (n_known_items × d)
known_items: Optional[pd.DataFrame] = None
itemid_to_row: Dict[int, int] = {}

n_items: int = 0
popular_items_sorted: Optional[np.ndarray] = None

# ---------------------------------------------------------
# Global objects for item-only cross-source recommender
# ---------------------------------------------------------
# Base path for raw CSVs (all sources). You can override with PETSHOP_DATA_DIR env var.
DATA_BASE: Path = Path(os.getenv("PETSHOP_DATA_DIR", "/kaggle/working/excel_csv"))
item_only_recsys = None      # will hold ItemOnlyRecommender instance
item_only_catalog: Optional[pd.DataFrame] = None


# =========================================================
# Helpers for CF part (your original code)
# =========================================================
def keys_to_item_ids(item_keys: List[str]) -> List[int]:
    """
    Map item_key strings to internal item_ids using item_encoder.
    Unknown keys are silently ignored.
    """
    if item_encoder is None or not item_keys:
        return []
    ids: List[int] = []
    for key in item_keys:
        try:
            iid = int(item_encoder.transform([key])[0])
            ids.append(iid)
        except Exception:
            continue
    return ids


def build_weight_vector_from_items(
    item_ids: List[int],
    weights: Optional[List[float]] = None
) -> np.ndarray:
    """
    Build a dense weight vector of length n_items from a list of item_ids
    (optionally with per-item weights).
    """
    global n_items
    w = np.zeros(n_items, dtype=np.float32)
    if not item_ids:
        return w
    if weights is None or len(weights) != len(item_ids):
        weights = [1.0] * len(item_ids)

    for iid, wi in zip(item_ids, weights):
        if 0 <= iid < n_items:
            w[iid] += float(wi)
    return w


def score_itemknn_from_weights(user_weights: np.ndarray) -> np.ndarray:
    """
    Compute item-kNN scores given a user weight vector over items.
    """
    if item_sim_dense is None:
        raise RuntimeError("Item similarity matrix is not loaded")

    if user_weights.sum() <= 0:
        # no info → return popularity
        return item_popularity.copy()

    scores = item_sim_dense @ user_weights
    return scores


def format_recommendations(
    item_ids: List[int],
    scores: np.ndarray
) -> List[Dict[str, Any]]:
    """
    Convert item_ids and scores to a list of dicts including item metadata.
    """
    global items_catalog
    if items_catalog is None:
        return []

    sub = items_catalog[items_catalog["item_id"].isin(item_ids)].copy()
    sub = sub.set_index("item_id")

    out: List[Dict[str, Any]] = []
    for iid in item_ids:
        score = float(scores[iid]) if 0 <= iid < len(scores) else 0.0
        if iid in sub.index:
            row = sub.loc[iid]
            out.append({
                "item_id": int(iid),
                "item_key": row.get("item_key"),
                "source": row.get("source"),
                "category": row.get("category"),
                "size": row.get("size"),
                "pet_type": row.get("pet_type"),
                "name": row.get("name"),
                "brand": row.get("brand"),
                "score": score,
            })
        else:
            out.append({
                "item_id": int(iid),
                "item_key": None,
                "source": None,
                "category": None,
                "size": None,
                "pet_type": None,
                "name": None,
                "brand": None,
                "score": score,
            })
    return out


# Item-only recommender (all sources, no users)

def _to_numeric_series(s: pd.Series, regex_keep: str = r"[0-9\.,]+") -> pd.Series:
    s = s.astype(str).str.extract(f"({regex_keep})", expand=False)
    s = s.str.replace(" ", "", regex=False)
    s = s.str.replace(".", "", regex=False)
    s = s.str.replace(",", ".", regex=False)
    return pd.to_numeric(s, errors="coerce")


def _minmax_norm(x: pd.Series) -> pd.Series:
    x = x.astype(float)
    xmin, xmax = np.nanmin(x), np.nanmax(x)
    if np.isfinite(xmin) and np.isfinite(xmax) and xmax > xmin:
        out = (x - xmin) / (xmax - xmin)
    else:
        out = pd.Series(np.zeros(len(x)), index=x.index, dtype=float)
    return out.fillna(0.0)


def _log1p_norm(x: pd.Series) -> pd.Series:
    return _minmax_norm(np.log1p(x.astype(float)))


def _build_tails_items() -> pd.DataFrame:
    path = DATA_BASE / "pet-food-customer-orders-online" / "pet_food_customer_orders.csv"
    if not path.exists():
        return pd.DataFrame()

    df = pd.read_csv(path)

    df["wet_tray_size_clean"] = df["wet_tray_size"].fillna("none").astype(str)
    df["pet_life_stage_at_order"] = df["pet_life_stage_at_order"].fillna("unknown").astype(str)
    df["pet_breed_size"] = df["pet_breed_size"].fillna("unknown").astype(str)
    df["pet_food_tier"] = df["pet_food_tier"].fillna("unknown").astype(str)

    df["item_key"] = (
        "tails_" +
        df["pet_food_tier"] + "|" +
        df["wet_tray_size_clean"] + "|" +
        df["pet_life_stage_at_order"] + "|" +
        df["pet_breed_size"]
    )
    df["source"] = "tails"

    grp = df.groupby("item_key", as_index=False).agg(
        n_orders=("customer_id", "nunique"),
        n_rows=("customer_id", "size"),
        total_wet_trays=("wet_trays", "sum"),
        mean_kcal=("total_order_kcal", "mean"),
        mean_discount=("wet_food_discount_percent", "mean")
    )

    orders_norm = _log1p_norm(grp["n_orders"])
    rows_norm = _log1p_norm(grp["n_rows"])
    wet_trays_norm = _log1p_norm(grp["total_wet_trays"])
    discount_norm = _minmax_norm(grp["mean_discount"].fillna(0.0))

    grp["score_tails"] = (
        0.4 * orders_norm +
        0.3 * wet_trays_norm +
        0.2 * rows_norm -
        0.1 * discount_norm
    )

    rep_cols = df.groupby("item_key").agg({
        "pet_food_tier": "first",
        "wet_tray_size_clean": "first",
        "pet_breed_size": "first",
        "pet_life_stage_at_order": "first"
    }).reset_index()

    simple = grp.merge(rep_cols, on="item_key", how="left")
    simple["source"] = "tails"
    simple["category"] = simple["pet_food_tier"]
    simple["pet_type"] = np.nan
    simple["pet_size"] = simple["pet_breed_size"]
    simple["price"] = np.nan
    simple["rating_raw"] = np.nan

    simple["title_or_name"] = (
        "Tails " + simple["pet_food_tier"] +
        " " + simple["wet_tray_size_clean"] +
        " (" + simple["pet_life_stage_at_order"] +
        ", " + simple["pet_breed_size"] + ")"
    )

    simple = simple.rename(columns={"score_tails": "global_score"})
    simple["raw_id"] = np.nan

    cols = [
        "item_key", "source", "title_or_name", "category",
        "pet_type", "pet_size", "price", "rating_raw",
        "n_orders", "n_rows", "total_wet_trays", "mean_kcal",
        "mean_discount", "global_score", "raw_id"
    ]
    return simple[cols]


def _build_store_items() -> pd.DataFrame:
    path = DATA_BASE / "pet-store-records-2020" / "pet_store_records_2020.csv"
    if not path.exists():
        return pd.DataFrame()

    df = pd.read_csv(path)
    df["item_key"] = "store_" + df["product_id"].astype(str)
    df["source"] = "store"

    rating_norm = df["rating"] / 10.0
    sales_norm = _log1p_norm(df["sales"])
    price_norm = _minmax_norm(df["price"])
    rebuy_norm = df["re_buy"].astype(float)

    df["score_store"] = (
        0.4 * rating_norm +
        0.35 * sales_norm +
        0.15 * rebuy_norm -
        0.10 * price_norm
    )

    simple = df[[
        "item_key", "source", "product_id", "product_category",
        "pet_type", "pet_size", "price", "rating", "sales", "re_buy",
        "score_store"
    ]].copy()

    simple = simple.rename(columns={
        "product_id": "raw_id",
        "product_category": "category",
        "score_store": "global_score",
        "rating": "rating_raw"
    })

    simple["title_or_name"] = (
        "Store " + simple["category"].astype(str) +
        " (" + simple["pet_type"].astype(str) + ", " +
        simple["pet_size"].astype(str) + ")"
    )
    return simple


def _build_aliexpress_items() -> pd.DataFrame:
    path = DATA_BASE / "e-commerce-pet-supplies-dataset" / "aliexpress_pet_supplies.csv"
    if not path.exists():
        return pd.DataFrame()

    df = pd.read_csv(path)
    df["item_key"] = "ali_" + df.index.astype(str)
    df["source"] = "aliexpress"

    df["avg_star"] = df["averageStar"].astype(float)
    df["trade_num"] = _to_numeric_series(df["tradeAmount"])
    df["wished"] = df["wishedCount"].astype(float)
    df["quantity"] = df["quantity"].astype(float)

    star_norm = _minmax_norm(df["avg_star"])
    trade_norm = _log1p_norm(df["trade_num"])
    wish_norm = _log1p_norm(df["wished"])
    qty_norm = _log1p_norm(df["quantity"])

    df["score_ali"] = (
        0.45 * star_norm +
        0.30 * trade_norm +
        0.15 * wish_norm +
        0.10 * qty_norm
    )

    simple = df[[
        "item_key", "source", "title",
        "avg_star", "trade_num", "wished", "quantity", "score_ali"
    ]].copy()

    simple = simple.rename(columns={
        "title": "title_or_name",
        "score_ali": "global_score"
    })

    simple["rating_raw"] = simple["avg_star"]
    simple["price"] = np.nan
    simple["category"] = np.nan
    simple["pet_type"] = np.nan
    simple["pet_size"] = np.nan
    simple["raw_id"] = np.nan
    return simple


def _build_chewy_items() -> pd.DataFrame:
    path = DATA_BASE / "chewy-data" / "chewy_scraper_sample.csv"
    if not path.exists():
        return pd.DataFrame()

    df = pd.read_csv(path)
    df["item_key"] = "chewy_" + df["sku"].astype(str)
    df["source"] = "chewy"

    df["price_val"] = _to_numeric_series(df["Price"])
    df["rating_val"] = df["average_rating"].astype(float)
    df["reviews_val"] = df["reviews_count"].fillna(0).astype(float)

    rating_norm = _minmax_norm(df["rating_val"])
    reviews_norm = _log1p_norm(df["reviews_val"])
    price_norm = _minmax_norm(df["price_val"])

    df["score_chewy"] = (
        0.5 * rating_norm +
        0.35 * reviews_norm -
        0.15 * price_norm
    )

    simple = df[[
        "item_key", "source", "name", "brand", "breadcrumb",
        "price_val", "rating_val", "reviews_val", "score_chewy"
    ]].copy()

    simple = simple.rename(columns={
        "name": "title_or_name",
        "price_val": "price",
        "rating_val": "rating_raw",
        "score_chewy": "global_score",
        "breadcrumb": "category"
    })

    simple["pet_type"] = np.nan
    simple["pet_size"] = np.nan
    simple["raw_id"] = df["sku"].astype(str)
    return simple


def _build_amazon_items() -> pd.DataFrame:
    path = DATA_BASE / "amazon-pet-supplies-data" / "amazon_pet_supplies_dataset_sample.csv"
    if not path.exists():
        return pd.DataFrame()

    df = pd.read_csv(path)
    df["item_key"] = "amz_" + df["asin"].astype(str)
    df["source"] = "amazon"

    df["price_val"] = _to_numeric_series(df["price"])
    rating = pd.Series(np.zeros(len(df)), index=df.index, dtype=float)

    price_norm = _minmax_norm(df["price_val"])
    rating_norm = rating  # zeros

    df["score_amz"] = (
        0.2 * rating_norm -
        0.8 * price_norm
    )

    simple = df[[
        "item_key", "source", "title", "brand",
        "breadcrumbs", "price_val", "score_amz"
    ]].copy()

    simple = simple.rename(columns={
        "title": "title_or_name",
        "price_val": "price",
        "score_amz": "global_score",
        "breadcrumbs": "category"
    })

    simple["rating_raw"] = rating
    simple["pet_type"] = np.nan
    simple["pet_size"] = np.nan
    simple["raw_id"] = df["asin"].astype(str)
    return simple


def build_item_only_catalog() -> pd.DataFrame:
    tails_items = _build_tails_items()
    store_items = _build_store_items()
    ali_items = _build_aliexpress_items()
    chewy_items = _build_chewy_items()
    amz_items = _build_amazon_items()

    frames = [tails_items, store_items, ali_items, chewy_items, amz_items]
    frames = [f for f in frames if not f.empty]

    if not frames:
        return pd.DataFrame()

    all_items = pd.concat(frames, ignore_index=True, sort=False)

    all_items["source_score_norm"] = (
        all_items.groupby("source")["global_score"]
        .transform(lambda x: _minmax_norm(x))
    )

    all_items["final_score"] = (
        0.5 * _minmax_norm(all_items["global_score"]) +
        0.5 * all_items["source_score_norm"]
    )
    return all_items


class ItemOnlyRecommender:
    """Pure item-only (no users), ranking by final_score with simple filters."""
    def __init__(self, items_df: pd.DataFrame):
        self.items = items_df.copy()
        self.items = self.items.replace([np.inf, -np.inf], np.nan)
        self.items["final_score"] = self.items["final_score"].fillna(0.0)

    def recommend_global(
        self,
        N: int = 10,
        source: Optional[str] = None,
        max_price: Optional[float] = None,
        pet_type: Optional[str] = None,
    ) -> pd.DataFrame:
        df = self.items

        if source is not None:
            df = df[df["source"] == source]

        if max_price is not None:
            df = df[(df["price"].notna()) & (df["price"] <= max_price)]

        if pet_type is not None:
            pt = pet_type.lower()
            mask = (
                df["pet_type"].fillna("").str.lower().str.contains(pt) |
                df["category"].fillna("").str.lower().str.contains(pt) |
                df["title_or_name"].fillna("").str.lower().str.contains(pt)
            )
            df = df[mask]

        df = df.sort_values("final_score", ascending=False)
        return df.head(N).reset_index(drop=True)


def load_item_only_models() -> bool:
    """Load item-only cross-source catalog + recommender."""
    global item_only_recsys, item_only_catalog

    try:
        catalog = build_item_only_catalog()
        if catalog.empty:
            print("⚠️ Item-only catalog is empty; check DATA_BASE:", DATA_BASE)
            item_only_recsys = None
            item_only_catalog = None
            return False

        item_only_catalog = catalog
        item_only_recsys = ItemOnlyRecommender(catalog)
        print(f"✅ Item-only recommender loaded from CSVs at {DATA_BASE}, n_items={len(catalog)}")
        return True
    except Exception as e:
        print(f"❌ Error loading item-only recommender: {e}")
        item_only_recsys = None
        item_only_catalog = None
        return False


def _global_itemonly_recs(k: int = 10) -> List[Dict[str, Any]]:

    if item_only_recsys is None or item_only_catalog is None:
        return []

    df = item_only_recsys.recommend_global(N=k)
    out: List[Dict[str, Any]] = []
    for _, row in df.iterrows():
        out.append({
            "item_id": None,  # no CF-trained id for cross-source items
            "item_key": row.get("item_key"),
            "source": row.get("source"),
            "category": row.get("category"),
            "size": row.get("pet_size"),        # map pet_size to 'size'
            "pet_type": row.get("pet_type"),
            "name": row.get("title_or_name"),
            "brand": None,                      # could be added if you want
            "score": float(row.get("final_score", 0.0)),
        })
    return out


def _hybrid_merge(
    cf_recs: List[Dict[str, Any]],
    global_recs: List[Dict[str, Any]],
    k: int
) -> List[Dict[str, Any]]:

    if not global_recs:
        return cf_recs[:k]

    seen_keys = set()
    out: List[Dict[str, Any]] = []

    # First, CF-based list
    for r in cf_recs:
        key = r.get("item_key")
        if key and key not in seen_keys:
            out.append(r)
            seen_keys.add(key)
        if len(out) >= k:
            return out

    # Then, global item-only list (all sources)
    for r in global_recs:
        key = r.get("item_key")
        if key and key in seen_keys:
            continue
        out.append(r)
        if key:
            seen_keys.add(key)
        if len(out) >= k:
            break

    return out


# Recommendation methods (3 modes) with hybrid logic

def recommend_user_history(
    history_item_keys: List[str],
    k: int = 10
) -> List[Dict[str, Any]]:

    item_ids = keys_to_item_ids(history_item_keys)
    has_history = len(item_ids) > 0

    # No valid history → use global item-only first
    if not has_history:
        hybrid = _global_itemonly_recs(k=k)
        if hybrid:
            return hybrid
        # fallback: your original popularity logic
        top_idx = popular_items_sorted[:k].tolist()
        scores = item_popularity
        return format_recommendations(top_idx, scores)

    # CF-based part
    user_weights = build_weight_vector_from_items(item_ids)
    scores = score_itemknn_from_weights(user_weights)
    scores[item_ids] = -np.inf  # avoid recommending already-seen items
    top_idx = np.argsort(-scores)[:k * 2].tolist()  # get a bit more for mixing
    cf_recs = format_recommendations(top_idx, scores)

    # Item-only part
    global_recs = _global_itemonly_recs(k=k * 2)

    # Hybrid mix
    return _hybrid_merge(cf_recs, global_recs, k)


def recommend_from_clicks(
    clicked_item_keys: List[str],
    click_weights: Optional[List[float]] = None,
    k: int = 10
) -> List[Dict[str, Any]]:

    item_ids = keys_to_item_ids(clicked_item_keys)
    has_clicks = len(item_ids) > 0

    if not has_clicks:
        hybrid = _global_itemonly_recs(k=k)
        if hybrid:
            return hybrid
        top_idx = popular_items_sorted[:k].tolist()
        scores = item_popularity
        return format_recommendations(top_idx, scores)

    user_weights = build_weight_vector_from_items(item_ids, click_weights)
    scores = score_itemknn_from_weights(user_weights)
    scores[item_ids] = -np.inf
    top_idx = np.argsort(-scores)[:k * 2].tolist()
    cf_recs = format_recommendations(top_idx, scores)

    global_recs = _global_itemonly_recs(k=k * 2)
    return _hybrid_merge(cf_recs, global_recs, k)


def recommend_from_text(
    text_query: str,
    k: int = 10
) -> List[Dict[str, Any]]:

    global vectorizer, X_tfidf, known_items, itemid_to_row

    if vectorizer is None or X_tfidf is None or known_items is None:
        raise RuntimeError("TF-IDF models are not loaded")

    if not text_query.strip():
        top_idx = popular_items_sorted[:k].tolist()
        scores = item_popularity
        return format_recommendations(top_idx, scores)

    q = vectorizer.transform([text_query])
    q = skl_normalize(q)
    scores_known = (X_tfidf @ q.T)
    scores_known = np.asarray(scores_known.todense()).ravel()

    known_item_ids = known_items["item_id"].to_numpy().astype(int)
    scores_full = np.zeros(n_items, dtype=np.float32)
    for local_idx, iid in enumerate(known_item_ids):
        if 0 <= iid < n_items:
            scores_full[iid] = scores_known[local_idx]

    top_idx = np.argsort(-scores_full)[:k].tolist()
    return format_recommendations(top_idx, scores_full)


# 
# Load models at startup
# 
def load_models() -> bool:
    global item_sim_dense, item_popularity
    global user_encoder, item_encoder, items_catalog
    global vectorizer, X_tfidf, known_items, itemid_to_row
    global n_items, popular_items_sorted

    try:
        # 1) Load Item-kNN model
        npz_path = MODEL_DIR / "itemknn_model.npz"
        if not npz_path.exists():
            raise FileNotFoundError(f"{npz_path} not found")

        npz = np.load(npz_path)
        item_sim_dense = npz["item_sim_dense"]
        item_popularity = npz["item_popularity"]

        n_items = item_sim_dense.shape[0]
        popular_items_sorted = np.argsort(-item_popularity)

        # 2) Load encoders + catalog
        user_encoder = joblib.load(MODEL_DIR / "user_encoder.pkl")
        item_encoder = joblib.load(MODEL_DIR / "item_encoder.pkl")
        items_catalog = pd.read_parquet(MODEL_DIR / "items_catalog.parquet")

        # 3) Load TF-IDF content model
        vectorizer = joblib.load(MODEL_DIR / "tfidf_vectorizer.pkl")
        X_tfidf = load_npz(MODEL_DIR / "X_tfidf.npz")
        known_items = pd.read_parquet(MODEL_DIR / "known_items.parquet")

        known_items = known_items.reset_index(drop=True)
        itemid_to_row = {
            int(row.item_id): int(i) for i, row in known_items.iterrows()
        }

        print("✅ CF + TF-IDF models loaded from", MODEL_DIR)
        print(f"   n_items={n_items}, X_tfidf shape={X_tfidf.shape}")
        return True

    except Exception as e:
        print(f"❌ Error loading CF/TF-IDF models: {e}")
        return False


@app.on_event("startup")
async def on_startup():
    cf_ok = load_models()
    item_only_ok = load_item_only_models()
    print(f"Startup status → CF: {cf_ok}, Item-only: {item_only_ok}")


# 
# API Models
# 
class RecommendationRequest(BaseModel):

    mode: str = "user"   # "user" | "click" | "text"

    user_id: Optional[str] = None

    history_item_keys: Optional[List[str]] = None
    clicked_item_keys: Optional[List[str]] = None
    click_weights: Optional[List[float]] = None

    text_query: Optional[str] = None

    k: int = 10


class RecommendationResponse(BaseModel):
    recommendations: List[Dict[str, Any]]
    success: bool
    message: str


# 
# Endpoints (unchanged from your API surface)
# 
@app.get("/")
async def root():
    return {"message": "Pet Shop Recommendation API (Item-kNN + Content + Hybrid)",
            "status": "running"}


@app.get("/health")
async def health():
    return {
        "status": "healthy" if item_sim_dense is not None else "uninitialized",
        "models_loaded": item_sim_dense is not None,
        "n_items": int(n_items),
        "item_only_loaded": item_only_recsys is not None,
    }


@app.post("/recommend", response_model=RecommendationResponse)
async def recommend(request: RecommendationRequest):
    if item_sim_dense is None:
        raise HTTPException(status_code=503, detail="Models not loaded")

    try:
        mode = request.mode.lower().strip()
        if mode == "user":
            recs = recommend_user_history(
                history_item_keys=request.history_item_keys or [],
                k=request.k
            )
            msg = "User-history-based hybrid recommendations generated"
        elif mode == "click":
            recs = recommend_from_clicks(
                clicked_item_keys=request.clicked_item_keys or [],
                click_weights=request.click_weights,
                k=request.k
            )
            msg = "Click/session-based hybrid recommendations generated"
        elif mode == "text":
            if not request.text_query:
                raise HTTPException(
                    status_code=400,
                    detail="text_query is required for mode='text'"
                )
            recs = recommend_from_text(
                text_query=request.text_query,
                k=request.k
            )
            msg = "Text-based recommendations generated"
        else:
            raise HTTPException(
                status_code=400,
                detail=f"Unknown mode '{request.mode}', must be 'user', 'click' or 'text'."
            )

        return RecommendationResponse(
            recommendations=recs,
            success=True,
            message=msg
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,
                            detail=f"Error generating recommendations: {str(e)}")


@app.post("/recommend/batch")
async def recommend_batch(requests: List[RecommendationRequest]):
    """
    Batch version: send an array of RecommendationRequest objects.
    Each will be processed independently.
    """
    if item_sim_dense is None:
        raise HTTPException(status_code=503, detail="Models not loaded")

    results = []
    for req in requests:
        try:
            mode = req.mode.lower().strip()
            if mode == "user":
                recs = recommend_user_history(
                    history_item_keys=req.history_item_keys or [],
                    k=req.k
                )
                msg = "User-history-based hybrid recommendations generated"
            elif mode == "click":
                recs = recommend_from_clicks(
                    clicked_item_keys=req.clicked_item_keys or [],
                    click_weights=req.click_weights,
                    k=req.k
                )
                msg = "Click/session-based hybrid recommendations generated"
            elif mode == "text":
                if not req.text_query:
                    raise ValueError("text_query is required for mode='text'")
                recs = recommend_from_text(
                    text_query=req.text_query,
                    k=req.k
                )
                msg = "Text-based recommendations generated"
            else:
                raise ValueError(f"Unknown mode '{req.mode}'")

            results.append({
                "user_id": req.user_id,
                "mode": req.mode,
                "success": True,
                "message": msg,
                "recommendations": recs,
            })
        except Exception as e:
            results.append({
                "user_id": req.user_id,
                "mode": req.mode,
                "success": False,
                "message": str(e),
                "recommendations": [],
            })

    return {"results": results}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8081)

#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Config
# ============================================================

# ASP.NET MVC app (where /api/Chatbot/send-message lives)
# Your run_pet_shop.sh starts it on http://localhost:5115
DOTNET_BASE="${DOTNET_BASE:-http://localhost:5115}"

# Python recommendation API (FastAPI)
REC_BASE="${REC_BASE:-http://127.0.0.1:8081}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FE_DIR="$ROOT_DIR/PET SHOP/Code/Pet_Shop/Pet_Shop"

echo "================================================================"
echo " PET SHOP RECOMMENDATION API CHECK"
echo " Root dir: $ROOT_DIR"
echo " ASP.NET base: $DOTNET_BASE"
echo " Rec API base: $REC_BASE"
echo "================================================================"
echo

section() {
  echo
  echo "----------------------------------------------------------------"
  echo "$1"
  echo "----------------------------------------------------------------"
}

curl_json() {
  local method="$1"; shift
  local url="$1"; shift
  local data="${1:-}"

  echo
  echo ">>> $method $url"
  if [[ "$method" == "GET" ]]; then
    curl -i -s "$url" || echo " (curl error)"
  else
    curl -i -s \
      -H "Content-Type: application/json" \
      -X "$method" \
      -d "$data" \
      "$url" || echo " (curl error)"
  fi
  echo
}

# ============================================================
# 1) FE entry points that TRIGGER recommendation (Chatbot, etc.)
#    → Which files in FE are responsible
# ============================================================
section "1) FE endpoints that trigger recommendations (Chatbot, etc.)"

if [[ -d "$FE_DIR" ]]; then
  echo "[INFO] Looking in Razor views + JS under:"
  echo "       $FE_DIR"
  echo

  # Where FE calls the chatbot API (which then calls the rec API server-side)
  echo ">>> Places where FE calls /api/Chatbot/send-message"
  echo
  grep -R --line-number "/api/Chatbot/send-message" "$FE_DIR" \
    --include="*.cshtml" --include="*.js" 2>/dev/null \
    || echo "  (no FE calls to /api/Chatbot/send-message found)"
  echo

  # Any other FE references to 'Chatbot' that might be related
  echo ">>> Other FE references to 'Chatbot' (for context)"
  echo
  grep -R --line-number "Chatbot" "$FE_DIR" \
    --include="*.cshtml" --include="*.js" 2>/dev/null \
    || echo "  (no extra Chatbot references found)"
  echo

  # Any FE mentions of 'recommend' (in case you wire directly later)
  echo ">>> FE mentions of 'recommend' (JS/Razor only)"
  echo
  grep -R --line-number "recommend" "$FE_DIR" \
    --include="*.cshtml" --include="*.js" 2>/dev/null \
    || echo "  (no FE-side 'recommend' strings found)"
  echo
else
  echo "⚠️ FE directory not found at: $FE_DIR"
fi

echo
echo "[SUMMARY] From this section:"
echo " - Any line with /api/Chatbot/send-message is where FE triggers recommendations."
echo " - If your recommendations behave strangely from the browser,"
echo "   these FE files are the ENTRY POINTS you need to check."

# ============================================================
# 2) Backend C# that CALLS the Python recommendation API
#    → This is usually where 'wrong' JSON is built.
# ============================================================
section "2) Backend C# code that calls the Python recommendation API"

BACKEND_ROOT="$FE_DIR"

if [[ -d "$BACKEND_ROOT" ]]; then
  echo "[INFO] Searching C# for calls to 127.0.0.1:8081 and /recommend"
  echo "       (Controllers, Services, Scripts)"
  echo

  grep -R --line-number -E "127\.0\.0\.1:8081|/recommend\b" "$BACKEND_ROOT" \
    --include="*.cs" --include="*.cshtml" --include="*.js" 2>/dev/null \
    || echo "  (no explicit calls to 127.0.0.1:8081 or /recommend found)"
else
  echo "⚠️ Backend directory not found at: $BACKEND_ROOT"
fi

echo
echo "[HOW TO READ THIS]"
echo " - Lines above show EXACT files/lines where C# or Razor mentions"
echo "   the FastAPI base URL or the /recommend endpoint."
echo " - These files are the most likely place where your JSON payload"
echo "   might be 'wrong' (missing fields, wrong names, etc.)."

# ============================================================
# 3) Direct tests against Python Recommendation API
#    → Confirms FastAPI behaves as expected independently.
# ============================================================
section "3) Direct tests against Python Recommendation API"

# 3.1 root
section "3.1 GET / (root)"
curl_json GET "$REC_BASE/"

# 3.2 health
section "3.2 GET /health"
curl_json GET "$REC_BASE/health"

# 3.3 mode=user
section "3.3 POST /recommend (mode=user – history-based hybrid)"
USER_BODY='{
  "mode": "user",
  "user_id": "demo_user_1",
  "history_item_keys": ["store_101", "store_202"],
  "k": 5
}'
curl_json POST "$REC_BASE/recommend" "$USER_BODY"

# 3.4 mode=click
section "3.4 POST /recommend (mode=click – session-based hybrid)"
CLICK_BODY='{
  "mode": "click",
  "user_id": "session_abc",
  "clicked_item_keys": ["store_303", "chewy_12345"],
  "click_weights": [1.0, 3.0],
  "k": 5
}'
curl_json POST "$REC_BASE/recommend" "$CLICK_BODY"

# 3.5 mode=text
section "3.5 POST /recommend (mode=text – TF-IDF)"
TEXT_BODY='{
  "mode": "text",
  "user_id": "anon_text_user",
  "text_query": "grain-free dry dog food for small breeds",
  "k": 5
}'
curl_json POST "$REC_BASE/recommend" "$TEXT_BODY"

# 3.6 bad text (should 400)
section "3.6 POST /recommend (mode=text but missing text_query – expect 400)"
BAD_TEXT_BODY='{
  "mode": "text",
  "user_id": "bad_case",
  "k": 3
}'
curl_json POST "$REC_BASE/recommend" "$BAD_TEXT_BODY"

# 3.7 bad mode (should 400)
section "3.7 POST /recommend (unknown mode – expect 400)"
BAD_MODE_BODY='{
  "mode": "abc",
  "k": 3
}'
curl_json POST "$REC_BASE/recommend" "$BAD_MODE_BODY"

# 3.8 batch
section "3.8 POST /recommend/batch – mixed modes"
BATCH_BODY='[
  {
    "mode": "user",
    "user_id": "batch_user_1",
    "history_item_keys": ["store_101"],
    "k": 3
  },
  {
    "mode": "click",
    "user_id": "batch_user_2",
    "clicked_item_keys": ["chewy_999"],
    "click_weights": [2.0],
    "k": 3
  },
  {
    "mode": "text",
    "user_id": "batch_user_3",
    "text_query": "cat litter",
    "k": 3
  }
]'
curl_json POST "$REC_BASE/recommend/batch" "$BATCH_BODY"

# ============================================================
# 4) Optional: full chain test ASP.NET → /api/Chatbot/send-message
#    This shows if the server-side bridge to FastAPI is working.
# ============================================================
section "4) Optional – test ASP.NET /api/Chatbot/send-message → rec API"

CHAT_BODY='{"message":"Hello from check_reco_api.sh"}'
curl_json POST "$DOTNET_BASE/api/Chatbot/send-message" "$CHAT_BODY"

echo
echo "================================================================"
echo " Done."
echo " - Section 1 shows which FE files trigger recommendations."
echo " - Section 2 shows which backend files call the Python rec API."
echo "   Those are the places that can be 'wrong' in JSON or URL."
echo " - Sections 3–4 confirm whether FastAPI itself and the ASP.NET"
echo "   bridge are behaving correctly."
echo "================================================================"

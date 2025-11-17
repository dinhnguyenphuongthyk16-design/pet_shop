#!/usr/bin/env bash
set -euo pipefail

echo "🐾 HyHy Pet Shop full stack launcher (ASP.NET + Python rec API)"

# ----------------------------------
# 0) Locate project dirs
# ----------------------------------
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

APP_DIR="$SCRIPT_DIR/PET SHOP/Code/Pet_Shop/Pet_Shop"
PROJECT_FILE="$APP_DIR/Pet_Shop.csproj"

API_DIR="$SCRIPT_DIR/PET SHOP/Code/AI_chatbot_train"
REQ_FILE="$API_DIR/requirements.txt"
VENV_DIR="$API_DIR/.venv"

if [ ! -d "$APP_DIR" ]; then
  echo "❌ Cannot find ASP.NET project directory:"
  echo "   $APP_DIR"
  exit 1
fi

if [ ! -f "$PROJECT_FILE" ]; then
  echo "❌ Cannot find project file:"
  echo "   $PROJECT_FILE"
  exit 1
fi

if [ ! -d "$API_DIR" ]; then
  echo "❌ Cannot find AI_chatbot_train directory:"
  echo "   $API_DIR"
  exit 1
fi

if [ ! -f "$REQ_FILE" ]; then
  echo "❌ Cannot find requirements.txt for Python API:"
  echo "   $REQ_FILE"
  exit 1
fi

# ----------------------------------
# 1) Detect TargetFramework (e.g. net7.0 → 7.0)
# ----------------------------------
tfm_line="$(grep -m1 '<TargetFramework>' "$PROJECT_FILE" || true)"
if [ -z "$tfm_line" ]; then
  echo "⚠️  Cannot detect <TargetFramework> from Pet_Shop.csproj, defaulting to net7.0"
  REQUIRED_TFM="net7.0"
else
  REQUIRED_TFM="$(echo "$tfm_line" | sed -E 's/.*<TargetFramework>([^<]+)<\/TargetFramework>.*/\1/')"
fi

REQUIRED_RUNTIME="$(echo "$REQUIRED_TFM" | sed -E 's/^net([0-9]+(\.[0-9]+)?).*/\1/')"

echo "📦 Detected TargetFramework: $REQUIRED_TFM"
echo "📦 Required .NET runtime:    $REQUIRED_RUNTIME"

# ----------------------------------
# 2) Helper: ensure a given .NET runtime exists
# ----------------------------------
ensure_dotnet_runtime() {
  local ver="$1"

  if ! command -v dotnet >/dev/null 2>&1; then
    echo "❌ 'dotnet' command not found. Please install .NET SDK first:"
    echo "   https://learn.microsoft.com/dotnet/core/install/linux-ubuntu"
    exit 1
  fi

  if dotnet --list-runtimes 2>/dev/null | grep -q "Microsoft.NETCore.App $ver"; then
    echo "✅ .NET runtime $ver already installed."
    return 0
  fi

  echo "⚠️  .NET runtime $ver not found. Installing (requires sudo)..."

  # 2.1 Add Microsoft package feed for Ubuntu 20.04 if missing
  if ! ls /etc/apt/sources.list.d 2>/dev/null | grep -qi 'microsoft.*prod'; then
    echo "📥 Adding Microsoft package repository for Ubuntu 20.04..."
    wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb >/dev/null
    rm /tmp/packages-microsoft-prod.deb
  else
    echo "🔎 Microsoft package repository already configured."
  fi

  echo "🔄 Updating apt cache..."
  sudo apt-get update -y >/dev/null

  echo "📦 Installing aspnetcore-runtime-$ver and dotnet-runtime-$ver ..."
  if ! sudo apt-get install -y "aspnetcore-runtime-$ver" "dotnet-runtime-$ver"; then
    echo "❌ Failed to install .NET runtime $ver via apt."
    echo "   You may need to download and install it manually from:"
    echo "   https://dotnet.microsoft.com/en-us/download/dotnet/$ver"
    exit 1
  fi

  echo "✅ Successfully installed .NET $ver runtime."
}

# ----------------------------------
# 3) Python venv + deps for rec API
# ----------------------------------
ensure_python_env() {
  echo "🐍 Ensuring Python venv for recommendation API..."

  if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ python3 not found. Please install Python 3."
    exit 1
  fi

  local first_time="false"

  if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating virtualenv at $VENV_DIR"
    python3 -m venv "$VENV_DIR"
    first_time="true"
  else
    echo "✅ Virtualenv already exists at $VENV_DIR"
  fi

  # shellcheck source=/dev/null
  source "$VENV_DIR/bin/activate"

  # If venv is new → install everything
  if [ "$first_time" = "true" ]; then
    echo "📦 First time setup: upgrading pip and installing requirements..."
    python -m pip install --upgrade pip
    pip install -r "$REQ_FILE"
    echo "✅ Python env ready (fresh setup)."
    deactivate
    return 0
  fi

  # For existing venv, test whether required libs are importable
  echo "🔍 Checking installed Python packages in existing venv..."
  if python - << 'PY'
import importlib, sys

required = [
    "fastapi",
    "uvicorn",
    "numpy",
    "pandas",
    "sklearn",
    "scipy",
    "joblib",
    "pyarrow",
]

missing = []
for pkg in required:
    try:
        importlib.import_module(pkg)
    except Exception:
        missing.append(pkg)

if missing:
    print("Missing packages:", ", ".join(missing))
    sys.exit(1)
else:
    print("All required packages are importable.")
PY
  then
    echo "✅ Python env already has all required packages. Skipping reinstall."
    deactivate
    return 0
  else
    echo "⚠️ Some Python packages are missing or broken. Installing from $REQ_FILE ..."
    python -m pip install --upgrade pip
    pip install -r "$REQ_FILE"
    echo "✅ Python env repaired."
    deactivate
    return 0
  fi
}

PY_API_PID=""

start_python_api() {
  echo "🚀 Starting Python Recommendation API (FastAPI + Uvicorn)..."
  # shellcheck source=/dev/null
  source "$VENV_DIR/bin/activate"

  cd "$API_DIR"
  # Use uvicorn to run your app (recommendation_api.py)
  uvicorn recommendation_api:app --host 0.0.0.0 --port 8081 &
  PY_API_PID=$!

  deactivate

  echo "🐍 Python API PID: $PY_API_PID"
}

cleanup() {
  if [ -n "${PY_API_PID:-}" ]; then
    echo "🧹 Stopping Python API (PID=$PY_API_PID)..."
    kill "$PY_API_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

wait_for_api() {
  echo "⏳ Waiting for FastAPI rec server on http://127.0.0.1:8081/health ..."
  local max_tries=30
  local i=0
  while [ $i -lt $max_tries ]; do
    if curl -sSf http://127.0.0.1:8081/health >/dev/null 2>&1; then
      echo "✅ FastAPI server is up."
      return 0
    fi
    i=$((i+1))
    sleep 1
  done
  echo "❌ FastAPI server did not become ready in time."
  return 1
}

test_recommendation_api() {
  if ! command -v curl >/dev/null 2>&1; then
    echo "⚠️  curl not found, skipping API tests."
    return 0
  fi

  echo "🧪 Testing Recommendation API endpoints..."

  echo "→ GET /health"
  if ! curl -sS http://127.0.0.1:8081/health; then
    echo -e "\n❌ /health request failed."
    return 1
  fi
  echo -e "\n✅ /health OK\n"

  echo "→ POST /recommend (mode='text')"
  if ! curl -sS -X POST "http://127.0.0.1:8081/recommend" \
    -H "Content-Type: application/json" \
    -d '{
      "mode": "text",
      "text_query": "grain free dog food",
      "k": 3
    }'; then
    echo -e "\n❌ /recommend (text) request failed."
    return 1
  fi
  echo -e "\n✅ /recommend (text) OK\n"

  echo "→ POST /recommend (mode='user') with dummy history"
  if ! curl -sS -X POST "http://127.0.0.1:8081/recommend" \
    -H "Content-Type: application/json" \
    -d '{
      "mode": "user",
      "history_item_keys": ["dummy_item_key_1", "dummy_item_key_2"],
      "k": 3
    }'; then
    echo -e "\n❌ /recommend (user) request failed."
    return 1
  fi
  echo -e "\n✅ /recommend (user) OK (or at least responded)\n"

  echo "→ POST /recommend (mode='click') with dummy clicks"
  if ! curl -sS -X POST "http://127.0.0.1:8081/recommend" \
    -H "Content-Type: application/json" \
    -d '{
      "mode": "click",
      "clicked_item_keys": ["dummy_clicked_item"],
      "click_weights": [1.0],
      "k": 3
    }'; then
    echo -e "\n❌ /recommend (click) request failed."
    return 1
  fi
  echo -e "\n✅ /recommend (click) OK (or at least responded)\n"

  echo "🎉 Recommendation API auto-tests finished."
}

# ----------------------------------
# 4) Run everything
# ----------------------------------
ensure_dotnet_runtime "$REQUIRED_RUNTIME"
ensure_python_env

# Start Python API in background
start_python_api

# Wait for API and run tests
if wait_for_api; then
  test_recommendation_api || echo "⚠️ Some API tests failed; check logs above."
else
  echo "⚠️ Skipping tests because API did not start correctly."
fi

# Finally run ASP.NET app in foreground
echo "📁 Switching to ASP.NET project directory:"
cd "$APP_DIR"
pwd

echo "🧩 Restoring .NET packages..."
dotnet restore

# Optional: force app URLs
export ASPNETCORE_URLS="https://localhost:7000;http://localhost:5000"
export ASPNETCORE_ENVIRONMENT=Development

echo "🚀 Starting HyHy Pet Shop ASP.NET app..."
echo "   → Open: http://localhost:5115"
dotnet run

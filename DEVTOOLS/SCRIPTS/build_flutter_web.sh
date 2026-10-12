#!/bin/bash
set -e

echo "=== TRUTHPRENUER FLUTTER WEB BUILD ==="

# Check if flutter is installed; if not, download shallow stable channel
if ! command -v flutter &> /dev/null; then
  echo "Flutter not detected in build environment. Installing shallow stable channel..."
  if [ ! -d "$HOME/flutter" ]; then
    git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$HOME/flutter"
  fi
  export PATH="$PATH:$HOME/flutter/bin"
fi

echo "Flutter version:"
flutter --version

# Disable analytics and precache web artifacts
flutter config --no-analytics
flutter precache --web

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
USERS_DIR="${ROOT_DIR}/USERS"
cd "${USERS_DIR}"

echo "Compiling Flutter Web release..."
DART_DEFINES=()
if [ -n "$SUPABASE_URL" ]; then
  DART_DEFINES+=(--dart-define="SUPABASE_URL=${SUPABASE_URL}")
fi
if [ -n "$SUPABASE_ANON_KEY" ]; then
  DART_DEFINES+=(--dart-define="SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}")
fi
if [ -n "$GEMINI_API_KEY" ]; then
  DART_DEFINES+=(--dart-define="GEMINI_API_KEY=${GEMINI_API_KEY}")
fi

flutter build web --release "${DART_DEFINES[@]}"

# Ensure Cloudflare Pages SPA redirect rule exists in build/web
if [ ! -f "build/web/_redirects" ]; then
  echo "/*    /index.html   200" > build/web/_redirects
fi

echo "=== BUILD SUCCESSFUL ==="

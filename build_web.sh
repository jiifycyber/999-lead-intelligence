#!/bin/bash
set -e

echo "========================================"
echo " BUILDING 999 LEAD INTELLIGENCE"
echo "========================================"

if [ ! -f ".env.deploy" ]; then
  echo "ERROR: .env.deploy missing"
  exit 1
fi

set -a
source .env.deploy
set +a

if [ -z "$SUPABASE_URL" ]; then
  echo "ERROR: SUPABASE_URL missing"
  exit 1
fi

if [ -z "$SUPABASE_PUBLISHABLE_KEY" ]; then
  echo "ERROR: SUPABASE_PUBLISHABLE_KEY missing"
  exit 1
fi

echo "Supabase URL: LOADED"
echo "Supabase publishable key: LOADED"

flutter clean
flutter pub get

flutter build web \
  --release \
  --base-href "/999-lead-intelligence/" \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_PUBLISHABLE_KEY"

echo ""
echo "========================================"
echo " WEB BUILD SUCCESSFUL"
echo "========================================"
echo "Output: build/web"

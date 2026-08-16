#!/bin/zsh
set -e

set -a
source .env.deploy
set +a

if [[ -z "$SUPABASE_URL" ]]; then
  echo "ERROR: SUPABASE_URL is missing"
  exit 1
fi

if [[ -z "$SUPABASE_PUBLISHABLE_KEY" ]]; then
  echo "ERROR: SUPABASE_PUBLISHABLE_KEY is missing"
  exit 1
fi

echo "✓ Supabase URL loaded"
echo "✓ Supabase publishable key loaded"
echo "✓ Starting 999 Lead Intelligence..."

flutter run -d chrome \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_PUBLISHABLE_KEY"

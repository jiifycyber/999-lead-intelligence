# Lead Generation Pro

A connected Flutter starter application for lead generation, CRM, marketing, SEO, automation, communications, analytics, administration and integrations.

## What is wired now
- Flutter app entry point and theme
- Dashboard navigation to all major modules
- Lead model + Supabase-backed LeadService
- Supabase initialization via dart-define
- Database starter schema
- AI and communications service boundaries
- Mobile/web-ready Flutter layout

## External integrations
The project is connection-ready, but private service credentials are intentionally NOT embedded. Twilio, CallRail, OpenAI/AI providers, Google Ads, Meta, WordPress and payment providers should be called through secure backend/Supabase Edge Functions.

## Run
1. Install Flutter.
2. `flutter pub get`
3. Create a Supabase project and run `supabase/schema.sql`.
4. Run:
   `flutter run --dart-define=SUPABASE_URL=YOUR_URL --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY`

## Web build
`flutter build web --release --dart-define=SUPABASE_URL=YOUR_URL --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY`

## Important
This is a substantial connected application scaffold, not a claim that third-party paid accounts or API credentials have already been provisioned. Those require your actual provider accounts/credentials.

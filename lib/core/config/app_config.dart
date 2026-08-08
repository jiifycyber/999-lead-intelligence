class AppConfig {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const twilioEnabled = bool.fromEnvironment('TWILIO_ENABLED', defaultValue: false);
  static const callRailEnabled = bool.fromEnvironment('CALLRAIL_ENABLED', defaultValue: false);
}

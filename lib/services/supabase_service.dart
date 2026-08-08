import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/app_config.dart';
class SupabaseService {
  static bool get configured => AppConfig.supabaseUrl.isNotEmpty && AppConfig.supabaseAnonKey.isNotEmpty;
  static SupabaseClient? get client => configured ? Supabase.instance.client : null;
}

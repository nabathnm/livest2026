import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const supabaseUrl = 'https://kktruowghwbltqrwcden.supabase.co';
  static const anonKey = 'sb_publishable_6djwNuOhXt5RVIy3b5mp1Q_XP45LA2x';

  static SupabaseClient get client => Supabase.instance.client;
}

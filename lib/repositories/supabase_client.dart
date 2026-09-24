import 'package:supabase_flutter/supabase_flutter.dart';

/// Safe accessor for Supabase client. Returns null if Supabase was never initialized.
SupabaseClient? get safeSupabaseClient {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
}

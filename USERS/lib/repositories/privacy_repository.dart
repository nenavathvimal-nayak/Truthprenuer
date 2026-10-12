import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

final privacyRepositoryProvider = Provider<PrivacyRepository>((ref) {
  return PrivacyRepository(safeSupabaseClient);
});

class PrivacyRepository {
  final SupabaseClient? _supabase;

  PrivacyRepository([this._supabase]);

  /// Records a consent action in the DPDP Consent Ledger
  Future<void> recordConsent({
    required String purpose,
    required String status, // 'granted' or 'withdrawn'
    required String source,
  }) async {
    final client = _supabase;
    if (client == null) return;

    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client.from('consent_records').insert({
      'user_id': userId,
      'purpose': purpose,
      'status': status,
      'consent_version': '1.0',
      'source': source,
      'granted_at': status == 'granted' ? DateTime.now().toIso8601String() : null,
      'withdrawn_at': status == 'withdrawn' ? DateTime.now().toIso8601String() : null,
    });
    
    // Log the action for auditing
    await _logAccess(
      action: 'CONSENT_UPDATE',
      resource: 'consent_records',
      context: 'Purpose: $purpose, Status: $status',
    );
  }

  /// Initiates an account deletion flow
  Future<void> requestAccountDeletion() async {
    final client = _supabase;
    if (client == null) return;

    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await _logAccess(
      action: 'DELETION_REQUEST',
      resource: 'profiles',
      context: 'User requested account deletion',
    );
  }

  /// Requests a data export
  Future<void> requestDataExport() async {
    final client = _supabase;
    if (client == null) return;

    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await _logAccess(
      action: 'DATA_EXPORT_REQUEST',
      resource: 'all_user_data',
      context: 'User requested data export',
    );
  }

  /// Internal helper to write to the access_logs table for auditability
  Future<void> _logAccess({
    required String action,
    required String resource,
    String? context,
  }) async {
    final client = _supabase;
    if (client == null) return;

    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await client.from('access_logs').insert({
        'actor_id': userId,
        'target_user_id': userId,
        'action': action,
        'resource_accessed': resource,
        'context': context,
      });
    } catch (e) {
      // In production, failure to write an audit log should ideally be alerted on.
    }
  }
}

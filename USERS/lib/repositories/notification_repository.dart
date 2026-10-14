import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../utils/app_logger.dart';
import 'supabase_client.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(safeSupabaseClient);
});

class NotificationRepository {
  final SupabaseClient? _client;

  NotificationRepository([this._client]);

  Future<List<AppNotification>> getNotifications({int limit = 50}) async {
    final client = _client;
    if (client == null) return [];
    final user = client.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await client
          .from('notifications')
          .select('*, actor:profiles!notifications_actor_id_fkey(full_name, username, avatar_url)')
          .eq('recipient_id', user.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List).map((row) {
        final typeStr = (row['event_type'] as String?)?.toLowerCase() ?? 'system';
        final typeEnum = AppNotificationType.values.firstWhere(
          (t) => t.name.toLowerCase() == typeStr || typeStr.contains(t.name.toLowerCase()),
          orElse: () => AppNotificationType.system,
        );

        final actor = row['actor'] as Map<String, dynamic>?;
        final actorName = actor?['full_name'] as String? ??
            (row['actor_id'] != null ? 'Community Member' : 'TRUTHPRENUER');

        return AppNotification(
          id: row['id'] as String,
          type: typeEnum,
          actorId: (row['actor_id'] as String?) ?? 'system',
          actorName: actorName,
          message: row['body'] as String? ?? '',
          time: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
          isRead: row['is_read'] as bool? ?? false,
          actionId: row['resource_path'] as String?,
        );
      }).toList();
    } catch (e) {
      // Fallback without actor join in case foreign key alias differs
      try {
        final response = await client
            .from('notifications')
            .select()
            .eq('recipient_id', user.id)
            .order('created_at', ascending: false)
            .limit(limit);

        return (response as List).map((row) {
          final typeStr = (row['event_type'] as String?)?.toLowerCase() ?? 'system';
          final typeEnum = AppNotificationType.values.firstWhere(
            (t) => t.name.toLowerCase() == typeStr || typeStr.contains(t.name.toLowerCase()),
            orElse: () => AppNotificationType.system,
          );

          return AppNotification(
            id: row['id'] as String,
            type: typeEnum,
            actorId: (row['actor_id'] as String?) ?? 'system',
            actorName: row['title'] as String? ?? 'Community Member',
            message: row['body'] as String? ?? '',
            time: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
            isRead: row['is_read'] as bool? ?? false,
            actionId: row['resource_path'] as String?,
          );
        }).toList();
      } catch (innerErr) {
        AppLogger.error('Failed to fetch notifications from database', innerErr, null, 'NotificationRepository');
        return [];
      }
    }
  }

  Future<void> markNotificationRead(String id) async {
    final client = _client;
    if (client == null) return;
    final user = client.auth.currentUser;
    if (user == null) return;

    try {
      await client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', id)
          .eq('recipient_id', user.id);
    } catch (e) {
      AppLogger.warning('Failed to update notification read status: $e');
    }
  }

  Future<void> markAllNotificationsRead() async {
    final client = _client;
    if (client == null) return;
    final user = client.auth.currentUser;
    if (user == null) return;

    try {
      await client
          .from('notifications')
          .update({'is_read': true})
          .eq('recipient_id', user.id)
          .eq('is_read', false);
    } catch (e) {
      AppLogger.warning('Failed to mark all notifications read: $e');
    }
  }

  RealtimeChannel? subscribeToNotifications(void Function(AppNotification) onNewNotification) {
    final client = _client;
    if (client == null) return null;
    final user = client.auth.currentUser;
    if (user == null) return null;

    try {
      return client
          .channel('user:notifications:${user.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'recipient_id',
              value: user.id,
            ),
            callback: (payload) {
              final row = payload.newRecord;
              final typeStr = (row['event_type'] as String?)?.toLowerCase() ?? 'system';
              final typeEnum = AppNotificationType.values.firstWhere(
                (t) => t.name.toLowerCase() == typeStr || typeStr.contains(t.name.toLowerCase()),
                orElse: () => AppNotificationType.system,
              );

              final notif = AppNotification(
                id: row['id'] as String,
                type: typeEnum,
                actorId: (row['actor_id'] as String?) ?? 'system',
                actorName: row['title'] as String? ?? 'Community Member',
                message: row['body'] as String? ?? '',
                time: DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now(),
                isRead: row['is_read'] as bool? ?? false,
                actionId: row['resource_path'] as String?,
              );
              onNewNotification(notif);
            },
          )
          .subscribe();
    } catch (e) {
      AppLogger.warning('Failed to subscribe to realtime notifications: $e');
      return null;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/models.dart';
import 'supabase_client.dart';

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(safeSupabaseClient);
});

class MessagingRepository {
  final SupabaseClient? _client;

  MessagingRepository([this._client]);

  Future<List<Conversation>> getConversations() async {
    final client = _client;
    if (client == null) return [];

    final user = client.auth.currentUser;
    if (user == null) return [];

    try {
      final memberships = await client
          .from('conversation_members')
          .select('conversation_id')
          .eq('user_id', user.id);

      final conversationIds = (memberships as List)
          .map((m) => m['conversation_id'] as String)
          .toList();

      if (conversationIds.isEmpty) return [];

      final conversations = await client
          .from('conversations')
          .select('*, conversation_members(user_id, profiles(full_name, role, avatar_url)), messages(*)')
          .inFilter('id', conversationIds)
          .order('updated_at', ascending: false);

      return (conversations as List).map((c) {
        final members = (c['conversation_members'] as List? ?? []);
        final otherMember = members.firstWhere(
          (m) => m['user_id'] != user.id,
          orElse: () => members.isNotEmpty ? members.first : null,
        );

        final profile = otherMember?['profiles'] as Map<String, dynamic>?;
        final rawMessages = (c['messages'] as List? ?? []);
        rawMessages.sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
        final lastMsg = rawMessages.isNotEmpty ? rawMessages.first : null;

        return Conversation(
          id: c['id'],
          participantIds: members.map((m) => m['user_id'].toString()).toList(),
          participantName: profile?['full_name'] ?? 'Peer',
          participantAvatarURL: profile?['avatar_url'],
          lastMessage: lastMsg?['content'] ?? 'Conversation started',
          lastMessageTime: DateTime.tryParse(lastMsg?['created_at'] ?? '') ?? DateTime.now(),
          unreadCount: 0,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final client = _client;
    if (client == null) return [];

    try {
      final response = await client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return (response as List).map((m) {
        return ChatMessage(
          id: m['id'],
          conversationId: m['conversation_id'],
          senderId: m['sender_id'],
          text: m['content'] ?? '',
          sentAt: DateTime.tryParse(m['created_at'] ?? '') ?? DateTime.now(),
          isRead: true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final client = _client;
    if (client == null) {
      return ChatMessage(
        id: "local_msg_${DateTime.now().millisecondsSinceEpoch}",
        conversationId: conversationId,
        senderId: 'founder_dev_1',
        text: content.trim(),
        sentAt: DateTime.now(),
        isRead: true,
      );
    }

    final user = client.auth.currentUser;
    if (user == null) throw Exception('Authentication required to send message');
    final senderId = user.id;

    final res = await client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'content': content.trim(),
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    await client.from('conversations').update({
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);

    return ChatMessage(
      id: res['id'],
      conversationId: res['conversation_id'],
      senderId: res['sender_id'],
      text: res['content'] ?? '',
      sentAt: DateTime.tryParse(res['created_at'] ?? '') ?? DateTime.now(),
      isRead: true,
    );
  }

  Future<String> getOrCreateConversation(String otherUserId) async {
    final client = _client;
    if (client == null) return 'local_conv_${DateTime.now().millisecondsSinceEpoch}';

    final user = client.auth.currentUser;
    if (user == null) return 'local_conv_${DateTime.now().millisecondsSinceEpoch}';

    // Check if conversation already exists between these 2 users
    final myConvs = await client
        .from('conversation_members')
        .select('conversation_id')
        .eq('user_id', user.id);

    final convIds = (myConvs as List).map((m) => m['conversation_id'] as String).toList();
    if (convIds.isNotEmpty) {
      final shared = await client
          .from('conversation_members')
          .select('conversation_id')
          .eq('user_id', otherUserId)
          .inFilter('conversation_id', convIds)
          .maybeSingle();

      if (shared != null) {
        return shared['conversation_id'] as String;
      }
    }

    // Create new conversation
    final newConv = await client.from('conversations').insert({}).select().single();
    final newConvId = newConv['id'] as String;

    await client.from('conversation_members').insert([
      {'conversation_id': newConvId, 'user_id': user.id},
      {'conversation_id': newConvId, 'user_id': otherUserId},
    ]);

    return newConvId;
  }
}

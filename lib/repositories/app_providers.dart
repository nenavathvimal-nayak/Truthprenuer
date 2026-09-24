import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/startup_health_models.dart';
import 'auth_repository.dart';
import 'profile_repository.dart';
import 'validation_repository.dart';
import 'feedback_repository.dart';
import 'evidence_repository.dart';
import 'messaging_repository.dart';

// Export all repository providers for convenient access
export 'auth_repository.dart';
export 'profile_repository.dart';
export 'validation_repository.dart';
export 'feedback_repository.dart';
export 'evidence_repository.dart';
export 'ai_repository.dart';
export 'decision_repository.dart';
export 'messaging_repository.dart';
export 'privacy_repository.dart';

// Current active profile
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final profileRepo = ref.watch(profileRepositoryProvider);

  final user = authRepo.currentUser;
  if (user != null) {
    final profile = await profileRepo.getProfile(user.id);
    if (profile != null) return profile;
  }

  return null;
});

// Authoritative Validations Stream
final validationsProvider = FutureProvider<List<ValidationRequest>>((ref) async {
  final repo = ref.watch(validationRepositoryProvider);
  final backendList = await repo.getValidations();
  return backendList;
});

// Authoritative Validation Responses Stream
final validationResponsesProvider = FutureProvider.autoDispose.family<List<ValidationResponse>, String>((ref, validationId) async {
  final repo = ref.watch(feedbackRepositoryProvider);
  final backendResponses = await repo.getResponsesForValidation(validationId);
  return backendResponses;
});

// Authoritative Evidence Items Provider
final evidenceListProvider = StateNotifierProvider<EvidenceNotifier, List<EvidenceItem>>((ref) {
  return EvidenceNotifier(ref.watch(evidenceRepositoryProvider));
});

class EvidenceNotifier extends StateNotifier<List<EvidenceItem>> {
  final EvidenceRepository _repository;

  EvidenceNotifier(this._repository) : super([]);

  void addEvidence(EvidenceItem item) {
    state = [item, ...state];
    _repository.addEvidence(item).catchError((_) {});
  }

  void deleteEvidence(String id) {
    state = state.where((e) => e.id != id).toList();
    _repository.deleteEvidence(id).catchError((_) {});
  }
}

// Authoritative Community Users for Discovery & Network
final communityUsersProvider = Provider<List<User>>((ref) {
  return [];
});

// Notifications State Notifier
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super([]);

  void markAllNotificationsRead() {
    state = state.map((n) {
      n.isRead = true;
      return n;
    }).toList();
  }

  void markNotificationRead(String id) {
    state = state.map((n) {
      if (n.id == id) n.isRead = true;
      return n;
    }).toList();
  }
}

// Conversations State Notifier
final conversationsProvider = StateNotifierProvider<ConversationsNotifier, List<Conversation>>((ref) {
  final repo = ref.watch(messagingRepositoryProvider);
  final notifier = ConversationsNotifier(repo);
  notifier.loadConversations();
  return notifier;
});

class ConversationsNotifier extends StateNotifier<List<Conversation>> {
  final MessagingRepository _repository;

  ConversationsNotifier(this._repository) : super([]);

  Future<void> loadConversations() async {
    try {
      final conversations = await _repository.getConversations();
      state = conversations;
    } catch (_) {}
  }

  Future<Conversation> getOrCreateConversation(String targetUserId) async {
    final existing = state.where((c) => c.participantIds.contains(targetUserId)).firstOrNull;
    if (existing != null) return existing;

    final convId = await _repository.getOrCreateConversation(targetUserId);
    await loadConversations();
    
    return state.firstWhere(
      (c) => c.id == convId,
      orElse: () => Conversation(
        id: convId,
        participantIds: ["", targetUserId], // Placeholder since we don't have current user ID here
        lastMessage: "Started conversation",
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
      )
    );
  }

  void markConversationAsRead(String id) {
    state = state.map((c) {
      if (c.id == id) c.unreadCount = 0;
      return c;
    }).toList();
  }

  void togglePinConversation(String id) {
    state = state.map((c) {
      if (c.id == id) c.isPinned = !c.isPinned;
      return c;
    }).toList();
  }

  void togglePin(String id) => togglePinConversation(id);

  void markConversationAsUnread(String id) {
    state = state.map((c) {
      if (c.id == id) c.unreadCount = 1;
      return c;
    }).toList();
  }

  void toggleArchive(String id) {
    state = state.map((c) {
      if (c.id == id) c.isArchived = !c.isArchived;
      return c;
    }).toList();
  }
}

// In-Memory Chat Messages State Notifier
final chatMessagesProvider = StateNotifierProvider.autoDispose.family<ChatMessagesNotifier, List<ChatMessage>, String>((ref, conversationId) {
  final repo = ref.watch(messagingRepositoryProvider);
  final notifier = ChatMessagesNotifier(conversationId, repo);
  notifier.loadMessages();
  return notifier;
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final String conversationId;
  final MessagingRepository _repository;

  ChatMessagesNotifier(this.conversationId, this._repository) : super([]);

  Future<void> loadMessages() async {
    try {
      final messages = await _repository.getMessages(conversationId);
      state = messages;
    } catch (_) {}
  }

  Future<void> sendMessage({
    required String text,
    String? replyToText,
    String? replyToAuthor,
    String? attachmentType,
    String? attachmentUrl,
    String? attachmentTitle,
    String? attachmentSubtitle,
  }) async {
    try {
      final newMsg = await _repository.sendMessage(
        conversationId: conversationId,
        content: text,
      );
      state = [...state, newMsg];
    } catch (_) {
      final msg = ChatMessage(
        id: "msg_${DateTime.now().millisecondsSinceEpoch}",
        conversationId: conversationId,
        senderId: "founder_dev_1",
        text: text,
        sentAt: DateTime.now(),
        isRead: true,
        replyToText: replyToText,
        replyToAuthor: replyToAuthor,
        attachmentType: attachmentType,
        attachmentUrl: attachmentUrl,
        attachmentTitle: attachmentTitle,
        attachmentSubtitle: attachmentSubtitle,
      );
      state = [...state, msg];
    }
  }

  void reactToMessage(String messageId, String emoji) {
    state = state.map((m) {
      if (m.id == messageId) m.reaction = emoji;
      return m;
    }).toList();
  }

  void deleteMessage(String messageId) {
    state = state.where((m) => m.id != messageId).toList();
  }
}

// Aliases for legacy views compatibility
final topValidatorsProvider = Provider<List<User>>((ref) => ref.watch(communityUsersProvider));
final chatsProvider = Provider<List<Conversation>>((ref) => ref.watch(conversationsProvider));

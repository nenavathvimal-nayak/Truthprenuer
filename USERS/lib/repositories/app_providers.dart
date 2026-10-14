import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/role_provider.dart';
import '../models/startup_health_models.dart';
import 'auth_repository.dart';
import 'profile_repository.dart';
import 'validation_repository.dart';
import 'feedback_repository.dart';
import 'evidence_repository.dart';
import 'messaging_repository.dart';
import 'notification_repository.dart';
import 'supabase_client.dart';

// Export all repository providers for convenient access
export 'auth_repository.dart';
export 'profile_repository.dart';
export 'validation_repository.dart';
export 'feedback_repository.dart';
export 'evidence_repository.dart';
export 'ai_repository.dart';
export 'decision_repository.dart';
export 'messaging_repository.dart';
export 'notification_repository.dart';
export 'privacy_repository.dart';

// Current active profile
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final profileRepo = ref.watch(profileRepositoryProvider);

  final user = authRepo.currentUser;
  if (user != null) {
    final profile = await profileRepo.getProfile(user.id);
    if (profile != null) {
      // Automatically align active workspace role with authenticated profile role
      ref.read(roleProvider.notifier).syncRoleFromProfile(profile.userRole);
      return profile;
    }

    final metadata = user.userMetadata ?? {};
    final displayName = metadata['full_name'] as String? ?? (user.email?.split('@').first ?? 'Founder');
    final username = metadata['username'] as String? ?? 'user_${user.id.substring(0, 8)}';
    return User(
      id: user.id,
      name: displayName,
      username: username,
      bio: '',
      role: 'Founder',
      userRole: UserRole.founder,
      skills: [],
      location: '',
      isVerified: false,
    );
  }

  return null;
});

// Authoritative Validations Stream
final validationsProvider = FutureProvider<List<ValidationRequest>>((ref) async {
  final repo = ref.watch(validationRepositoryProvider);
  return await repo.getValidations();
});

// Authoritative Validation Responses Stream
final validationResponsesProvider = FutureProvider.autoDispose.family<List<ValidationResponse>, String>((ref, validationId) async {
  final repo = ref.watch(feedbackRepositoryProvider);
  return await repo.getResponsesForValidation(validationId);
});

// Authoritative Evidence Items Provider
final evidenceListProvider = StateNotifierProvider<EvidenceNotifier, List<EvidenceItem>>((ref) {
  return EvidenceNotifier(ref.watch(evidenceRepositoryProvider));
});

class EvidenceNotifier extends StateNotifier<List<EvidenceItem>> {
  final EvidenceRepository _repository;

  EvidenceNotifier(this._repository, [List<EvidenceItem>? initialItems])
      : super(initialItems ?? const []);

  void addEvidence(EvidenceItem item) {
    state = [item, ...state];
    _repository.addEvidence(item).catchError((_) {});
  }

  void deleteEvidence(String id) {
    state = state.where((e) => e.id != id).toList();
    _repository.deleteEvidence(id).catchError((_) {});
  }
}

// Authoritative Community Users from Supabase (Real Users)
final realCommunityUsersProvider = FutureProvider<List<User>>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  final realUsers = await repo.searchProfiles(query: '');
  return realUsers;
});

final communityUsersProvider = Provider<List<User>>((ref) {
  final asyncUsers = ref.watch(realCommunityUsersProvider);
  return asyncUsers.maybeWhen(
    data: (users) => users,
    orElse: () => const <User>[],
  );
});

// Authoritative Notifications State Notifier
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationsNotifier(repo);
});

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  final NotificationRepository _repo;

  NotificationsNotifier([NotificationRepository? repo, List<AppNotification>? initialNotifications])
      : _repo = repo ?? NotificationRepository(safeSupabaseClient),
        super(initialNotifications ?? const []) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final remote = await _repo.getNotifications();
      if (remote.isNotEmpty) {
        state = remote;
      }
    } catch (_) {}
  }

  void markAllNotificationsRead() {
    state = state.map((n) {
      n.isRead = true;
      return n;
    }).toList();
    _repo.markAllNotificationsRead().catchError((_) {});
  }

  void markNotificationRead(String id) {
    state = state.map((n) {
      if (n.id == id) n.isRead = true;
      return n;
    }).toList();
    _repo.markNotificationRead(id).catchError((_) {});
  }

  void addNotification(AppNotification notif) {
    state = [notif, ...state];
  }
}

// Conversations State Notifier
final conversationsProvider = StateNotifierProvider<ConversationsNotifier, List<Conversation>>((ref) {
  final repo = ref.watch(messagingRepositoryProvider);
  return ConversationsNotifier(repo);
});

class ConversationsNotifier extends StateNotifier<List<Conversation>> {
  final MessagingRepository _repo;

  ConversationsNotifier([MessagingRepository? repo, List<Conversation>? initialConversations])
      : _repo = repo ?? MessagingRepository(safeSupabaseClient),
        super(initialConversations ?? const []) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      final remote = await _repo.getConversations();
      if (remote.isNotEmpty) {
        final remoteIds = remote.map((c) => c.id).toSet();
        final localOnly = state.where((c) => !remoteIds.contains(c.id)).toList();
        state = [...remote, ...localOnly];
      }
    } catch (_) {}
  }

  Conversation getOrCreateConversation(String targetUserId) {
    final existing = state.where((c) => c.participantIds.contains(targetUserId)).firstOrNull;
    if (existing != null) return existing;

    final localId = "conv_${DateTime.now().millisecondsSinceEpoch}";
    final myId = safeSupabaseClient?.auth.currentUser?.id ?? "local_user";
    final newConv = Conversation(
      id: localId,
      participantIds: [myId, targetUserId],
      lastMessage: "Started conversation",
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
    );
    state = [newConv, ...state];

    // Background sync to backend / Supabase
    _repo.getOrCreateConversation(targetUserId).then((remoteId) {
      if (remoteId != localId && !remoteId.startsWith('local_')) {
        state = state.map((c) {
          if (c.id == localId) {
            return Conversation(
              id: remoteId,
              participantIds: c.participantIds,
              participantName: c.participantName,
              participantAvatarURL: c.participantAvatarURL,
              lastMessage: c.lastMessage,
              lastMessageTime: c.lastMessageTime,
              unreadCount: c.unreadCount,
              isPinned: c.isPinned,
              isArchived: c.isArchived,
            );
          }
          return c;
        }).toList();
      }
    }).catchError((_) {});

    return newConv;
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

// In-Memory & Supabase Backed Chat Messages State Notifier
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessage>, String>((ref, conversationId) {
  final repo = ref.watch(messagingRepositoryProvider);
  return ChatMessagesNotifier(conversationId, repo);
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final String conversationId;
  final MessagingRepository _repo;

  ChatMessagesNotifier(this.conversationId, [MessagingRepository? repo, List<ChatMessage>? initialMessages])
      : _repo = repo ?? MessagingRepository(safeSupabaseClient),
        super(initialMessages ?? const []) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final remote = await _repo.getMessages(conversationId);
      if (remote.isNotEmpty) {
        state = remote;
      }
    } catch (_) {}
  }

  void sendMessage({
    required String text,
    String? replyToText,
    String? replyToAuthor,
    String? attachmentType,
    String? attachmentUrl,
    String? attachmentTitle,
    String? attachmentSubtitle,
  }) {
    final senderId = safeSupabaseClient?.auth.currentUser?.id ?? "local_user";
    final localMsg = ChatMessage(
      id: "msg_${DateTime.now().millisecondsSinceEpoch}",
      conversationId: conversationId,
      senderId: senderId,
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
    state = [...state, localMsg];

    // Background sync to backend / Supabase
    _repo.sendMessage(
      conversationId: conversationId,
      content: text,
    ).then((remoteMsg) {
      state = state.map((m) {
        if (m.id == localMsg.id) {
          return remoteMsg;
        }
        return m;
      }).toList();
    }).catchError((_) {});
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

// -------------------------------------------------------------
// Connection Request State Machine & In-Flight Lock
// -------------------------------------------------------------

enum ConnectionStatus {
  none,
  requested,
  received,
  connected,
}

class ConnectionsNotifier extends StateNotifier<Map<String, ConnectionStatus>> {
  final Set<String> _inFlight = {};

  ConnectionsNotifier([Map<String, ConnectionStatus>? initialConnections])
      : super(initialConnections ?? const {});

  ConnectionStatus getStatus(String userId) {
    return state[userId] ?? ConnectionStatus.none;
  }

  bool isInFlight(String userId) => _inFlight.contains(userId);

  Future<void> sendOrToggleRequest(String userId) async {
    if (_inFlight.contains(userId)) return;
    _inFlight.add(userId);

    final current = getStatus(userId);
    try {
      if (current == ConnectionStatus.none) {
        state = {...state, userId: ConnectionStatus.requested};
      } else if (current == ConnectionStatus.requested) {
        // Withdraw request
        final updated = Map<String, ConnectionStatus>.from(state);
        updated.remove(userId);
        state = updated;
      } else if (current == ConnectionStatus.received) {
        // Mutual request resolved cleanly to connected (prevents deadlock)
        state = {...state, userId: ConnectionStatus.connected};
      }
    } finally {
      // Debounce window to lock against rapid tap oscillation
      await Future.delayed(const Duration(milliseconds: 250));
      _inFlight.remove(userId);
    }
  }

  Future<void> acceptRequest(String userId) async {
    if (_inFlight.contains(userId)) return;
    _inFlight.add(userId);
    try {
      state = {...state, userId: ConnectionStatus.connected};
    } finally {
      await Future.delayed(const Duration(milliseconds: 250));
      _inFlight.remove(userId);
    }
  }

  Future<void> declineRequest(String userId) async {
    if (_inFlight.contains(userId)) return;
    _inFlight.add(userId);
    try {
      final updated = Map<String, ConnectionStatus>.from(state);
      updated.remove(userId);
      state = updated;
    } finally {
      await Future.delayed(const Duration(milliseconds: 250));
      _inFlight.remove(userId);
    }
  }

  void reset() {
    state = {};
  }

  void clearAll() {
    state = {};
  }
}

final connectionsProvider = StateNotifierProvider<ConnectionsNotifier, Map<String, ConnectionStatus>>((ref) {
  return ConnectionsNotifier();
});

class ValidationUpvoteState {
  final bool isUpvoted;
  final int count;

  const ValidationUpvoteState({
    required this.isUpvoted,
    required this.count,
  });

  ValidationUpvoteState copyWith({bool? isUpvoted, int? count}) {
    return ValidationUpvoteState(
      isUpvoted: isUpvoted ?? this.isUpvoted,
      count: count ?? this.count,
    );
  }
}

class UpvotesNotifier extends StateNotifier<Map<String, ValidationUpvoteState>> {
  final ValidationRepository _repository;
  final Set<String> _inFlight = {};

  UpvotesNotifier(this._repository) : super({});

  ValidationUpvoteState getStatus(String validationId, {int defaultCount = 0, bool defaultIsUpvoted = false}) {
    return state[validationId] ?? ValidationUpvoteState(
      isUpvoted: defaultIsUpvoted,
      count: defaultCount,
    );
  }

  /// Optimistically updates upvote count and toggles state.
  /// Locks during in-flight debounce to prevent duplicate rapid clicks or oscillations.
  /// Automatically rolls back on server or network error.
  Future<bool> toggleUpvote(String validationId, {int defaultCount = 0, bool defaultIsUpvoted = false}) async {
    if (_inFlight.contains(validationId)) {
      return false;
    }
    _inFlight.add(validationId);

    final current = getStatus(validationId, defaultCount: defaultCount, defaultIsUpvoted: defaultIsUpvoted);
    final nextIsUpvoted = !current.isUpvoted;
    final nextCount = nextIsUpvoted ? current.count + 1 : (current.count > 0 ? current.count - 1 : 0);

    // 1. Optimistic Update
    state = {
      ...state,
      validationId: ValidationUpvoteState(isUpvoted: nextIsUpvoted, count: nextCount),
    };

    try {
      final success = await _repository.toggleUpvote(validationId, upvote: nextIsUpvoted);
      if (!success) {
        // Rollback on rejection
        state = {
          ...state,
          validationId: current,
        };
        return false;
      }
      return true;
    } catch (_) {
      // Rollback on failure
      state = {
        ...state,
        validationId: current,
      };
      return false;
    } finally {
      await Future.delayed(const Duration(milliseconds: 250));
      _inFlight.remove(validationId);
    }
  }

  void reset() {
    state = {};
  }

  void clearAll() {
    state = {};
  }
}

final upvotesProvider = StateNotifierProvider<UpvotesNotifier, Map<String, ValidationUpvoteState>>((ref) {
  final repo = ref.watch(validationRepositoryProvider);
  return UpvotesNotifier(repo);
});

/// Resets all user-scoped providers to completely prevent account-switch data leakage
void resetAllUserScopedProviders(Ref ref) {
  ref.read(validationRepositoryProvider).clearCache();
  ref.read(profileRepositoryProvider).clearCache();
  ref.invalidate(currentUserProvider);
  ref.invalidate(validationsProvider);
  ref.invalidate(evidenceListProvider);
  ref.invalidate(notificationsProvider);
  ref.invalidate(conversationsProvider);
  ref.invalidate(connectionsProvider);
  ref.invalidate(upvotesProvider);
}

// Aliases for legacy views compatibility
final topValidatorsProvider = Provider<List<User>>((ref) => ref.watch(communityUsersProvider));
final chatsProvider = Provider<List<Conversation>>((ref) => ref.watch(conversationsProvider));

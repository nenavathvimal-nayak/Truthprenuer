import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../models/role_provider.dart';
import '../models/startup_health_models.dart';
import 'auth_repository.dart';
import 'profile_repository.dart';
import 'validation_repository.dart';
import 'feedback_repository.dart';
import 'evidence_repository.dart';

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
  final backendList = await repo.getValidations();
  if (backendList.isNotEmpty) return backendList;

  // Pre-seeded high quality empirical validation sprints
  return [
    ValidationRequest(
      id: "val_auto_inventory",
      authorId: "founder_dev_1",
      authorName: "Alex Vimal",
      authorRole: "Founder",
      title: "Automated Restaurant Inventory via Invoice OCR",
      problem: "Restaurant owners lose 15% margin on food spoilage because daily stock audits take 2 hours every night.",
      solution: "WhatsApp bot that parses handwritten vendor invoices into daily inventory balance sheets automatically.",
      targetAudience: "Small Restaurant Owners & Head Chefs",
      tags: ["Pricing", "F&B", "Automation"],
      validationStage: ValidationStage.prototype,
      feedbackCount: 18,
      upvotes: 42,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ValidationRequest(
      id: "val_soc2_compliance",
      authorId: "founder_dev_1",
      authorName: "Alex Vimal",
      authorRole: "Founder",
      title: "Instant SOC2 Evidence Collector for Micro-SaaS",
      problem: "Solo-founders and micro-teams lose enterprise deals because enterprise security questionnaires take 40+ hours.",
      solution: "One-click GitHub and AWS audit connector that auto-generates SOC2 evidence sheets.",
      targetAudience: "B2B SaaS Founders (<10 employees)",
      tags: ["Problem", "Security", "DevOps"],
      validationStage: ValidationStage.idea,
      feedbackCount: 9,
      upvotes: 27,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
});

// Authoritative Validation Responses Stream
final validationResponsesProvider = FutureProvider.autoDispose.family<List<ValidationResponse>, String>((ref, validationId) async {
  final repo = ref.watch(feedbackRepositoryProvider);
  final backendResponses = await repo.getResponsesForValidation(validationId);
  if (backendResponses.isNotEmpty) return backendResponses;

  if (validationId == "val_auto_inventory") {
    return [
      ValidationResponse(
        id: "resp_1",
        validationId: validationId,
        respondentId: "user_marcus",
        respondentName: "Marcus Sterling",
        respondentRole: "Head of Operations",
        answers: [
          ValidationAnswer(
            id: "ans_1_1",
            responseId: "resp_1",
            questionId: "q1",
            answerText: "Severe (4/5) - nightly manual reconciliation causes inventory leakage.",
            numericValue: 4.0,
          ),
          ValidationAnswer(
            id: "ans_1_2",
            responseId: "resp_1",
            questionId: "q2",
            answerText: "Yes, ₹999/mo is trivial if invoice OCR works with 90%+ accuracy.",
            numericValue: 1.0,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      ValidationResponse(
        id: "resp_2",
        validationId: validationId,
        respondentId: "user_elena",
        respondentName: "Elena Rostova",
        respondentRole: "Principal Validator",
        answers: [
          ValidationAnswer(
            id: "ans_2_1",
            responseId: "resp_2",
            questionId: "q1",
            answerText: "Moderate (3/5) - suppliers already provide digital CSVs in 40% of cases.",
            numericValue: 3.0,
          ),
          ValidationAnswer(
            id: "ans_2_2",
            responseId: "resp_2",
            questionId: "q2",
            answerText: "Willing to pay only if WhatsApp OCR handles crumpled or handwritten receipts.",
            numericValue: 0.0,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
      ),
    ];
  }
  return [];
});

// Authoritative Evidence Items Provider
final evidenceListProvider = StateNotifierProvider<EvidenceNotifier, List<EvidenceItem>>((ref) {
  return EvidenceNotifier(ref.watch(evidenceRepositoryProvider));
});

class EvidenceNotifier extends StateNotifier<List<EvidenceItem>> {
  final EvidenceRepository _repository;

  EvidenceNotifier(this._repository) : super([
    EvidenceItem(
      id: "ev_1",
      validationId: "val_auto_inventory",
      type: EvidenceItemType.interview,
      title: "Daily Spoilage Friction Confirmed",
      summary: "3 Restaurant owners in Bangalore confirmed spending 90 mins every night counting stock.",
      confidenceScore: 88,
      keyInsight: "Direct operational pain confirmed; willingness to pay \$49/mo tier established.",
      classification: EvidenceClassification.supports,
      tags: ["Supports", "Interview"],
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    EvidenceItem(
      id: "ev_2",
      validationId: "val_auto_inventory",
      type: EvidenceItemType.survey,
      title: "WhatsApp Alerts Preferred Over Native App",
      summary: "12 of 14 respondents stated they will ignore another mobile app but check WhatsApp alerts instantly.",
      confidenceScore: 92,
      keyInsight: "Shift from standalone mobile dashboard to conversational WhatsApp notifications.",
      classification: EvidenceClassification.supports,
      tags: ["Supports", "Channel Fit"],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    EvidenceItem(
      id: "ev_3",
      validationId: "val_auto_inventory",
      type: EvidenceItemType.data,
      title: "Hardware Barcode Scanner Resistance",
      summary: "Chefs refused to use handheld barcode guns during peak dinner rush.",
      confidenceScore: 78,
      keyInsight: "Eliminate barcode scanner assumption; focus exclusively on invoice OCR.",
      classification: EvidenceClassification.contradicts,
      tags: ["Contradicts", "Friction"],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ]);

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
    data: (users) => users.isNotEmpty ? users : _defaultSeedUsers,
    orElse: () => _defaultSeedUsers,
  );
});

final _defaultSeedUsers = [
  User(
    id: "user_elena",
    name: "Elena Rostova",
    username: "erostova",
    bio: "Partner at Apex Ventures. Former operator building developer platforms.",
    role: "Investor",
    userRole: UserRole.investor,
    skills: ["Venture Capital", "B2B SaaS", "Developer Tools", "GTM Strategy"],
    location: "San Francisco, CA",
    isVerified: true,
    validationsCompleted: 41,
    helpfulnessScore: 4.9,
  ),
  User(
    id: "user_marcus",
    name: "Marcus Vance",
    username: "marcusv",
    bio: "12+ yrs evaluating distributed cloud architecture & security compliance.",
    role: "Professional",
    userRole: UserRole.professional,
    skills: ["SOC2 Compliance", "Cloud Security", "Enterprise DevOps"],
    location: "New York, NY",
    isVerified: true,
    validationsCompleted: 38,
    helpfulnessScore: 4.8,
  ),
  User(
    id: "user_sarah",
    name: "Sarah Chen",
    username: "schen_growth",
    bio: "Growth & Retention Lead. Helped 4 startups scale from \$0 to \$1M ARR.",
    role: "Professional",
    userRole: UserRole.professional,
    skills: ["Customer Acquisition", "Pricing Strategy", "Product-Led Growth"],
    location: "Singapore",
    isVerified: true,
    validationsCompleted: 32,
    helpfulnessScore: 4.7,
  ),
  User(
    id: "user_dev",
    name: "Dev Patel",
    username: "dev_fintech",
    bio: "Building payments rails and embedded banking integrations.",
    role: "Founder",
    userRole: UserRole.founder,
    skills: ["FinTech", "Payments", "API Design", "Banking"],
    location: "London, UK",
    isVerified: true,
    validationsCompleted: 29,
    helpfulnessScore: 4.6,
  ),
];

// Notifications State Notifier
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super([
    AppNotification(
      id: "notif_1",
      type: AppNotificationType.feedback,
      actorId: "user_marcus",
      actorName: "Marcus Vance",
      message: "submitted structured feedback on your Automated Restaurant Inventory sprint.",
      time: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: false,
      actionId: "val_auto_inventory",
    ),
    AppNotification(
      id: "notif_2",
      type: AppNotificationType.milestone,
      actorId: "system",
      actorName: "TRUTHPRENUER",
      message: "Automated Restaurant Inventory reached 15+ responses. AI Evidence Synthesis is ready.",
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      actionId: "val_auto_inventory",
    ),
    AppNotification(
      id: "notif_3",
      type: AppNotificationType.connection,
      actorId: "user_elena",
      actorName: "Elena Rostova",
      message: "sent you a connection request to discuss your validation sprint.",
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionId: "user_elena",
    ),
  ]);

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
  return ConversationsNotifier();
});

class ConversationsNotifier extends StateNotifier<List<Conversation>> {
  ConversationsNotifier() : super([
    Conversation(
      id: "conv_elena",
      participantIds: ["founder_dev_1", "user_elena"],
      lastMessage: "Read your restaurant OCR evidence. Impressive counter-metric on barcode guns.",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 18)),
      unreadCount: 1,
      isPinned: true,
    ),
    Conversation(
      id: "conv_marcus",
      participantIds: ["founder_dev_1", "user_marcus"],
      lastMessage: "I left detailed feedback on the SOC2 question regarding AWS audit scope.",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isPinned: false,
    ),
  ]);

  Conversation getOrCreateConversation(String targetUserId) {
    final existing = state.where((c) => c.participantIds.contains(targetUserId)).firstOrNull;
    if (existing != null) return existing;

    final newConv = Conversation(
      id: "conv_${DateTime.now().millisecondsSinceEpoch}",
      participantIds: ["founder_dev_1", targetUserId],
      lastMessage: "Started conversation",
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
    );
    state = [newConv, ...state];
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

// In-Memory Chat Messages State Notifier
final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessage>, String>((ref, conversationId) {
  return ChatMessagesNotifier(conversationId);
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final String conversationId;

  ChatMessagesNotifier(this.conversationId) : super([
    ChatMessage(
      id: "msg_init_1",
      conversationId: conversationId,
      senderId: "user_elena",
      text: "Hi Alex! Reviewed your latest invoice OCR validation. How are you addressing handwriting variance on vendor sheets?",
      sentAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
    ),
    ChatMessage(
      id: "msg_init_2",
      conversationId: conversationId,
      senderId: "founder_dev_1",
      text: "Hey Elena! We're pairing Google Document AI with a fine-tuned layout model. 94% accuracy on handwritten totals in our 12-kitchen sample.",
      sentAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: true,
    ),
    ChatMessage(
      id: "msg_init_3",
      conversationId: conversationId,
      senderId: "user_elena",
      text: "Read your restaurant OCR evidence. Impressive counter-metric on barcode guns.",
      sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
      isRead: false,
    ),
  ]);

  void sendMessage({
    required String text,
    String? replyToText,
    String? replyToAuthor,
    String? attachmentType,
    String? attachmentUrl,
    String? attachmentTitle,
    String? attachmentSubtitle,
  }) {
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

  ConnectionsNotifier()
      : super({
          // Seed initial pending request from Elena (matches Elena's notification)
          "user_elena": ConnectionStatus.received,
        });

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
    state = {
      "user_elena": ConnectionStatus.received,
    };
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

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';
import 'startup_health_models.dart';
import 'mock_data_store_seed.dart'; // We'll create this next

class SearchResults {
  final List<User> users;
  final List<ValidationRequest> validations;
  final List<PostItem> posts;

  SearchResults({
    this.users = const [],
    this.validations = const [],
    this.posts = const [],
  });

  bool get isEmpty => users.isEmpty && validations.isEmpty && posts.isEmpty;
}

class MockDataStore extends ChangeNotifier {
  bool isAuthenticated = false;
  User? currentUser;

  // Core data
  List<User> users = [];
  List<Startup> startups = [];
  List<ValidationRequest> validations = [];
  List<Comment> comments = [];
  List<PostItem> posts = [];
  List<Conversation> conversations = [];
  List<ChatMessage> messages = [];
  List<AppNotification> notifications = [];
  List<StructuredFeedback> structuredFeedback = [];
  List<EvidenceItem> evidenceItems = [];
  List<AIValidationReport> aiReports = [];
  List<StartupHealth> startupHealths = [];

  // Core Decision Intelligence
  List<DecisionAction> decisionCenterActions = [];

  // App state
  bool isDarkMode = true;
  bool notificationsEnabled = true;
  String searchQuery = "";
  List<String> searchHistory = ["SaaS", "FinTech", "Alex Rivera", "Growth strategies"];

  MockDataStore() {
    seedData(this);
  }

  // MARK: - Actions

  void notify() {
    notifyListeners();
  }

  void login({String userId = "me"}) {
    try {
      currentUser = users.firstWhere((u) => u.id == userId);
      isAuthenticated = true;
      notifyListeners();
    } catch (_) {}
  }

  void logout() {
    currentUser = null;
    isAuthenticated = false;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String bio,
    required String role,
    required String website,
    required String twitter,
    required String location,
    required List<String> skills,
  }) {
    if (currentUser == null) return;
    int idx = users.indexWhere((u) => u.id == currentUser!.id);
    if (idx != -1) {
      users[idx].name = name;
      users[idx].bio = bio;
      users[idx].role = role;
      users[idx].website = website;
      users[idx].twitterHandle = twitter;
      users[idx].location = location;
      users[idx].skills = skills;
      currentUser = users[idx];
      notifyListeners();
    }
  }

  void updateUserAvatar(String newAvatarURL) {
    if (currentUser == null) return;
    int idx = users.indexWhere((u) => u.id == currentUser!.id);
    if (idx != -1) {
      users[idx].avatarURL = newAvatarURL;
      currentUser = users[idx];
      notifyListeners();
    }
  }

  void toggleUpvote(String validationId) {
    int idx = validations.indexWhere((v) => v.id == validationId);
    if (idx != -1) {
      validations[idx].isUpvoted = !validations[idx].isUpvoted;
      validations[idx].upvotes += validations[idx].isUpvoted ? 1 : -1;
      notifyListeners();
    }
  }

  void toggleBookmark(String validationId) {
    int idx = validations.indexWhere((v) => v.id == validationId);
    if (idx != -1) {
      validations[idx].isBookmarked = !validations[idx].isBookmarked;
      notifyListeners();
    }
  }

  void togglePin(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].isPinned = !conversations[idx].isPinned;
      notifyListeners();
    }
  }

  void toggleArchive(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].isArchived = !conversations[idx].isArchived;
      notifyListeners();
    }
  }

  void toggleMessageReaction(String messageId, {String reaction = "❤️"}) {
    int idx = messages.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      if (messages[idx].reaction == reaction) {
        messages[idx].reaction = null;
      } else {
        messages[idx].reaction = reaction;
      }
      notifyListeners();
    }
  }

  void togglePostLike(String postId) {
    int idx = posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      posts[idx].isLiked = !posts[idx].isLiked;
      posts[idx].likes += posts[idx].isLiked ? 1 : -1;
      notifyListeners();
    }
  }

  void toggleCommentLike(String commentId) {
    int idx = comments.indexWhere((c) => c.id == commentId);
    if (idx != -1) {
      comments[idx].isLiked = !comments[idx].isLiked;
      comments[idx].likes += comments[idx].isLiked ? 1 : -1;
      notifyListeners();
    }
  }

  void togglePostBookmark(String postId) {
    int idx = posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      posts[idx].isBookmarked = !posts[idx].isBookmarked;
      notifyListeners();
    }
  }

  void addValidation({
    required String title,
    required String problem,
    required String solution,
    required String targetAudience,
    List<String> tags = const [],
  }) {
    final newV = ValidationRequest(
      id: const Uuid().v4(),
      title: title,
      problem: problem,
      solution: solution,
      targetAudience: targetAudience,
      authorId: currentUser?.id ?? "me",
      upvotes: 1,
      commentsCount: 0,
      isUpvoted: true,
      createdAt: DateTime.now(),
      tags: tags,
      views: 0,
    );
    validations.insert(0, newV);
    
    if (currentUser != null) {
      int idx = users.indexWhere((u) => u.id == currentUser!.id);
      if (idx != -1) {
        users[idx].validationsCount += 1;
        currentUser = users[idx];
      }
    }
    notifyListeners();
  }

  void addValidationInstance(ValidationRequest validation) {
    validations.insert(0, validation);
    notifyListeners();
  }

  List<ValidationRequest> validationsNeedingFeedback() {
    return validations.where((v) => v.needsFeedback && v.authorId != (currentUser?.id ?? "me")).toList();
  }

  List<ValidationRequest> myValidations() {
    return validations.where((v) => v.authorId == (currentUser?.id ?? "me")).toList();
  }

  List<PostItem> myPosts() {
    return posts.where((p) => p.authorId == (currentUser?.id ?? "me")).toList();
  }

  List<StructuredFeedback> feedbackFor(String validationId) {
    return structuredFeedback.where((f) => f.validationId == validationId).toList();
  }

  void addEvidenceItem(EvidenceItem item) {
    evidenceItems.insert(0, item);
    notifyListeners();
  }

  void deleteEvidenceItem(String id) {
    evidenceItems.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addStructuredFeedback(StructuredFeedback feedback) {
    structuredFeedback.insert(0, feedback);
    
    int vIdx = validations.indexWhere((v) => v.id == feedback.validationId);
    if (vIdx != -1) {
      validations[vIdx].feedbackCount += 1;
      validations[vIdx].needsFeedback = validations[vIdx].feedbackCount < 3;
      
      recalculateHealth(feedback.validationId);
    }
    
    try {
      final validation = validations.firstWhere((v) => v.id == feedback.validationId);
      final validator = users.firstWhere((u) => u.id == feedback.validatorId);
      final notif = AppNotification(
        id: const Uuid().v4(),
        type: AppNotificationType.feedback,
        actorId: validator.id,
        actorName: validator.name,
        message: "provided detailed feedback on your validation.",
        time: DateTime.now(),
        isRead: false,
        actionId: validation.id,
      );
      notifications.insert(0, notif);
    } catch (_) {}
    
    notifyListeners();
  }

  void recalculateHealth(String validationId) {
    final feedbacks = structuredFeedback.where((f) => f.validationId == validationId).toList();
    
    int totalRating = feedbacks.fold(0, (sum, f) => sum + f.overallRating);
    int avgRating = feedbacks.isEmpty ? 0 : totalRating ~/ feedbacks.length;
    
    int willingCount = feedbacks.where((f) => f.willingToPay).length;
    
    final scores = [
      HealthScore(
        dimension: StartupHealthDimension.problemStrength,
        score: avgRating * 20,
        explanation: "Based on ${feedbacks.length} validator ratings.",
        recommendation: "Continue gathering feedback to increase confidence."
      ),
      HealthScore(
        dimension: StartupHealthDimension.demand,
        score: (willingCount * 30).clamp(0, 100),
        explanation: "$willingCount validators indicated willingness to pay.",
        recommendation: "Explore price sensitivity."
      )
    ];
    
    final health = StartupHealth(startupId: validationId, scores: scores);
    
    int vIdx = validations.indexWhere((v) => v.id == validationId);
    if (vIdx != -1) {
      validations[vIdx].startupHealth = health;
      validations[vIdx].healthScore = health.overallScore;
      notifyListeners();
    }
  }

  void addPost({required String authorId, required String title, required String body, List<String> tags = const []}) {
    final newPost = PostItem(
      id: const Uuid().v4(),
      authorId: authorId,
      title: title,
      body: body,
      tags: tags,
      likes: 0,
      commentsCount: 0,
      isLiked: false,
      isBookmarked: false,
      createdAt: DateTime.now(),
    );
    posts.insert(0, newPost);
    notifyListeners();
  }

  void addComment(String text, String validationId) {
    final c = Comment(
      id: const Uuid().v4(),
      validationId: validationId,
      authorId: currentUser?.id ?? "me",
      authorName: currentUser?.name ?? "You",
      authorRole: currentUser?.role ?? "Founder",
      text: text,
      timestamp: "Just now",
    );
    comments.add(c);
    int vIdx = validations.indexWhere((v) => v.id == validationId);
    if (vIdx != -1) {
      validations[vIdx].commentsCount += 1;
      notifyListeners();
    }
  }

  void sendMessage(
    String conversationId,
    String text, {
    String? attachmentType,
    String? attachmentUrl,
    String? attachmentTitle,
    String? attachmentSubtitle,
    String? replyToText,
    String? replyToAuthor,
  }) {
    final msg = ChatMessage(
      id: const Uuid().v4(),
      conversationId: conversationId,
      senderId: currentUser?.id ?? "me",
      text: text,
      sentAt: DateTime.now(),
      isRead: false,
      attachmentType: attachmentType,
      attachmentUrl: attachmentUrl,
      attachmentTitle: attachmentTitle,
      attachmentSubtitle: attachmentSubtitle,
      replyToText: replyToText,
      replyToAuthor: replyToAuthor,
    );
    messages.add(msg);
    int cIdx = conversations.indexWhere((c) => c.id == conversationId);
    if (cIdx != -1) {
      conversations[cIdx].lastMessage = text.isNotEmpty ? text : (attachmentTitle ?? "Attachment");
      conversations[cIdx].lastMessageTime = DateTime.now();
      notifyListeners();
    }
  }

  void reactToMessage(String messageId, String emoji) {
    int idx = messages.indexWhere((m) => m.id == messageId);
    if (idx != -1) {
      if (messages[idx].reaction == emoji) {
        messages[idx].reaction = null;
      } else {
        messages[idx].reaction = emoji;
      }
      notifyListeners();
    }
  }

  void deleteMessage(String messageId) {
    messages.removeWhere((m) => m.id == messageId);
    notifyListeners();
  }

  Conversation getOrCreateConversation(String targetUserId) {
    final myId = currentUser?.id ?? "me";
    for (final c in conversations) {
      if (c.participantIds.contains(targetUserId) && c.participantIds.contains(myId)) {
        return c;
      }
    }
    final newConv = Conversation(
      id: "conv_${DateTime.now().millisecondsSinceEpoch}",
      participantIds: [myId, targetUserId],
      lastMessage: "Started conversation",
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
    );
    conversations.insert(0, newConv);
    notifyListeners();
    return newConv;
  }

  void togglePinConversation(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].isPinned = !conversations[idx].isPinned;
      notifyListeners();
    }
  }

  void toggleArchiveConversation(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].isArchived = !conversations[idx].isArchived;
      notifyListeners();
    }
  }

  void markConversationAsRead(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].unreadCount = 0;
    }
    for (var m in messages.where((m) => m.conversationId == conversationId)) {
      m.isRead = true;
    }
    notifyListeners();
  }

  void markConversationAsUnread(String conversationId) {
    int idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      conversations[idx].unreadCount = 1;
      notifyListeners();
    }
  }

  void markNotificationRead(String id) {
    int idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i].isRead = true;
    }
    notifyListeners();
  }

  SearchResults get searchResults {
    final q = searchQuery.toLowerCase().trim();
    if (q.isEmpty) return SearchResults();
    
    return SearchResults(
      users: users.where((u) => 
        u.name.toLowerCase().contains(q) || 
        u.username.toLowerCase().contains(q) || 
        u.bio.toLowerCase().contains(q)
      ).toList(),
      validations: validations.where((v) => 
        v.title.toLowerCase().contains(q) || 
        v.problem.toLowerCase().contains(q) || 
        v.tags.any((t) => t.toLowerCase().contains(q))
      ).toList(),
      posts: posts.where((p) => 
        p.title.toLowerCase().contains(q) || 
        p.body.toLowerCase().contains(q) || 
        p.tags.any((t) => t.toLowerCase().contains(q))
      ).toList(),
    );
  }

  void addSearchHistory(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    searchHistory.removeWhere((item) => item.toLowerCase() == q.toLowerCase());
    searchHistory.insert(0, q);
    if (searchHistory.length > 10) searchHistory.removeLast();
    notifyListeners();
  }

  void removeSearchHistory(String query) {
    searchHistory.remove(query);
    notifyListeners();
  }

  int get unreadNotificationCount {
    return notifications.where((n) => !n.isRead).length;
  }

  int get unreadMessageCount {
    return conversations.fold(0, (sum, c) => sum + c.unreadCount);
  }

  List<ChatMessage> messagesFor(String conversationId) {
    return messages.where((m) => m.conversationId == conversationId).toList();
  }

  User? otherUser(Conversation conversation) {
    final otherId = conversation.participantIds.firstWhere((id) => id != currentUser?.id, orElse: () => "");
    if (otherId.isEmpty) return null;
    try {
      return users.firstWhere((u) => u.id == otherId);
    } catch (_) {
      return null;
    }
  }
}

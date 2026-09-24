import 'startup_health_models.dart';

enum UserRole {
  founder('Founder', 'Build & validate your startup with evidence'),
  investor('Investor', 'Discover truth-validated deal flow'),
  professional('Professional', 'Lend expertise & earn validation karma'),
  creator('Creator', 'Share startup wisdom & grow your audience'),
  student('Student', 'Learn startup validation by doing');

  final String label;
  final String description;
  const UserRole(this.label, this.description);
}

enum ProblemFrequency {
  daily("Daily"),
  weekly("Weekly"),
  monthly("Monthly"),
  rarely("Rarely"),
  never("Never");

  final String value;
  const ProblemFrequency(this.value);
}

enum ValidationStage {
  idea("Idea"),
  prototype("Prototype"),
  mvp("MVP"),
  launched("Launched"),
  growing("Growing");

  final String value;
  const ValidationStage(this.value);
}

enum ValidationVisibility {
  public("Public"),
  community("Community"),
  connections("Connections"),
  inviteOnly("Invite Only"),
  private("Private");

  final String label;
  const ValidationVisibility(this.label);
}

class ValidationPassport {
  final Map<String, int> verifiedExpertise;
  final int ideasImproved;
  final int startupsFunded;
  final double founderTrustRating;
  final int proofOfValidationTokens;
  final bool isVerified;

  ValidationPassport({
    this.verifiedExpertise = const {},
    this.ideasImproved = 0,
    this.startupsFunded = 0,
    this.founderTrustRating = 0.0,
    this.proofOfValidationTokens = 0,
    this.isVerified = false,
  });
}

class DecisionIntelligence {
  final String nextBestAction;
  final double confidence;
  final int contradictoryFeedbackCount;
  final String recentEvidenceSummary;

  DecisionIntelligence({
    required this.nextBestAction,
    required this.confidence,
    required this.contradictoryFeedbackCount,
    required this.recentEvidenceSummary,
  });
}

enum ActionType {
  gatherEvidence("Gather Evidence"),
  pivot("Consider Pivot"),
  build("Start Building"),
  expertReview("Expert Review");

  final String value;
  const ActionType(this.value);
}

class DecisionAction {
  final String id;
  final String title;
  final String description;
  final String impact;
  final double confidence;
  final ActionType type;
  final String? validationId;

  DecisionAction({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
    required this.confidence,
    required this.type,
    this.validationId,
  });
}

class User {
  final String id;
  String name;
  String username;
  String bio;
  String role;
  UserRole userRole;
  String? avatarURL;

  String website;
  String twitterHandle;
  List<String> skills;
  String location;
  DateTime joinedDate;
  bool isVerified;

  List<String> validatorExpertise;
  int validationsCompleted;
  double helpfulnessScore;
  ValidationStage currentStage;
  int validationsCount;

  ValidationPassport validationPassport;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.role,
    this.userRole = UserRole.founder,
    this.avatarURL,
    this.website = "",
    this.twitterHandle = "",
    this.skills = const [],
    this.location = "",
    this.validationsCount = 0,
    DateTime? joinedDate,
    this.isVerified = false,
    this.validatorExpertise = const [],
    this.validationsCompleted = 0,
    this.helpfulnessScore = 0.0,
    this.currentStage = ValidationStage.idea,
    ValidationPassport? validationPassport,
  })  : joinedDate = joinedDate ?? DateTime.now(),
        validationPassport = validationPassport ?? ValidationPassport();

  User copyWith({
    String? id,
    String? name,
    String? username,
    String? bio,
    String? role,
    UserRole? userRole,
    String? avatarURL,
    String? website,
    String? twitterHandle,
    List<String>? skills,
    String? location,
    DateTime? joinedDate,
    bool? isVerified,
    List<String>? validatorExpertise,
    int? validationsCompleted,
    double? helpfulnessScore,
    ValidationStage? currentStage,
    int? validationsCount,
    ValidationPassport? validationPassport,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      userRole: userRole ?? this.userRole,
      avatarURL: avatarURL ?? this.avatarURL,
      website: website ?? this.website,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      joinedDate: joinedDate ?? this.joinedDate,
      isVerified: isVerified ?? this.isVerified,
      validatorExpertise: validatorExpertise ?? this.validatorExpertise,
      validationsCompleted: validationsCompleted ?? this.validationsCompleted,
      helpfulnessScore: helpfulnessScore ?? this.helpfulnessScore,
      currentStage: currentStage ?? this.currentStage,
      validationsCount: validationsCount ?? this.validationsCount,
      validationPassport: validationPassport ?? this.validationPassport,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      bio: json['bio'] as String,
      role: json['role'] as String,
      userRole: UserRole.values.firstWhere(
        (e) => e.name == json['userRole'],
        orElse: () => UserRole.founder,
      ),
      avatarURL: json['avatarURL'] as String?,
      website: json['website'] as String? ?? "",
      twitterHandle: json['twitterHandle'] as String? ?? "",
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      location: json['location'] as String? ?? "",
      validationsCount: json['validationsCount'] as int? ?? 0,
      joinedDate: json['joinedDate'] != null ? DateTime.parse(json['joinedDate'] as String) : null,
      isVerified: json['isVerified'] as bool? ?? false,
      validatorExpertise: (json['validatorExpertise'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      validationsCompleted: json['validationsCompleted'] as int? ?? 0,
      helpfulnessScore: (json['helpfulnessScore'] as num?)?.toDouble() ?? 0.0,
      currentStage: ValidationStage.values.firstWhere(
        (e) => e.name == json['currentStage'],
        orElse: () => ValidationStage.idea,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'role': role,
      'userRole': userRole.name,
      'avatarURL': avatarURL,
      'website': website,
      'twitterHandle': twitterHandle,
      'skills': skills,
      'location': location,
      'joinedDate': joinedDate.toIso8601String(),
      'isVerified': isVerified,
      'validatorExpertise': validatorExpertise,
      'validationsCompleted': validationsCompleted,
      'helpfulnessScore': helpfulnessScore,
      'currentStage': currentStage.name,
      'validationsCount': validationsCount,
    };
  }
}

class Startup {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String industry;
  final String stage;
  final String founderId;
  final String? logoURL;

  Startup({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.industry,
    required this.stage,
    required this.founderId,
    this.logoURL,
  });
}

class ValidationRequest {
  final String id;
  final String authorId;
  final DateTime createdAt;

  String title;
  String problem;
  String get description => problem;
  String solution;
  String targetAudience;
  List<String> tags;

  ValidationStage validationStage;
  ValidationStage get stage => validationStage;
  String businessModel;
  String existingAlternatives;
  String differentiator;
  String goToMarket;
  String targetPersona;

  int healthScore;
  int feedbackCount;
  bool needsFeedback;

  int upvotes;
  int commentsCount;
  bool isUpvoted;
  int views;
  bool isBookmarked;

  String? authorName;
  String? authorRole;
  String? authorAvatarURL;
  String status;

  int get responsesCount => feedbackCount > 0 ? feedbackCount : commentsCount;

  ValidationVisibility visibility;
  DecisionIntelligence? decisionIntelligence;
  AIValidationReport? aiReport;
  StartupHealth? startupHealth;

  ValidationRequest({
    required this.id,
    required this.title,
    required this.problem,
    required this.solution,
    required this.targetAudience,
    required this.authorId,
    this.upvotes = 0,
    this.commentsCount = 0,
    this.isUpvoted = false,
    this.isBookmarked = false,
    DateTime? createdAt,
    this.tags = const [],
    this.views = 0,
    this.validationStage = ValidationStage.idea,
    this.businessModel = "",
    this.existingAlternatives = "",
    this.differentiator = "",
    this.goToMarket = "",
    this.targetPersona = "",
    this.healthScore = 0,
    this.feedbackCount = 0,
    this.needsFeedback = true,
    this.authorName,
    this.authorRole,
    this.authorAvatarURL,
    this.status = "active",
    this.visibility = ValidationVisibility.community,
    DecisionIntelligence? decisionIntelligence,
    this.aiReport,
    this.startupHealth,
  })  : createdAt = createdAt ?? DateTime.now(),
        decisionIntelligence = decisionIntelligence ??
            DecisionIntelligence(
              nextBestAction:
                  "Gather 3 more structured feedback responses to validate pricing.",
              confidence: 0.75,
              contradictoryFeedbackCount: 1,
              recentEvidenceSummary:
                  "General positive sentiment, but willingness to pay is still unclear.",
            );

  factory ValidationRequest.fromJson(Map<String, dynamic> json) {
    return ValidationRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      problem: json['description'] as String? ?? '',
      solution: json['hypothesis'] as String? ?? '',
      targetAudience: json['targetAudience'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      upvotes: json['upvotes'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isUpvoted: json['isUpvoted'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      tags: [(json['industry'] as String? ?? '')].where((e) => e.isNotEmpty).toList(),
      views: json['views'] as int? ?? 0,
      validationStage: ValidationStage.values.firstWhere(
        (e) => e.name == json['validationStage'],
        orElse: () => ValidationStage.idea,
      ),
      businessModel: json['businessModel'] as String? ?? "",
      existingAlternatives: json['existingAlternatives'] as String? ?? "",
      differentiator: json['differentiator'] as String? ?? "",
      goToMarket: json['goToMarket'] as String? ?? "",
      targetPersona: json['targetPersona'] as String? ?? "",
      healthScore: json['healthScore'] as int? ?? 0,
      feedbackCount: json['feedbackCount'] as int? ?? 0,
      needsFeedback: json['needsFeedback'] as bool? ?? true,
      authorName: json['authorName'] as String?,
      authorRole: json['authorRole'] as String?,
      authorAvatarURL: json['authorAvatarURL'] as String?,
      status: json['status'] as String? ?? "active",
      visibility: ValidationVisibility.values.firstWhere(
        (e) => e.name == json['visibility'],
        orElse: () => ValidationVisibility.community,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': problem,
      'hypothesis': solution,
      'targetAudience': targetAudience,
      'authorId': authorId,
      'upvotes': upvotes,
      'commentsCount': commentsCount,
      'isUpvoted': isUpvoted,
      'isBookmarked': isBookmarked,
      'createdAt': createdAt.toIso8601String(),
      'industry': tags.isNotEmpty ? tags.first : '',
      'views': views,
      'validationStage': validationStage.name,
      'businessModel': businessModel,
      'existingAlternatives': existingAlternatives,
      'differentiator': differentiator,
      'goToMarket': goToMarket,
      'targetPersona': targetPersona,
      'healthScore': healthScore,
      'feedbackCount': feedbackCount,
      'needsFeedback': needsFeedback,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorAvatarURL': authorAvatarURL,
      'status': status,
      'visibility': visibility.name,
    };
  }
}

enum EvidenceType {
  image,
  document,
  link,
  audio,
}

class EvidenceAttachment {
  String id;
  final EvidenceType type;
  final String url;
  final String? description;

  EvidenceAttachment({
    String? id,
    required this.type,
    required this.url,
    this.description,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

class StructuredFeedback {
  final String id;
  final String validationId;
  final String validatorId;

  final ProblemFrequency problemFrequency;
  final String currentSolution;
  final bool willingToPay;
  final String expectedPrice;
  final String missingFeature;
  final int overallRating;
  final String textFeedback;

  double confidenceScore;
  List<EvidenceAttachment> evidence;
  final DateTime createdAt;

  StructuredFeedback({
    required this.id,
    required this.validationId,
    required this.validatorId,
    required this.problemFrequency,
    required this.currentSolution,
    required this.willingToPay,
    required this.expectedPrice,
    required this.missingFeature,
    required this.overallRating,
    required this.textFeedback,
    this.confidenceScore = 0.5,
    this.evidence = const [],
    required this.createdAt,
  });
}

class PostItem {
  final String id;
  final String authorId;
  String title;
  String body;
  List<String> tags;

  int likes;
  int commentsCount;
  bool isLiked;
  bool isBookmarked;
  final DateTime createdAt;

  PostItem({
    required this.id,
    required this.authorId,
    required this.title,
    required this.body,
    this.tags = const [],
    required this.likes,
    required this.commentsCount,
    required this.isLiked,
    required this.isBookmarked,
    required this.createdAt,
  });
}

class Comment {
  final String id;
  final String validationId;
  final String authorId;
  final String authorName;
  final String authorRole;
  String text;
  final String timestamp;
  int likes;
  bool isLiked;

  Comment({
    required this.id,
    required this.validationId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.text,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
  });
}

class Conversation {
  final String id;
  final List<String> participantIds;
  final String? participantName;
  final String? participantAvatarURL;
  String lastMessage;
  DateTime lastMessageTime;
  int unreadCount;
  bool isPinned;
  bool isArchived;

  Conversation({
    required this.id,
    required this.participantIds,
    this.participantName,
    this.participantAvatarURL,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isPinned = false,
    this.isArchived = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      participantName: json['participantName'] as String?,
      participantAvatarURL: json['participantAvatarURL'] as String?,
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageTime: json['lastMessageTime'] != null ? DateTime.parse(json['lastMessageTime'] as String) : DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'participantName': participantName,
      'participantAvatarURL': participantAvatarURL,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'isArchived': isArchived,
    };
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  String text;
  final DateTime sentAt;
  bool isRead;
  String? reaction;
  final String? attachmentType; // 'pitch_deck', 'validation', 'image', 'audio'
  final String? attachmentUrl;
  final String? attachmentTitle;
  final String? attachmentSubtitle;
  final String? replyToText;
  final String? replyToAuthor;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.isRead,
    this.reaction,
    this.attachmentType,
    this.attachmentUrl,
    this.attachmentTitle,
    this.attachmentSubtitle,
    this.replyToText,
    this.replyToAuthor,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt'] as String) : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      reaction: json['reaction'] as String?,
      attachmentType: json['attachmentType'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentTitle: json['attachmentTitle'] as String?,
      attachmentSubtitle: json['attachmentSubtitle'] as String?,
      replyToText: json['replyToText'] as String?,
      replyToAuthor: json['replyToAuthor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'isRead': isRead,
      'reaction': reaction,
      'attachmentType': attachmentType,
      'attachmentUrl': attachmentUrl,
      'attachmentTitle': attachmentTitle,
      'attachmentSubtitle': attachmentSubtitle,
      'replyToText': replyToText,
      'replyToAuthor': replyToAuthor,
    };
  }
}

enum AppNotificationType {
  feedback("doc.text.magnifyingglass"),
  mention("at.circle.fill"),
  system("bell.fill"),
  milestone("star.circle.fill"),
  welcome("hand.wave.fill"),
  connection("person.2.fill"),
  upvote("arrow.up.circle.fill"),
  follow("person.2.fill"),
  comment("text.bubble.fill"),
  message("message.fill"),
  match("person.2.fill");

  final String icon;
  const AppNotificationType(this.icon);
}

class AppNotification {
  final String id;
  final AppNotificationType type;
  final String actorId;
  final String actorName;
  String message;
  final DateTime time;
  bool isRead;
  String? actionId;

  AppNotification({
    required this.id,
    required this.type,
    required this.actorId,
    required this.actorName,
    required this.message,
    required this.time,
    required this.isRead,
    this.actionId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      type: AppNotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AppNotificationType.system,
      ),
      actorId: json['actorId'] as String,
      actorName: json['actorName'] as String,
      message: json['message'] as String,
      time: json['time'] != null ? DateTime.parse(json['time'] as String) : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      actionId: json['actionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'actorId': actorId,
      'actorName': actorName,
      'message': message,
      'time': time.toIso8601String(),
      'isRead': isRead,
      'actionId': actionId,
    };
  }
}

extension DateExtensions on DateTime {
  String get timeAgoDisplay {
    final diff = DateTime.now().difference(this).inSeconds;
    if (diff < 60) return "Just now";
    if (diff < 3600) return "${diff ~/ 60}m ago";
    if (diff < 86400) return "${diff ~/ 3600}h ago";
    return "${diff ~/ 86400}d ago";
  }
}

enum QuestionType {
  multipleChoice,
  text,
  rating,
  boolean,
}

class ValidationQuestion {
  final String id;
  final String validationId;
  final String text;
  final QuestionType type;
  final List<String> options;

  const ValidationQuestion({
    required this.id,
    this.validationId = "",
    required this.text,
    this.type = QuestionType.multipleChoice,
    this.options = const [],
  });
}

class ValidationResponse {
  final String id;
  final String validationId;
  final String respondentId;
  final String? respondentName;
  final String? respondentRole;
  final List<ValidationAnswer> answers;
  final DateTime createdAt;

  ValidationResponse({
    required this.id,
    required this.validationId,
    required this.respondentId,
    this.respondentName,
    this.respondentRole,
    this.answers = const [],
    required this.createdAt,
  });

  factory ValidationResponse.fromJson(Map<String, dynamic> json) {
    return ValidationResponse(
      id: json['id'] as String,
      validationId: json['validationId'] as String,
      respondentId: json['respondentId'] as String,
      respondentName: json['respondentName'] as String?,
      respondentRole: json['respondentRole'] as String?,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => ValidationAnswer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'validationId': validationId,
      'respondentId': respondentId,
      'respondentName': respondentName,
      'respondentRole': respondentRole,
      'answers': answers.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ValidationAnswer {
  final String id;
  final String responseId;
  final String questionId;
  final String? answerText;
  final double? numericValue;
  final List<String> selectedOptions;
  final DateTime createdAt;

  ValidationAnswer({
    required this.id,
    required this.responseId,
    required this.questionId,
    this.answerText,
    this.numericValue,
    this.selectedOptions = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ValidationAnswer.fromJson(Map<String, dynamic> json) {
    return ValidationAnswer(
      id: json['id'] as String,
      responseId: json['responseId'] as String,
      questionId: json['questionId'] as String,
      answerText: json['answerText'] as String?,
      numericValue: (json['numericValue'] as num?)?.toDouble(),
      selectedOptions: (json['selectedOptions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'responseId': responseId,
      'questionId': questionId,
      'answerText': answerText,
      'numericValue': numericValue,
      'selectedOptions': selectedOptions,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum DecisionType {
  gatherEvidence("Gather More Evidence"),
  iterate("Iterate"),
  build("Build"),
  retest("Re-test"),
  pivot("Pivot"),
  pause("Pause");

  final String label;
  const DecisionType(this.label);
}

class Decision {
  final String id;
  final String validationId;
  final String authorId;
  final DecisionType type;
  final String rationale;
  final List<String> supportingEvidenceIds;
  final DateTime createdAt;

  Decision({
    required this.id,
    required this.validationId,
    required this.authorId,
    required this.type,
    required this.rationale,
    this.supportingEvidenceIds = const [],
    required this.createdAt,
  });
}

class Experiment {
  final String id;
  final String validationId;
  final String? decisionId;
  final String authorId;
  final String hypothesis;
  final String targetAudience;
  final String testDescription;
  final String successCriteria;
  final int durationDays;
  final String status; // 'planned', 'running', 'completed', 'cancelled'
  final DateTime createdAt;

  Experiment({
    required this.id,
    required this.validationId,
    this.decisionId,
    required this.authorId,
    required this.hypothesis,
    required this.targetAudience,
    required this.testDescription,
    required this.successCriteria,
    this.durationDays = 7,
    this.status = 'planned',
    required this.createdAt,
  });
}

class Report {
  final String id;
  final String reporterId;
  final String targetType; // 'validation', 'profile', 'message', 'evidence'
  final String targetId;
  final String reason;
  final String explanation;
  final String status;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.reason,
    this.explanation = '',
    this.status = 'pending',
    required this.createdAt,
  });
}

class PrivacyRequest {
  final String id;
  final String userId;
  final String requestType; // 'export', 'rectification', 'erasure', 'inquiry'
  final String status; // 'pending', 'processing', 'completed', 'rejected'
  final String details;
  final DateTime createdAt;
  final DateTime? completedAt;

  PrivacyRequest({
    required this.id,
    required this.userId,
    required this.requestType,
    this.status = 'pending',
    this.details = '',
    required this.createdAt,
    this.completedAt,
  });
}



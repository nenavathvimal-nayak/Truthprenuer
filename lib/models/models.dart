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

  DecisionIntelligence? decisionIntelligence;
  // TODO: Add AIValidationReport and StartupHealth types when defined
  dynamic aiReport;
  dynamic startupHealth;

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
  String lastMessage;
  DateTime lastMessageTime;
  int unreadCount;
  bool isPinned;
  bool isArchived;

  Conversation({
    required this.id,
    required this.participantIds,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.isPinned = false,
    this.isArchived = false,
  });
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

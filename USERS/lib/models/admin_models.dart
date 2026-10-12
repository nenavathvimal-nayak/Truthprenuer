
enum AuditLogSeverity {
  info,
  success,
  warning,
  critical,
}

class AdminPlatformMetrics {
  final int totalValidations;
  final int activeValidations;
  final int featuredValidations;
  final int flaggedValidations;
  final int totalUsers;
  final int verifiedValidators;
  final int totalResponses;
  final int highConvictionSprints;
  final double averageConvictionScore;
  final bool isRealtimeConnected;
  final int activeRealtimeChannels;
  final int connectionLatencyMs;
  final DateTime lastRefreshed;

  const AdminPlatformMetrics({
    this.totalValidations = 0,
    this.activeValidations = 0,
    this.featuredValidations = 0,
    this.flaggedValidations = 0,
    this.totalUsers = 0,
    this.verifiedValidators = 0,
    this.totalResponses = 0,
    this.highConvictionSprints = 0,
    this.averageConvictionScore = 0.0,
    this.isRealtimeConnected = true,
    this.activeRealtimeChannels = 3,
    this.connectionLatencyMs = 18,
    required this.lastRefreshed,
  });

  AdminPlatformMetrics copyWith({
    int? totalValidations,
    int? activeValidations,
    int? featuredValidations,
    int? flaggedValidations,
    int? totalUsers,
    int? verifiedValidators,
    int? totalResponses,
    int? highConvictionSprints,
    double? averageConvictionScore,
    bool? isRealtimeConnected,
    int? activeRealtimeChannels,
    int? connectionLatencyMs,
    DateTime? lastRefreshed,
  }) {
    return AdminPlatformMetrics(
      totalValidations: totalValidations ?? this.totalValidations,
      activeValidations: activeValidations ?? this.activeValidations,
      featuredValidations: featuredValidations ?? this.featuredValidations,
      flaggedValidations: flaggedValidations ?? this.flaggedValidations,
      totalUsers: totalUsers ?? this.totalUsers,
      verifiedValidators: verifiedValidators ?? this.verifiedValidators,
      totalResponses: totalResponses ?? this.totalResponses,
      highConvictionSprints: highConvictionSprints ?? this.highConvictionSprints,
      averageConvictionScore: averageConvictionScore ?? this.averageConvictionScore,
      isRealtimeConnected: isRealtimeConnected ?? this.isRealtimeConnected,
      activeRealtimeChannels: activeRealtimeChannels ?? this.activeRealtimeChannels,
      connectionLatencyMs: connectionLatencyMs ?? this.connectionLatencyMs,
      lastRefreshed: lastRefreshed ?? this.lastRefreshed,
    );
  }
}

class AdminAuditLogItem {
  final String id;
  final String action;
  final String actorName;
  final String actorRole;
  final String target;
  final String details;
  final AuditLogSeverity severity;
  final DateTime timestamp;

  const AdminAuditLogItem({
    required this.id,
    required this.action,
    required this.actorName,
    required this.actorRole,
    required this.target,
    required this.details,
    this.severity = AuditLogSeverity.info,
    required this.timestamp,
  });

  factory AdminAuditLogItem.now({
    required String action,
    required String actorName,
    String actorRole = "System",
    required String target,
    required String details,
    AuditLogSeverity severity = AuditLogSeverity.info,
  }) {
    return AdminAuditLogItem(
      id: "log_${DateTime.now().millisecondsSinceEpoch}_${action.hashCode.abs() % 1000}",
      action: action,
      actorName: actorName,
      actorRole: actorRole,
      target: target,
      details: details,
      severity: severity,
      timestamp: DateTime.now(),
    );
  }
}

class PlatformAnnouncement {
  final String id;
  final String message;
  final String authorName;
  final bool isActive;
  final DateTime createdAt;

  const PlatformAnnouncement({
    required this.id,
    required this.message,
    required this.authorName,
    this.isActive = true,
    required this.createdAt,
  });
}

enum StartupHealthDimension {
  problemStrength,
  demand,
  validationConfidence,
  solutionReadiness,
  productReadiness,
  pmfReadiness,
  execution,
  team,
  growth,
  fundingReadiness,
}

extension StartupHealthDimensionExtension on StartupHealthDimension {
  String get rawValue {
    switch (this) {
      case StartupHealthDimension.problemStrength: return "Problem Strength";
      case StartupHealthDimension.demand: return "Demand Validation";
      case StartupHealthDimension.validationConfidence: return "Validation Confidence";
      case StartupHealthDimension.solutionReadiness: return "Solution Readiness";
      case StartupHealthDimension.productReadiness: return "Product Readiness";
      case StartupHealthDimension.pmfReadiness: return "PMF Readiness";
      case StartupHealthDimension.execution: return "Execution Velocity";
      case StartupHealthDimension.team: return "Team Capabilities";
      case StartupHealthDimension.growth: return "Growth Engines";
      case StartupHealthDimension.fundingReadiness: return "Funding Readiness";
    }
  }

  String get description {
    switch (this) {
      case StartupHealthDimension.problemStrength: return "How painful and urgent is the problem being solved?";
      case StartupHealthDimension.demand: return "Is there empirical evidence that people want this?";
      case StartupHealthDimension.validationConfidence: return "How rigorous and reliable is the validation evidence?";
      case StartupHealthDimension.solutionReadiness: return "Does the proposed solution effectively address the problem?";
      case StartupHealthDimension.productReadiness: return "Is the product built and functioning well?";
      case StartupHealthDimension.pmfReadiness: return "Are there early signs of Product-Market Fit?";
      case StartupHealthDimension.execution: return "Is the team moving quickly and shipping?";
      case StartupHealthDimension.team: return "Does the team have the right skills and domain expertise?";
      case StartupHealthDimension.growth: return "Are there scalable channels to acquire users?";
      case StartupHealthDimension.fundingReadiness: return "Is the startup prepared for external investment?";
    }
  }
}

class HealthScore {
  String id;
  final StartupHealthDimension dimension;
  final int score; // 0-100
  final String explanation;
  final List<String> evidenceReferences; // IDs of evidence items backing this score
  final String recommendation;

  HealthScore({
    String? id,
    required this.dimension,
    required this.score,
    required this.explanation,
    this.evidenceReferences = const [],
    required this.recommendation,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory HealthScore.fromJson(Map<String, dynamic> json) {
    return HealthScore(
      id: json['id'] as String?,
      dimension: StartupHealthDimension.values.firstWhere(
        (e) => e.name == json['dimension'],
        orElse: () => StartupHealthDimension.problemStrength,
      ),
      score: json['score'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
      evidenceReferences: (json['evidenceReferences'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dimension': dimension.name,
      'score': score,
      'explanation': explanation,
      'evidenceReferences': evidenceReferences,
      'recommendation': recommendation,
    };
  }
}

class StartupHealth {
  String id;
  final String startupId;
  int overallScore;
  final List<HealthScore> scores;
  final DateTime lastUpdated;

  StartupHealth({
    String? id,
    required this.startupId,
    required this.scores,
    DateTime? lastUpdated,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        lastUpdated = lastUpdated ?? DateTime.now(),
        overallScore = scores.isEmpty
            ? 0
            : (scores.fold(0, (sum, item) => sum + item.score) / scores.length).round();

  factory StartupHealth.fromJson(Map<String, dynamic> json) {
    return StartupHealth(
      id: json['id'] as String?,
      startupId: json['startupId'] as String,
      scores: (json['scores'] as List<dynamic>?)
              ?.map((e) => HealthScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startupId': startupId,
      'overallScore': overallScore,
      'scores': scores.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

/// 8-Part Structured Evidence Synthesis Output
class AIValidationReport {
  String id;
  final String validationId;

  // Canonical Blueprint Fields
  final List<String> observations;
  final List<String> observedPatterns;
  final List<String> contradictions;
  final String evidenceStrength;
  final List<String> uncertainties;
  final List<String> missingInformation;
  final List<String> suggestedQuestions;
  final String nextExperiment;

  // Compatibility / Supporting Fields
  final String problemAnalysis;
  final String competitorOverview;
  final List<String> marketAssumptions;
  final List<String> risks;
  final String suggestedAudience;
  final List<String> interviewQuestions;
  final List<String> biasWarnings;
  final DateTime generatedAt;

  AIValidationReport({
    String? id,
    required this.validationId,
    this.observations = const [],
    this.observedPatterns = const [],
    this.contradictions = const [],
    this.evidenceStrength = "Moderate",
    this.uncertainties = const [],
    this.missingInformation = const [],
    this.suggestedQuestions = const [],
    this.nextExperiment = "",
    String? problemAnalysis,
    this.competitorOverview = "",
    this.marketAssumptions = const [],
    this.risks = const [],
    this.suggestedAudience = "",
    List<String>? interviewQuestions,
    this.biasWarnings = const [],
    DateTime? generatedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        problemAnalysis = problemAnalysis ?? (observations.isNotEmpty ? observations.first : "Empirical analysis in progress."),
        interviewQuestions = interviewQuestions ?? suggestedQuestions,
        generatedAt = generatedAt ?? DateTime.now();

  double get overallScore => 0.78;
  String get summary => problemAnalysis;
  List<String> get strengths => marketAssumptions.isNotEmpty ? marketAssumptions : observedPatterns;
  List<String> get recommendedActions => missingInformation.isNotEmpty ? missingInformation : (uncertainties.isNotEmpty ? uncertainties : risks);

  factory AIValidationReport.fromJson(Map<String, dynamic> json) {
    return AIValidationReport(
      id: json['id'] as String?,
      validationId: json['validationId'] as String,
      observations: (json['observations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      observedPatterns: (json['observedPatterns'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      contradictions: (json['contradictions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      evidenceStrength: json['evidenceStrength'] as String? ?? "Moderate",
      uncertainties: (json['uncertainties'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      missingInformation: (json['missingInformation'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      suggestedQuestions: (json['suggestedQuestions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      nextExperiment: json['nextExperiment'] as String? ?? "",
      problemAnalysis: json['problemAnalysis'] as String?,
      competitorOverview: json['competitorOverview'] as String? ?? "",
      marketAssumptions: (json['marketAssumptions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      risks: (json['risks'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      suggestedAudience: json['suggestedAudience'] as String? ?? "",
      interviewQuestions: (json['interviewQuestions'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      biasWarnings: (json['biasWarnings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      generatedAt: json['generatedAt'] != null ? DateTime.parse(json['generatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'validationId': validationId,
      'observations': observations,
      'observedPatterns': observedPatterns,
      'contradictions': contradictions,
      'evidenceStrength': evidenceStrength,
      'uncertainties': uncertainties,
      'missingInformation': missingInformation,
      'suggestedQuestions': suggestedQuestions,
      'nextExperiment': nextExperiment,
      'problemAnalysis': problemAnalysis,
      'competitorOverview': competitorOverview,
      'marketAssumptions': marketAssumptions,
      'risks': risks,
      'suggestedAudience': suggestedAudience,
      'interviewQuestions': interviewQuestions,
      'biasWarnings': biasWarnings,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

enum EvidenceItemType {
  interview("Interview"),
  survey("Survey"),
  data("Data"),
  other("Other");

  final String value;
  const EvidenceItemType(this.value);
}

enum EvidenceClassification {
  supports("Supports"),
  contradicts("Contradicts"),
  mixed("Mixed"),
  inconclusive("Inconclusive");

  final String label;
  const EvidenceClassification(this.label);
}

class EvidenceItem {
  final String id;
  final String validationId;
  final EvidenceItemType type;
  final String title;
  final String summary;
  final int confidenceScore; // 0-100
  final String keyInsight;
  final EvidenceClassification classification;
  final String provenance;
  final List<String> tags;
  final bool isPrivate;
  final DateTime createdAt;

  EvidenceItem({
    required this.id,
    required this.validationId,
    required this.type,
    required this.title,
    required this.summary,
    required this.confidenceScore,
    required this.keyInsight,
    this.classification = EvidenceClassification.supports,
    this.provenance = "",
    this.tags = const [],
    this.isPrivate = true,
    required this.createdAt,
  });

  factory EvidenceItem.fromJson(Map<String, dynamic> json) {
    return EvidenceItem(
      id: json['id'] as String,
      validationId: json['validationId'] as String,
      type: EvidenceItemType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EvidenceItemType.other,
      ),
      title: json['title'] as String,
      summary: json['summary'] as String,
      confidenceScore: json['confidenceScore'] as int? ?? 0,
      keyInsight: json['keyInsight'] as String,
      classification: EvidenceClassification.values.firstWhere(
        (e) => e.name == json['classification'],
        orElse: () => EvidenceClassification.inconclusive,
      ),
      provenance: json['provenance'] as String? ?? "",
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      isPrivate: json['isPrivate'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'validationId': validationId,
      'type': type.name,
      'title': title,
      'summary': summary,
      'confidenceScore': confidenceScore,
      'keyInsight': keyInsight,
      'classification': classification.name,
      'provenance': provenance,
      'tags': tags,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

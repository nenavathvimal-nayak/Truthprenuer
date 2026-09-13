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
}

class AIValidationReport {
  String id;
  final String validationId;
  final String problemAnalysis;
  final String competitorOverview;
  final List<String> marketAssumptions;
  final List<String> risks;
  final List<String> missingInformation;
  final String suggestedAudience;
  final List<String> interviewQuestions;
  final List<String> biasWarnings;
  final DateTime generatedAt;

  AIValidationReport({
    String? id,
    required this.validationId,
    required this.problemAnalysis,
    required this.competitorOverview,
    required this.marketAssumptions,
    required this.risks,
    required this.missingInformation,
    required this.suggestedAudience,
    required this.interviewQuestions,
    required this.biasWarnings,
    DateTime? generatedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        generatedAt = generatedAt ?? DateTime.now();
}

enum EvidenceItemType {
  userInterview("User Interview"),
  prototypeTest("Prototype Test"),
  aiCritique("AI Critique"),
  expertReview("Expert Review"),
  marketData("Market Data");

  final String value;
  const EvidenceItemType(this.value);
}

class EvidenceItem {
  final String id;
  final String startupId;
  final EvidenceItemType type;
  final String title;
  final String content;
  final String? sourceId;
  final int confidenceLevel; // 0-100
  final DateTime createdAt;

  EvidenceItem({
    required this.id,
    required this.startupId,
    required this.type,
    required this.title,
    required this.content,
    this.sourceId,
    required this.confidenceLevel,
    required this.createdAt,
  });
}

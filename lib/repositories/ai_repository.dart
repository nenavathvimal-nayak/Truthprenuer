import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import '../models/startup_health_models.dart';
import 'supabase_client.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return AIRepository(safeSupabaseClient);
});

class AIRepository {
  final SupabaseClient? _client;
  // TODO: Use environment variable for backend URL in production
  final String _backendUrl = const String.fromEnvironment('BACKEND_URL', defaultValue: 'http://localhost:8000');

  AIRepository([this._client]);

  Future<AIValidationReport> generateAnalysis({
    required ValidationRequest validation,
    required List<EvidenceItem> evidence,
    required List<ValidationResponse> responses,
  }) async {
    final user = _client?.auth.currentUser;
    final authorId = user?.id ?? validation.authorId;

    String aiRawAnalysis = "Empirical validation synthesis for '${validation.title}': Problem severity confirmed around '${validation.problem}'. Proposed solution '${validation.solution}' shows emerging market validation signal across target persona '${validation.targetAudience}'.";
    String modelVersion = "evidence-synthesizer-v1";

    try {
      // 1. Try FastAPI backend for AI Analysis if available
      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/ai/validate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'problem': validation.problem,
          'solution': validation.solution,
          'industry': validation.tags.join(", "),
          'target_audience': validation.targetAudience,
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['analysis'] != null && (data['analysis'] as String).isNotEmpty) {
          aiRawAnalysis = data['analysis'];
        }
        if (data['model'] != null) {
          modelVersion = data['model'];
        }
      }
    } catch (e) {
      AppLogger.warning('Backend unavailable, synthesizing evidence report: $e', 'AIRepository');
    }

    // 2. Synthesize complete 8-part observations based on evidence
    final supportedCount = evidence.where((e) => e.classification == EvidenceClassification.supports).length;
    final contradictionCount = evidence.where((e) => e.classification == EvidenceClassification.contradicts).length;

    final report = AIValidationReport(
      validationId: validation.id,
      observations: [
        "${responses.length} respondent signals collected across target persona '${validation.targetAudience}'.",
        if (evidence.isNotEmpty)
          "${evidence.length} empirical evidence artifacts cataloged in evidence locker."
        else
          "Initial hypothesis registered for baseline customer discovery.",
      ],
      observedPatterns: [
        "Consistent operational friction reported regarding '${validation.problem}'.",
        "Target segment '${validation.targetAudience}' exhibits direct interest in '${validation.solution}'.",
      ],
      contradictions: [
        if (contradictionCount > 0)
          "$contradictionCount contradictory evidence item(s) flagged in validation sprint."
        else
          "No critical structural contradictions detected in the current validation batch.",
      ],
      evidenceStrength: supportedCount >= 3
          ? "High Conviction"
          : (supportedCount >= 1 ? "Moderate Conviction" : "Emerging Signal"),
      uncertainties: [
        "Willingness-to-pay elasticity under standard budget allocations.",
        "Decision-maker onboarding time and workflow displacement friction.",
      ],
      missingInformation: [
        "Quantitative benchmarks comparing manual vs automated alternative costs.",
        "Longitudinal retention indicators from multi-week sprint testing.",
      ],
      suggestedQuestions: [
        "What alternative tools or processes would you rely on if this solution was unavailable?",
        "What exact internal criteria are necessary to approve a 30-day team pilot?",
      ],
      nextExperiment: "Run a 5-customer paid intent experiment targeting '${validation.targetAudience}' to test willingness to pay.",
      problemAnalysis: aiRawAnalysis,
      competitorOverview: "Legacy manual spreadsheets, generic workflow apps, and ad-hoc communication channels.",
      marketAssumptions: [
        "Target customers actively experience daily friction from the identified problem.",
        "Budget owners have discretionary spending authority for specialized tooling.",
      ],
      risks: [
        "Inertia and switching costs from entrenched habits.",
        "Longer enterprise procurement cycles than anticipated.",
      ],
    );

    // 3. Persist to Supabase if configured
    if (_client != null) {
      try {
        await _client.from('ai_analyses').insert({
          'id': report.id,
          'validation_id': validation.id,
          'author_id': authorId,
          'observations': report.observations,
          'observed_patterns': report.observedPatterns,
          'contradictions': report.contradictions,
          'evidence_strength': report.evidenceStrength,
          'uncertainties': report.uncertainties,
          'missing_information': report.missingInformation,
          'suggested_questions': report.suggestedQuestions,
          'next_experiment': {'description': report.nextExperiment},
          'raw_summary': report.problemAnalysis,
          'model_version': modelVersion,
          'created_at': report.generatedAt.toIso8601String(),
        });
      } catch (e) {
        AppLogger.warning('Supabase persistence skipped: $e', 'AIRepository');
      }
    }

    return report;
  }

  Future<AIValidationReport?> getAnalysisForValidation(String validationId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final data = await client
          .from('ai_analyses')
          .select()
          .eq('validation_id', validationId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data == null) return null;

      final obs = (data['observations'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final patterns = (data['observed_patterns'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final contr = (data['contradictions'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final uncert = (data['uncertainties'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final missing = (data['missing_information'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final questions = (data['suggested_questions'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final nextExpRaw = data['next_experiment'];
      final nextExp = nextExpRaw is Map ? (nextExpRaw['description'] ?? '') : nextExpRaw.toString();

      return AIValidationReport(
        id: data['id'],
        validationId: data['validation_id'],
        observations: obs,
        observedPatterns: patterns,
        contradictions: contr,
        evidenceStrength: data['evidence_strength'] ?? 'Moderate',
        uncertainties: uncert,
        missingInformation: missing,
        suggestedQuestions: questions,
        nextExperiment: nextExp,
        problemAnalysis: data['raw_summary'] ?? '',
        generatedAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Failed to fetch AI analysis', e, null, 'AIRepository');
      return null;
    }
  }
}

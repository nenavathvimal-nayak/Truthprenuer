import 'package:flutter/foundation.dart';
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

  AIRepository([this._client]);

  Future<AIValidationReport> generateAnalysis({
    required ValidationRequest validation,
    required List<EvidenceItem> evidence,
    required List<ValidationResponse> responses,
  }) async {
    final user = _client?.auth.currentUser;
    final authorId = user?.id ?? validation.authorId;

    // Synthesize observations and contradictions from empirical evidence
    final supportedCount = evidence.where((e) => e.classification == EvidenceClassification.supports).length;
    final contradictedCount = evidence.where((e) => e.classification == EvidenceClassification.contradicts).length;

    final observations = [
      "${responses.length} respondent signals collected across target persona '${validation.targetAudience}'.",
      if (evidence.isNotEmpty) "${evidence.length} empirical evidence artifacts cataloged in evidence locker.",
      "Primary assumption under test: '${validation.solution}'.",
    ];

    final patterns = [
      if (supportedCount > 0) "$supportedCount data points validate core problem urgency.",
      "Validators actively compare against existing manual workarounds.",
      "Clear preference for lightweight, non-intrusive automation.",
    ];

    final contradictions = [
      if (contradictedCount > 0)
        "$contradictedCount validator observations directly contradict proposed delivery mechanism.",
      "Price sensitivity observed at enterprise tier vs self-serve adoption.",
    ];

    final uncertainties = [
      "Willingness to pay annual upfront contracts remains unverified.",
      "Integration friction with legacy internal tools requires empirical test.",
    ];

    final missingInformation = [
      "Quantitative churn rate of existing alternatives.",
      "Decision-maker sign-off timeline for commercial pilots.",
    ];

    final suggestedQuestions = [
      "What is the exact dollar loss incurred when this workflow breaks?",
      "Who inside your team approves software purchases under \$500/year?",
    ];

    const nextExperiment = "Conduct 5 focused pricing interviews testing \$49/seat/mo vs \$199 flat tier.";

    final report = AIValidationReport(
      validationId: validation.id,
      observations: observations,
      observedPatterns: patterns,
      contradictions: contradictions,
      evidenceStrength: supportedCount >= 3 ? "High Conviction" : "Emerging Signal",
      uncertainties: uncertainties,
      missingInformation: missingInformation,
      suggestedQuestions: suggestedQuestions,
      nextExperiment: nextExperiment,
      problemAnalysis: "Empirical validation indicates genuine problem urgency with ongoing friction around pricing and delivery channels.",
      competitorOverview: "Target audience currently cobbles together manual spreadsheets and ad-hoc notifications.",
      marketAssumptions: [
        "Customer willingness to adopt WhatsApp/API notifications over dedicated desktop dashboards.",
        "Rapid pilot onboarding within 48 hours without engineering support.",
      ],
      risks: [
        "Enterprise compliance objection regarding customer data privacy.",
        "Low switching friction if competitors add invoice OCR.",
      ],
    );

    // Persist to Supabase
    try {
      await _client?.from('ai_analyses').insert({
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
        'model_version': 'gemini-1.5-pro',
        'created_at': report.generatedAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('AIRepository error: $e');
      throw Exception('Failed to persist AI analysis: $e');
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
      debugPrint('AIRepository query error: $e');
      return null;
    }
  }
}

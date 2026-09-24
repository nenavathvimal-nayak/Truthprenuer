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

    try {
      // 1. Ask FastAPI backend for AI Analysis
      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/ai/validate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'problem': validation.problem,
          'solution': validation.solution,
          'industry': validation.tags.join(", "),
          'target_audience': validation.targetAudience,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Backend returned ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final aiRawAnalysis = data['analysis'] ?? 'Analysis unavailable.';

      // 2. Synthesize observations based on evidence
      final supportedCount = evidence.where((e) => e.classification == EvidenceClassification.supports).length;
      
      final report = AIValidationReport(
        validationId: validation.id,
        observations: [
          "${responses.length} respondent signals collected across target persona '${validation.targetAudience}'.",
          if (evidence.isNotEmpty) "${evidence.length} empirical evidence artifacts cataloged in evidence locker.",
        ],
        observedPatterns: [],
        contradictions: [],
        evidenceStrength: supportedCount >= 3 ? "High Conviction" : "Emerging Signal",
        uncertainties: [],
        missingInformation: [],
        suggestedQuestions: [],
        nextExperiment: "Review AI analysis and formulate a new hypothesis.",
        problemAnalysis: aiRawAnalysis,
        competitorOverview: "",
        marketAssumptions: [],
        risks: [],
      );

      // 3. Persist to Supabase
      if (_client != null) {
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
          'model_version': data['model'] ?? 'fastapi-proxy',
          'created_at': report.generatedAt.toIso8601String(),
        });
      }

      return report;
    } catch (e) {
      AppLogger.error('Failed to generate AI analysis', e, null, 'AIRepository');
      throw Exception('Failed to generate AI analysis: $e');
    }
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

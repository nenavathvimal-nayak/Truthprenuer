import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'supabase_client.dart';

final decisionRepositoryProvider = Provider<DecisionRepository>((ref) {
  return DecisionRepository(safeSupabaseClient);
});

class DecisionRepository {
  final SupabaseClient? _client;

  DecisionRepository([this._client]);

  Future<void> recordDecision(Decision decision) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    final authorId = user?.id ?? decision.authorId;

    await client.from('decisions').insert({
      'id': decision.id,
      'validation_id': decision.validationId,
      'author_id': authorId,
      'decision_type': decision.type.label,
      'rationale': decision.rationale,
      'supporting_evidence_ids': decision.supportingEvidenceIds,
      'created_at': decision.createdAt.toIso8601String(),
    });
  }

  Future<List<Decision>> getDecisionsForValidation(String validationId) async {
    final client = _client;
    if (client == null) return [];

    try {
      final response = await client
          .from('decisions')
          .select()
          .eq('validation_id', validationId)
          .order('created_at', ascending: false);

      return (response as List).map((data) {
        final typeStr = data['decision_type'] ?? 'Gather Evidence';
        final typeEnum = DecisionType.values.firstWhere(
          (t) => t.label.toLowerCase() == typeStr.toString().toLowerCase(),
          orElse: () => DecisionType.gatherEvidence,
        );

        final evidenceRaw = data['supporting_evidence_ids'];
        final List<String> evidenceIds = evidenceRaw is List
            ? evidenceRaw.map((e) => e.toString()).toList()
            : [];

        return Decision(
          id: data['id'],
          validationId: data['validation_id'],
          authorId: data['author_id'],
          type: typeEnum,
          rationale: data['rationale'] ?? '',
          supportingEvidenceIds: evidenceIds,
          createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('DecisionRepository error: $e');
      return [];
    }
  }

  Future<void> createExperiment(Experiment experiment) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    final authorId = user?.id ?? experiment.authorId;

    await client.from('experiments').insert({
      'id': experiment.id,
      'validation_id': experiment.validationId,
      'decision_id': experiment.decisionId,
      'author_id': authorId,
      'hypothesis': experiment.hypothesis,
      'target_audience': experiment.targetAudience,
      'test_description': experiment.testDescription,
      'success_criteria': experiment.successCriteria,
      'duration_days': experiment.durationDays,
      'status': experiment.status,
      'created_at': experiment.createdAt.toIso8601String(),
    });
  }

  Future<List<Experiment>> getExperimentsForValidation(String validationId) async {
    final client = _client;
    if (client == null) return [];

    try {
      final response = await client
          .from('experiments')
          .select()
          .eq('validation_id', validationId)
          .order('created_at', ascending: false);

      return (response as List).map((data) {
        return Experiment(
          id: data['id'],
          validationId: data['validation_id'],
          decisionId: data['decision_id'],
          authorId: data['author_id'],
          hypothesis: data['hypothesis'] ?? '',
          targetAudience: data['target_audience'] ?? '',
          testDescription: data['test_description'] ?? '',
          successCriteria: data['success_criteria'] ?? '',
          durationDays: data['duration_days'] ?? 7,
          status: data['status'] ?? 'planned',
          createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('DecisionRepository error: $e');
      return [];
    }
  }
}

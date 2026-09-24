import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/startup_health_models.dart';
import 'supabase_client.dart';

final evidenceRepositoryProvider = Provider<EvidenceRepository>((ref) {
  return EvidenceRepository(safeSupabaseClient);
});

class EvidenceRepository {
  final SupabaseClient? _client;

  EvidenceRepository([this._client]);

  Future<void> addEvidence(EvidenceItem item) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    if (user == null) throw Exception('Authentication required to add evidence');
    final authorId = user.id;

    await client.from('evidence_items').insert({
      'id': item.id,
      'validation_id': item.validationId,
      'author_id': authorId,
      'title': item.title,
      'type': item.type.value.toLowerCase(),
      'summary': item.summary,
      'confidence_score': item.confidenceScore,
      'key_insight': item.keyInsight,
      'classification': item.classification.label,
      'provenance': item.provenance,
      'tags': item.tags,
      'is_private': item.isPrivate,
      'created_at': item.createdAt.toIso8601String(),
    });
  }

  Future<List<EvidenceItem>> getEvidenceForValidation(
    String validationId, {
    EvidenceClassification? classification,
  }) async {
    final client = _client;
    if (client == null) return [];

    try {
      var builder = client
          .from('evidence_items')
          .select()
          .eq('validation_id', validationId);

      if (classification != null) {
        builder = builder.eq('classification', classification.label);
      }

      final response = await builder.order('created_at', ascending: false);

      return (response as List).map((data) {
        final typeStr = data['type'] ?? 'other';
        final typeEnum = EvidenceItemType.values.firstWhere(
          (t) => t.value.toLowerCase() == typeStr.toString().toLowerCase(),
          orElse: () => EvidenceItemType.other,
        );

        final classStr = data['classification'] ?? 'Supports';
        final classEnum = EvidenceClassification.values.firstWhere(
          (c) => c.label.toLowerCase() == classStr.toString().toLowerCase(),
          orElse: () => EvidenceClassification.supports,
        );

        final tagsRaw = data['tags'];
        final List<String> tags = tagsRaw is List
            ? tagsRaw.map((t) => t.toString()).toList()
            : [];

        return EvidenceItem(
          id: data['id'],
          validationId: data['validation_id'],
          type: typeEnum,
          title: data['title'] ?? '',
          summary: data['summary'] ?? '',
          confidenceScore: (data['confidence_score'] as num?)?.toInt() ?? 80,
          keyInsight: data['key_insight'] ?? '',
          classification: classEnum,
          provenance: data['provenance'] ?? '',
          tags: tags,
          isPrivate: data['is_private'] ?? true,
          createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('EvidenceRepository error: $e');
      return [];
    }
  }

  Future<void> deleteEvidence(String id) async {
    final client = _client;
    if (client == null) return;
    await client.from('evidence_items').delete().eq('id', id);
  }
}

import '../utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'supabase_client.dart';

final validationRepositoryProvider = Provider<ValidationRepository>((ref) {
  return ValidationRepository(safeSupabaseClient);
});

class ValidationRepository {
  final SupabaseClient? _client;

  ValidationRepository([this._client]);

  Future<void> createValidation(
    ValidationRequest request,
    List<ValidationQuestion> questions,
  ) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    final authorId = user?.id ?? request.authorId;

    // 1. Insert Validation
    final validationData = {
      'id': request.id,
      'author_id': authorId,
      'title': request.title,
      'description': request.problem,
      'hypothesis': request.solution,
      'target_audience': request.targetAudience,
      'industry': request.tags.isNotEmpty ? request.tags.first : 'General',
      'validation_stage': request.validationStage.name,
      'status': 'active',
      'visibility': request.visibility.name,
      'upvotes': request.upvotes,
      'created_at': request.createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    await client
        .from('validations')
        .upsert(validationData)
        .timeout(const Duration(seconds: 3));

    // 2. Insert Questions
    if (questions.isNotEmpty) {
      final questionsData = questions.map((q) => {
        'id': q.id,
        'validation_id': request.id,
        'question_text': q.text,
        'question_type': q.type.name,
        'options': q.options,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      await client
          .from('validation_questions')
          .upsert(questionsData)
          .timeout(const Duration(seconds: 3));
    }
  }

  Future<void> saveDraft(
    ValidationRequest request,
    List<ValidationQuestion> questions,
  ) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    final authorId = user?.id ?? request.authorId;

    final draftData = {
      'id': request.id,
      'author_id': authorId,
      'title': request.title.isEmpty ? 'Untitled Validation Draft' : request.title,
      'description': request.problem,
      'hypothesis': request.solution,
      'target_audience': request.targetAudience,
      'industry': request.tags.isNotEmpty ? request.tags.first : 'General',
      'validation_stage': request.validationStage.name,
      'status': 'draft',
      'visibility': 'private',
      'upvotes': 0,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await client
        .from('validations')
        .upsert(draftData)
        .timeout(const Duration(seconds: 3));

    if (questions.isNotEmpty) {
      final questionsData = questions.map((q) => {
        'id': q.id,
        'validation_id': request.id,
        'question_text': q.text,
        'question_type': q.type.name,
        'options': q.options,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      await client
          .from('validation_questions')
          .upsert(questionsData)
          .timeout(const Duration(seconds: 3));
    }
  }

  Future<List<ValidationRequest>> getValidations({
    String? industry,
    ValidationStage? stage,
    String? status = 'active',
  }) async {
    final client = _client;
    if (client == null) return [];

    try {
      var builder = client
          .from('validations')
          .select('*, profiles!validations_author_id_fkey(full_name, role, avatar_url)');

      if (status != null) {
        builder = builder.eq('status', status);
      }
      if (industry != null && industry != 'All') {
        builder = builder.eq('industry', industry);
      }
      if (stage != null) {
        builder = builder.eq('validation_stage', stage.name);
      }

      final response = await builder
          .order('created_at', ascending: false)
          .timeout(const Duration(seconds: 2));

      return (response as List).map((data) => _mapToValidationRequest(data)).toList();
    } catch (_) {
      // Return empty list on network or parse failure
      return [];
    }
  }

  Future<ValidationRequest?> getValidationById(String id) async {
    final client = _client;
    if (client == null) return null;

    try {
      final data = await client
          .from('validations')
          .select('*, profiles!validations_author_id_fkey(full_name, role, avatar_url)')
          .eq('id', id)
          .maybeSingle()
          .timeout(const Duration(seconds: 2));

      if (data == null) return null;
      return _mapToValidationRequest(data);
    } catch (_) {
      return null;
    }
  }

  Future<List<ValidationQuestion>> getQuestionsForValidation(String validationId) async {
    final client = _client;
    if (client == null) return [];

    try {
      final response = await client
          .from('validation_questions')
          .select()
          .eq('validation_id', validationId)
          .order('created_at', ascending: true)
          .timeout(const Duration(seconds: 2));

      return (response as List).map((data) {
        final typeStr = data['question_type'] ?? 'multiple_choice';
        final typeEnum = QuestionType.values.firstWhere(
          (t) => t.name == typeStr,
          orElse: () => QuestionType.multipleChoice,
        );
        final rawOptions = data['options'];
        final List<String> options = rawOptions is List
            ? rawOptions.map((o) => o.toString()).toList()
            : [];

        return ValidationQuestion(
          id: data['id'],
          validationId: data['validation_id'],
          text: data['question_text'] ?? '',
          type: typeEnum,
          options: options,
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to fetch data', e, null, 'ValidationRepository');
      return [];
    }
  }

  Future<void> deleteValidation(String id) async {
    final client = _client;
    if (client == null) return;
    await client
        .from('validations')
        .delete()
        .eq('id', id)
        .timeout(const Duration(seconds: 3));
  }

  ValidationRequest _mapToValidationRequest(Map<String, dynamic> data) {
    final profile = data['profiles'] as Map<String, dynamic>?;
    final stageStr = data['validation_stage'] ?? 'idea';
    final stageEnum = ValidationStage.values.firstWhere(
      (s) => s.name == stageStr,
      orElse: () => ValidationStage.idea,
    );

    final visStr = data['visibility'] ?? 'community';
    final visEnum = ValidationVisibility.values.firstWhere(
      (v) => v.name == visStr,
      orElse: () => ValidationVisibility.community,
    );

    return ValidationRequest(
      id: data['id'],
      authorId: data['author_id'] ?? '',
      authorName: profile?['full_name'] ?? 'Founder',
      authorRole: profile?['role'] ?? 'Founder',
      authorAvatarURL: profile?['avatar_url'],
      title: data['title'] ?? 'Validation Sprint',
      problem: data['description'] ?? '',
      solution: data['hypothesis'] ?? '',
      targetAudience: data['target_audience'] ?? '',
      tags: [data['industry'] ?? 'General'],
      validationStage: stageEnum,
      visibility: visEnum,
      status: data['status'] ?? 'active',
      upvotes: data['upvotes'] ?? 0,
      createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

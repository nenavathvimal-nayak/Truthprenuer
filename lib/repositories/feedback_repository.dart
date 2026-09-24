import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';
import 'supabase_client.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(safeSupabaseClient);
});

class FeedbackRepository {
  final SupabaseClient? _client;

  FeedbackRepository([this._client]);

  Future<bool> hasUserResponded({
    required String validationId,
    required String userId,
  }) async {
    final client = _client;
    if (client == null) return false;

    try {
      final res = await client
          .from('validation_responses')
          .select('id')
          .eq('validation_id', validationId)
          .eq('respondent_id', userId)
          .maybeSingle();

      return res != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> submitResponse({
    required String validationId,
    required List<ValidationAnswer> answers,
  }) async {
    final client = _client;
    if (client == null) return;

    final user = client.auth.currentUser;
    if (user == null) throw Exception('Authentication required to submit feedback');
    final respondentId = user.id;

    // 1. Insert Response
    final responseRes = await client
        .from('validation_responses')
        .insert({
          'validation_id': validationId,
          'respondent_id': respondentId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    final responseId = responseRes['id'];

    // 2. Insert Answers
    if (answers.isNotEmpty) {
      final answersData = answers.map((a) => {
        'id': a.id,
        'response_id': responseId,
        'question_id': a.questionId,
        'answer_text': a.answerText,
        'numeric_value': a.numericValue,
        'selected_options': a.selectedOptions,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      await client.from('validation_answers').insert(answersData);
    }
  }

  Future<void> addStructuredFeedback(StructuredFeedback feedback) async {
    final List<ValidationAnswer> answers = <ValidationAnswer>[
      ValidationAnswer(
        id: const Uuid().v4(),
        responseId: feedback.id,
        questionId: const Uuid().v4(),
        answerText: feedback.problemFrequency.name,
      ),
      if (feedback.currentSolution.isNotEmpty)
        ValidationAnswer(
          id: const Uuid().v4(),
          responseId: feedback.id,
          questionId: const Uuid().v4(),
          answerText: feedback.currentSolution,
        ),
      ValidationAnswer(
        id: const Uuid().v4(),
        responseId: feedback.id,
        questionId: const Uuid().v4(),
        answerText: feedback.willingToPay ? "Yes" : "No",
        numericValue: double.tryParse(feedback.expectedPrice),
      ),
      if (feedback.missingFeature.isNotEmpty)
        ValidationAnswer(
          id: const Uuid().v4(),
          responseId: feedback.id,
          questionId: const Uuid().v4(),
          answerText: feedback.missingFeature,
        ),
      ValidationAnswer(
        id: const Uuid().v4(),
        responseId: feedback.id,
        questionId: const Uuid().v4(),
        numericValue: feedback.overallRating.toDouble(),
      ),
      if (feedback.textFeedback.isNotEmpty)
        ValidationAnswer(
          id: const Uuid().v4(),
          responseId: feedback.id,
          questionId: const Uuid().v4(),
          answerText: feedback.textFeedback,
        ),
    ];

    try {
      await submitResponse(validationId: feedback.validationId, answers: answers);
    } catch (e) {
      throw Exception('FeedbackRepository error: $e');
    }
  }

  Future<List<ValidationResponse>> getResponsesForValidation(String validationId) async {
    final client = _client;
    if (client == null) return [];

    try {
      final responseList = await client
          .from('validation_responses')
          .select('*, profiles!validation_responses_respondent_id_fkey(full_name, role), validation_answers(*)')
          .eq('validation_id', validationId)
          .order('created_at', ascending: false);

      return (responseList as List).map((data) {
        final profile = data['profiles'] as Map<String, dynamic>?;
        final rawAnswers = data['validation_answers'] as List? ?? [];
        final answers = rawAnswers.map((a) => ValidationAnswer(
          id: a['id'],
          responseId: a['response_id'],
          questionId: a['question_id'],
          answerText: a['answer_text'],
          numericValue: (a['numeric_value'] as num?)?.toDouble(),
          selectedOptions: (a['selected_options'] as List?)?.map((o) => o.toString()).toList() ?? [],
          createdAt: DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now(),
        )).toList();

        return ValidationResponse(
          id: data['id'],
          validationId: data['validation_id'],
          respondentId: data['respondent_id'],
          respondentName: profile?['full_name'] ?? 'Validator',
          respondentRole: profile?['role'] ?? 'Contributor',
          answers: answers,
          createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('FeedbackRepository error: $e');
      return [];
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/models.dart';
import '../models/mock_data_store.dart';

final validationRepositoryProvider = Provider<ValidationRepository>((ref) {
  return ValidationRepository();
});

class ValidationRepository {
  bool get _isSupabaseActive {
    final url = dotenv.env['SUPABASE_URL'];
    return url != null && url.isNotEmpty && url != 'your_project_url_here';
  }

  Future<void> createValidation(ValidationRequest request, List<ValidationQuestion> questions) async {
    if (_isSupabaseActive) {
      // 1. Insert Validation
      final validationData = {
        'id': request.id,
        'author_id': Supabase.instance.client.auth.currentUser!.id,
        'title': request.title,
        'description': request.problem,
        'hypothesis': request.solution,
        'target_audience': request.targetAudience,
        'industry': request.tags.isNotEmpty ? request.tags.first : 'Tech',
        'status': 'active',
        'upvotes': request.upvotes,
      };
      
      await Supabase.instance.client.from('validations').insert(validationData);

      // 2. Insert Questions
      if (questions.isNotEmpty) {
        final questionsData = questions.map((q) => {
          'id': q.id,
          'validation_id': request.id,
          'question_text': q.text,
          'question_type': q.type.name,
          'options': q.options,
        }).toList();

        await Supabase.instance.client.from('validation_questions').insert(questionsData);
      }
    } else {
      // Fallback: Use MockDataStore
      final store = MockDataStore();
      store.addValidationInstance(request);
    }
  }

  Future<List<ValidationRequest>> getValidations() async {
    if (_isSupabaseActive) {
      final response = await Supabase.instance.client
          .from('validations')
          .select()
          .order('created_at', ascending: false);
          
      return (response as List).map((data) => ValidationRequest(
        id: data['id'],
        authorId: data['author_id'],
        authorName: 'Founder',
        authorRole: 'Founder',
        title: data['title'],
        problem: data['description'],
        solution: data['hypothesis'],
        targetAudience: data['target_audience'],
        tags: [data['industry']],
        validationStage: ValidationStage.idea,
        businessModel: '',
        existingAlternatives: '',
        differentiator: '',
        goToMarket: '',
        targetPersona: data['target_audience'],
        healthScore: 50,
        feedbackCount: 0,
        needsFeedback: true,
        upvotes: data['upvotes'] ?? 0,
        commentsCount: 0,
        isUpvoted: false,
        views: 0,
        isBookmarked: false,
        createdAt: DateTime.parse(data['created_at']),
        authorAvatarURL: null,
      )).toList();
    } else {
      return MockDataStore().validations;
    }
  }
}

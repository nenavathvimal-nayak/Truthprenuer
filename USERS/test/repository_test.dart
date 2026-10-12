import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/models/startup_health_models.dart';
import 'package:taeed_flutter/repositories/ai_repository.dart';

void main() {
  group('Truthprenuer Repository & AI Pipeline Tests', () {
    test('AIRepository synthesizes evidence into 8-part structured report', () async {
      final aiRepo = AIRepository();

      final validation = ValidationRequest(
        id: 'val_test',
        authorId: 'user_1',
        title: 'B2B Invoice Automation',
        problem: 'Restaurants waste 15% on manual stock counting.',
        solution: 'WhatsApp invoice OCR bot.',
        targetAudience: 'Restaurant Owners',
      );

      final evidence = [
        EvidenceItem(
          id: 'ev_1',
          validationId: 'val_test',
          type: EvidenceItemType.interview,
          title: '3 Kitchen Leads Interviewed',
          summary: 'Confirmed daily stock count friction.',
          confidenceScore: 88,
          keyInsight: 'Severe operational pain confirmed.',
          classification: EvidenceClassification.supports,
          createdAt: DateTime.now(),
        ),
      ];

      final report = await aiRepo.generateAnalysis(
        validation: validation,
        responses: [],
        evidence: evidence,
      );

      expect(report.validationId, 'val_test');
      expect(report.observations, isNotEmpty);
      expect(report.observedPatterns, isNotEmpty);
      expect(report.contradictions, isNotEmpty);
      expect(report.uncertainties, isNotEmpty);
      expect(report.missingInformation, isNotEmpty);
      expect(report.suggestedQuestions, isNotEmpty);
      expect(report.nextExperiment, isNotEmpty);
      expect(report.problemAnalysis, isNotEmpty);
    });
  });
}

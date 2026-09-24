import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/models/startup_health_models.dart';

void main() {
  group('Truthprenuer Domain Models Tests', () {
    test('ValidationRequest model initializes correctly', () {
      final now = DateTime.now();
      final val = ValidationRequest(
        id: 'val_123',
        authorId: 'user_456',
        authorName: 'Alex Vimal',
        title: 'B2B Procurement Automation',
        problem: 'Vendor onboarding takes 3 weeks on average.',
        solution: 'Automated vendor compliance verification portal.',
        targetAudience: 'Chief Procurement Officers',
        visibility: ValidationVisibility.community,
        validationStage: ValidationStage.idea,
        healthScore: 78,
        feedbackCount: 12,
        createdAt: now,
      );

      expect(val.id, 'val_123');
      expect(val.authorName, 'Alex Vimal');
      expect(val.visibility, ValidationVisibility.community);
      expect(val.validationStage, ValidationStage.idea);
      expect(val.healthScore, 78);
      expect(val.needsFeedback, isTrue);
    });

    test('ValidationResponse and ValidationAnswer map correctly', () {
      final ans1 = ValidationAnswer(
        id: 'ans_1',
        responseId: 'resp_1',
        questionId: 'q_problem_freq',
        answerText: 'Daily',
        numericValue: 5.0,
      );

      final ans2 = ValidationAnswer(
        id: 'ans_2',
        responseId: 'resp_1',
        questionId: 'q_wtp',
        answerText: 'Yes',
        numericValue: 49.0,
      );

      final resp = ValidationResponse(
        id: 'resp_1',
        validationId: 'val_123',
        respondentId: 'resp_user_1',
        respondentName: 'Marcus Sterling',
        respondentRole: 'Head of Operations',
        answers: [ans1, ans2],
        createdAt: DateTime.now(),
      );

      expect(resp.answers.length, 2);
      expect(resp.respondentRole, 'Head of Operations');
      expect(resp.answers[0].numericValue, 5.0);
      expect(resp.answers[1].answerText, 'Yes');
    });

    test('EvidenceItem classification and confidence score work as expected', () {
      final evidence = EvidenceItem(
        id: 'ev_101',
        validationId: 'val_123',
        type: EvidenceItemType.interview,
        title: '5 Procurement Team Leads Confirm Onboarding Bottleneck',
        summary: 'Direct interviews showed 18 days spent on manual vendor audits.',
        confidenceScore: 92,
        keyInsight: 'Customer onboarding friction confirmed directly.',
        classification: EvidenceClassification.supports,
        createdAt: DateTime.now(),
      );

      expect(evidence.classification, EvidenceClassification.supports);
      expect(evidence.confidenceScore, 92);
      expect(evidence.type, EvidenceItemType.interview);
    });

    test('Decision and Experiment models initialize properly', () {
      final dec = Decision(
        id: 'dec_1',
        validationId: 'val_123',
        authorId: 'founder_1',
        type: DecisionType.build,
        rationale: 'Customer pain is validated with 92% confidence.',
        createdAt: DateTime.now(),
      );

      expect(dec.type, DecisionType.build);
      expect(dec.rationale, contains('92%'));

      final exp = Experiment(
        id: 'exp_1',
        decisionId: 'dec_1',
        validationId: 'val_123',
        authorId: 'founder_1',
        hypothesis: 'Automated OCR verification will cut onboarding time from 3 weeks to 2 hours.',
        targetAudience: 'Tier-1 Vendors',
        testDescription: 'Prototype Concierge onboarding workflow',
        successCriteria: '80% vendor self-serve completion without human intervention',
        durationDays: 14,
        createdAt: DateTime.now(),
      );

      expect(exp.durationDays, 14);
      expect(exp.testDescription, 'Prototype Concierge onboarding workflow');
    });

    test('User model and copyWith preserve attributes', () {
      final user = User(
        id: 'user_1',
        name: 'Sarah Chen',
        username: 'schen',
        bio: 'B2B SaaS Operator',
        role: 'Founder',
        skills: ['Product', 'Go-To-Market'],
      );

      final updated = user.copyWith(
        bio: 'Founder building enterprise compliance tools.',
        skills: ['Product', 'Go-To-Market', 'SOC2'],
      );

      expect(updated.id, 'user_1');
      expect(updated.name, 'Sarah Chen');
      expect(updated.bio, 'Founder building enterprise compliance tools.');
      expect(updated.skills.length, 3);
    });
  });
}

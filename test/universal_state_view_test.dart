import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/components/universal_state_view.dart';
import 'package:taeed_flutter/design_system/app_colors.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: <ThemeExtension<dynamic>>[AppThemeColors.dark],
      ),
      home: Scaffold(body: child),
    );
  }

  group('UniversalStateView Widget Tests', () {
    testWidgets('renders empty state correctly with title and action', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        createTestWidget(
          UniversalStateView.empty(
            title: 'No Active Validations',
            message: 'Create your first sprint to turn assumptions into empirical evidence.',
            actionLabel: 'Create Validation',
            onAction: () => actionTriggered = true,
          ),
        ),
      );

      expect(find.text('No Active Validations'), findsOneWidget);
      expect(find.text('Create your first sprint to turn assumptions into empirical evidence.'), findsOneWidget);
      expect(find.text('Create Validation'), findsOneWidget);

      await tester.tap(find.text('Create Validation'));
      await tester.pump();
      expect(actionTriggered, isTrue);
    });

    testWidgets('renders unauthorized state with strict security warning', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const UniversalStateView.unauthorized(
            title: 'Private Founder Intelligence',
            message: 'This validation sprint is restricted to authorized principals.',
          ),
        ),
      );

      expect(find.text('Private Founder Intelligence'), findsOneWidget);
      expect(find.text('This validation sprint is restricted to authorized principals.'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('renders error state and triggers retry', (tester) async {
      bool retryTriggered = false;

      await tester.pumpWidget(
        createTestWidget(
          UniversalStateView.error(
            title: 'Connection Interrupted',
            message: 'Failed to fetch customer evidence.',
            onAction: () => retryTriggered = true,
          ),
        ),
      );

      expect(find.text('Connection Interrupted'), findsOneWidget);
      expect(find.text('Failed to fetch customer evidence.'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();
      expect(retryTriggered, isTrue);
    });
  });
}

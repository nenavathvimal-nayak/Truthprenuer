import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/design_system/responsive_layout.dart';

void main() {
  group('DeviceStyles & DeviceType Unit Tests', () {
    test('Mobile factory sets 1 section and correct flags', () {
      final styles = DeviceStyles.mobile();
      expect(styles.type, DeviceType.mobile);
      expect(styles.sectionCount, 1);
      expect(styles.gridColumns, 1);
      expect(styles.showBottomNav, isTrue);
      expect(styles.showNavRail, isFalse);
      expect(styles.showFullSidebar, isFalse);
      expect(styles.showRightPanel, isFalse);
    });

    test('Foldable factory sets 2 sections and nav rail', () {
      final styles = DeviceStyles.foldable();
      expect(styles.type, DeviceType.foldable);
      expect(styles.sectionCount, 2);
      expect(styles.gridColumns, 2);
      expect(styles.showBottomNav, isFalse);
      expect(styles.showNavRail, isTrue);
      expect(styles.showFullSidebar, isFalse);
      expect(styles.showRightPanel, isFalse);
    });

    test('Tablet factory sets 2 sections (<960px) and 3 sections (>=960px)', () {
      final stylesNarrow = DeviceStyles.tablet(width: 850);
      expect(stylesNarrow.type, DeviceType.tablet);
      expect(stylesNarrow.sectionCount, 2);
      expect(stylesNarrow.showRightPanel, isFalse);

      final stylesWide = DeviceStyles.tablet(width: 1000);
      expect(stylesWide.type, DeviceType.tablet);
      expect(stylesWide.sectionCount, 3);
      expect(stylesWide.showRightPanel, isTrue);
    });

    test('Desktop factory sets 3 sections and full sidebar + right panel', () {
      final styles = DeviceStyles.desktop();
      expect(styles.type, DeviceType.desktop);
      expect(styles.sectionCount, 3);
      expect(styles.gridColumns, 3);
      expect(styles.showBottomNav, isFalse);
      expect(styles.showNavRail, isFalse);
      expect(styles.showFullSidebar, isTrue);
      expect(styles.showRightPanel, isTrue);
    });
  });

  group('ResponsiveBuilder Widget Tests', () {
    testWidgets('renders mobile child at width < 600', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, deviceType, styles) {
              if (deviceType == DeviceType.mobile) {
                return Text('Mobile Section ${styles.sectionCount}');
              }
              return const Text('Other Device');
            },
          ),
        ),
      );

      expect(find.text('Mobile Section 1'), findsOneWidget);
      expect(find.text('Other Device'), findsNothing);
    });

    testWidgets('renders desktop child at width >= 1140', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, deviceType, styles) {
              if (deviceType == DeviceType.desktop) {
                return Text('Desktop Section ${styles.sectionCount}');
              }
              return const Text('Other Device');
            },
          ),
        ),
      );

      expect(find.text('Desktop Section 3'), findsOneWidget);
      expect(find.text('Other Device'), findsNothing);
    });

    testWidgets('renders tablet child at width 900', (tester) async {
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, deviceType, styles) {
              if (deviceType == DeviceType.tablet) {
                return Text('Tablet Section ${styles.sectionCount}');
              }
              return const Text('Other Device');
            },
          ),
        ),
      );

      expect(find.text('Tablet Section 2'), findsOneWidget);
    });
  });
}

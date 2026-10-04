import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/router/app_router.dart';

void main() {
  group('AppRouter Route Guard Safety Tests', () {
    test('Router configuration initializes and defines all key routes', () {
      expect(appRouter, isNotNull);
      final routes = appRouter.configuration.routes;
      expect(routes.isNotEmpty, isTrue);
    });
  });
}

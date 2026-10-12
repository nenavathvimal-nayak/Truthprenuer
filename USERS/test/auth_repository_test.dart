import 'package:flutter_test/flutter_test.dart';
import 'package:taeed_flutter/repositories/auth_repository.dart';

void main() {
  group('AuthRepository Password Reset & Recovery Tests', () {
    test('resetPasswordForEmail handles null client gracefully', () async {
      final repo = AuthRepository(null);

      // Should complete without throwing when client is null (offline/preview fallback)
      expect(
        () async => await repo.resetPasswordForEmail(
          'founder@truthprenuer.com',
          redirectTo: 'https://truthprenuer.pages.dev/change-password?recovery=true',
        ),
        returnsNormally,
      );
    });

    test('updatePassword throws expected exception when unconfigured', () async {
      final repo = AuthRepository(null);

      expect(
        () async => await repo.updatePassword('NewSecurePassword123!'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

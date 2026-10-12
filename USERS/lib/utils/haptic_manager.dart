import 'package:flutter/services.dart';

class HapticManager {
  HapticManager._();

  static final HapticManager shared = HapticManager._();

  Future<void> notificationSuccess() async {
    await HapticFeedback.lightImpact();
  }

  Future<void> notificationError() async {
    await HapticFeedback.heavyImpact();
  }

  Future<void> notificationWarning() async {
    await HapticFeedback.mediumImpact();
  }

  Future<void> impactLight() async {
    await HapticFeedback.lightImpact();
  }

  Future<void> impactMedium() async {
    await HapticFeedback.mediumImpact();
  }

  Future<void> impactHeavy() async {
    await HapticFeedback.heavyImpact();
  }

  Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  Future<void> success() => notificationSuccess();
  Future<void> error() => notificationError();
  Future<void> warning() => notificationWarning();
  Future<void> lightImpact() => impactLight();
  Future<void> mediumImpact() => impactMedium();
  Future<void> heavyImpact() => impactHeavy();
}

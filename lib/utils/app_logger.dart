import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

class AppLogger {
  static void info(String message, [String? context]) {
    _log(LogLevel.info, message, context);
  }

  static void warning(String message, [String? context]) {
    _log(LogLevel.warning, message, context);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace, String? context]) {
    _log(LogLevel.error, message, context, error, stackTrace);
  }

  static void _log(LogLevel level, String message, [String? context, dynamic error, StackTrace? stackTrace]) {
    if (!kDebugMode) return; // In production, we would send to Crashlytics/Datadog here

    final prefix = switch (level) {
      LogLevel.info => '🔵 INFO',
      LogLevel.warning => '🟠 WARN',
      LogLevel.error => '🔴 ERROR',
    };

    final contextStr = context != null ? ' [$context]' : '';
    debugPrint('$prefix$contextStr: $message');
    
    if (error != null) {
      debugPrint('   Details: $error');
    }
    if (stackTrace != null) {
      debugPrint('   Stack: $stackTrace');
    }
  }
}

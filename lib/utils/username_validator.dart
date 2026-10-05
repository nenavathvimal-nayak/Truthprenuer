class UsernameValidationResult {
  final bool isValid;
  final String? error;

  const UsernameValidationResult(this.isValid, [this.error]);

  static const valid = UsernameValidationResult(true);
}

class UsernameValidator {
  static const int minLength = 3;
  static const int maxLength = 20;

  static final RegExp _validFormat = RegExp(r'^[a-zA-Z0-9_]+$');

  static const Set<String> _reservedUsernames = {
    'admin',
    'administrator',
    'truthprenuer',
    'support',
    'root',
    'system',
    'api',
    'auth',
    'help',
    'team',
    'mod',
    'moderator',
    'official',
    'security',
    'privacy',
    'legal',
    'billing',
    'status',
    'founder',
  };

  /// Validates syntax and reserved word restrictions for a prospective username.
  static UsernameValidationResult validate(String? raw) {
    if (raw == null) {
      return const UsernameValidationResult(false, 'Username cannot be empty');
    }

    final clean = raw.trim().replaceAll('@', '');
    if (clean.isEmpty) {
      return const UsernameValidationResult(false, 'Username cannot be empty');
    }

    if (clean.length < minLength) {
      return const UsernameValidationResult(false, 'Username must be at least $minLength characters');
    }

    if (clean.length > maxLength) {
      return const UsernameValidationResult(false, 'Username cannot exceed $maxLength characters');
    }

    if (!_validFormat.hasMatch(clean)) {
      return const UsernameValidationResult(false, 'Only letters, numbers, and underscores are allowed');
    }

    if (_reservedUsernames.contains(clean.toLowerCase())) {
      return const UsernameValidationResult(false, 'This username is reserved by Truthprenuer');
    }

    return UsernameValidationResult.valid;
  }

  /// Sanitizes raw input into clean username string
  static String sanitize(String raw) {
    return raw.trim().replaceAll('@', '').toLowerCase();
  }
}

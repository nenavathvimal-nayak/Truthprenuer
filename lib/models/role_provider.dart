import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class RoleNotifier extends StateNotifier<UserRole> {
  RoleNotifier([super.initialRole = UserRole.founder]) {
    _loadSavedRole();
  }

  static const _key = 'user_active_role';

  Future<void> _loadSavedRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      if (saved != null) {
        state = UserRole.values.firstWhere((r) => r.name == saved);
      }
    } catch (_) {
      // Fallback gracefully in testing environments
    }
  }

  Future<void> switchRole(UserRole role) async {
    if (state == role) return;
    state = role;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, role.name);
    } catch (_) {
      // Fallback gracefully in testing environments
    }
  }

  bool get isFounder => state == UserRole.founder;
  bool get isInvestor => state == UserRole.investor;
  bool get isProfessional => state == UserRole.professional;
  bool get isCreator => state == UserRole.creator;
  bool get isStudent => state == UserRole.student;
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserRole>((ref) {
  return RoleNotifier();
});

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_logger.dart';
import 'app_providers.dart';
import 'supabase_client.dart';

enum NetworkConnectivityStatus {
  online,
  offline,
  syncing,
}

class NetworkConnectivityState {
  final NetworkConnectivityStatus status;
  final DateTime? lastChecked;
  final String? failureReason;

  const NetworkConnectivityState({
    this.status = NetworkConnectivityStatus.online,
    this.lastChecked,
    this.failureReason,
  });

  bool get isOnline => status == NetworkConnectivityStatus.online;
  bool get isOffline => status == NetworkConnectivityStatus.offline;
  bool get isSyncing => status == NetworkConnectivityStatus.syncing;

  NetworkConnectivityState copyWith({
    NetworkConnectivityStatus? status,
    DateTime? lastChecked,
    String? failureReason,
    bool clearFailureReason = false,
  }) {
    return NetworkConnectivityState(
      status: status ?? this.status,
      lastChecked: lastChecked ?? this.lastChecked,
      failureReason: clearFailureReason ? null : (failureReason ?? this.failureReason),
    );
  }
}

class NetworkConnectivityNotifier extends StateNotifier<NetworkConnectivityState> {
  final Ref _ref;
  Timer? _heartbeatTimer;

  NetworkConnectivityNotifier(this._ref, {bool autoStartHeartbeat = true}) : super(const NetworkConnectivityState()) {
    if (autoStartHeartbeat) {
      _initHeartbeat();
    }
  }

  void _initHeartbeat() {
    _heartbeatTimer?.cancel();
    // Periodically verify connectivity every 45 seconds
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 45), (_) {
      checkConnectivity();
    });
  }

  /// Explicit manual or periodic connectivity check
  Future<void> checkConnectivity() async {
    final wasOfflineOrSyncing = state.isOffline || state.isSyncing;

    if (state.isOffline) {
      state = state.copyWith(status: NetworkConnectivityStatus.syncing);
    }

    try {
      final client = safeSupabaseClient;
      bool reachable = false;

      if (client != null) {
        try {
          // Verify auth state accessibility
          final _ = client.auth.currentSession;
          reachable = true;
        } catch (_) {
          reachable = false;
        }
      } else {
        // If Supabase is not configured (offline / test / mock environment), assume online
        reachable = true;
      }

      if (reachable) {
        state = state.copyWith(
          status: NetworkConnectivityStatus.online,
          lastChecked: DateTime.now(),
          clearFailureReason: true,
        );

        // Auto-reconnect convergence: if transitioning back to online, invalidate stale feeds
        if (wasOfflineOrSyncing) {
          _reconvergeFeeds();
        }
      } else {
        state = state.copyWith(
          status: NetworkConnectivityStatus.offline,
          lastChecked: DateTime.now(),
          failureReason: "Network destination unreachable",
        );
      }
    } catch (e) {
      AppLogger.warning('Network connectivity check failed: $e', 'NetworkConnectivity');
      state = state.copyWith(
        status: NetworkConnectivityStatus.offline,
        lastChecked: DateTime.now(),
        failureReason: e.toString(),
      );
    }
  }

  /// Chaos / Testing hooks to deterministically simulate network transitions
  void simulateOffline({String? reason}) {
    state = state.copyWith(
      status: NetworkConnectivityStatus.offline,
      lastChecked: DateTime.now(),
      failureReason: reason ?? "Simulated network failure",
    );
  }

  void simulateOnline() {
    final wasOffline = state.isOffline || state.isSyncing;
    state = state.copyWith(
      status: NetworkConnectivityStatus.online,
      lastChecked: DateTime.now(),
      clearFailureReason: true,
    );
    if (wasOffline) {
      _reconvergeFeeds();
    }
  }

  void _reconvergeFeeds() {
    AppLogger.info('Reconnected to network. Re-converging state feeds...', 'NetworkConnectivity');
    _ref.invalidate(validationsProvider);
    _ref.invalidate(communityUsersProvider);
    _ref.invalidate(notificationsProvider);
    _ref.invalidate(conversationsProvider);
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    super.dispose();
  }
}

final networkConnectivityProvider = StateNotifierProvider<NetworkConnectivityNotifier, NetworkConnectivityState>((ref) {
  return NetworkConnectivityNotifier(ref, autoStartHeartbeat: false);
});

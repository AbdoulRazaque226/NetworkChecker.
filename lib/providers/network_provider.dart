import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/network_report.dart';
import '../models/network_status.dart';
import '../services/network_service.dart';

/// Exposes the live network state to the UI (Ben's home_screen / status_card).
///
/// State managed:
///  - [currentStatus] → network type currently detected.
///  - [isConnected]   → whether a real internet connection exists.
///  - [isLoading]     → a diagnostic is currently running.
///  - [lastReport]    → the most recent completed report.
///  - [lastError]     → message of the last failed diagnostic, if any.
///
/// It is a plain `ChangeNotifier` (no extra package needed) — the UI rebuilds
/// with Flutter's built-in `ListenableBuilder`/`AnimatedBuilder`:
///
///     ListenableBuilder(
///       listenable: networkProvider,
///       builder: (context, _) => ...,
///     );
class NetworkProvider extends ChangeNotifier {
  /// Injects [NetworkService]; tests can pass a fake service.
  NetworkProvider({NetworkService? networkService})
      : _networkService = networkService ?? NetworkService();

  final NetworkService _networkService;

  NetworkStatus _currentStatus = NetworkStatus.none;
  bool _isConnected = false;
  bool _isLoading = false;
  String? _lastError;
  NetworkReport? _lastReport;
  String _userId = '';
  Timer? _pollingTimer;

  /// The network type currently detected.
  NetworkStatus get currentStatus => _currentStatus;

  /// Whether a real internet connection is currently confirmed.
  bool get isConnected => _isConnected;

  /// Whether a diagnostic is in progress right now.
  bool get isLoading => _isLoading;

  /// Error message of the last failed diagnostic, or `null`.
  String? get lastError => _lastError;

  /// The most recent completed [NetworkReport], or `null` before the first run.
  NetworkReport? get lastReport => _lastReport;

  /// The Firebase uid stamped on every report produced while signed in.
  String get userId => _userId;

  /// Set the authenticated user id so reports are attributed correctly.
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  /// Runs a diagnostic right now and updates the exposed state.
  ///
  /// Returns the generated [NetworkReport] so the caller (e.g. Ben's history
  /// flow) can persist it immediately afterwards.
  Future<NetworkReport> checkConnection() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final NetworkReport report =
          await _networkService.checkConnection(userId: _userId);
      _currentStatus = report.connectionType;
      _isConnected = report.isConnected;
      _lastReport = report;
      return report;
    } catch (error) {
      // Keep the last known state, but surface the error to the UI.
      _lastError = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Starts monitoring network changes continuously.
  ///
  /// Abdoul's Platform Channel currently only exposes `getNetworkInfo()` —
  /// there is no native event stream (EventChannel) yet. As a fallback, this
  /// method polls a fresh diagnostic every [interval] so the UI stays up to
  /// date. Once Abdoul ships an EventChannel, this can be switched to events.
  void startListening({Duration interval = const Duration(seconds: 15)}) {
    stopListening();
    _pollingTimer = Timer.periodic(interval, (_) async {
      try {
        await checkConnection();
      } catch (_) {
        // A failed auto-check must not crash the app or kill the timer.
      }
    });
  }

  /// Stops the continuous monitoring started by [startListening].
  void stopListening() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
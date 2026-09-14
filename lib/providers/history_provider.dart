import 'package:flutter/foundation.dart';

import '../models/network_report.dart';
import '../services/firestore_service.dart';

/// Exposes the diagnostic history to the UI (Ben's history_screen).
///
/// The provider keeps an in-memory, newest-first copy of [reports] that stays
/// in sync with Firestore. Call [loadHistory] once the user signs in.
class HistoryProvider extends ChangeNotifier {
  /// Injects [FirestoreService]; tests can pass a fake service.
  HistoryProvider({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  List<NetworkReport> _reports = <NetworkReport>[];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  /// The loaded history, newest first. Unmodifiable for the UI.
  List<NetworkReport> get reports => List.unmodifiable(_reports);

  /// Whether a [loadHistory] call is currently running.
  bool get isLoading => _isLoading;

  /// Message of the last failed operation, or `null`.
  String? get error => _error;

  /// Loads the full history of [userId] from Firestore, newest first.
  Future<void> loadHistory(String userId) async {
    _userId = userId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reports = await _firestoreService.getReports(userId);
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Persists [report] to Firestore and inserts it at the top of the local
  /// list (newest first).
  ///
  /// Returns the saved report, which carries the Firestore-generated id.
  Future<NetworkReport> addReport(NetworkReport report) async {
    final NetworkReport saved = await _firestoreService.saveReport(report);
    _reports.insert(0, saved);
    _error = null;
    notifyListeners();
    return saved;
  }

  /// Deletes the report [id] from Firestore and from the local list.
  ///
  /// The local removal happens first so the UI updates instantly; the
  /// Firestore deletion runs afterwards and surfaces any error via [error].
  Future<void> deleteReport(String id) async {
    final String? uid = _userId;
    if (uid == null) {
      _error = 'No user loaded — call loadHistory() before deleting.';
      notifyListeners();
      return;
    }

    _reports.removeWhere((NetworkReport r) => r.id == id);
    notifyListeners();

    try {
      await _firestoreService.deleteReport(uid, id);
    } catch (error) {
      _error = error.toString();
      notifyListeners();
    }
  }
}
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

/// Exposes the authentication state to the UI (Ben's login_screen / app shell).
///
/// State managed:
///  - [currentUser]     → the signed-in Firebase [User], or `null`.
///  - [isAuthenticated] → convenience getter, true when a user is signed in.
///  - [isLoading]       → a sign-in / sign-out operation is in progress.
///  - [error]           → message of the last failed operation, if any.
///
/// The provider subscribes to Firebase `authStateChanges` so it automatically
/// stays in sync when the session is created, refreshed or ended — even
/// without an explicit call to [signIn] / [signOut].
class AuthProvider extends ChangeNotifier {
  /// Injects [AuthService]; tests can pass a fake service.
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    // Follow Firebase auth state for the whole provider lifetime.
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  final AuthService _authService;
  late final StreamSubscription<User?> _authSubscription;

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  /// The currently signed-in [User], or `null`.
  User? get currentUser => _currentUser;

  /// Convenience getter: `true` when a user is signed in.
  bool get isAuthenticated => _currentUser != null;

  /// Whether a sign-in / sign-out operation is running.
  bool get isLoading => _isLoading;

  /// Message of the last failed authentication operation, or `null`.
  String? get error => _error;

  /// The current user's Firebase uid, or `null`.
  ///
  /// This is what gets stamped on [NetworkReport.userId] and used to scope the
  /// Firestore history of each user.
  String? get userId => _currentUser?.uid;

  /// Signs the user in **anonymously** (no credentials required).
  Future<void> signIn() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final User? user = await _authService.signInAnonymously();
      if (user == null) {
        _error = 'Sign-in completed but no user was returned.';
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signOut();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
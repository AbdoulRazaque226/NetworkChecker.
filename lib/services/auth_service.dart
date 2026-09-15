import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around Firebase Auth.
///
/// Centralizes every authentication call so the rest of the app (providers and
/// UI) never talks to `FirebaseAuth` directly. It depends only on the Firebase
/// configuration already initialized in `main.dart` by Abdoul
/// (`Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`),
/// so nothing has to be changed on his side.
class AuthService {
  /// Injects [FirebaseAuth] so tests can pass a fake; defaults to the real
  /// shared instance already configured by the Firebase initialization.
  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Signs the user in **anonymously** (no email/password required).
  ///
  /// Returns the resulting [User], or `null` when sign-in did not produce one.
  /// Anonymous auth keeps onboarding frictionless while still giving each user
  /// its own Firestore history (see FirestoreService).
  Future<User?> signInAnonymously() async {
    final UserCredential credential = await _auth.signInAnonymously();
    return credential.user;
  }

  /// Signs the user in with an email address and password.
  Future<User?> signInWithEmail(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  /// Creates a new account with an email address and password.
  Future<User?> signUpWithEmail(String email, String password) async {
    final UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  /// Signs the current user out.
  Future<void> signOut() => _auth.signOut();

  /// The currently authenticated user, or `null` when signed out.
  User? get currentUser => _auth.currentUser;

  /// The current user's Firebase uid, or `null` when signed out.
  String? get currentUserId => _auth.currentUser?.uid;

  /// Reactive authentication stream (session start/end, token refresh, ...).
  ///
  /// The auth provider subscribes to this stream to keep the UI in sync
  /// automatically, even without an explicit sign-in/sign-out call.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'gen_l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/history_provider.dart';
import 'providers/language_provider.dart';
import 'providers/network_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageProvider _languageProvider = LanguageProvider();

  @override
  void initState() {
    super.initState();
    _languageProvider.loadSavedLocale();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _languageProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'NetworkChecker',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          locale: _languageProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppStartup(languageProvider: _languageProvider),
        );
      },
    );
  }
}

/// Routes the user through the app: onboarding (first launch) → login/crate
/// account → home. Follows the Firebase authentication state reactively.
class AppStartup extends StatefulWidget {
  const AppStartup({super.key, required this.languageProvider});

  final LanguageProvider languageProvider;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  static const String _onboardingPrefsKey = 'onboarding_completed';

  final AuthProvider _authProvider = AuthProvider();
  late final NetworkProvider _networkProvider = NetworkProvider();
  late final HistoryProvider _historyProvider = HistoryProvider();

  bool _ready = false;
  bool _onboardingCompleted = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _onboardingCompleted =
        prefs.getBool(_onboardingPrefsKey) ?? false;

    // Wire the data providers whenever a user is (or becomes) authenticated.
    if (_authProvider.isAuthenticated) {
      _wireProviders();
      await _historyProvider.loadHistory(_authProvider.userId!);
    }
    _authProvider.addListener(_onAuthChanged);

    if (mounted) setState(() => _ready = true);
  }

  void _onAuthChanged() {
    if (_authProvider.isAuthenticated && _authProvider.userId != null) {
      _wireProviders();
      _historyProvider.loadHistory(_authProvider.userId!);
    }
  }

  void _wireProviders() {
    _networkProvider.userId = _authProvider.userId!;
  }

  Future<void> _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingPrefsKey, true);
    if (mounted) setState(() => _onboardingCompleted = true);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _authProvider.dispose();
    _networkProvider.dispose();
    _historyProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // First launch only.
    if (!_onboardingCompleted) {
      return OnboardingScreen(
        languageProvider: widget.languageProvider,
        onComplete: _completeOnboarding,
      );
    }

    return ListenableBuilder(
      listenable: _authProvider,
      builder: (context, _) {
        if (_authProvider.isLoading || !_authProvider.isAuthenticated) {
          return LoginScreen(
            authProvider: _authProvider,
            languageProvider: widget.languageProvider,
          );
        }

        return HomeScreen(
          networkProvider: _networkProvider,
          historyProvider: _historyProvider,
          authProvider: _authProvider,
          languageProvider: widget.languageProvider,
        );
      },
    );
  }
}
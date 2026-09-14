import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/network_provider.dart';
import 'providers/history_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetworkChecker',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const AppStartup(),
    );
  }
}

/// Gère la connexion anonyme au démarrage, puis affiche HomeScreen.
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  final AuthProvider _authProvider = AuthProvider();
  late final NetworkProvider _networkProvider = NetworkProvider();
  late final HistoryProvider _historyProvider = HistoryProvider();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
  print('DEBUT INIT');
  if (!_authProvider.isAuthenticated) {
    await _authProvider.signIn();
    print('APRES SIGNIN - erreur: ${_authProvider.error}');
  }
  if (_authProvider.userId != null) {
    print('USER ID: ${_authProvider.userId}');
    _networkProvider.userId = _authProvider.userId!;
    await _historyProvider.loadHistory(_authProvider.userId!);
    print('HISTORIQUE CHARGE');
  } else {
    print('PAS DE USER ID - AUTHENTIFICATION ECHOUEE');
  }
}

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authProvider,
      builder: (context, _) {
        if (_authProvider.isLoading || !_authProvider.isAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return HomeScreen(
          networkProvider: _networkProvider,
          historyProvider: _historyProvider,
        );
      },
    );
  }
}
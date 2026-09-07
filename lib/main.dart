import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'platform/network_channel.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Network Channel')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final info = await NetworkChannel.getNetworkInfo();
              print('Résultat du natif : $info');
            },
            child: const Text('Tester la connexion'),
            
          ),
        ),
      ),
    );
  }
}
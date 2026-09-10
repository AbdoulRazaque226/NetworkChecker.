import 'package:flutter/material.dart';
import '../providers/network_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/status_card.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.networkProvider,
    required this.historyProvider,
  });

  final NetworkProvider networkProvider;
  final HistoryProvider historyProvider;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Lance un premier diagnostic au chargement de l'écran.
    widget.networkProvider.checkConnection();
    // Démarre la surveillance continue (toutes les 15s par défaut).
    widget.networkProvider.startListening();
  }

  @override
  void dispose() {
    widget.networkProvider.stopListening();
    super.dispose();
  }

  Future<void> _runManualTest() async {
    try {
      final report = await widget.networkProvider.checkConnection();
      await widget.historyProvider.addReport(report);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnostic enregistré')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetworkChecker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(historyProvider: widget.historyProvider),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.networkProvider,
        builder: (context, _) {
          final provider = widget.networkProvider;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StatusCard(
                  connectionType: provider.currentStatus,
                  isConnected: provider.isConnected,
                  signalStrength: provider.lastReport?.signalStrength,
                ),
                const SizedBox(height: 24),
                if (provider.lastError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      provider.lastError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: provider.isLoading ? null : _runManualTest,
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(provider.isLoading ? 'Test en cours...' : 'Lancer un test'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
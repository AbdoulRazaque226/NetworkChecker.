import 'package:flutter/material.dart';
import '../providers/history_provider.dart';
import '../widgets/history_tile.dart';
import '../widgets/export_button.dart';
import '../services/export_service.dart';
import 'details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, required this.historyProvider});

  final HistoryProvider historyProvider;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isExporting = false;

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      final exportService = ExportService();
      await exportService.exportToJson(widget.historyProvider.reports);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export JSON réussi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur export : $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: ListenableBuilder(
        listenable: widget.historyProvider,
        builder: (context, _) {
          final provider = widget.historyProvider;

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Erreur : ${provider.error}'));
          }

          if (provider.reports.isEmpty) {
            return const Center(child: Text('Aucun diagnostic enregistré pour le moment.'));
          }

          return ListView.separated(
            itemCount: provider.reports.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final report = provider.reports[index];
              return HistoryTile(
                report: report,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailsScreen(report: report)),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ExportButton(onPressed: _handleExport, isLoading: _isExporting),
      ),
    );
  }
}
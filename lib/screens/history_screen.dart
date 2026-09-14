import 'package:flutter/material.dart';
import '../providers/history_provider.dart';
import '../models/network_report.dart';
import '../models/network_status.dart';
import '../services/export_service.dart';
import 'details_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      final String jsonContent = exportService.exportToJson(widget.historyProvider.reports);

      // Écrit le JSON dans un fichier temporaire
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = 'networkchecker_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonContent);

      // Ouvre le menu de partage du système
      await Share.shareXFiles([XFile(file.path)], text: 'Export NetworkChecker');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export JSON prêt à partager')),
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

  Future<void> _confirmDeleteOne(NetworkReport report) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce diagnostic ?'),
        content: Text(
          'Le rapport du ${_formatDate(report.timestamp)} sera supprimé définitivement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.historyProvider.deleteReport(report.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rapport supprimé')),
        );
      }
    }
  }

  Future<void> _confirmClearAll() async {
    final reports = widget.historyProvider.reports;
    if (reports.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider tout l\'historique ?'),
        content: Text(
          'Les ${reports.length} rapports enregistrés seront supprimés définitivement. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tout supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final idsToDelete = reports.map((r) => r.id).toList();
      for (final id in idsToDelete) {
        await widget.historyProvider.deleteReport(id);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historique vidé')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} à $h:$m';
  }

  Color _statusColor(NetworkReport report) =>
      report.isConnected ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

  IconData _statusIcon(NetworkReport report) {
    if (!report.isConnected) return Icons.wifi_off_rounded;
    return switch (report.connectionType) {
      NetworkStatus.wifi => Icons.wifi_rounded,
      NetworkStatus.mobile => Icons.signal_cellular_alt_rounded,
      NetworkStatus.none => Icons.signal_wifi_off_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          ListenableBuilder(
            listenable: widget.historyProvider,
            builder: (context, _) {
              final hasReports = widget.historyProvider.reports.isNotEmpty;
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: 'Tout supprimer',
                onPressed: hasReports ? _confirmClearAll : null,
              );
            },
          ),
        ],
      ),
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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun diagnostic enregistré',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.reports.length,
            itemBuilder: (context, index) {
              final report = provider.reports[index];
              final color = _statusColor(report);

              return Dismissible(
                key: ValueKey(report.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _confirmDeleteOne(report);
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailsScreen(report: report)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(_statusIcon(report), color: color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.connectionType.displayName,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _formatDate(report.timestamp),
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            if (report.latencyMs != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${report.latencyMs} ms',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                              ),
                            IconButton(
                              icon: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 20),
                              onPressed: () => _confirmDeleteOne(report),
                              tooltip: 'Supprimer',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _handleExport,
        icon: _isExporting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.ios_share_rounded),
        label: Text(_isExporting ? 'Export...' : 'Exporter'),
      ),
    );
  }
}
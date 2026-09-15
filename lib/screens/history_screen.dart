import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../gen_l10n/app_localizations.dart';
import '../models/network_report.dart';
import '../models/network_status.dart';
import '../providers/history_provider.dart';
import '../services/export_service.dart';
import '../widgets/circuit_background.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    setState(() => _isExporting = true);
    try {
      final exportService = ExportService();
      final String jsonContent =
          exportService.exportToJson(widget.historyProvider.reports);

      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'networkchecker_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonContent);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'NetworkChecker ${l10n.history_export}',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.history_exportReady)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text('${l10n.history_exportError} : $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _confirmDeleteOne(NetworkReport report) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.history_deleteConfirmTitle),
        content: Text(l10n.history_deleteConfirmBody(
            _formatDate(report.timestamp))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.history_cancel),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.history_delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.historyProvider.deleteReport(report.id);
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.history_deleted)));
      }
    }
  }

  Future<void> _confirmClearAll() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final reports = widget.historyProvider.reports;
    if (reports.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.history_clearAllConfirmTitle),
        content: Text(l10n.history_clearAllConfirmBody(reports.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.history_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.history_clearAll),
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
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.history_cleared)));
      }
    }
  }

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} à $h:$m';
  }

  Color _statusColor(NetworkReport report) =>
      report.isConnected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error;

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
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history_title),
        actions: [
          ListenableBuilder(
            listenable: widget.historyProvider,
            builder: (context, _) {
              final hasReports = widget.historyProvider.reports.isNotEmpty;
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: l10n.history_clearAll,
                onPressed: hasReports ? _confirmClearAll : null,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          ListenableBuilder(
            listenable: widget.historyProvider,
            builder: (context, _) {
              final provider = widget.historyProvider;

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: Text('${l10n.home_error} : ${provider.error}'),
                );
              }

              if (provider.reports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.history_empty,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => DetailsScreen(report: report),
                                ),
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
                                      color: color.withValues(alpha: 0.12),
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
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _formatDate(report.timestamp),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (report.latencyMs != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.10),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${report.latencyMs} ms',
                                        style: theme.textTheme.bodySmall!.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      size: 20,
                                    ),
                                    onPressed: () => _confirmDeleteOne(report),
                                    tooltip: l10n.history_delete,
                                  ),
                                ],
                              ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isExporting ? null : _handleExport,
        icon: _isExporting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.ios_share_rounded),
        label: Text(_isExporting ? l10n.history_exporting : l10n.history_export),
      ),
    );
  }
}
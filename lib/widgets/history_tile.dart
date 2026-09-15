import 'package:flutter/material.dart';

import '../models/network_report.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({super.key, required this.report, required this.onTap});

  final NetworkReport report;
  final VoidCallback onTap;

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} à $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color statusColor =
        report.isConnected ? theme.colorScheme.primary : theme.colorScheme.error;
    final bool hasLatency = report.latencyMs != null;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  report.isConnected
                      ? Icons.network_check_rounded
                      : Icons.wifi_off_rounded,
                  color: statusColor,
                  size: 24,
                ),
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
              if (hasLatency)
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
                icon: Icon(Icons.chevron_right_rounded),
                color: theme.colorScheme.onSurfaceVariant,
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
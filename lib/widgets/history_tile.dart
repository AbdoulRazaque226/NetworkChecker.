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
    final Color statusColor = report.isConnected ? Colors.green : Colors.red;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.15),
        child: Icon(
          report.isConnected ? Icons.check_circle : Icons.error,
          color: statusColor,
        ),
      ),
      title: Text(report.connectionType.displayName),
      subtitle: Text(_formatDate(report.timestamp)),
      trailing: report.latencyMs != null
          ? Text('${report.latencyMs} ms', style: const TextStyle(color: Colors.grey))
          : null,
    );
  }
}
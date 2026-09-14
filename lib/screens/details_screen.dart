import 'package:flutter/material.dart';
import '../models/network_report.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.report});

  final NetworkReport report;

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} à $h:$m';
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value ?? 'Non disponible', style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = report.isConnected ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails du diagnostic')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: statusColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    report.isConnected ? Icons.check_circle : Icons.error,
                    color: statusColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    report.isConnected ? 'Connecté à internet' : 'Pas d\'accès internet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _row('Type', report.connectionType.displayName),
          _row('Date', _formatDate(report.timestamp)),
          _row('Signal', report.signalStrength != null ? '${report.signalStrength}' : null),
          _row('Adresse IP', report.ipAddress),
          _row('Réseau (SSID)', report.ssid),
          _row('Latence', report.latencyMs != null ? '${report.latencyMs} ms' : null),
        ],
      ),
    );
  }
}
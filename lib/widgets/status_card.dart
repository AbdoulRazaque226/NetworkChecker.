import 'package:flutter/material.dart';
import '../models/network_status.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.connectionType,
    required this.isConnected,
    this.signalStrength,
  });

  final NetworkStatus connectionType;
  final bool isConnected;
  final int? signalStrength;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isConnected ? Colors.green : Colors.red;
    final IconData icon = switch (connectionType) {
      NetworkStatus.wifi => Icons.wifi,
      NetworkStatus.mobile => Icons.signal_cellular_alt,
      NetworkStatus.none => Icons.signal_wifi_off,
    };

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(icon, color: statusColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    connectionType.displayName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isConnected ? 'Connecté à internet' : 'Pas d\'accès internet',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                  ),
                  if (signalStrength != null) ...[
                    const SizedBox(height: 4),
                    Text('Signal : $signalStrength'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
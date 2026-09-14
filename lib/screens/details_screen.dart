import 'package:flutter/material.dart';
import '../models/network_report.dart';
import '../models/network_status.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.report});

  final NetworkReport report;

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    const mois = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${date.day} ${mois[date.month - 1]} ${date.year} à $h:$m';
  }

  Color get _statusColor => report.isConnected ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

  IconData get _statusIcon {
    if (!report.isConnected) return Icons.wifi_off_rounded;
    return switch (report.connectionType) {
      NetworkStatus.wifi => Icons.wifi_rounded,
      NetworkStatus.mobile => Icons.signal_cellular_alt_rounded,
      NetworkStatus.none => Icons.signal_wifi_off_rounded,
    };
  }

  Color _batteryColor(int level) {
    if (level <= 20) return const Color(0xFFC62828);
    if (level <= 50) return const Color(0xFFEF6C00);
    return const Color(0xFF2E7D32);
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String? value,
    required Color iconColor,
  }) {
    final bool available = value != null;
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: available ? iconColor.withOpacity(0.12) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: available ? iconColor : Colors.grey.shade400, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  value ?? 'Non disponible',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: available ? Colors.black87 : Colors.grey.shade400,
                    fontStyle: available ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: _statusColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_statusColor, _statusColor.withOpacity(0.75)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_statusIcon, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        report.isConnected ? 'Connecté à internet' : 'Pas d\'accès internet',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.connectionType.displayName,
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Informations générales',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.schedule_rounded,
                  label: 'Date du diagnostic',
                  value: _formatDate(report.timestamp),
                  iconColor: Colors.indigo,
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.speed_rounded,
                  label: 'Latence',
                  value: report.latencyMs != null ? '${report.latencyMs} ms' : null,
                  iconColor: Colors.teal,
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.battery_charging_full_rounded,
                  label: 'Batterie',
                  value: report.batteryLevel != null ? '${report.batteryLevel}%' : null,
                  iconColor: report.batteryLevel != null
                      ? _batteryColor(report.batteryLevel!)
                      : Colors.grey,
                ),
                const SizedBox(height: 24),
                Text(
                  'Détails techniques',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.network_check_rounded,
                  label: 'Force du signal',
                  value: report.signalStrength != null ? '${report.signalStrength} dBm' : null,
                  iconColor: Colors.orange,
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.dns_rounded,
                  label: 'Adresse IP',
                  value: report.ipAddress,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 10),
                _infoCard(
                  icon: Icons.router_rounded,
                  label: 'Réseau (SSID)',
                  value: report.ssid,
                  iconColor: Colors.purple,
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
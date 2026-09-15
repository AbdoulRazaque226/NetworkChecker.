import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../models/network_report.dart';
import '../models/network_status.dart';
import '../widgets/circuit_background.dart';

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

  IconData get _statusIcon {
    if (!report.isConnected) return Icons.wifi_off_rounded;
    return switch (report.connectionType) {
      NetworkStatus.wifi => Icons.wifi_rounded,
      NetworkStatus.mobile => Icons.signal_cellular_alt_rounded,
      NetworkStatus.none => Icons.signal_wifi_off_rounded,
    };
  }

  Color _batteryColor(int level, ColorScheme scheme) {
    if (level <= 20) return scheme.error;
    if (level <= 50) return const Color(0xFFF59E0B);
    return scheme.primary;
  }

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String? value,
    required Color iconColor,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool available = value != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.onSurfaceVariant.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: available ? iconColor.withValues(alpha: 0.12) : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: available ? iconColor : scheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                const SizedBox(height: 3),
                Text(
                  value ?? AppLocalizations.of(context)!.details_notAvailable,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: available
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant.withValues(alpha: 0.6),
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color statusColor =
        report.isConnected ? scheme.primary : scheme.error;
    final String statusLabel =
        report.isConnected ? l10n.details_connected : l10n.details_disconnected;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: scaffoldBackground(context),
                surfaceTintColor: Colors.transparent,
                iconTheme: IconThemeData(color: scheme.onSurface),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          statusColor.withValues(alpha: 0.85),
                          statusColor.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_statusIcon, color: Colors.white, size: 34),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            statusLabel,
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            report.connectionType.displayName,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      l10n.details_general,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.schedule_rounded,
                      label: l10n.details_date,
                      value: _formatDate(report.timestamp),
                      iconColor: scheme.secondary,
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.speed_rounded,
                      label: l10n.details_latency,
                      value: report.latencyMs != null
                          ? l10n.details_milliseconds(report.latencyMs!)
                          : null,
                      iconColor: scheme.primary,
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.battery_charging_full_rounded,
                      label: l10n.details_battery,
                      value: report.batteryLevel != null
                          ? '${report.batteryLevel}%'
                          : null,
                      iconColor: report.batteryLevel != null
                          ? _batteryColor(report.batteryLevel!, scheme)
                          : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.details_technical,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.network_check_rounded,
                      label: l10n.details_signal,
                      value: report.signalStrength != null
                          ? '${report.signalStrength} dBm'
                          : null,
                      iconColor: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.dns_rounded,
                      label: l10n.details_ip,
                      value: report.ipAddress,
                      iconColor: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    _infoCard(
                      context: context,
                      icon: Icons.router_rounded,
                      label: l10n.details_ssid,
                      value: report.ssid,
                      iconColor: Colors.purple,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Scaffold background colour used behind the collapsed app bar so the
  /// texture and the app bar stay visually consistent.
  static Color scaffoldBackground(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
}
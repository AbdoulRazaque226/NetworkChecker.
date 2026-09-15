import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../models/network_status.dart';

/// Hero status card: connection type, connection state and a live signal bar.
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
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Color statusColor = isConnected
        ? theme.colorScheme.primary
        : theme.colorScheme.error;
    final IconData icon = switch (connectionType) {
      NetworkStatus.wifi => Icons.wifi_rounded,
      NetworkStatus.mobile => Icons.signal_cellular_alt_rounded,
      NetworkStatus.none => Icons.signal_wifi_off_rounded,
    };
    final String stateText =
        isConnected ? l10n.home_connected : l10n.home_disconnected;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.45),
                      width: 1.4,
                    ),
                  ),
                  child: Icon(icon, color: statusColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        connectionType.displayName,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stateText,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (signalStrength != null) ...[
              const SizedBox(height: 18),
              _SignalBar(strength: signalStrength!, color: statusColor),
            ],
          ],
        ),
      ),
    );
  }
}

/// A small visualization of the Wi-Fi signal strength.
class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.strength, required this.color});

  /// RSSI in dBm (negative) or mobile level 0-4.
  final int strength;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String label = strength > -1
        ? '$strength'
        : '$strength dBm';
    // Level 0..4; good signal is closer to 0 dBm (less negative).
    final int bars = strength <= -95
        ? 1
        : strength <= -75
            ? 2
            : strength <= -55
                ? 3
                : strength < -1
                    ? 4
                    : (strength + 1).clamp(1, 4);

    return Row(
      children: [
        ...List.generate(4, (int index) {
          final bool active = index < bars;
          return Container(
            margin: const EdgeInsets.only(right: 4),
            width: 7,
            height: 10 + index * 5,
            decoration: BoxDecoration(
              color: active
                  ? color
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 10),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
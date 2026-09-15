import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../models/network_report.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../providers/language_provider.dart';
import '../providers/network_provider.dart';
import '../widgets/circuit_background.dart';
import '../widgets/language_toggle.dart';
import '../widgets/status_card.dart';
import 'history_screen.dart';
import 'how_it_works_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.networkProvider,
    required this.historyProvider,
    required this.authProvider,
    required this.languageProvider,
  });

  final NetworkProvider networkProvider;
  final HistoryProvider historyProvider;
  final AuthProvider authProvider;
  final LanguageProvider languageProvider;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Un premier diagnostic au chargement de l'écran.
    widget.networkProvider.checkConnection();
    // Surveillance continue (toutes les 15s par défaut).
    widget.networkProvider.startListening();
  }

  @override
  void dispose() {
    widget.networkProvider.stopListening();
    super.dispose();
  }

  Future<void> _runManualTest() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    try {
      final report = await widget.networkProvider.checkConnection();
      await widget.historyProvider.addReport(report);
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.home_testSaved)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${l10n.home_error} : $e')));
      }
    }
  }

  Future<void> _confirmSignOut() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.home_signOut),
        content: Text(l10n.home_signOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.history_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.home_signOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.authProvider.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: theme.textTheme.titleLarge!.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          LanguageToggle(languageProvider: widget.languageProvider),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: l10n.how_title,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const HowItWorksScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: l10n.history_title,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => HistoryScreen(
                    historyProvider: widget.historyProvider,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: l10n.home_signOut,
            onPressed: _confirmSignOut,
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          ListenableBuilder(
            listenable: widget.networkProvider,
            builder: (context, _) {
              final provider = widget.networkProvider;
              return RefreshIndicator(
                onRefresh: _runManualTest,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    StatusCard(
                      connectionType: provider.currentStatus,
                      isConnected: provider.isConnected,
                      signalStrength: provider.lastReport?.signalStrength,
                    ),
                    const SizedBox(height: 12),
                    if (provider.lastReport?.batteryLevel != null)
                      _BatteryCard(batteryLevel: provider.lastReport!.batteryLevel!),
                    if (provider.lastError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          '${l10n.home_error} : ${provider.lastError}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    if (provider.lastReport == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: Text(
                          l10n.home_noReport,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    const SizedBox(height: 28),
                    Text(l10n.home_section_metrics,
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      l10n.home_section_metrics_desc,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 14),
                    _MetricsGrid(report: provider.lastReport),
                    const SizedBox(height: 24),
                    ListenableBuilder(
                      listenable: provider,
                      builder: (context, _) => ElevatedButton.icon(
                        onPressed: provider.isLoading ? null : _runManualTest,
                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh_rounded),
                        label: Text(
                          provider.isLoading
                              ? l10n.home_testing
                              : l10n.home_runTest,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BatteryCard extends StatelessWidget {
  const _BatteryCard({required this.batteryLevel});

  final int batteryLevel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color color = batteryLevel <= 20
        ? theme.colorScheme.error
        : batteryLevel <= 50
            ? const Color(0xFFF59E0B)
            : theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.battery_charging_full_rounded, color: color, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${l10n.home_metric_battery} : $batteryLevel%',
                style: theme.textTheme.titleMedium,
              ),
            ),
            _BatteryFill(level: batteryLevel, color: color),
          ],
        ),
      ),
    );
  }
}

class _BatteryFill extends StatelessWidget {
  const _BatteryFill({required this.level, required this.color});

  final int level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 24,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.4),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: level / 100,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.report});

  final NetworkReport? report;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool hasData = report != null;
    final String latency =
        (hasData && report!.latencyMs != null) ? '${report!.latencyMs} ms' : l10n.home_notAvailable;
    final String signal =
        (hasData && report!.signalStrength != null) ? '${report!.signalStrength} dBm' : l10n.home_notAvailable;
    final String ip = (hasData && report!.ipAddress != null)
        ? report!.ipAddress.toString()
        : l10n.home_notAvailable;
    final String ssid = (hasData && report!.ssid != null)
        ? report!.ssid.toString()
        : l10n.home_notAvailable;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.speed_rounded,
                titleKey: l10n.home_metric_latency,
                descKey: l10n.home_metric_latency_desc,
                value: latency,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.signal_cellular_alt_rounded,
                titleKey: l10n.home_metric_signal,
                descKey: l10n.home_metric_signal_desc,
                value: signal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.dns_rounded,
                titleKey: l10n.home_metric_ip,
                descKey: l10n.home_metric_ip_desc,
                value: ip,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.router_rounded,
                titleKey: l10n.home_metric_ssid,
                descKey: l10n.home_metric_ssid_desc,
                value: ssid,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.value,
  });

  final IconData icon;
  final String titleKey;
  final String descKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titleKey,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descKey,
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
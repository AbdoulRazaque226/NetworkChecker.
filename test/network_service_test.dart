import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker/models/network_report.dart';
import 'package:network_checker/models/network_status.dart';
import 'package:network_checker/services/export_service.dart';
import 'package:network_checker/services/network_service.dart';

/// Tests for [NetworkService] (mapping the native map → typed report) and
/// [ExportService] (JSON generation). The native layer is replaced by fakes,
/// so no device or Platform Channel is required.
void main() {
  group('NetworkService', () {
    /// Builds a service whose native call returns [raw] and whose latency
    /// probe returns [latency] (or null by default).
    NetworkService serviceWith(
      Map<String, dynamic> raw, {
      int? latency = 12,
    }) {
      return NetworkService(
        getNetworkInfo: () async => raw,
        measureLatency: () async => latency,
      );
    }

    test('maps a fully-populated native map into a NetworkReport', () async {
      final NetworkReport report = await serviceWith({
        'type': 'wifi',
        'isConnected': true,
        'signalStrength': 4,
        'ipAddress': '192.168.1.10',
        'ssid': 'FFSC_Guest',
      }).checkConnection(userId: 'uid-123');

      expect(report.connectionType, NetworkStatus.wifi);
      expect(report.isConnected, isTrue);
      expect(report.signalStrength, 4);
      expect(report.ipAddress, '192.168.1.10');
      expect(report.ssid, 'FFSC_Guest');
      expect(report.latencyMs, 12);
      expect(report.userId, 'uid-123');
      expect(report.timestamp.difference(DateTime.now()).inSeconds.abs(), 0);
      expect(report.id, '');
    });

    test('does not measure latency when there is no connection', () async {
      bool latencyCalled = false;
      final NetworkService service = NetworkService(
        getNetworkInfo: () async => <String, dynamic>{'type': 'none', 'isConnected': false},
        measureLatency: () async {
          latencyCalled = true;
          return 12;
        },
      );

      final NetworkReport report = await service.checkConnection();
      expect(report.connectionType, NetworkStatus.none);
      expect(report.isConnected, isFalse);
      expect(report.latencyMs, isNull);
      expect(latencyCalled, isFalse);
    });

    test('handles missing/nullable native fields gracefully', () async {
      final NetworkReport report =
          await serviceWith(<String, dynamic>{'isConnected': false})
              .checkConnection();

      expect(report.connectionType, NetworkStatus.none);
      expect(report.isConnected, isFalse);
      expect(report.signalStrength, isNull);
      expect(report.ipAddress, isNull);
      expect(report.ssid, isNull);
      expect(report.latencyMs, isNull);
    });

    test('coerces numeric values that arrive as strings', () async {
      final NetworkReport report = await serviceWith({
        'isConnected': true,
        'signalStrength': '5',
      }).checkConnection();

      expect(report.signalStrength, 5);
      expect(report.latencyMs, 12);
    });

    test('a latency probe failure yields a null latency, not a crash', () async {
      final NetworkService service = NetworkService(
        getNetworkInfo: () async => <String, dynamic>{'isConnected': true},
        measureLatency: () async {
          throw Exception('probe failed');
        },
      );

      final NetworkReport report = await service.checkConnection();
      expect(report.isConnected, isTrue);
      expect(report.latencyMs, isNull);
    });
  });

  group('ExportService', () {
    final List<NetworkReport> history = <NetworkReport>[
      NetworkReport(
        id: 'a',
        timestamp: DateTime(2026, 9, 8, 10),
        connectionType: NetworkStatus.wifi,
        isConnected: true,
        userId: 'u1',
      ),
      NetworkReport(
        id: 'b',
        timestamp: DateTime(2026, 9, 8, 11),
        connectionType: NetworkStatus.none,
        isConnected: false,
        userId: 'u1',
      ),
    ];

    test('exportReport produces valid JSON for one report', () {
      final String json = ExportService().exportReport(history.first);
      final Map<String, dynamic> decoded = jsonDecode(json) as Map<String, dynamic>;
      expect(decoded['id'], 'a');
      expect(decoded['connectionType'], 'wifi');
      expect(decoded['isConnected'], isTrue);
    });

    test('exportToJson produces a valid, readable JSON array', () {
      final String json = ExportService().exportToJson(history);
      final List<dynamic> decoded = jsonDecode(json) as List<dynamic>;
      expect(decoded, hasLength(2));
      expect(decoded[1]['connectionType'], 'none');
      // Verify pretty-printed output is multiline (not a single-line compact blob).
      expect(json, contains('\n'));
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker/models/network_report.dart';
import 'package:network_checker/models/network_status.dart';

/// Tests for [NetworkReport]: the shared contract used by the whole team.
/// These cover JSON round-trips and the tolerant timestamp parsing.
void main() {
  // DateTime is not a const type, so the sample is built with `final`.
  final NetworkReport sample = NetworkReport(
    id: 'doc-1',
    timestamp: DateTime(2026, 9, 8, 10, 30),
    connectionType: NetworkStatus.wifi,
    isConnected: true,
    signalStrength: 4,
    ipAddress: '192.168.1.10',
    ssid: 'FFSC_Guest',
    latencyMs: 42,
    userId: 'uid-123',
  );

  group('toJson / fromJson round-trip', () {
    test('round-trips every field through JSON', () {
      final NetworkReport decoded =
          NetworkReport.fromJson(sample.toJson());
      expect(decoded.id, sample.id);
      expect(decoded.timestamp, sample.timestamp);
      expect(decoded.connectionType, sample.connectionType);
      expect(decoded.isConnected, sample.isConnected);
      expect(decoded.signalStrength, sample.signalStrength);
      expect(decoded.ipAddress, sample.ipAddress);
      expect(decoded.ssid, sample.ssid);
      expect(decoded.latencyMs, sample.latencyMs);
      expect(decoded.userId, sample.userId);
    });

    test('writes connectionType as canonical string', () {
      final Map<String, dynamic> json = sample.toJson();
      expect(json['connectionType'], 'wifi');
    });

    test('writes timestamp as ISO-8601 string', () {
      final Map<String, dynamic> json = sample.toJson();
      expect(json['timestamp'], '2026-09-08T10:30:00.000');
    });
  });

  group('timestamp parsing', () {
    test('accepts a DateTime directly', () {
      final NetworkReport report = NetworkReport.fromJson(
        <String, dynamic>{'timestamp': DateTime(2026, 1, 1)},
      );
      expect(report.timestamp, DateTime(2026, 1, 1));
    });

    test('accepts an ISO-8601 string', () {
      final NetworkReport report = NetworkReport.fromJson(
        const <String, dynamic>{'timestamp': '2026-09-08T09:00:00Z'},
      );
      expect(report.timestamp, DateTime.utc(2026, 9, 8, 9));
    });

    test('accepts epoch milliseconds', () {
      final int epoch = DateTime(2026, 9, 8).millisecondsSinceEpoch;
      final NetworkReport report =
          NetworkReport.fromJson(<String, dynamic>{'timestamp': epoch});
      expect(report.timestamp, DateTime(2026, 9, 8));
    });

    test('falls back to now for invalid or missing timestamps', () {
      final DateTime before = DateTime.now();
      // Missing timestamp only happens when optional fields are absent, but the
      // defensive default must still be a valid DateTime.
      final NetworkReport report =
          NetworkReport.fromJson(const <String, dynamic>{});
      expect(report.timestamp.isAfter(before), isTrue);
    });
  });

  group('defaults for nullable/missing values', () {
    test('missing optional fields become null/empty without crashing', () {
      final NetworkReport report = NetworkReport.fromJson(
        const <String, dynamic>{'connectionType': 'none'},
      );
      expect(report.id, '');
      expect(report.connectionType, NetworkStatus.none);
      expect(report.isConnected, isFalse);
      expect(report.signalStrength, isNull);
      expect(report.ipAddress, isNull);
      expect(report.ssid, isNull);
      expect(report.latencyMs, isNull);
      expect(report.userId, '');
    });
  });

  group('copyWith', () {
    test('overrides only the provided fields', () {
      final NetworkReport updated =
          sample.copyWith(ipAddress: '10.0.0.1', latencyMs: 100);
      expect(updated.id, sample.id);
      expect(updated.ipAddress, '10.0.0.1');
      expect(updated.latencyMs, 100);
      expect(updated.connectionType, sample.connectionType);
      expect(updated.timestamp, sample.timestamp);
    });

    test('copyWith with no arguments returns an equal report', () {
      final NetworkReport copy = sample.copyWith();
      expect(copy.id, sample.id);
      expect(copy.latencyMs, sample.latencyMs);
    });
  });
}
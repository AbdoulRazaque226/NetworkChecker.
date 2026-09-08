import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker/models/network_report.dart';
import 'package:network_checker/models/network_status.dart';
import 'package:network_checker/providers/network_provider.dart';
import 'package:network_checker/services/network_service.dart';

/// Tests for [NetworkProvider]: the state exposed to Ben's UI is updated
/// correctly after a diagnostic. A fake [NetworkService] avoids the native
/// Platform Channel entirely.
void main() {
  late NetworkProvider provider;

  /// Creates a provider backed by a fake service whose native map is [raw].
  setUp(() {
    provider = NetworkProvider(
      networkService: NetworkService(
        getNetworkInfo: () async => <String, dynamic>{
          'type': 'wifi',
          'isConnected': true,
          'signalStrength': 4,
          'ipAddress': '192.168.1.10',
          'ssid': 'FFSC_Guest',
        },
        measureLatency: () async => 30,
      ),
    );
  });

  tearDown(() {
    provider.dispose();
  });

  test('checkConnection updates the exposed state and returns a report',
      () async {
    final NetworkReport report = await provider.checkConnection();

    expect(report.connectionType, NetworkStatus.wifi);
    expect(provider.currentStatus, NetworkStatus.wifi);
    expect(provider.isConnected, isTrue);
    expect(provider.isLoading, isFalse);
    expect(provider.lastReport, isNotNull);
    expect(provider.lastError, isNull);
  });

  test('isLoading is true while the diagnostic is running', () async {
    final Future<NetworkReport> pending = provider.checkConnection();
    expect(provider.isLoading, isTrue);
    await pending;
    expect(provider.isLoading, isFalse);
  });

  test('userId is stamped on generated reports', () async {
    provider.userId = 'uid-42';
    final NetworkReport report = await provider.checkConnection();
    expect(report.userId, 'uid-42');
  });

  test('a failed diagnostic surfaces the error without crashing', () async {
    final NetworkProvider failingProvider = NetworkProvider(
      networkService: NetworkService(
        getNetworkInfo: () async => throw Exception('channel unavailable'),
        measureLatency: () async => null,
      ),
    );
    addTearDown(failingProvider.dispose);

    await expectLater(failingProvider.checkConnection(), throwsException);
    expect(failingProvider.lastError, isNotNull);
  });

  test('startListening/stopListening toggle the polling without breaking',
      () async {
    provider.startListening(interval: const Duration(milliseconds: 10));
    await Future<void>.delayed(const Duration(milliseconds: 40));
    provider.stopListening();
    // After at least one tick the last report should have been produced.
    expect(provider.lastReport, isNotNull);
  });
}
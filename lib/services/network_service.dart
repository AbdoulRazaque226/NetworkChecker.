import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/network_report.dart';
import '../models/network_status.dart';
import '../platform/network_channel.dart';

/// Signature of the function that fetches the raw data from the native layer.
///
/// Injectable so [NetworkService] can be unit-tested with a fake, without
/// touching Abdoul's [NetworkChannel].
typedef GetNetworkInfo = Future<Map<String, dynamic>> Function();

/// Signature of the function that measures the connection latency in ms.
///
/// Injectable so tests can return a fixed value instead of hitting the real
/// network via `dart:io`.
typedef MeasureLatency = Future<int?> Function();

/// Business-logic layer sitting between the native Platform Channel and the app.
///
/// Responsibilities:
///  1. Call the native code (Abdoul's `NetworkChannel.getNetworkInfo()`).
///  2. Map the raw String/bool/nullable values into a typed [NetworkReport].
///  3. Measure latency (`latencyMs`) with a real HTTP round-trip when the
///     device reports an active connection.
///
/// No UI, no state — this service is consumed by [NetworkProvider].
class NetworkService {
  /// Builds a service. Provide a custom [getNetworkInfo] and/or [measureLatency]
  /// for tests; by default Abdoul's [NetworkChannel] static method and the
  /// built-in HTTP probe are used as-is.
  NetworkService({
    GetNetworkInfo? getNetworkInfo,
    MeasureLatency? measureLatency,
  })  : _getNetworkInfo = getNetworkInfo ?? NetworkChannel.getNetworkInfo,
        _measureLatency = measureLatency ?? _probeLatency;

  final GetNetworkInfo _getNetworkInfo;
  final MeasureLatency _measureLatency;

  /// Host used to measure latency. A fast, reliable endpoint keeps the check
  /// quick (a plain HTTPS GET that returns a small page).
  static const String _latencyProbeUrl = 'https://www.google.com';

  /// Runs a full network diagnostic and returns a [NetworkReport].
  ///
  /// [userId] is the currently authenticated Firebase uid and is stamped on the
  /// report so [FirestoreService] can store it under `users/{uid}/reports/`.
  Future<NetworkReport> checkConnection({String userId = ''}) async {
    // 1. Fetch the raw values from the native side.
    //    Keys documented in the team guide:
    //      - type           (String)  'wifi' | 'mobile' | 'none'
    //      - isConnected    (bool)    real internet access confirmed
    //      - signalStrength (int?)    wifi: RSSI dBm — mobile: level 0-4
    //      - ipAddress      (String?) local IP (wifi or mobile)
    //      - ssid           (String?) wifi only
    //      - batteryLevel   (int?)    device battery percentage 0-100
    final Map<String, dynamic> raw = await _getNetworkInfo();

    // 2. Transform the raw map into typed values (robust coercions).
    final NetworkStatus status =
        NetworkStatus.fromString(raw['type']?.toString());
    final bool isConnected = raw['isConnected'] == true;
    final int? signalStrength = _asInt(raw['signalStrength']);
    final String? ipAddress = _asString(raw['ipAddress']);
    final String? ssid = _asString(raw['ssid']);
    final int? batteryLevel = _asInt(raw['batteryLevel']);

    // 3. Measure latency only when a connection actually exists; otherwise it
    //    stays null and the report simply has no latency value. Any failure in
    //    the latency probe is swallowed — a bad network must never crash the
    //    diagnostic flow.
    int? latencyMs;
    if (isConnected) {
      try {
        latencyMs = await _measureLatency();
      } catch (_) {
        latencyMs = null;
      }
    }

    // 4. Build the typed report.
    return NetworkReport(
      timestamp: DateTime.now(),
      connectionType: status,
      isConnected: isConnected,
      signalStrength: signalStrength,
      ipAddress: ipAddress,
      ssid: ssid,
      latencyMs: latencyMs,
      batteryLevel: batteryLevel,
      userId: userId,
    );
  }

  /// Measures the round-trip time (ms) to [_latencyProbeUrl].
  ///
  /// Returns `null` when the request fails or times out, so a connectivity or
  /// DNS problem never crashes the diagnostic flow.
  static Future<int?> _probeLatency() async {
    // NOTE: `dart:io` is not available on the web, so latency measurement only
    // works on Android, iOS and desktop. On web, `isConnected` is still
    // reported by the native layer but `latencyMs` stays null.
    if (kIsWeb) return null;

    // Short timeouts keep a bad network from blocking the diagnostic.
    final HttpClient client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 4);
    final Stopwatch watch = Stopwatch()..start();
    try {
      final HttpClientRequest request = await client
          .getUrl(Uri.parse(_latencyProbeUrl))
          .timeout(const Duration(seconds: 4));
      final HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 4));
      // Drain the body so the full round-trip completes.
      await response.drain<void>();
      return watch.elapsedMilliseconds;
    } catch (_) {
      return null; // timeout, DNS failure, no internet, ...
    } finally {
      // Always release the socket, aborting any pending connection.
      client.close(force: true);
    }
  }

  /// Safely coerces a native value to an [int] (null when not possible).
  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Safely coerces a native value to a non-empty [String] (null when empty).
  static String? _asString(dynamic value) {
    final String? s = value?.toString();
    return (s == null || s.isEmpty) ? null : s;
  }
}
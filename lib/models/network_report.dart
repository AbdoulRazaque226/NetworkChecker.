import 'package:flutter/foundation.dart';

import 'network_status.dart';

/// A single, immutable network diagnostic report.
///
/// This class is the **shared contract** of the whole application:
///  - [NetworkService] (your workspace) builds it from the native Platform
///    Channel provided by Abdoul.
///  - [FirestoreService] persists it under `users/{uid}/reports/{reportId}`.
///  - Ben's UI (status_card, history_tile, details_screen) reads it for display.
///
/// Because three people depend on its shape, changing a field name or type
/// impacts the whole team — notify Ben before modifying this model.
@immutable
class NetworkReport {
  /// Firestore document id (`reportId`). Empty string until the report is
  /// persisted (Firestore generates the authoritative id on save).
  final String id;

  /// When the diagnostic was run (local device time).
  final DateTime timestamp;

  /// Type of connection detected: wi-fi, mobile or none.
  final NetworkStatus connectionType;

  /// Whether a real internet access was confirmed by the native layer.
  final bool isConnected;

  /// Signal strength provided by the native layer, when available.
  final int? signalStrength;

  /// Local IP address provided by the native layer, when available.
  final String? ipAddress;

  /// The connected Wi-Fi network name (SSID), when applicable.
  final String? ssid;

  /// Measured round-trip time to a known host, in milliseconds.
  final int? latencyMs;

  /// Firebase Auth uid of the user who owns this report.
  final String userId;

  /// Creates a [NetworkReport]. Only [timestamp], [connectionType] and
  /// [isConnected] are always required; the technical details are nullable
  /// because the native layer may not provide them yet.
  const NetworkReport({
    this.id = '',
    required this.timestamp,
    required this.connectionType,
    required this.isConnected,
    this.signalStrength,
    this.ipAddress,
    this.ssid,
    this.latencyMs,
    this.userId = '',
  });

  /// Rebuilds a [NetworkReport] from a JSON map.
  ///
  /// Accepts the shape produced by [toJson] (ISO-8601 timestamp string) and is
  /// tolerant of a `DateTime` object or an epoch-milliseconds integer, so it
  /// can also be reused after reading Firestore data (where the timestamp is a
  /// `Timestamp` — convert it to `DateTime` before calling, as done in
  /// FirestoreService).
  factory NetworkReport.fromJson(Map<String, dynamic> json) {
    return NetworkReport(
      id: json['id'] as String? ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
      connectionType: NetworkStatus.fromString(json['connectionType']?.toString()),
      isConnected: json['isConnected'] as bool? ?? false,
      signalStrength: json['signalStrength'] as int?,
      ipAddress: json['ipAddress'] as String?,
      ssid: json['ssid'] as String?,
      latencyMs: json['latencyMs'] as int?,
      userId: json['userId'] as String? ?? '',
    );
  }

  /// Serializes this report into a JSON map.
  ///
  /// `connectionType` is written as its canonical string ('wifi', 'mobile',
  /// 'none') and `timestamp` as an ISO-8601 string, which keeps the output
  /// human-readable and directly usable by the export feature.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'connectionType': connectionType.name,
      'isConnected': isConnected,
      'signalStrength': signalStrength,
      'ipAddress': ipAddress,
      'ssid': ssid,
      'latencyMs': latencyMs,
      'userId': userId,
    };
  }

  /// Creates a copy of this report with the given fields overridden.
  NetworkReport copyWith({
    String? id,
    DateTime? timestamp,
    NetworkStatus? connectionType,
    bool? isConnected,
    int? signalStrength,
    String? ipAddress,
    String? ssid,
    int? latencyMs,
    String? userId,
  }) {
    return NetworkReport(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      connectionType: connectionType ?? this.connectionType,
      isConnected: isConnected ?? this.isConnected,
      signalStrength: signalStrength ?? this.signalStrength,
      ipAddress: ipAddress ?? this.ipAddress,
      ssid: ssid ?? this.ssid,
      latencyMs: latencyMs ?? this.latencyMs,
      userId: userId ?? this.userId,
    );
  }

  /// Parses the various timestamp representations into a `DateTime`.
  static DateTime _parseTimestamp(dynamic value) {
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  @override
  String toString() =>
      'NetworkReport(id: $id, connectionType: $connectionType, '
      'isConnected: $isConnected, latencyMs: $latencyMs)';
}
import 'package:flutter/foundation.dart';

import 'network_status.dart';


@immutable
class NetworkReport {
  
  final String id;

  final DateTime timestamp;

  final NetworkStatus connectionType;
  final bool isConnected;

  
  final int? signalStrength;

  /// Local IP address provided by the native layer, when available.
  final String? ipAddress;

  /// The connected Wi-Fi network name (SSID), when applicable.
  final String? ssid;

  /// Measured round-trip time to a known host, in milliseconds.
  final int? latencyMs;

  /// Device battery level as a percentage (0-100), when available.
  final int? batteryLevel;

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
    this.batteryLevel,
    this.userId = '',
  });

  
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
      batteryLevel: json['batteryLevel'] as int?,
      userId: json['userId'] as String? ?? '',
    );
  }

 
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
      'batteryLevel': batteryLevel,
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
    int? batteryLevel,
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
      batteryLevel: batteryLevel ?? this.batteryLevel,
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
      'isConnected: $isConnected, latencyMs: $latencyMs, '
      'batteryLevel: $batteryLevel)';
}
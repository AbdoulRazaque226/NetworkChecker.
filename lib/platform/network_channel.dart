import 'package:flutter/services.dart';

class NetworkChannel {
  static const MethodChannel _channel = MethodChannel('com.networkchecker/network');

  static Future<Map<String, dynamic>> getNetworkInfo() async {
    final result = await _channel.invokeMethod('getNetworkInfo');
    return Map<String, dynamic>.from(result);
  }
}
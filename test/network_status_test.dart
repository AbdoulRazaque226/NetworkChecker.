import 'package:flutter_test/flutter_test.dart';
import 'package:network_checker/models/network_status.dart';

/// Tests for the [NetworkStatus] enum: the string mapping between the native
/// Platform Channel and the typed enum is a core contract of the app.
void main() {
  group('NetworkStatus.fromString', () {
    test('maps the exact native strings', () {
      expect(NetworkStatus.fromString('wifi'), NetworkStatus.wifi);
      expect(NetworkStatus.fromString('mobile'), NetworkStatus.mobile);
      expect(NetworkStatus.fromString('none'), NetworkStatus.none);
    });

    test('is case-insensitive', () {
      expect(NetworkStatus.fromString('WIFI'), NetworkStatus.wifi);
      expect(NetworkStatus.fromString('Mobile'), NetworkStatus.mobile);
      expect(NetworkStatus.fromString('NONE'), NetworkStatus.none);
    });

    test('falls back to none for unknown, empty or null values', () {
      expect(NetworkStatus.fromString('ethernet'), NetworkStatus.none);
      expect(NetworkStatus.fromString(''), NetworkStatus.none);
      expect(NetworkStatus.fromString(null), NetworkStatus.none);
    });
  });

  group('NetworkStatus helpers', () {
    test('label returns the canonical native string', () {
      expect(NetworkStatus.wifi.label, 'wifi');
      expect(NetworkStatus.mobile.label, 'mobile');
      expect(NetworkStatus.none.label, 'none');
    });

    test('displayName provides UI-ready strings', () {
      expect(NetworkStatus.wifi.displayName, 'Wi-Fi');
      expect(NetworkStatus.mobile.displayName, 'Mobile data');
      expect(NetworkStatus.none.displayName, 'No connection');
    });

    test('isActive is false only for none', () {
      expect(NetworkStatus.wifi.isActive, isTrue);
      expect(NetworkStatus.mobile.isActive, isTrue);
      expect(NetworkStatus.none.isActive, isFalse);
    });
  });
}
/// The type of network connection detected by the native layer.
///
/// The native Platform Channel returns the connection type as a plain String
/// ('wifi', 'mobile' or 'none'). This enum is the typed representation of that
/// string, used across the whole app (models, providers, services, UI).
enum NetworkStatus {
  /// Connected to a Wi-Fi network.
  wifi,

  /// Connected to mobile/cellular data.
  mobile,

  /// No active network connection.
  none;

  /// Maps the raw string returned by the native layer to an enum value.
  ///
  /// Any unknown or missing value falls back to [NetworkStatus.none] so the app
  /// never crashes on an unexpected native response.
  static NetworkStatus fromString(String? value) {
    switch (value?.toLowerCase() ?? '') {
      case 'wifi':
        return NetworkStatus.wifi;
      case 'mobile':
        return NetworkStatus.mobile;
      default:
        return NetworkStatus.none;
    }
  }

  /// The canonical string expected by / produced from the native layer.
  String get label => name;

  /// Human-readable label, ready to be displayed in the UI.
  String get displayName => switch (this) {
        NetworkStatus.wifi => 'Wi-Fi',
        NetworkStatus.mobile => 'Mobile data',
        NetworkStatus.none => 'No connection',
      };

  /// Whether this status represents an active connection.
  bool get isActive => this != NetworkStatus.none;
}
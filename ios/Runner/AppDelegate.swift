import UIKit
import Flutter
import Network
import SystemConfiguration.CaptiveNetwork
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private let monitor = NWPathMonitor()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.networkchecker/network",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      if call.method == "getNetworkInfo" {
        result(self.getNetworkInfo())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Returns the same keys as the Android implementation:
  /// type, isConnected, signalStrength, ipAddress, ssid, batteryLevel.
  private func getNetworkInfo() -> [String: Any?] {
    let path = monitor.currentPath

    var type = "none"
    var isConnected = false

    if path.status == .satisfied {
      isConnected = true
      if path.usesInterfaceType(.wifi) {
        type = "wifi"
      } else if path.usesInterfaceType(.cellular) {
        type = "mobile"
      }
    }

    // signalStrength: iOS does not expose a public Wi-Fi RSSI or cellular
    // signal-level API to third-party apps (unlike Android). Left null —
    // there is no reliable native equivalent without private APIs.
    let signalStrength: Int? = nil

    let ipAddress = getIPAddress()
    let ssid = (type == "wifi") ? getWifiSSID() : nil
    let batteryLevel = getBatteryLevel()

    return [
      "type": type,
      "isConnected": isConnected,
      "signalStrength": signalStrength,
      "ipAddress": ipAddress,
      "ssid": ssid,
      "batteryLevel": batteryLevel
    ]
  }

  /// Reads the device's local IP address (Wi-Fi or cellular interface).
  private func getIPAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>?

    guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
    defer { freeifaddrs(ifaddr) }

    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
      let interface = ptr.pointee
      let addrFamily = interface.ifa_addr.pointee.sa_family

      if addrFamily == UInt8(AF_INET) {
        let name = String(cString: interface.ifa_name)
        // en0 = Wi-Fi, pdp_ip0 = cellular data on iOS
        if name == "en0" || name == "pdp_ip0" {
          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
          getnameinfo(
            interface.ifa_addr,
            socklen_t(interface.ifa_addr.pointee.sa_len),
            &hostname, socklen_t(hostname.count),
            nil, socklen_t(0), NI_NUMERICHOST
          )
          address = String(cString: hostname)
        }
      }
    }
    return address
  }

  private func getWifiSSID() -> String? {
    guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return nil }
    for interface in interfaces {
      if let info = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
        return info[kCNNetworkInfoKeySSID as String] as? String
      }
    }
    return nil
  }

  /// Reads the device's battery level as a percentage (0-100).
  ///
  /// UIDevice.batteryMonitoringEnabled must be turned on first, otherwise
  /// batteryLevel always returns -1.
  private func getBatteryLevel() -> Int? {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    let level = device.batteryLevel
    if level < 0 {
      return nil
    }
    return Int(level * 100)
  }
}
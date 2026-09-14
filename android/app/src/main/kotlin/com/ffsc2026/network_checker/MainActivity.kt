package com.ffsc2026.network_checker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import android.telephony.TelephonyManager
import android.os.BatteryManager
import androidx.core.app.ActivityCompat
import android.Manifest
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.networkchecker/network"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getNetworkInfo") {
                val info = getNetworkInfo()
                result.success(info)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        val permissions = arrayOf(
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_PHONE_STATE
        )
        val toRequest = permissions.filter {
            ActivityCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }
        if (toRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, toRequest.toTypedArray(), 1)
        }
    }

    private fun getBatteryLevel(): Int? {
        val batteryManager = getSystemService(BATTERY_SERVICE) as? BatteryManager
        return batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    private fun getNetworkInfo(): Map<String, Any?> {
        val connectivityManager = getSystemService(ConnectivityManager::class.java)
        val network = connectivityManager.activeNetwork
        val capabilities = connectivityManager.getNetworkCapabilities(network)
        val linkProperties = connectivityManager.getLinkProperties(network)

        val type: String
        val isConnected: Boolean
        var signalStrength: Int? = null
        var ipAddress: String? = null
        var ssid: String? = null
        val batteryLevel: Int? = getBatteryLevel()

        ipAddress = linkProperties?.linkAddresses
            ?.map { it.address.hostAddress }
            ?.firstOrNull { it != null && !it.contains(":") }

        if (capabilities == null) {
            type = "none"
            isConnected = false
        } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
            type = "wifi"
            isConnected = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)

            val wifiManager = applicationContext.getSystemService(WIFI_SERVICE) as WifiManager
            val wifiInfo = wifiManager.connectionInfo

            signalStrength = wifiInfo.rssi
            ssid = wifiInfo.ssid?.trim('"')
            if (ssid == "<unknown ssid>") ssid = null

        } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
            type = "mobile"
            isConnected = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)

            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
                try {
                    val telephonyManager = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
                    signalStrength = telephonyManager.signalStrength?.level
                } catch (e: Exception) {
                    signalStrength = null
                }
            }
        } else {
            type = "none"
            isConnected = false
        }

        return mapOf(
            "type" to type,
            "isConnected" to isConnected,
            "signalStrength" to signalStrength,
            "ipAddress" to ipAddress,
            "ssid" to ssid,
            "batteryLevel" to batteryLevel
        )
    }
}
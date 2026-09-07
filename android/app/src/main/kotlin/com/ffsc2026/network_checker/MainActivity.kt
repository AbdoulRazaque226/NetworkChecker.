package com.ffsc2026.network_checker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.ConnectivityManager
import android.net.NetworkCapabilities

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

    private fun getNetworkInfo(): Map<String, Any?> {
        val connectivityManager = getSystemService(ConnectivityManager::class.java)
        val network = connectivityManager.activeNetwork
        val capabilities = connectivityManager.getNetworkCapabilities(network)

        val type: String
        val isConnected: Boolean

        if (capabilities == null) {
            type = "none"
            isConnected = false
        } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
            type = "wifi"
            isConnected = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
            type = "mobile"
            isConnected = capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        } else {
            type = "none"
            isConnected = false
        }

        return mapOf(
            "type" to type,
            "isConnected" to isConnected,
            "signalStrength" to null,
            "ipAddress" to null,
            "ssid" to null
        )
    }
}
package com.example.sas_flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var powerButtonPressedTime: Long = 0
    private val DOUBLE_CLICK_THRESHOLD = 400 // 400 ms for double-click detection
    private val handler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val filter = IntentFilter(Intent.ACTION_SCREEN_OFF)
        registerReceiver(powerButtonReceiver, filter)
    }

    private val powerButtonReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val currentTime = System.currentTimeMillis()
            if (currentTime - powerButtonPressedTime <= DOUBLE_CLICK_THRESHOLD) {
                launchApp()
            }
            powerButtonPressedTime = currentTime
        }
    }

    private fun launchApp() {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(powerButtonReceiver)
    }
}


package com.example.ios_playground

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AppUsageApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            AppUsageImplementation()
        )
    }
}

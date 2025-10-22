# Platform Channels

## 📋 Metadata

```yaml
priority: LOW
level: ADVANCED
category: Specialized
applies_to:
  - native_integration
  - platform_specific
ai_agent_tags:
  - platform-channels
  - native
  - method-channel
  - event-channel
  - interop
```

---

## 🎯 Overview

**Platform Channels** تسمح بالتواصل بين Flutter و Native code (Android/iOS). استخدمها للوصول لميزات Platform-specific.

### Why Platform Channels?
- 📱 Access native APIs
- 🔌 Integrate native SDKs
- ⚡ Performance critical code
- 🎯 Platform-specific features
- 🔄 Two-way communication

---

## 🔵 Priority Level: LOW

**Status:** `ADVANCED` - للميزات Native فقط

---

## 📚 Core Concepts

### 1. MethodChannel - Request/Response

```dart
// Flutter Side
import 'package:flutter/services.dart';

class BatteryService {
  static const platform = MethodChannel('com.example.app/battery');
  
  Future<int?> getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
      return null;
    }
  }
  
  Future<void> vibrate(int duration) async {
    try {
      await platform.invokeMethod('vibrate', {'duration': duration});
    } on PlatformException catch (e) {
      print("Failed to vibrate: '${e.message}'.");
    }
  }
}

// Usage
final batteryService = BatteryService();
final level = await batteryService.getBatteryLevel();
print('Battery level: $level%');
```

---

### 2. Android Implementation

```kotlin
// android/app/src/main/kotlin/MainActivity.kt
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/battery"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error(
                            "UNAVAILABLE",
                            "Battery level not available.",
                            null
                        )
                    }
                }
                "vibrate" -> {
                    val duration = call.argument<Int>("duration") ?: 100
                    vibrate(duration.toLong())
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
    
    private fun vibrate(duration: Long) {
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(
                VibrationEffect.createOneShot(
                    duration,
                    VibrationEffect.DEFAULT_AMPLITUDE
                )
            )
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(duration)
        }
    }
}
```

---

### 3. iOS Implementation

```swift
// ios/Runner/AppDelegate.swift
import UIKit
import Flutter
import AudioToolbox

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(
            name: "com.example.app/battery",
            binaryMessenger: controller.binaryMessenger
        )
        
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            guard let self = self else { return }
            
            switch call.method {
            case "getBatteryLevel":
                self.getBatteryLevel(result: result)
            case "vibrate":
                if let args = call.arguments as? [String: Any],
                   let duration = args["duration"] as? Int {
                    self.vibrate(duration: duration)
                    result(nil)
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Duration not provided",
                        details: nil
                    ))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getBatteryLevel(result: FlutterResult) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        
        if batteryLevel < 0 {
            result(FlutterError(
                code: "UNAVAILABLE",
                message: "Battery level not available",
                details: nil
            ))
        } else {
            result(Int(batteryLevel * 100))
        }
    }
    
    private func vibrate(duration: Int) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
```

---

### 4. EventChannel - Streaming Data

```dart
// Flutter Side
import 'package:flutter/services.dart';

class LocationService {
  static const stream = EventChannel('com.example.app/location');
  
  Stream<Map<String, double>>? _locationStream;
  
  Stream<Map<String, double>> get locationUpdates {
    _locationStream ??= stream.receiveBroadcastStream().map((event) {
      return {
        'latitude': event['latitude'] as double,
        'longitude': event['longitude'] as double,
      };
    });
    return _locationStream!;
  }
}

// Usage
class LocationWidget extends StatelessWidget {
  final locationService = LocationService();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: locationService.locationUpdates,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final location = snapshot.data!;
          return Text(
            'Lat: ${location['latitude']}, Lon: ${location['longitude']}',
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

### 5. Android EventChannel

```kotlin
// android/app/src/main/kotlin/MainActivity.kt
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val LOCATION_CHANNEL = "com.example.app/location"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCATION_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {
            private var locationHandler: Handler? = null
            
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                locationHandler = Handler(Looper.getMainLooper())
                
                // Simulate location updates
                val runnable = object : Runnable {
                    override fun run() {
                        val location = mapOf(
                            "latitude" to 24.7136 + Random.nextDouble(-0.01, 0.01),
                            "longitude" to 46.6753 + Random.nextDouble(-0.01, 0.01)
                        )
                        events?.success(location)
                        locationHandler?.postDelayed(this, 1000)
                    }
                }
                locationHandler?.post(runnable)
            }
            
            override fun onCancel(arguments: Any?) {
                locationHandler?.removeCallbacksAndMessages(null)
                locationHandler = null
            }
        })
    }
}
```

---

### 6. BasicMessageChannel - Binary Data

```dart
// For sending large binary data
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageProcessor {
  static const channel = BasicMessageChannel<ByteData>(
    'com.example.app/image',
    StandardMessageCodec(),
  );
  
  Future<Uint8List?> processImage(Uint8List imageData) async {
    try {
      final ByteData? result = await channel.send(
        ByteData.sublistView(imageData),
      );
      return result?.buffer.asUint8List();
    } catch (e) {
      print('Error processing image: $e');
      return null;
    }
  }
}
```

---

### 7. Create Plugin Package

```bash
# Create plugin
flutter create --template=plugin --platforms=android,ios my_plugin

# Project structure:
my_plugin/
├── lib/
│   └── my_plugin.dart          # Flutter API
├── android/
│   └── src/main/kotlin/...     # Android implementation
├── ios/
│   └── Classes/...             # iOS implementation
└── example/                     # Example app
```

```dart
// lib/my_plugin.dart
import 'package:flutter/services.dart';

class MyPlugin {
  static const MethodChannel _channel = MethodChannel('my_plugin');
  
  static Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
```

---

## ✅ Best Practices

### Rule 1: Handle Errors Gracefully

```dart
// ✅ Always wrap in try-catch
Future<int?> getBatteryLevel() async {
  try {
    return await platform.invokeMethod('getBatteryLevel');
  } on PlatformException catch (e) {
    print('Platform error: ${e.code} - ${e.message}');
    return null;
  } catch (e) {
    print('Unknown error: $e');
    return null;
  }
}
```

---

### Rule 2: Use Type-Safe Arguments

```dart
// ✅ Good - Type-safe
await platform.invokeMethod('vibrate', <String, dynamic>{
  'duration': 100,
  'intensity': 50,
});

// ❌ Bad - No types
await platform.invokeMethod('vibrate', {'duration': 100});
```

---

### Rule 3: Document Channel Names

```dart
// ✅ Good - Well documented
/// Channel for battery operations.
/// Methods:
/// - getBatteryLevel(): Returns int (0-100)
/// - vibrate(duration: int): Vibrates device
static const platform = MethodChannel('com.example.app/battery');
```

---

## 🎯 Common Use Cases

### 1. Access Device Info
```dart
// Battery, storage, sensors
```

### 2. Native SDKs
```dart
// Google Maps, AdMob, Firebase
```

### 3. Background Services
```dart
// Location tracking, notifications
```

### 4. Hardware Features
```dart
// Camera, Bluetooth, NFC
```

### 5. Platform APIs
```dart
// Contacts, calendar, photos
```

---

## 🚫 When NOT to Use

```yaml
DON'T Use Platform Channels if:
  - Package already exists (use pub.dev)
  - Flutter has built-in support
  - Can be done in pure Dart
  - Not platform-specific feature

DO Use When:
  - No existing package
  - Platform-specific API needed
  - Performance critical (rare)
  - Native SDK integration
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - proper error handling
  - channel name uniqueness
  - type-safe arguments
  - null safety
  - disposal (EventChannel)
  - documentation

suggest:
  - search pub.dev first
  - use existing packages
  - wrap in try-catch
  - document channel contract
  - create plugin if reusable

enforce:
  - error handling
  - type safety
  - channel names unique
  - proper disposal
```

---

## 📊 Summary Checklist

```markdown
- [ ] MethodChannel for request/response
- [ ] EventChannel for streaming
- [ ] BasicMessageChannel for binary
- [ ] Error handling implemented
- [ ] Type-safe arguments
- [ ] Both platforms implemented
- [ ] Channel names documented
- [ ] EventChannel disposed
- [ ] Tested on real devices
```

---

## 🔗 Related Rules

- [Performance](../flutter-basics/performance-basics.md)
- [Error Handling](../core/error-handling.md)

---

**Priority:** 🔵 LOW  
**Level:** ADVANCED  
**For:** Native Integration  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

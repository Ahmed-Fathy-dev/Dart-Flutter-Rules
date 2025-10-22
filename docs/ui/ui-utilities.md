# 🎨 UI Utilities & Components

## 📋 Metadata

```yaml
priority: MEDIUM
level: OPTIONAL
category: UI & Utilities
ai_agent_tags:
  - ui
  - utilities
  - widgets
  - notifications
  - loading
```

---

## 1. 📱 Pinput - OTP/PIN Input

### Setup
```yaml
dependencies:
  pinput: ^5.0.0  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
import 'package:pinput/pinput.dart';

Pinput(
  length: 6,
  onCompleted: (pin) => print('OTP: $pin'),
)
```

### Custom Styling
```dart
final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
);

Pinput(
  length: 6,
  defaultPinTheme: defaultPinTheme,
  onCompleted: (pin) => print(pin),
)
```

---

## 2. 🔔 Fluttertoast

### Setup
```yaml
dependencies:
  fluttertoast: ^8.2.8  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
Fluttertoast.showToast(
  msg: "تم الحفظ بنجاح",
  gravity: ToastGravity.BOTTOM,
);
```

---

## 3. 🎉 Toastification

### Setup
```yaml
dependencies:
  toastification: ^2.3.0  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
toastification.show(
  context: context,
  type: ToastificationType.success,
  title: const Text('نجح!'),
  description: const Text('تم حفظ البيانات'),
);
```

---

## 4. 🌐 Internet Connection Checker

### Setup
```yaml
dependencies:
  internet_connection_checker_plus: ^2.5.2  # ✅ Latest
```

### Basic Usage
```dart
final hasConnection = await InternetConnection().hasInternetAccess;
```

---

## 5. 💀 Skeletonizer

### Setup
```yaml
dependencies:
  skeletonizer: ^1.4.2  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
Skeletonizer(
  enabled: isLoading,
  child: YourWidget(),
)
```

---

## 6. 🔑 UUID

### Setup
```yaml
dependencies:
  uuid: ^4.5.1  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
final uuid = Uuid();
final id = uuid.v4();
```

---

## 7. 📊 Smooth Page Indicator

### Setup
```yaml
dependencies:
  smooth_page_indicator: ^1.2.0+3  # ✅ Latest
```

### Basic Usage
```dart
SmoothPageIndicator(
  controller: _controller,
  count: 3,
  effect: WormEffect(),
)
```

---

**Priority:** 🟠 MEDIUM  
**Level:** OPTIONAL  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

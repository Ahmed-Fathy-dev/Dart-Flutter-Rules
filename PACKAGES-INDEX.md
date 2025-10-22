# 📦 Flutter Packages Index

**آخر تحديث:** 2025-10-22  
**المكتبات الموثقة:** 29 packages

---

## 🎯 Quick Reference

### **بحسب الفئة:**
- [🔴 CRITICAL (4)](#critical-packages) - إلزامية
- [🟡 HIGH (7)](#high-priority-packages) - موصى بها بشدة
- [🟢 MEDIUM (7)](#medium-priority-packages) - مفيدة
- [🔵 LOW/Specialized (11)](#specialized-packages) - متخصصة

---

## 🔴 CRITICAL Packages

### **1. Talker - Professional Logging**
```yaml
Package: talker
Version: ^4.6.4
Priority: CRITICAL
Documentation: docs/tools/logging.md
```

**Features:**
- ✅ In-app logs viewer
- ✅ Dio integration (HTTP logs)
- ✅ Riverpod integration
- ✅ Export/Share logs
- ✅ Custom colors & filters

**When to use:**
- ✅ Production apps
- ✅ Debugging complex issues
- ✅ Bug reports

**Related Packages:**
- `talker_flutter: ^4.6.4`
- `talker_dio_logger: ^4.6.4`
- `talker_riverpod_logger: ^4.6.4`

---

### **2. dart_mappable - JSON Serialization**
```yaml
Package: dart_mappable
Version: ^4.4.0
Priority: HIGH
Documentation: docs/data/json-serialization.md
Alternative to: json_serializable
```

**Features:**
- ⚡ Better performance
- 🔄 Full polymorphism support
- 📝 Less boilerplate
- ✅ Built-in copyWith & equality

**When to use:**
- ✅ New projects
- ✅ Performance-critical
- ✅ Need polymorphism

**Related Packages:**
- `dart_mappable_builder: ^4.3.1+1`

---

### **3. ObjectBox - Ultra-Fast Database**
```yaml
Package: objectbox
Version: ^4.3.0
Priority: HIGH
Documentation: docs/data/local-storage.md
Alternative to: Hive, Drift
```

**Features:**
- ⚡ 10x faster than Hive
- 🔗 Native relations
- 📊 Powerful queries
- 🔄 Real-time observers

**Performance:**
- Insert 10K items: ~30ms (vs 300ms Hive)
- Query 10K items: ~5ms (vs 50ms Hive)

**When to use:**
- ✅ High-performance apps
- ✅ Complex relations
- ✅ Real-time apps

**Related Packages:**
- `objectbox_flutter_libs: ^4.3.0`
- `objectbox_generator: ^4.3.0`

---

### **4. Envied - Secure Environment Config**
```yaml
Package: envied
Version: ^1.1.0
Priority: HIGH
Documentation: docs/specialized/environment-config.md
Alternative to: flutter_dotenv
```

**Features:**
- 🔒 Compile-time obfuscation
- 🎯 Type-safe
- 🌍 Multi-environment
- 🚀 CI/CD ready

**When to use:**
- ✅ Production apps
- ✅ API keys & secrets
- ✅ Multi-environment setup

**Related Packages:**
- `envied_generator: ^1.1.0`

---

## 🟡 HIGH Priority Packages

### **5. Equatable - Value Equality**
```yaml
Package: equatable
Version: ^2.0.7
Priority: HIGH
Documentation: docs/core/value-equality.md
```

**Features:**
- ✅ Easy equality comparison
- 📝 Less boilerplate
- 🎯 Correct hashCode
- ✅ Built-in toString

**When to use:**
- ✅ All models
- ✅ State management classes
- ✅ Value objects

---

### **6. pretty_dio_logger - Beautiful HTTP Logs**
```yaml
Package: pretty_dio_logger
Version: ^1.4.0
Priority: MEDIUM
Documentation: docs/data/http-clients.md
```

**Features:**
- 🎨 Beautiful colored logs
- 📊 Formatted output
- 🔒 Filter sensitive data
- ✅ Compact mode

**When to use:**
- ✅ Development
- ✅ Debugging API calls
- ❌ Not in production

---

### **7. Flutter Hooks - React-Style Hooks**
```yaml
Package: flutter_hooks
Version: ^0.21.2
Priority: MEDIUM
Documentation: docs/state-management/hooks.md
```

**Features:**
- ✅ Less boilerplate
- 🔄 Reusable logic
- 🧹 Auto cleanup
- 🎯 Riverpod integration

**When to use:**
- ✅ Complex widgets
- ✅ Reusable logic
- ✅ With Riverpod

**Related Packages:**
- `hooks_riverpod: ^2.6.1`

---

### **8-11. Common UI Packages**
```yaml
Documentation: docs/ui/common-packages.md
```

#### **8. Google Fonts**
```yaml
Package: google_fonts
Version: ^6.2.1
Use: Custom fonts, Arabic fonts
```

#### **9. Flutter SVG**
```yaml
Package: flutter_svg
Version: ^2.0.17
Use: SVG icons & images
```

#### **10. Form Builder Validators**
```yaml
Package: form_builder_validators
Version: ^11.1.2
Use: Form validation
```

#### **11. Image Picker**
```yaml
Package: image_picker
Version: ^1.1.2
Use: Camera & gallery access
```

#### **12. Permission Handler**
```yaml
Package: permission_handler
Version: ^12.0.0+1
Use: Runtime permissions
```

---

## 🟢 MEDIUM Priority Packages

### **UI Utilities**
```yaml
Documentation: docs/ui/ui-utilities.md
```

#### **13. Pinput - OTP/PIN Input**
```yaml
Package: pinput
Version: ^5.0.0
Use: OTP verification
```

#### **14. Fluttertoast - Simple Toasts**
```yaml
Package: fluttertoast
Version: ^8.2.8
Use: Simple notifications
```

#### **15. Toastification - Modern Toasts**
```yaml
Package: toastification
Version: ^2.3.0
Use: Rich notifications
```

#### **16. Internet Connection Checker Plus**
```yaml
Package: internet_connection_checker_plus
Version: ^2.5.2
Use: Connection monitoring
```

#### **17. Skeletonizer - Loading Skeletons**
```yaml
Package: skeletonizer
Version: ^1.4.2
Use: Loading states
```

#### **18. UUID - Unique IDs**
```yaml
Package: uuid
Version: ^4.5.1
Use: Local IDs, offline-first
```

#### **19. Smooth Page Indicator**
```yaml
Package: smooth_page_indicator
Version: ^1.2.0+3
Use: PageView indicators
```

---

## 🔵 Specialized Packages

### **Advanced Features**
```yaml
Documentation: docs/specialized/advanced-packages.md
```

#### **20. FL Chart - Charts & Graphs**
```yaml
Package: fl_chart
Version: ^0.69.2
Use: Line, bar, pie charts
```

#### **21. Media Kit - Video Player**
```yaml
Package: media_kit
Version: ^1.1.11
Use: Video playback
Related: media_kit_video, media_kit_libs_video
```

#### **22. Printing & PDF**
```yaml
Packages:
  - printing: ^5.13.4
  - pdf: ^3.11.1
Use: PDF generation & printing
```

#### **23. Barcode Scan**
```yaml
Package: barcode_scan2
Version: ^4.3.3
Use: QR/Barcode scanning
```

#### **24. Flutter InAppWebView**
```yaml
Package: flutter_inappwebview
Version: ^6.1.5
Use: In-app browser
```

#### **25. Window Manager (Desktop)**
```yaml
Package: window_manager
Version: ^0.4.3
Use: Desktop window control
```

#### **26. Iconsax Flutter**
```yaml
Package: iconsax_flutter
Version: ^1.0.0
Use: Modern icon set
```

#### **27. Dropdown Button 2**
```yaml
Package: dropdown_button2
Version: ^3.0.3
Use: Enhanced dropdowns
```

---

## 📊 Version Updates (2025-10-22)

### **Updated Packages:**
```yaml
✅ build_runner: 2.4.14 → 2.4.15
✅ shared_preferences: 2.3.4 → 2.3.5
✅ intl: 0.20.1 → 0.20.2
✅ flutter_secure_storage: 9.2.2 → 9.2.4
✅ lottie: 3.3.0 → 3.3.1
✅ dio: 5.0.0 → 5.9.0
✅ json_serializable: 6.0.0 → 6.9.2
```

### **New Packages Added:**
```yaml
🆕 dart_mappable: 4.4.0
🆕 talker: 4.6.4 (+ integrations)
🆕 objectbox: 4.3.0 (+ libs & generator)
🆕 envied: 1.1.0 (+ generator)
🆕 flutter_hooks: 0.21.2
🆕 hooks_riverpod: 2.6.1
🆕 equatable: 2.0.7
🆕 pretty_dio_logger: 1.4.0
🆕 22 UI/Utility packages
```

---

## 🎯 Quick Decision Guide

### **"I need..."**

#### **JSON Serialization:**
- 🟢 Start with: `json_serializable`
- ⚡ Performance: `dart_mappable`
- 🔄 Polymorphism: `dart_mappable`

#### **Database:**
- 📝 Simple settings: `shared_preferences`
- 🔄 Cache/offline: `Hive`
- ⚡ High performance: `ObjectBox`
- 🗄️ SQL: `Drift`

#### **Logging:**
- 🟢 Development: `dart:developer log`
- ⚡ Production: `Talker`
- 📊 HTTP logs: `pretty_dio_logger`

#### **Environment Config:**
- 🟢 Development: `flutter_dotenv`
- 🔒 Production: `Envied`

#### **State Management:**
- 🟢 Simple: Built-in (setState, ValueNotifier)
- 🔄 Complex: `Riverpod`
- 🪝 Modern: `hooks_riverpod`

#### **UI Components:**
- 🎨 Fonts: `google_fonts`
- 🖼️ SVG: `flutter_svg`
- ✅ Forms: `form_builder_validators`
- 📸 Images: `image_picker`
- 🔐 Permissions: `permission_handler`

---

## 📚 Related Documentation

- [INDEX](./docs/INDEX.md) - Full documentation index
- [rules-config.yaml](./rules-config.yaml) - Configuration file
- [COMPLETE-AUDIT-REPORT](./COMPLETE-AUDIT-REPORT.md) - Audit details

---

**Status:** ✅ Production-Ready  
**Last Updated:** 2025-10-22  
**Total Packages:** 29  
**Quality:** ⭐⭐⭐⭐⭐

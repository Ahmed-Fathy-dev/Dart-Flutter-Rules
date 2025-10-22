# 🔍 Logging with Talker

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Development Tools
applies_to:
  - all_projects
recommended_package: talker
ai_agent_tags:
  - logging
  - debugging
  - monitoring
  - error-tracking
  - talker
```

---

## 🎯 Overview

**Talker** هو نظام logging حديث وقوي لـ Flutter/Dart. أفضل من `print()` و `debugPrint()`.

### Why Talker?
- ✅ **Beautiful logs** - ألوان ورموز واضحة
- 📱 **Flutter UI** - شاشة logs داخل التطبيق
- 🔌 **Integrations** - Dio, Riverpod, Bloc
- 📊 **Error tracking** - تتبع الأخطاء
- 📝 **History** - حفظ السجلات
- 🎯 **Filters** - تصفية حسب المستوى

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` لجميع المشاريع

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  talker: ^5.0.2  # ✅ Latest (Aug 2025)
  talker_flutter: ^5.0.2  # ✅ For Flutter UI
  
  # Optional integrations
  talker_riverpod_logger: ^5.0.2  # ✅ Riverpod integration
  talker_dio_logger: ^5.0.2  # ✅ Dio integration
```

---

### 2. Basic Setup

```dart
import 'package:talker/talker.dart';

final talker = Talker();

void main() {
  // Basic logging
  talker.log('Application started');
  talker.info('This is info');
  talker.warning('This is warning');
  talker.error('This is error');
  talker.critical('This is critical');
  
  runApp(MyApp());
}
```

---

### 3. Logging Levels

```dart
// Debug - for development only
talker.debug('Debug message');

// Verbose - detailed information
talker.verbose('Verbose details');

// Info - general information
talker.info('User logged in');

// Warning - potential issues
talker.warning('Slow network detected');

// Error - errors that can be handled
talker.error('Failed to load data');

// Critical - critical errors
talker.critical('Database connection lost');
```

---

### 4. Structured Logging

```dart
class UserLoginLog {
  final String userId;
  final DateTime timestamp;
  
  UserLoginLog({
    required this.userId,
    required this.timestamp,
  });
  
  @override
  String toString() => 'User $userId logged in at $timestamp';
}

// Log custom objects
talker.log(UserLoginLog(
  userId: '123',
  timestamp: DateTime.now(),
));
```

---

### 5. Error Logging with Stack Trace

```dart
try {
  throw Exception('Something went wrong');
} catch (error, stackTrace) {
  talker.error(
    'Failed to process request',
    error,
    stackTrace,
  );
  
  // Or use handle method
  talker.handle(
    error,
    stackTrace,
    'Custom error message',
  );
}
```

---

### 6. Flutter Integration

```dart
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

void main() {
  // Initialize
  runApp(MyApp(talker: talker));
}

class MyApp extends StatelessWidget {
  final Talker talker;
  
  const MyApp({required this.talker});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Show logs screen
      home: TalkerScreen(talker: talker),
    );
  }
}
```

---

### 7. In-App Logs Viewer

```dart
import 'package:talker_flutter/talker_flutter.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('View Logs'),
            leading: const Icon(Icons.bug_report),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TalkerScreen(talker: talker),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

### 8. Riverpod Integration

```dart
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talker,
          settings: const TalkerRiverpodLoggerSettings(
            enabled: true,
            printProviderDisposed: true,
            printStateFullData: true,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// Automatic logging of:
// - Provider creation
// - State changes
// - Provider disposal
// - Errors
```

---

### 9. Dio Integration

```dart
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient({required Talker talker}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
      ),
    );
    
    // Add Talker interceptor
    _dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
          printRequestData: true,
          printResponseData: true,
          printErrorData: true,
          printErrorHeaders: true,
          printErrorMessage: true,
        ),
      ),
    );
  }
}

// Automatic logging of:
// - HTTP requests
// - Response data
// - Headers
// - Errors
// - Request duration
```

---

### 10. Custom Log Colors & Icons

```dart
import 'package:talker/talker.dart';

class CustomTalker extends Talker {
  CustomTalker() : super(
    settings: TalkerSettings(
      colors: {
        TalkerLogType.info: AnsiPen()..blue(),
        TalkerLogType.warning: AnsiPen()..yellow(),
        TalkerLogType.error: AnsiPen()..red(),
      },
    ),
  );
}

// Custom log types
class PaymentLog extends TalkerLog {
  PaymentLog(String message) : super(message);
  
  @override
  String get title => '💰 PAYMENT';
  
  @override
  AnsiPen get pen => AnsiPen()..green();
}

// Usage
talker.log(PaymentLog('Payment successful: \$99.99'));
```

---

### 11. Filters & History

```dart
// Get all logs
final allLogs = talker.history.logs;

// Filter by type
final errors = talker.history.logs
    .where((log) => log.logLevel == LogLevel.error)
    .toList();

// Filter by time
final recentLogs = talker.history.logs
    .where((log) => 
        log.time.isAfter(DateTime.now().subtract(Duration(hours: 1)))
    )
    .toList();

// Clear history
talker.history.clear();

// Clean old logs (keep last 100)
talker.configure(
  settings: TalkerSettings(
    maxHistoryItems: 100,
  ),
);
```

---

### 12. Production Setup

```dart
import 'package:talker/talker.dart';

final talker = Talker(
  settings: TalkerSettings(
    // Disable console output in production
    enabled: kDebugMode,
    
    // Enable for crash reports
    useConsoleLogs: kDebugMode,
    
    // Keep history for error reports
    maxHistoryItems: 500,
    
    // Log levels
    level: kDebugMode ? LogLevel.verbose : LogLevel.error,
  ),
);

void main() {
  // Catch all errors
  FlutterError.onError = (details) {
    talker.handle(
      details.exception,
      details.stack,
      'Flutter Error',
    );
  };
  
  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Async Error');
    return true;
  };
  
  runApp(MyApp());
}
```

---

### 13. Export Logs

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> exportLogs() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/logs.txt');
  
  final logsText = talker.history.logs
      .map((log) => '${log.time} | ${log.message}')
      .join('\n');
  
  await file.writeAsString(logsText);
  
  talker.info('Logs exported to: ${file.path}');
}
```

---

### 14. Share Logs (for bug reports)

```dart
import 'package:share_plus/share_plus.dart';

Future<void> shareLogs() async {
  final logsText = talker.history.logs
      .map((log) => '${log.time} | ${log.level.name} | ${log.message}')
      .join('\n');
  
  await Share.share(
    logsText,
    subject: 'App Logs - ${DateTime.now()}',
  );
}
```

---

## 🎯 Real-World Example: E-commerce App

```dart
import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

// Global talker instance
late final Talker talker;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Talker
  talker = TalkerFlutter.init(
    settings: TalkerSettings(
      enabled: true,
      useConsoleLogs: true,
      level: kDebugMode ? LogLevel.verbose : LogLevel.error,
      maxHistoryItems: 1000,
    ),
  );
  
  // Catch errors
  FlutterError.onError = (details) {
    talker.handle(
      details.exception,
      details.stack,
      'Flutter Error',
    );
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Async Error');
    return true;
  };
  
  talker.info('🚀 App started');
  
  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(talker: talker),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      // Global error widget
      builder: (context, child) {
        ErrorWidget.builder = (details) {
          talker.error('Widget error: ${details.exception}');
          return ErrorScreen(details: details);
        };
        return child!;
      },
    );
  }
}

// API Client with logging
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(baseUrl: 'https://api.shop.com'));
    
    _dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: true,
        ),
      ),
    );
  }
  
  Future<List<Product>> getProducts() async {
    try {
      talker.info('📦 Fetching products...');
      
      final response = await _dio.get('/products');
      
      final products = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      
      talker.info('✅ Loaded ${products.length} products');
      
      return products;
    } catch (e, st) {
      talker.error('❌ Failed to load products', e, st);
      rethrow;
    }
  }
}

// Repository with logging
class ProductRepository {
  final ApiClient _api;
  
  ProductRepository(this._api);
  
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      talker.verbose('Repository: getProducts called');
      
      final products = await _api.getProducts();
      
      talker.debug('Repository: Loaded ${products.length} products');
      
      return Right(products);
    } on DioException catch (e, st) {
      talker.error('Repository: Network error', e, st);
      return Left(NetworkFailure(e.message ?? 'Network error'));
    } catch (e, st) {
      talker.error('Repository: Unknown error', e, st);
      return Left(GeneralFailure(e.toString()));
    }
  }
}

// Settings with logs viewer
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('View App Logs'),
            subtitle: const Text('Debug information'),
            leading: const Icon(Icons.bug_report),
            trailing: Badge(
              label: Text('${talker.history.logs.length}'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TalkerScreen(talker: talker),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Export Logs'),
            leading: const Icon(Icons.download),
            onTap: () => exportLogs(),
          ),
          ListTile(
            title: const Text('Share Logs'),
            subtitle: const Text('For bug reports'),
            leading: const Icon(Icons.share),
            onTap: () => shareLogs(),
          ),
          ListTile(
            title: const Text('Clear Logs'),
            leading: const Icon(Icons.delete),
            onTap: () {
              talker.history.clear();
              talker.info('Logs cleared');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ استخدم talker في كل المشروع
✅ استخدم المستويات المناسبة
✅ Log errors with stack traces
✅ استخدم structured logging
✅ Enable in-app logs viewer
✅ Export/share logs للـ bug reports
```

### **❌ تجنب:**
```dart
❌ استخدام print() مباشرة
❌ Logging sensitive data (passwords, tokens)
❌ Too verbose في production
❌ عدم حفظ الأخطاء
❌ نسيان clear old logs
```

---

## 🎯 Comparison

### **print() / debugPrint():**
```dart
❌ No colors
❌ No levels
❌ No history
❌ No UI viewer
❌ No integrations
```

### **Talker:**
```dart
✅ Beautiful colors
✅ Multiple levels
✅ Full history
✅ In-app viewer
✅ Dio/Riverpod integrations
✅ Error tracking
✅ Export/Share logs
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - talker instance initialized
  - error handling with talker
  - production settings configured
  - sensitive data not logged

suggest:
  - add talker logging
  - use appropriate log level
  - add error handling
  - configure for production

enforce:
  - no print() statements
  - all errors logged
  - stack traces included
  - production mode configured
```

---

## 📚 Related Files

- [Debugging](./debugging.md) - Debug tools
- [Error Handling](../core/error-handling.md) - Error patterns
- [HTTP Clients](../data/http-clients.md) - Dio integration

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**For:** All Projects  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

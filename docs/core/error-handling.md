# Error Handling

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Core
applies_to:
  - all_projects
  - all_platforms
ai_agent_tags:
  - error-handling
  - exceptions
  - try-catch
  - critical
  - production-ready
```

---

## 🎯 Overview

**Error Handling** هو أساس أي تطبيق production-ready. التعامل الصحيح مع الأخطاء يمنع crashes ويحسن تجربة المستخدم.

### Why It Matters
- 🚫 منع crashes غير متوقعة
- 👤 تجربة مستخدم أفضل
- 🐛 debug أسهل
- 📊 tracking الأخطاء في production

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - إلزامي في جميع المشاريع

### Why CRITICAL?

```dart
// بدون error handling ❌
Future<void> loadUserData() async {
  final data = await api.getUserData();
  // ماذا لو فشل الـ API call؟ → App crash!
  setState(() => user = data);
}

// مع error handling ✅
Future<void> loadUserData() async {
  try {
    final data = await api.getUserData();
    setState(() => user = data);
  } catch (e) {
    _showError('Failed to load data');
    // App يستمر في العمل
  }
}
```

---

## 📚 Core Concepts

### 1. Try-Catch Blocks

#### Basic Pattern
```dart
try {
  // Code that might throw
  final result = await riskyOperation();
  return result;
} catch (e) {
  // Handle error
  print('Error: $e');
  return null;
}
```

#### With Finally
```dart
File? file;
try {
  file = await File('path').open();
  await file.write('data');
} catch (e) {
  print('Error writing file: $e');
} finally {
  // Always executed, even if error
  await file?.close();
}
```

#### Specific Exception Types
```dart
try {
  final data = await api.getData();
} on NetworkException catch (e) {
  _showError('No internet connection');
} on TimeoutException catch (e) {
  _showError('Request timed out');
} on FormatException catch (e) {
  _showError('Invalid data format');
} catch (e) {
  // Catch all other errors
  _showError('Something went wrong');
}
```

---

### 2. Custom Exceptions

#### Define Custom Exceptions
```dart
// Base exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  AppException(this.message, {this.code, this.originalError});
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

// Specific exceptions
class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

class AuthException extends AppException {
  AuthException(String message) : super(message, code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  final Map<String, String> errors;
  
  ValidationException(String message, this.errors) 
      : super(message, code: 'VALIDATION_ERROR');
}

// Usage
Future<User> login(String email, String password) async {
  if (!_isValidEmail(email)) {
    throw ValidationException('Invalid input', {
      'email': 'Please enter a valid email'
    });
  }
  
  try {
    final response = await _api.post('/login', {
      'email': email,
      'password': password,
    });
    return User.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw AuthException('Invalid credentials');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException('Connection timeout');
    } else {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}
```

---

### 3. Result Pattern

بدلاً من throwing exceptions، استخدم Result type:

```dart
// Result class
class Result<T> {
  final T? data;
  final AppException? error;
  
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
  
  bool get isSuccess => data != null;
  bool get isFailure => error != null;
  
  // Map function
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      return Result.success(transform(data!));
    }
    return Result.failure(error!);
  }
  
  // Fold function
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data!);
    }
    return onFailure(error!);
  }
}

// Usage
Future<Result<User>> login(String email, String password) async {
  try {
    final user = await _authService.login(email, password);
    return Result.success(user);
  } on AppException catch (e) {
    return Result.failure(e);
  } catch (e) {
    return Result.failure(AppException('Unknown error: $e'));
  }
}

// In UI
void _handleLogin() async {
  final result = await login(email, password);
  
  result.fold(
    onSuccess: (user) {
      Navigator.pushReplacement(context, HomePage(user: user));
    },
    onFailure: (error) {
      _showError(error.message);
    },
  );
}
```

---

## ✅ Best Practices

### Rule 1: Never Silent Errors

```dart
// ❌ Bad - Silent failure
try {
  await saveData();
} catch (e) {
  // Nothing! User won't know what happened
}

// ✅ Good - At least log it
try {
  await saveData();
} catch (e) {
  log('Failed to save data: $e', name: 'DataService');
  rethrow; // or handle properly
}

// ✅ Better - Inform user
try {
  await saveData();
} catch (e) {
  log('Failed to save data: $e', name: 'DataService');
  _showError('Could not save your changes');
}

// ✅ Best - Track in production
try {
  await saveData();
} catch (e, stackTrace) {
  log('Failed to save data: $e', name: 'DataService');
  FirebaseCrashlytics.instance.recordError(e, stackTrace);
  _showError('Could not save your changes');
}
```

---

### Rule 2: Async Error Handling

```dart
// ❌ Bad - No error handling
Future<void> loadData() async {
  final data = await api.getData(); // Can crash!
  setState(() => _data = data);
}

// ✅ Good - Basic try-catch
Future<void> loadData() async {
  try {
    final data = await api.getData();
    setState(() => _data = data);
  } catch (e) {
    _showError('Failed to load data');
  }
}

// ✅ Better - With loading states
Future<void> loadData() async {
  setState(() => _isLoading = true);
  
  try {
    final data = await api.getData();
    setState(() {
      _data = data;
      _error = null;
    });
  } catch (e) {
    setState(() => _error = e.toString());
  } finally {
    setState(() => _isLoading = false);
  }
}

// ✅ Best - With proper state management
Future<void> loadData() async {
  emit(DataLoading());
  
  try {
    final data = await api.getData();
    emit(DataLoaded(data));
  } on NetworkException catch (e) {
    emit(DataError('No internet connection'));
  } on TimeoutException catch (e) {
    emit(DataError('Request timed out'));
  } catch (e, stackTrace) {
    log('Unexpected error', error: e, stackTrace: stackTrace);
    emit(DataError('Something went wrong'));
  }
}
```

---

### Rule 3: Streams Error Handling

```dart
// ❌ Bad - No error handling
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    yield await heavyComputation(i); // Can throw!
  }
}

// ✅ Good - Handle errors in stream
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    try {
      yield await heavyComputation(i);
    } catch (e) {
      log('Error in computation: $e');
      yield -1; // Error value
    }
  }
}

// ✅ Better - Use addError
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    try {
      yield await heavyComputation(i);
    } catch (e, stackTrace) {
      addError(e, stackTrace);
    }
  }
}

// Usage in StreamBuilder
StreamBuilder<int>(
  stream: countStream(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ErrorWidget(snapshot.error.toString());
    }
    if (snapshot.hasData) {
      return Text('${snapshot.data}');
    }
    return CircularProgressIndicator();
  },
)
```

---

### Rule 4: Global Error Handler

```dart
// في main.dart
void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    log('Flutter error: ${details.exception}', 
        name: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack);
    
    if (kReleaseMode) {
      // Send to crash reporting
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };
  
  // Catch async errors outside Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    log('Platform error: $error',
        name: 'PlatformError',
        error: error,
        stackTrace: stack);
    
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  
  // Run app in error zone
  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stack) {
      log('Zone error: $error',
          name: 'ZoneError',
          error: error,
          stackTrace: stack);
      
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordError(error, stack);
      }
    },
  );
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Catching Too Broadly

```dart
// ❌ Bad - Hides programming errors
try {
  final user = await getUser();
  print(user.name.toUpperCase()); // Typo in property name
} catch (e) {
  print('Failed to get user'); // Hides the real bug!
}

// ✅ Good - Catch specific errors
try {
  final user = await getUser();
  print(user.name.toUpperCase());
} on NetworkException catch (e) {
  print('Network error: $e');
} on TimeoutException catch (e) {
  print('Timeout: $e');
}
// Let programming errors crash in development
```

---

### Pitfall 2: Not Propagating Errors

```dart
// ❌ Bad - Error lost
Future<User> getUser() async {
  try {
    return await api.getUser();
  } catch (e) {
    print('Error: $e');
    return null; // Caller doesn't know about error!
  }
}

// ✅ Good - Rethrow or return Result
Future<User?> getUser() async {
  try {
    return await api.getUser();
  } catch (e) {
    log('Failed to get user: $e');
    rethrow; // Let caller handle it
  }
}

// ✅ Better - Use Result pattern
Future<Result<User>> getUser() async {
  try {
    final user = await api.getUser();
    return Result.success(user);
  } catch (e) {
    return Result.failure(AppException('Failed to get user'));
  }
}
```

---

### Pitfall 3: Not Cleaning Up Resources

```dart
// ❌ Bad - Resource leak
Future<void> processFile(String path) async {
  final file = await File(path).open();
  await file.write('data');
  await file.close(); // ⚠️ Not executed if error!
}

// ✅ Good - Use finally
Future<void> processFile(String path) async {
  File? file;
  try {
    file = await File(path).open();
    await file.write('data');
  } finally {
    await file?.close(); // Always executed
  }
}

// ✅ Better - Use try-with-resources pattern
Future<void> processFile(String path) async {
  await File(path).openWrite().use((file) async {
    await file.write('data');
  });
}
```

---

## 💡 Advanced Patterns

### Pattern 1: Error Boundary Widget

```dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error)? errorBuilder;
  
  const ErrorBoundary({
    required this.child,
    this.errorBuilder,
    super.key,
  });
  
  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  
  @override
  void initState() {
    super.initState();
    // Catch errors in build
    FlutterError.onError = (details) {
      setState(() => _error = details.exception);
    };
  }
  
  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ??
          ErrorWidget(_error.toString());
    }
    return widget.child;
  }
}

// Usage
ErrorBoundary(
  errorBuilder: (error) => Scaffold(
    body: Center(
      child: Text('Something went wrong: $error'),
    ),
  ),
  child: MyApp(),
)
```

---

### Pattern 2: Retry Logic

```dart
class RetryConfig {
  final int maxAttempts;
  final Duration delay;
  final bool exponentialBackoff;
  
  const RetryConfig({
    this.maxAttempts = 3,
    this.delay = const Duration(seconds: 1),
    this.exponentialBackoff = true,
  });
}

Future<T> retry<T>(
  Future<T> Function() operation, {
  RetryConfig config = const RetryConfig(),
  bool Function(Object error)? shouldRetry,
}) async {
  int attempts = 0;
  Duration currentDelay = config.delay;
  
  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempts++;
      
      if (attempts >= config.maxAttempts) {
        rethrow;
      }
      
      if (shouldRetry != null && !shouldRetry(e)) {
        rethrow;
      }
      
      await Future.delayed(currentDelay);
      
      if (config.exponentialBackoff) {
        currentDelay *= 2;
      }
    }
  }
}

// Usage
final data = await retry(
  () => api.getData(),
  config: RetryConfig(maxAttempts: 3, delay: Duration(seconds: 2)),
  shouldRetry: (error) => error is NetworkException,
);
```

---

### Pattern 3: Circuit Breaker

```dart
class CircuitBreaker {
  final int failureThreshold;
  final Duration resetTimeout;
  
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  CircuitState _state = CircuitState.closed;
  
  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(minutes: 1),
  });
  
  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitState.open) {
      if (DateTime.now().difference(_lastFailureTime!) > resetTimeout) {
        _state = CircuitState.halfOpen;
      } else {
        throw CircuitBreakerOpenException();
      }
    }
    
    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }
  
  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitState.closed;
  }
  
  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    
    if (_failureCount >= failureThreshold) {
      _state = CircuitState.open;
    }
  }
}

enum CircuitState { closed, open, halfOpen }
```

---

## 🧪 Testing Error Handling

```dart
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('Error Handling Tests', () {
    test('should handle network error', () async {
      final api = MockApi();
      when(() => api.getData()).thenThrow(NetworkException('No internet'));
      
      final service = DataService(api);
      final result = await service.loadData();
      
      expect(result.isFailure, isTrue);
      expect(result.error, isA<NetworkException>());
    });
    
    test('should retry on failure', () async {
      final api = MockApi();
      var callCount = 0;
      when(() => api.getData()).thenAnswer((_) async {
        callCount++;
        if (callCount < 3) {
          throw NetworkException('Temporary error');
        }
        return 'success';
      });
      
      final result = await retry(() => api.getData());
      
      expect(result, equals('success'));
      expect(callCount, equals(3));
    });
    
    test('should not catch programming errors', () {
      expect(
        () => throw AssertionError('Bug'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - كل async operation يجب أن يكون في try-catch
  - لا توجد catch blocks فارغة
  - الأخطاء يتم logging-ها
  - المستخدم يتم إعلامه بالأخطاء
  - الـ resources يتم تنظيفها (finally)
  - Custom exceptions لأنواع الأخطاء المختلفة

suggest:
  - استخدام Result pattern بدلاً من throwing
  - إضافة specific exception types
  - Retry logic للـ network errors
  - Global error handler
  - Error tracking (Crashlytics)

enforce:
  - لا silent errors أبداً
  - كل catch يجب أن يفعل شيء (log, show, rethrow)
  - finally للـ resource cleanup
  - User-friendly error messages
```

---

## 📊 Summary Checklist

```markdown
- [ ] جميع async operations في try-catch
- [ ] لا توجد catch blocks فارغة
- [ ] Custom exceptions محددة
- [ ] Result pattern للـ functions المهمة
- [ ] Global error handler مُعد
- [ ] Logging لجميع الأخطاء
- [ ] User-friendly messages
- [ ] Resource cleanup في finally
- [ ] Error tracking في production
- [ ] Tests للـ error cases
- [ ] Retry logic للـ network operations
- [ ] Circuit breaker للـ external services
```

---

## 🔗 Related Rules

- [Null Safety](./null-safety.md) - تجنب null errors
- [Async/Await](./async-await.md) - async error handling
- [Testing](../testing/unit-testing.md) - testing errors

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

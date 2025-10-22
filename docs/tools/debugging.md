# Debugging Techniques

## 📋 Metadata

```yaml
priority: LOW
level: ESSENTIAL
category: Development Tools
applies_to:
  - all_projects
ai_agent_tags:
  - debugging
  - devtools
  - troubleshooting
  - development
```

---

## 🎯 Overview

**Debugging** مهارة أساسية. استخدام الأدوات الصحيحة يسرّع إيجاد وإصلاح الأخطاء.

### Why Learn Debugging?
- 🐛 Find bugs faster
- 🔍 Understand behavior
- ⚡ Faster development
- 📊 Better code quality
- 🎯 Root cause analysis

---

## 🔵 Priority Level: LOW

**Status:** `ESSENTIAL` لجميع المطورين

---

## 📚 Core Concepts

### 1. Print Debugging

```dart
// ✅ Basic debugging
void fetchData() async {
  print('fetchData: Starting...'); // Log start
  
  try {
    final data = await api.getData();
    print('fetchData: Got ${data.length} items'); // Log success
    return data;
  } catch (e) {
    print('fetchData: Error - $e'); // Log error
    rethrow;
  }
}

// ✅ Pretty printing
import 'dart:developer' as developer;

developer.log(
  'User data',
  name: 'UserService',
  error: error,
  stackTrace: stackTrace,
);

// ✅ Inspect objects
import 'dart:convert';

print(JsonEncoder.withIndent('  ').convert(user.toJson()));
```

---

### 2. Debugger & Breakpoints

```dart
// ✅ Programmatic breakpoint
void processData(List<Item> items) {
  for (var item in items) {
    if (item.id == 'problematic_id') {
      debugger(); // Pauses execution here
    }
    // Process item
  }
}

// IDE Breakpoints:
// 1. Click left gutter to add breakpoint
// 2. Run in debug mode (F5)
// 3. Execution pauses at breakpoint
// 4. Inspect variables
// 5. Step through code
```

---

### 3. Flutter DevTools

```bash
# Open DevTools
flutter run
# Press 'v' to open DevTools in browser

# Or directly
flutter pub global activate devtools
flutter pub global run devtools
```

#### DevTools Features:
```yaml
Widget Inspector:
  - View widget tree
  - Check layout constraints
  - Debug overflow issues
  - Toggle debug painting

Performance:
  - Frame rendering timeline
  - GPU/CPU graphs
  - Identify jank
  - Record performance traces

Memory:
  - Heap snapshot
  - Memory allocation tracking
  - Find memory leaks
  - Object inspection

Network:
  - HTTP requests
  - Response times
  - Request/response bodies
  - Network errors

Logging:
  - All print statements
  - Error messages
  - Custom logs
  - Stack traces
```

---

### 4. Debug Mode vs Release Mode

```dart
// ✅ Conditional debugging
void expensiveOperation() {
  if (kDebugMode) {
    print('Debug: Starting expensive operation');
    debugPrint('Details: $details');
  }
  
  // Operation code
}

// ✅ Assertions (only in debug)
void updateUser(User user) {
  assert(user.id.isNotEmpty, 'User ID cannot be empty');
  assert(user.age >= 0, 'Age must be positive');
  
  // Update logic
}

// ✅ Debug-only widgets
if (kDebugMode)
  FloatingActionButton(
    onPressed: () => _debugFunction(),
    child: Icon(Icons.bug_report),
  )
```

---

### 5. Widget Inspector

```dart
// Enable debug painting
void main() {
  debugPaintSizeEnabled = true; // Show layout boundaries
  debugPaintBaselinesEnabled = true; // Show text baselines
  debugPaintPointersEnabled = true; // Show pointer hits
  
  runApp(MyApp());
}

// In DevTools:
// - Select Widget Mode
// - Click on widget
// - View properties
// - Check constraints
// - Debug layout issues
```

---

### 6. Network Debugging

```dart
// ✅ Log all HTTP requests
import 'package:dio/dio.dart';

final dio = Dio();
dio.interceptors.add(
  LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (obj) => print(obj),
  ),
);

// ✅ Debug specific requests
try {
  final response = await dio.get('/users');
  print('Response: ${response.statusCode}');
  print('Body: ${response.data}');
} catch (e) {
  if (e is DioException) {
    print('Request: ${e.requestOptions.uri}');
    print('Headers: ${e.requestOptions.headers}');
    print('Response: ${e.response?.statusCode}');
    print('Error: ${e.message}');
  }
}
```

---

### 7. State Debugging

```dart
// ✅ Log state changes (Bloc)
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      print('UserBloc: Loading user ${event.userId}');
      emit(UserLoading());
      
      try {
        final user = await repository.getUser(event.userId);
        print('UserBloc: Loaded user ${user.name}');
        emit(UserLoaded(user));
      } catch (e) {
        print('UserBloc: Error - $e');
        emit(UserError(e.toString()));
      }
    });
  }
  
  @override
  void onChange(Change<UserState> change) {
    super.onChange(change);
    print('UserBloc: ${change.currentState} → ${change.nextState}');
  }
}

// ✅ Provider debugging
class UserModel with ChangeNotifier {
  User? _user;
  
  void setUser(User user) {
    _user = user;
    print('UserModel: User updated to ${user.name}');
    notifyListeners();
  }
}
```

---

### 8. Performance Debugging

```dart
// ✅ Measure performance
import 'dart:developer';

void expensiveOperation() {
  final stopwatch = Stopwatch()..start();
  
  // Operation
  processLargeList();
  
  stopwatch.stop();
  print('Operation took ${stopwatch.elapsedMilliseconds}ms');
}

// ✅ Timeline events
Future<void> loadData() async {
  Timeline.startSync('loadData');
  
  try {
    await api.getData();
  } finally {
    Timeline.finishSync();
  }
}

// ✅ Track widget rebuilds
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyWidget rebuilt'); // Track rebuilds
    return Container();
  }
}
```

---

### 9. Memory Debugging

```dart
// ✅ Detect memory leaks
class MyService {
  StreamSubscription? _subscription;
  
  void init() {
    _subscription = stream.listen((data) {
      // Handle data
    });
  }
  
  void dispose() {
    _subscription?.cancel();
    print('MyService: Disposed'); // Verify disposal
  }
}

// ✅ Check for retained objects
// In DevTools:
// 1. Go to Memory tab
// 2. Take snapshot
// 3. Perform action
// 4. Take another snapshot
// 5. Compare - should be similar
```

---

### 10. Error Handling Debug

```dart
// ✅ Global error handler
void main() {
  FlutterError.onError = (details) {
    print('Flutter Error:');
    print('Exception: ${details.exception}');
    print('Stack: ${details.stack}');
    
    // Send to crash reporting
    if (kReleaseMode) {
      // crashlytics.recordError(details.exception, details.stack);
    }
  };
  
  runZonedGuarded(
    () => runApp(MyApp()),
    (error, stack) {
      print('Zone Error:');
      print('Error: $error');
      print('Stack: $stack');
    },
  );
}
```

---

## ✅ Best Practices

### Rule 1: Use debugPrint Instead of print

```dart
// ❌ Bad - Can be dropped in long logs
print('Very long message that might be dropped...');

// ✅ Good - Never dropped
debugPrint('Very long message that will show completely');
```

---

### Rule 2: Remove Debug Code Before Release

```dart
// ✅ Good - Debug code removed in release
if (kDebugMode) {
  print('Debug info');
}

// ❌ Bad - Debug code in release
print('Debug info'); // Visible in release!
```

---

### Rule 3: Use Descriptive Logs

```dart
// ❌ Bad - Unclear
print('Error: $e');

// ✅ Good - Clear context
print('UserService.getUser: Failed to fetch user with ID $userId - $e');
```

---

## 🎯 Debugging Workflow

```yaml
1. Reproduce Issue:
   - Find steps to reproduce
   - Note environment (device, OS)
   - Check logs

2. Isolate Problem:
   - Add breakpoints
   - Add logging
   - Use DevTools Inspector

3. Identify Root Cause:
   - Check stack trace
   - Inspect variables
   - Review state changes

4. Fix:
   - Implement solution
   - Test thoroughly
   - Verify no side effects

5. Prevent:
   - Add tests
   - Add assertions
   - Document fix
```

---

## 🚨 Common Issues

### Issue 1: Widget Not Updating
```dart
// Check:
- setState() called?
- Provider notifyListeners() called?
- Bloc emit() called?
- Widget using correct provider/consumer?
```

### Issue 2: Network Request Failing
```dart
// Check:
- Correct URL?
- Internet permission (Android)?
- HTTPS allowed?
- Token valid?
- Request timeout?
```

### Issue 3: Layout Overflow
```dart
// Solution:
- Use DevTools Widget Inspector
- Check constraints
- Use Expanded/Flexible
- Add ListView/SingleChildScrollView
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - no print in release
  - debugPrint usage
  - kDebugMode checks
  - proper error handling
  - assertions in debug
  - devtools integration

suggest:
  - add debug logs
  - use debugPrint
  - add breakpoints locations
  - check DevTools
  - add assertions
  - log state changes

enforce:
  - kDebugMode for debug code
  - descriptive log messages
  - proper error context
  - clean debug code before release
```

---

## 📊 Summary Checklist

```markdown
- [ ] DevTools installed
- [ ] Breakpoints used
- [ ] Logging added
- [ ] Network debugging setup
- [ ] State changes logged
- [ ] Performance measured
- [ ] Memory checked
- [ ] Debug code removed (release)
```

---

## 🔗 Related Rules

- [Error Handling](../core/error-handling.md)
- [Performance](../flutter-basics/performance-basics.md)
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🔵 LOW  
**Level:** ESSENTIAL  
**For:** All Developers  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

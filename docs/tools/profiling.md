# Performance Profiling

## 📋 Metadata

```yaml
priority: LOW
level: ADVANCED
category: Development Tools
applies_to:
  - performance_optimization
  - production_apps
ai_agent_tags:
  - profiling
  - performance
  - optimization
  - devtools
  - metrics
```

---

## 🎯 Overview

**Performance Profiling** يحدد bottlenecks ويحسّن الأداء. ضروري للتطبيقات السلسة.

### Why Profile?
- 🎯 Find bottlenecks
- ⚡ Improve performance
- 📊 Data-driven optimization
- 🔋 Better battery life
- ✅ 60 FPS target

---

## 🔵 Priority Level: LOW

**Status:** `ADVANCED` - للتحسين المتقدم

---

## 📚 Core Concepts

### 1. Flutter DevTools Performance

```bash
# Run app in profile mode
flutter run --profile

# Open DevTools
# Press 'v' in terminal

# Or open directly
flutter pub global activate devtools
flutter pub global run devtools
```

#### Performance Tab Features:
```yaml
Frame Rendering:
  - FPS graph
  - Frame times
  - Jank detection
  - GPU/UI thread

Timeline:
  - Event recording
  - Widget builds
  - Layout/Paint times
  - Custom events

Memory:
  - Heap usage
  - Allocation tracking
  - Memory leaks
  - GC events
```

---

### 2. Performance Overlay

```dart
// Enable performance overlay
void main() {
  runApp(
    MaterialApp(
      showPerformanceOverlay: true, // Shows FPS graphs
      home: MyHomePage(),
    ),
  );
}

// Custom overlay
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (kDebugMode)
              Positioned(
                top: 50,
                right: 10,
                child: PerformanceInfo(),
              ),
          ],
        );
      },
      home: MyHomePage(),
    );
  }
}
```

---

### 3. Timeline Events

```dart
import 'dart:developer';

// ✅ Track custom operations
Future<void> loadData() async {
  Timeline.startSync('loadData');
  
  try {
    final data = await api.getData();
    
    Timeline.startSync('processData');
    final processed = processData(data);
    Timeline.finishSync();
    
    return processed;
  } finally {
    Timeline.finishSync();
  }
}

// ✅ Async operations
Future<void> fetchAndProcess() async {
  final timelineTask = TimelineTask()..start('fetchAndProcess');
  
  try {
    await fetchData();
    await processData();
  } finally {
    timelineTask.finish();
  }
}
```

---

### 4. Benchmark Tests

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('list scrolling performance', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: 1000,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
        ),
      ),
    );
    
    // Measure scroll performance
    final stopwatch = Stopwatch()..start();
    
    await tester.fling(
      find.byType(ListView),
      Offset(0, -500),
      1000,
    );
    
    await tester.pumpAndSettle();
    
    stopwatch.stop();
    
    expect(
      stopwatch.elapsedMilliseconds,
      lessThan(1000),
      reason: 'Scroll should complete in < 1 second',
    );
  });
}
```

---

### 5. CPU Profiling

```dart
// Track expensive operations
Future<void> heavyComputation() async {
  final stopwatch = Stopwatch()..start();
  
  // Expensive operation
  for (int i = 0; i < 1000000; i++) {
    // Complex calculation
  }
  
  stopwatch.stop();
  
  if (stopwatch.elapsedMilliseconds > 16) {
    print('⚠️ Heavy computation took ${stopwatch.elapsedMilliseconds}ms (> 16ms frame budget)');
  }
}

// Use Isolate for heavy work
Future<List<Result>> processInBackground(List<Data> data) async {
  return await compute(_processData, data);
}

List<Result> _processData(List<Data> data) {
  // Heavy computation in isolate
  return data.map((d) => process(d)).toList();
}
```

---

### 6. Memory Profiling

```dart
// Track memory usage
import 'dart:developer';

class MemoryTracker {
  static void logMemoryUsage(String label) {
    final info = ProcessInfo.currentRss;
    print('$label: Memory usage = ${info ~/ (1024 * 1024)} MB');
  }
}

// Usage
Future<void> loadLargeDataset() async {
  MemoryTracker.logMemoryUsage('Before load');
  
  final data = await loadData();
  
  MemoryTracker.logMemoryUsage('After load');
  
  processData(data);
  
  MemoryTracker.logMemoryUsage('After process');
}

// Find memory leaks
class MyService {
  StreamSubscription? _subscription;
  
  void init() {
    _subscription = stream.listen((_) {});
    print('MyService initialized - ${identityHashCode(this)}');
  }
  
  void dispose() {
    _subscription?.cancel();
    print('MyService disposed - ${identityHashCode(this)}');
  }
}
```

---

### 7. Build Performance

```dart
// Track rebuild count
class PerformanceWidget extends StatelessWidget {
  static int _buildCount = 0;
  
  @override
  Widget build(BuildContext context) {
    _buildCount++;
    
    if (kDebugMode && _buildCount % 10 == 0) {
      print('⚠️ Widget rebuilt $_buildCount times');
    }
    
    return Container(
      child: ExpensiveChild(),
    );
  }
}

// Optimize with const
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static text'), // const - never rebuilds
        SizedBox(height: 16),
        Icon(Icons.home),
      ],
    );
  }
}
```

---

### 8. Network Performance

```dart
// Measure API response times
class ApiMetrics {
  static final Map<String, List<int>> _responseTimes = {};
  
  static Future<Response> trackRequest(
    String endpoint,
    Future<Response> Function() request,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final response = await request();
      stopwatch.stop();
      
      _responseTimes.putIfAbsent(endpoint, () => [])
        .add(stopwatch.elapsedMilliseconds);
      
      if (stopwatch.elapsedMilliseconds > 3000) {
        print('⚠️ Slow request: $endpoint took ${stopwatch.elapsedMilliseconds}ms');
      }
      
      return response;
    } catch (e) {
      stopwatch.stop();
      print('❌ Failed request: $endpoint took ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }
  
  static void printStats() {
    _responseTimes.forEach((endpoint, times) {
      final avg = times.reduce((a, b) => a + b) / times.length;
      print('$endpoint: ${times.length} requests, avg ${avg.toStringAsFixed(0)}ms');
    });
  }
}

// Usage
final response = await ApiMetrics.trackRequest(
  '/users',
  () => dio.get('/users'),
);
```

---

### 9. Animation Performance

```dart
// Monitor animation frame rate
class AnimationPerformance extends StatefulWidget {
  @override
  State<AnimationPerformance> createState() => _AnimationPerformanceState();
}

class _AnimationPerformanceState extends State<AnimationPerformance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _frameCount = 0;
  DateTime _startTime = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _controller.addListener(() {
      _frameCount++;
      
      final elapsed = DateTime.now().difference(_startTime).inSeconds;
      if (elapsed > 0) {
        final fps = _frameCount / elapsed;
        if (fps < 55) {
          print('⚠️ Low FPS: ${fps.toStringAsFixed(1)}');
        }
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: child,
        );
      },
      child: Icon(Icons.refresh, size: 100),
    );
  }
}
```

---

### 10. App Startup Time

```dart
// Measure app startup
void main() async {
  final startTime = DateTime.now();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await initializeServices();
  
  final initTime = DateTime.now().difference(startTime);
  print('Services initialized in ${initTime.inMilliseconds}ms');
  
  runApp(MyApp());
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final totalTime = DateTime.now().difference(startTime);
    print('App started in ${totalTime.inMilliseconds}ms');
    
    if (totalTime.inSeconds > 3) {
      print('⚠️ Slow startup: ${totalTime.inSeconds}s');
    }
  });
}
```

---

## ✅ Best Practices

### Rule 1: Profile in Profile Mode

```bash
# ❌ Wrong - Debug mode is slow
flutter run

# ✅ Correct - Profile mode
flutter run --profile
```

---

### Rule 2: Set Performance Budgets

```dart
// ✅ Define acceptable thresholds
const int MAX_BUILD_TIME_MS = 16; // 60 FPS
const int MAX_API_RESPONSE_MS = 3000;
const int MAX_STARTUP_TIME_MS = 2000;

// Enforce in tests
test('widget builds quickly', () {
  final stopwatch = Stopwatch()..start();
  
  // Build widget
  
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(MAX_BUILD_TIME_MS));
});
```

---

### Rule 3: Profile Real Devices

```yaml
Always Profile On:
  - Real devices (not emulators)
  - Low-end devices
  - Different OS versions
  - Various screen sizes

Avoid:
  - Emulators (slower)
  - Debug mode
  - Debug builds
```

---

## 🎯 Performance Targets

```yaml
Frame Rate:
  - Target: 60 FPS (16ms per frame)
  - Acceptable: 55+ FPS
  - Poor: < 50 FPS

App Startup:
  - Excellent: < 1s
  - Good: 1-2s
  - Acceptable: 2-3s
  - Poor: > 3s

API Response:
  - Fast: < 500ms
  - Good: 500ms - 1s
  - Acceptable: 1s - 3s
  - Slow: > 3s

Memory:
  - Low-end device: < 100MB
  - Mid-range: < 200MB
  - High-end: < 300MB
```

---

## 🚨 Common Performance Issues

### Issue 1: Excessive Rebuilds
```dart
// Solution: Use const, extract widgets, localize setState
```

### Issue 2: Large Lists
```dart
// Solution: Use ListView.builder, itemExtent, caching
```

### Issue 3: Heavy Build Methods
```dart
// Solution: Extract widgets, use const, avoid computations
```

### Issue 4: Memory Leaks
```dart
// Solution: Dispose controllers, cancel subscriptions
```

### Issue 5: Network Bottlenecks
```dart
// Solution: Cache, pagination, parallel requests
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - profile mode usage
  - timeline events
  - performance budgets
  - memory tracking
  - build optimizations
  - const usage

suggest:
  - add timeline events
  - set performance budgets
  - profile on real device
  - optimize hot paths
  - reduce rebuilds
  - add caching

enforce:
  - profile mode for profiling
  - 60 FPS target
  - startup < 3s
  - dispose resources
  - const constructors
```

---

## 📊 Profiling Workflow

```yaml
1. Measure Baseline:
   - Record current performance
   - Identify problem areas
   - Set improvement goals

2. Profile:
   - Use DevTools Performance tab
   - Add timeline events
   - Track specific operations
   - Record user flows

3. Analyze:
   - Find bottlenecks
   - Check frame times
   - Review memory usage
   - Inspect network calls

4. Optimize:
   - Fix critical issues first
   - Measure after each change
   - Verify improvements
   - Document changes

5. Verify:
   - Test on real devices
   - Check all scenarios
   - Compare with baseline
   - Ensure no regressions
```

---

## 📊 Summary Checklist

```markdown
- [ ] DevTools configured
- [ ] Profile mode used
- [ ] Performance overlay enabled
- [ ] Timeline events added
- [ ] Benchmarks created
- [ ] Memory tracked
- [ ] Real device tested
- [ ] Performance budgets set
- [ ] Bottlenecks identified
- [ ] Optimizations applied
```

---

## 🔗 Related Rules

- [Performance Basics](../flutter-basics/performance-basics.md)
- [Build Optimization](../performance/build-optimization.md)
- [List Optimization](../performance/list-optimization.md)
- [Debugging](./debugging.md)

---

**Priority:** 🔵 LOW  
**Level:** ADVANCED  
**For:** Performance Optimization  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

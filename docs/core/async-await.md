# Async/Await & Asynchronous Programming

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Core
applies_to:
  - all_projects
  - all_platforms
ai_agent_tags:
  - async-await
  - futures
  - streams
  - asynchronous
  - critical
```

---

## 🎯 Overview

**Asynchronous Programming** أساسي في Flutter لأن معظم العمليات (API calls, file I/O, database) تحتاج وقت. استخدام async/await الصحيح يمنع UI freezing ويحسن تجربة المستخدم.

### Why It Matters
- 🚀 Responsive UI - واجهة سلسة
- ⚡ Better Performance - أداء أفضل
- 🔄 Multiple Operations - عمليات متزامنة
- 💪 Error Handling - معالجة أخطاء أفضل

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - إلزامي لجميع العمليات غير المتزامنة

### Why CRITICAL?

```dart
// ❌ Bad - Blocks UI thread
void loadData() {
  final data = api.getData(); // App freezes!
  setState(() => _data = data);
}

// ✅ Good - Non-blocking
Future<void> loadData() async {
  final data = await api.getData(); // UI responsive
  setState(() => _data = data);
}
```

---

## 📚 Core Concepts

### 1. Future - Single Async Operation

#### Basic Future
```dart
// Create a Future
Future<String> fetchUserName() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Ahmed';
}

// Use with await
void example() async {
  final name = await fetchUserName();
  print('Name: $name');
}

// Use with .then()
void example2() {
  fetchUserName().then((name) {
    print('Name: $name');
  });
}
```

#### Future States
```dart
Future<String> loadData() async {
  // Future has 3 states:
  // 1. Uncompleted (pending)
  // 2. Completed with value
  // 3. Completed with error
  
  try {
    final data = await api.getData();
    return data; // Completed with value
  } catch (e) {
    throw Exception('Failed'); // Completed with error
  }
}
```

---

### 2. Async/Await Keywords

#### async Keyword
```dart
// ✅ Mark function as async
Future<User> getUser() async {
  // Can use await inside
  return await api.getUser();
}

// ✅ Can return value directly
Future<int> getAge() async {
  return 25; // Automatically wrapped in Future
}

// ❌ Wrong - async without Future return type
void getData() async { // Should return Future<void>
  await api.getData();
}

// ✅ Correct
Future<void> getData() async {
  await api.getData();
}
```

#### await Keyword
```dart
// ✅ Wait for Future to complete
Future<void> loadUser() async {
  final user = await api.getUser(); // Wait here
  print(user.name); // Execute after Future completes
}

// ❌ Wrong - await without async
void loadUser() { // Missing async
  final user = await api.getUser(); // Error!
}

// ❌ Wrong - Forgot await
Future<void> loadUser() async {
  final future = api.getUser(); // future is Future<User>, not User!
  print(future.name); // Error!
}

// ✅ Correct
Future<void> loadUser() async {
  final user = await api.getUser(); // user is User
  print(user.name); // Works!
}
```

---

### 3. Future Methods

#### Future.wait - Run Parallel
```dart
// ✅ Run multiple operations in parallel
Future<void> loadAllData() async {
  // Bad - Sequential (slow)
  final user = await api.getUser();      // 2 seconds
  final posts = await api.getPosts();     // 2 seconds
  final comments = await api.getComments(); // 2 seconds
  // Total: 6 seconds!
  
  // Good - Parallel (fast)
  final results = await Future.wait([
    api.getUser(),
    api.getPosts(),
    api.getComments(),
  ]);
  // Total: 2 seconds!
  
  final user = results[0] as User;
  final posts = results[1] as List<Post>;
  final comments = results[2] as List<Comment>;
}

// ✅ Better - Type-safe
Future<void> loadAllData() async {
  final (user, posts, comments) = await (
    api.getUser(),
    api.getPosts(),
    api.getComments(),
  ).wait; // Dart 3.0+ record pattern
}
```

#### Future.any - First to Complete
```dart
// ✅ Use first successful result
Future<String> fetchFromMultipleSources() async {
  return await Future.any([
    api1.getData(),
    api2.getData(),
    api3.getData(),
  ]);
  // Returns result from first to complete
}
```

#### Future.timeout
```dart
// ✅ Add timeout to prevent hanging
Future<User> getUser() async {
  try {
    return await api.getUser().timeout(
      Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('Request took too long'),
    );
  } on TimeoutException {
    print('Request timed out');
    rethrow;
  }
}
```

#### Future.catchError
```dart
// ✅ Handle errors in Future chain
api.getUser()
  .then((user) => print(user.name))
  .catchError((error) => print('Error: $error'))
  .whenComplete(() => print('Done'));

// ✅ Better - Use try-catch with async/await
Future<void> loadUser() async {
  try {
    final user = await api.getUser();
    print(user.name);
  } catch (e) {
    print('Error: $e');
  } finally {
    print('Done');
  }
}
```

---

### 4. Streams - Multiple Async Events

#### Basic Stream
```dart
// Create a Stream
Stream<int> countStream() async* {
  for (int i = 0; i < 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // Emit value
  }
}

// Listen to Stream
void example() {
  countStream().listen(
    (value) => print('Value: $value'),
    onError: (error) => print('Error: $error'),
    onDone: () => print('Done'),
  );
}

// Or use await for
void example2() async {
  await for (final value in countStream()) {
    print('Value: $value');
  }
  print('Done');
}
```

#### StreamController
```dart
class CounterService {
  final _controller = StreamController<int>();
  int _count = 0;
  
  // Expose stream (read-only)
  Stream<int> get stream => _controller.stream;
  
  void increment() {
    _count++;
    _controller.add(_count); // Emit new value
  }
  
  void dispose() {
    _controller.close(); // Always close!
  }
}

// Usage
final service = CounterService();
service.stream.listen((count) => print('Count: $count'));
service.increment(); // Prints: Count: 1
service.increment(); // Prints: Count: 2
service.dispose();
```

#### Broadcast Stream
```dart
// Regular stream: single subscription only
final stream = Stream.fromIterable([1, 2, 3]);
stream.listen((value) => print('A: $value'));
stream.listen((value) => print('B: $value')); // Error!

// Broadcast stream: multiple subscriptions
final broadcastStream = Stream.fromIterable([1, 2, 3]).asBroadcastStream();
broadcastStream.listen((value) => print('A: $value'));
broadcastStream.listen((value) => print('B: $value')); // Works!
```

#### Stream Transformations
```dart
Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

// Map
final doubled = numbers.map((n) => n * 2);
// Output: 2, 4, 6, 8, 10

// Where (filter)
final evens = numbers.where((n) => n % 2 == 0);
// Output: 2, 4

// Take
final first3 = numbers.take(3);
// Output: 1, 2, 3

// Skip
final skip2 = numbers.skip(2);
// Output: 3, 4, 5

// Distinct
final unique = Stream.fromIterable([1, 1, 2, 2, 3]).distinct();
// Output: 1, 2, 3

// Combine
final combined = numbers
  .where((n) => n > 2)
  .map((n) => n * 2)
  .take(2);
// Output: 6, 8
```

---

## ✅ Best Practices

### Rule 1: Always Use async/await for Futures

```dart
// ❌ Bad - Nested .then() (callback hell)
void loadData() {
  api.getUser().then((user) {
    api.getPosts(user.id).then((posts) {
      api.getComments(posts.first.id).then((comments) {
        setState(() {
          _user = user;
          _posts = posts;
          _comments = comments;
        });
      });
    });
  });
}

// ✅ Good - Clean async/await
Future<void> loadData() async {
  final user = await api.getUser();
  final posts = await api.getPosts(user.id);
  final comments = await api.getComments(posts.first.id);
  
  setState(() {
    _user = user;
    _posts = posts;
    _comments = comments;
  });
}
```

---

### Rule 2: Handle Errors in Async Code

```dart
// ❌ Bad - No error handling
Future<void> loadData() async {
  final data = await api.getData(); // Can throw!
  setState(() => _data = data);
}

// ✅ Good - Try-catch
Future<void> loadData() async {
  try {
    final data = await api.getData();
    setState(() => _data = data);
  } catch (e) {
    print('Error: $e');
    _showError();
  }
}

// ✅ Better - Specific error types
Future<void> loadData() async {
  try {
    final data = await api.getData();
    setState(() => _data = data);
  } on NetworkException catch (e) {
    _showError('No internet connection');
  } on TimeoutException catch (e) {
    _showError('Request timed out');
  } catch (e, stackTrace) {
    log('Unexpected error', error: e, stackTrace: stackTrace);
    _showError('Something went wrong');
  }
}
```

---

### Rule 3: Don't Forget await

```dart
// ❌ Bad - Forgot await
Future<void> saveUser(User user) async {
  database.save(user); // Returns Future, but not awaited!
  print('User saved'); // Prints before save completes!
}

// ✅ Good - With await
Future<void> saveUser(User user) async {
  await database.save(user); // Wait for completion
  print('User saved'); // Prints after save completes
}

// ⚠️ Warning - Floating Future
void saveUser(User user) {
  database.save(user); // No await, no error handling
  // If save fails, you won't know!
}

// ✅ Fix - Add error handling
void saveUser(User user) {
  database.save(user).catchError((error) {
    print('Save failed: $error');
  });
}
```

---

### Rule 4: Use FutureBuilder in UI

```dart
// ❌ Bad - Manual state management
class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  
  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final user = await api.getUser();
      setState(() {
        _user = user;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return CircularProgressIndicator();
    if (_error != null) return Text('Error: $_error');
    if (_user == null) return Text('No user');
    return Text(_user!.name);
  }
}

// ✅ Good - Use FutureBuilder
class UserScreen extends StatelessWidget {
  final Future<User> _userFuture = api.getUser();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        if (!snapshot.hasData) {
          return Text('No user');
        }
        
        final user = snapshot.data!;
        return Text(user.name);
      },
    );
  }
}
```

---

### Rule 5: Use StreamBuilder for Streams

```dart
// ✅ StreamBuilder for real-time updates
class CounterScreen extends StatelessWidget {
  final CounterService _service = CounterService();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _service.stream,
      initialData: 0,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final count = snapshot.data ?? 0;
        
        return Column(
          children: [
            Text('Count: $count'),
            ElevatedButton(
              onPressed: _service.increment,
              child: Text('Increment'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Async in Constructors

```dart
// ❌ Wrong - Can't use async in constructor
class UserService {
  User? user;
  
  UserService() async { // Error!
    user = await api.getUser();
  }
}

// ✅ Solution 1: Factory with static method
class UserService {
  final User user;
  
  UserService._(this.user);
  
  static Future<UserService> create() async {
    final user = await api.getUser();
    return UserService._(user);
  }
}

// Usage
final service = await UserService.create();

// ✅ Solution 2: Initialize method
class UserService {
  User? user;
  
  UserService();
  
  Future<void> initialize() async {
    user = await api.getUser();
  }
}

// Usage
final service = UserService();
await service.initialize();
```

---

### Pitfall 2: Async in Build Method

```dart
// ❌ Wrong - Don't use async in build
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) async { // Error!
    final data = await api.getData();
    return Text(data);
  }
}

// ✅ Correct - Use FutureBuilder
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: api.getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

---

### Pitfall 3: Creating Future in build()

```dart
// ❌ Bad - Creates new Future on every build
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: api.getData(), // New Future every rebuild!
      builder: (context, snapshot) {
        return Text(snapshot.data ?? 'Loading...');
      },
    );
  }
}

// ✅ Good - Create Future once
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final Future<String> _dataFuture;
  
  @override
  void initState() {
    super.initState();
    _dataFuture = api.getData(); // Created once
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _dataFuture, // Reuses same Future
      builder: (context, snapshot) {
        return Text(snapshot.data ?? 'Loading...');
      },
    );
  }
}
```

---

### Pitfall 4: Not Disposing Streams

```dart
// ❌ Bad - Stream leak
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _controller = StreamController<int>();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _controller.stream,
      builder: (context, snapshot) => Text('${snapshot.data}'),
    );
  }
  // Missing dispose! Memory leak!
}

// ✅ Good - Always dispose
class _MyWidgetState extends State<MyWidget> {
  final _controller = StreamController<int>();
  
  @override
  void dispose() {
    _controller.close(); // Important!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _controller.stream,
      builder: (context, snapshot) => Text('${snapshot.data}'),
    );
  }
}
```

---

## 💡 Advanced Patterns

### Pattern 1: Completer

```dart
// For manual Future control
Future<String> getUserInput() {
  final completer = Completer<String>();
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: TextField(
        onSubmitted: (value) {
          completer.complete(value); // Complete Future
          Navigator.pop(context);
        },
      ),
    ),
  );
  
  return completer.future;
}

// Usage
final input = await getUserInput();
print('User entered: $input');
```

---

### Pattern 2: Debounce with Stream

```dart
// Debounce search input
class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = StreamController<String>();
  late final Stream<List<Product>> _resultsStream;
  
  @override
  void initState() {
    super.initState();
    
    _resultsStream = _searchController.stream
      .debounce(Duration(milliseconds: 500)) // Wait 500ms
      .distinct() // Skip duplicates
      .asyncMap((query) => api.search(query)); // Transform to results
  }
  
  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _searchController.add, // Add to stream
        ),
        StreamBuilder<List<Product>>(
          stream: _resultsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(snapshot.data![index].name));
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
```

---

### Pattern 3: Stream Subscription

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  StreamSubscription<int>? _subscription;
  int _count = 0;
  
  @override
  void initState() {
    super.initState();
    
    _subscription = counterStream().listen(
      (value) {
        setState(() => _count = value);
      },
      onError: (error) {
        print('Error: $error');
      },
      onDone: () {
        print('Stream closed');
      },
    );
  }
  
  @override
  void dispose() {
    _subscription?.cancel(); // Cancel subscription
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $_count');
  }
}
```

---

## 🧪 Testing Async Code

```dart
import 'package:test/test.dart';

void main() {
  group('Async Tests', () {
    test('should complete Future', () async {
      final result = await fetchData();
      expect(result, equals('data'));
    });
    
    test('should emit values in Stream', () async {
      final stream = Stream.fromIterable([1, 2, 3]);
      
      expect(
        stream,
        emitsInOrder([1, 2, 3]),
      );
    });
    
    test('should handle Future timeout', () async {
      expect(
        () => slowOperation().timeout(Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
    });
    
    test('should cancel Stream subscription', () async {
      final controller = StreamController<int>();
      final subscription = controller.stream.listen((_) {});
      
      await subscription.cancel();
      
      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - جميع async functions تُرجع Future<T>
  - استخدام await مع كل Future
  - try-catch حول async operations
  - FutureBuilder للـ UI
  - StreamBuilder للـ streams
  - dispose للـ StreamControllers
  - لا async في constructors
  - لا async في build methods
  - Future يُنشأ مرة واحدة (not in build)

suggest:
  - استخدام Future.wait للـ parallel operations
  - إضافة timeout للـ network calls
  - استخدام StreamController.broadcast عند الحاجة
  - debounce للـ search/input streams
  - Completer للـ manual control

enforce:
  - Future<void> لـ async functions بدون return
  - await لكل Future (no floating futures)
  - error handling في async code
  - dispose للـ resources
  - FutureBuilder/StreamBuilder في UI
```

---

## 📊 Summary Checklist

```markdown
- [ ] جميع async functions تُرجع Future
- [ ] await مستخدم مع كل Future
- [ ] try-catch للـ error handling
- [ ] FutureBuilder للـ async UI
- [ ] StreamBuilder للـ streams
- [ ] dispose للـ StreamControllers
- [ ] Future.wait للـ parallel operations
- [ ] timeout للـ network calls
- [ ] لا async في constructors/build
- [ ] Future يُنشأ في initState (not build)
```

---

## 🔗 Related Rules

- [Error Handling](./error-handling.md) - async error handling
- [Null Safety](./null-safety.md) - nullable futures
- [Performance](../flutter-basics/performance-basics.md) - async performance

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

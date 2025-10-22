# Built-in State Management

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: State Management
applies_to:
  - small_to_medium_projects
project_size: < 10 screens
ai_agent_tags:
  - state-management
  - built-in
  - valuenotifier
  - changenotifier
  - streams
```

---

## 🎯 Overview

**Built-in Solutions** هي حلول State Management المدمجة في Flutter SDK بدون dependencies خارجية. مناسبة للمشاريع الصغيرة والمتوسطة.

### Available Solutions
- `ValueNotifier` - Simple value changes
- `ChangeNotifier` - Complex state objects
- `InheritedWidget` - Dependency injection
- `Streams` - Reactive data flow
- `setState` - Local widget state

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للمشاريع الصغيرة (< 10 screens)

---

## 📚 Core Concepts

### 1. ValueNotifier - Simplest Solution

#### Basic Usage
```dart
class Counter {
  final ValueNotifier<int> count = ValueNotifier<int>(0);
  
  void increment() => count.value++;
  void decrement() => count.value--;
  
  void dispose() => count.dispose();
}

// In widget
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final _counter = Counter();
  
  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _counter.count,
          builder: (context, value, child) {
            return Text('Count: $value');
          },
        ),
        ElevatedButton(
          onPressed: _counter.increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

#### Multiple ValueNotifiers
```dart
class LoginController {
  final email = ValueNotifier<String>('');
  final password = ValueNotifier<String>('');
  final isLoading = ValueNotifier<bool>(false);
  final errorMessage = ValueNotifier<String?>(null);
  
  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = null;
    
    try {
      await authService.login(email.value, password.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  void dispose() {
    email.dispose();
    password.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
```

---

### 2. ChangeNotifier - Complex State

#### Basic ChangeNotifier
```dart
class CartModel extends ChangeNotifier {
  final List<Product> _items = [];
  
  List<Product> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.price);
  bool get isEmpty => _items.isEmpty;
  
  void addItem(Product product) {
    _items.add(product);
    notifyListeners(); // Notify all listeners
  }
  
  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
  
  bool contains(String productId) {
    return _items.any((item) => item.id == productId);
  }
}

// In widget
class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _cart = CartModel();
  
  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, child) {
        return Column(
          children: [
            Text('Items: ${_cart.itemCount}'),
            Text('Total: \$${_cart.totalPrice.toStringAsFixed(2)}'),
            Expanded(
              child: ListView.builder(
                itemCount: _cart.itemCount,
                itemBuilder: (context, index) {
                  final item = _cart.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\$${item.price}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _cart.removeItem(item.id),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
```

#### Advanced ChangeNotifier
```dart
class UserProfileModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isLoggedIn => _user != null;
  
  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _user = await apiClient.getUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await apiClient.updateUser(updatedUser);
      _user = updatedUser;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
```

---

### 3. Streams - Reactive State

#### StreamController
```dart
class CounterService {
  final _controller = StreamController<int>.broadcast();
  int _count = 0;
  
  Stream<int> get stream => _controller.stream;
  int get currentValue => _count;
  
  void increment() {
    _count++;
    _controller.add(_count);
  }
  
  void decrement() {
    _count--;
    _controller.add(_count);
  }
  
  void dispose() {
    _controller.close();
  }
}

// In widget
class CounterScreen extends StatelessWidget {
  final CounterService _service = CounterService();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _service.stream,
      initialData: _service.currentValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final count = snapshot.data ?? 0;
        
        return Column(
          children: [
            Text('Count: $count'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _service.increment,
                  child: Text('+'),
                ),
                ElevatedButton(
                  onPressed: _service.decrement,
                  child: Text('-'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

#### BehaviorSubject (rxdart)
```dart
import 'package:rxdart/rxdart.dart';

class SearchService {
  final _searchQuery = BehaviorSubject<String>.seeded('');
  final _results = BehaviorSubject<List<Product>>.seeded([]);
  final _isLoading = BehaviorSubject<bool>.seeded(false);
  
  Stream<String> get searchQuery => _searchQuery.stream;
  Stream<List<Product>> get results => _results.stream;
  Stream<bool> get isLoading => _isLoading.stream;
  
  SearchService() {
    _searchQuery.stream
        .debounceTime(Duration(milliseconds: 500))
        .distinct()
        .listen(_performSearch);
  }
  
  void updateQuery(String query) {
    _searchQuery.add(query);
  }
  
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      _results.add([]);
      return;
    }
    
    _isLoading.add(true);
    
    try {
      final results = await api.search(query);
      _results.add(results);
    } catch (e) {
      _results.addError(e);
    } finally {
      _isLoading.add(false);
    }
  }
  
  void dispose() {
    _searchQuery.close();
    _results.close();
    _isLoading.close();
  }
}
```

---

### 4. InheritedWidget - Dependency Injection

```dart
class AppState {
  final User? user;
  final ThemeMode themeMode;
  final Locale locale;
  
  const AppState({
    this.user,
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
  });
  
  AppState copyWith({
    User? user,
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppState(
      user: user ?? this.user,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class AppStateWidget extends InheritedWidget {
  final AppState state;
  final void Function(AppState) updateState;
  
  const AppStateWidget({
    required this.state,
    required this.updateState,
    required super.child,
    super.key,
  });
  
  static AppStateWidget of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    assert(widget != null, 'No AppStateWidget found in context');
    return widget!;
  }
  
  @override
  bool updateShouldNotify(AppStateWidget oldWidget) {
    return state != oldWidget.state;
  }
}

// Root widget
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState _state = const AppState();
  
  void _updateState(AppState newState) {
    setState(() => _state = newState);
  }
  
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      state: _state,
      updateState: _updateState,
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _state.themeMode,
        locale: _state.locale,
        home: HomeScreen(),
      ),
    );
  }
}

// Usage in any widget
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateWidget.of(context);
    final user = appState.state.user;
    
    return Column(
      children: [
        Text('User: ${user?.name ?? "Guest"}'),
        ElevatedButton(
          onPressed: () {
            appState.updateState(
              appState.state.copyWith(
                themeMode: ThemeMode.dark,
              ),
            );
          },
          child: Text('Toggle Theme'),
        ),
      ],
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Choose Right Tool for Job

```dart
// ✅ ValueNotifier for single values
final count = ValueNotifier<int>(0);
final name = ValueNotifier<String>('');

// ✅ ChangeNotifier for complex state
class UserModel extends ChangeNotifier {
  String? name;
  int? age;
  List<String> hobbies = [];
}

// ✅ Stream for continuous data
Stream<Location> locationStream();
Stream<int> timerStream();

// ✅ setState for local widget state
int _localCounter = 0;
void _increment() => setState(() => _localCounter++);
```

---

### Rule 2: Always Dispose

```dart
// ✅ Good - Proper disposal
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _counter = ValueNotifier<int>(0);
  final _cart = CartModel();
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((_) {});
  }
  
  @override
  void dispose() {
    _counter.dispose();
    _cart.dispose();
    _subscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Container();
}
```

---

### Rule 3: Minimize notifyListeners() Calls

```dart
// ❌ Bad - Multiple notifications
class TodoModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  
  void addMultiple(List<Todo> todos) {
    for (var todo in todos) {
      _todos.add(todo);
      notifyListeners(); // ❌ Called in loop!
    }
  }
}

// ✅ Good - Single notification
class TodoModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  
  void addMultiple(List<Todo> todos) {
    _todos.addAll(todos);
    notifyListeners(); // ✅ Called once
  }
}
```

---

## 📊 When to Use Built-in Solutions

```yaml
Perfect For:
  - Small apps (< 10 screens) ✅
  - Prototypes/MVPs ✅
  - Simple state ✅
  - Learning Flutter ✅
  - No external dependencies needed ✅

Not Ideal For:
  - Large apps (> 20 screens) ⚠️
  - Complex state logic ⚠️
  - Need for DI framework ⚠️
  - Team with different skill levels ⚠️
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - dispose() للـ ValueNotifier/ChangeNotifier
  - StreamSubscription.cancel()
  - notifyListeners() بعد state changes
  - Proper builder widgets (ValueListenableBuilder, etc.)
  - No memory leaks

suggest:
  - استخدام const constructors
  - extract builders إلى widgets
  - debounce للـ streams
  - BehaviorSubject للـ initial values

when_to_migrate:
  - إذا تجاوز 10 screens → consider Provider/Riverpod
  - إذا state معقد جداً → consider Bloc
  - إذا احتجت DI → use Provider/Riverpod
```

---

## 📊 Summary Checklist

```markdown
- [ ] dispose() لكل controller
- [ ] builder widgets صحيحة
- [ ] notifyListeners() بعد changes
- [ ] لا memory leaks
- [ ] stream subscriptions cancelled
- [ ] initialData للـ StreamBuilder
```

---

## 🔗 Related Rules

- [State Management Comparison](./comparison.md)
- [Provider](./provider.md) - Next step up
- [Performance](../flutter-basics/performance-basics.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Best For:** Small to Medium Projects  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

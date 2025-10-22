# Provider State Management

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: State Management
applies_to:
  - small_to_large_projects
project_size: 5-50 screens
officially_recommended: true
ai_agent_tags:
  - state-management
  - provider
  - dependency-injection
  - changenotifier
```

---

## 🎯 Overview

**Provider** هو الحل الموصى به رسمياً من فريق Flutter. مبني على `InheritedWidget` مع API أبسط و Dependency Injection مدمج.

### Why Provider?
- ✅ موصى به رسمياً
- 🎯 سهل التعلم
- 📦 Dependency Injection
- 🧪 سهل الاختبار
- 📚 توثيق ممتاز

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للمشاريع من 5-50 screen

---

## 📚 Core Concepts

### 1. Basic Provider Setup

#### pubspec.yaml
```yaml
dependencies:
  provider: ^6.1.5  # ✅ Updated to latest (patch fixes)
```

#### Simple Provider
```dart
import 'package:provider/provider.dart';

// Model
class Counter extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// Setup in main
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: MyApp(),
    ),
  );
}

// Usage in widgets
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Option 1: Consumer
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Column(
          children: [
            Text('Count: ${counter.count}'),
            child!, // Reused widget
          ],
        );
      },
      child: ElevatedButton(
        onPressed: () {
          context.read<Counter>().increment();
        },
        child: Text('Increment'),
      ),
    );
    
    // Option 2: context.watch (in build only)
    final counter = context.watch<Counter>();
    return Text('${counter.count}');
    
    // Option 3: context.read (for methods/callbacks)
    return ElevatedButton(
      onPressed: () => context.read<Counter>().increment(),
      child: Text('Increment'),
    );
  }
}
```

---

### 2. Multiple Providers

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MyApp(),
    ),
  );
}

// Usage
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = context.watch<Counter>();
    final cart = context.watch<CartModel>();
    final user = context.watch<UserModel>();
    
    return Column(
      children: [
        Text('Count: ${counter.count}'),
        Text('Cart items: ${cart.itemCount}'),
        Text('User: ${user.name}'),
      ],
    );
  }
}
```

---

### 3. ProxyProvider - Dependencies

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Independent provider
        Provider(create: (_) => ApiClient()),
        
        // Depends on ApiClient
        ProxyProvider<ApiClient, UserRepository>(
          update: (_, api, __) => UserRepository(api),
        ),
        
        // Depends on UserRepository
        ChangeNotifierProxyProvider<UserRepository, UserModel>(
          create: (_) => UserModel(),
          update: (_, repo, model) => model!..updateRepository(repo),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

---

### 4. Provider Types

#### ChangeNotifierProvider
```dart
// For mutable state that notifies
class CartModel extends ChangeNotifier {
  final List<Product> _items = [];
  
  List<Product> get items => List.unmodifiable(_items);
  
  void addItem(Product item) {
    _items.add(item);
    notifyListeners();
  }
}

ChangeNotifierProvider(
  create: (_) => CartModel(),
  child: MyApp(),
)
```

#### Provider (simple)
```dart
// For immutable objects/services
class ApiClient {
  Future<Data> getData() async {}
}

Provider(
  create: (_) => ApiClient(),
  child: MyApp(),
)
```

#### FutureProvider
```dart
// For async data that loads once
FutureProvider<User>(
  initialData: null,
  create: (_) => fetchUser(),
  child: MyApp(),
)

// Usage
final user = context.watch<User?>();
if (user == null) {
  return CircularProgressIndicator();
}
return Text(user.name);
```

#### StreamProvider
```dart
// For continuous data stream
StreamProvider<int>(
  initialData: 0,
  create: (_) => counterStream(),
  child: MyApp(),
)

// Usage
final count = context.watch<int>();
return Text('$count');
```

---

## ✅ Best Practices

### Rule 1: Watch vs Read vs Select

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ watch - Rebuilds when value changes
    final counter = context.watch<Counter>();
    // Use in build method
    
    // ✅ read - Doesn't rebuild, for callbacks
    return ElevatedButton(
      onPressed: () => context.read<Counter>().increment(),
      child: Text('${counter.count}'),
    );
    
    // ✅ select - Rebuilds only when specific property changes
    final count = context.select<Counter, int>((c) => c.count);
    return Text('$count');
    // Won't rebuild if other Counter properties change
  }
}
```

---

### Rule 2: Use Selector for Performance

```dart
// ❌ Bad - Rebuilds for any Counter change
Consumer<Counter>(
  builder: (context, counter, child) {
    return Text('${counter.count}');
  },
)

// ✅ Good - Rebuilds only when count changes
Selector<Counter, int>(
  selector: (_, counter) => counter.count,
  builder: (_, count, __) {
    return Text('$count');
  },
)

// ✅ Multiple values
Selector<CartModel, ({int count, double total})>(
  selector: (_, cart) => (
    count: cart.itemCount,
    total: cart.totalPrice,
  ),
  builder: (_, data, __) {
    return Column(
      children: [
        Text('Items: ${data.count}'),
        Text('Total: \$${data.total}'),
      ],
    );
  },
)
```

---

### Rule 3: Provide at Right Level

```dart
// ❌ Bad - Too high, entire app rebuilds
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FilterModel(), // Only used in one screen
      child: MyApp(),
    ),
  );
}

// ✅ Good - Provide where needed
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterModel(), // Only this screen
      child: _SearchScreenContent(),
    );
  }
}
```

---

### Rule 4: Lazy Providers

```dart
// ✅ Good - Lazy by default
ChangeNotifierProvider(
  create: (_) => ExpensiveService(), // Created only when first accessed
  child: MyApp(),
)

// If you need eager creation
ChangeNotifierProvider(
  create: (_) => ImportantService(),
  lazy: false, // Created immediately
  child: MyApp(),
)
```

---

## 🎯 Real-World Examples

### Example 1: Authentication

```dart
class AuthModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await authService.login(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void logout() {
    _user = null;
    notifyListeners();
  }
}

// Setup
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthModel()),
  ],
  child: MyApp(),
)

// Usage
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return CircularProgressIndicator();
        }
        
        return ElevatedButton(
          onPressed: () async {
            try {
              await auth.login(email, password);
              Navigator.pushReplacement(context, HomeScreen());
            } catch (e) {
              showError(e.toString());
            }
          },
          child: Text('Login'),
        );
      },
    );
  }
}
```

---

### Example 2: Shopping Cart

```dart
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0.0, (sum, item) => 
      sum + (item.product.price * item.quantity));
  
  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => 
        item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }
  
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => 
        item.product.id == productId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }
  
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Product screen
class ProductCard extends StatelessWidget {
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl),
          Text(product.name),
          Text('\$${product.price}'),
          ElevatedButton(
            onPressed: () {
              context.read<CartModel>().addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to cart')),
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}

// Cart screen
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Badge(
                label: Text('${cart.itemCount}'),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(child: Text('Cart is empty'));
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      leading: Image.network(item.product.imageUrl),
                      title: Text(item.product.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.product.price * item.quantity}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total: \$${cart.totalPrice}'),
                    ElevatedButton(
                      onPressed: () => _checkout(context),
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

## 🧪 Testing with Provider

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('CartModel', () {
    test('starts empty', () {
      final cart = CartModel();
      expect(cart.items, isEmpty);
      expect(cart.itemCount, equals(0));
    });
    
    test('adds item', () {
      final cart = CartModel();
      final product = Product(id: '1', name: 'Test', price: 10);
      
      cart.addItem(product);
      
      expect(cart.itemCount, equals(1));
      expect(cart.items.first.product, equals(product));
    });
  });
  
  testWidgets('CartScreen shows items', (tester) async {
    final cart = CartModel();
    cart.addItem(Product(id: '1', name: 'Test', price: 10));
    
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: MaterialApp(home: CartScreen()),
      ),
    );
    
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('\$10'), findsOneWidget);
  });
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Using watch in Callbacks

```dart
// ❌ Wrong - watch in callback
ElevatedButton(
  onPressed: () {
    context.watch<Counter>().increment(); // Error!
  },
  child: Text('Increment'),
)

// ✅ Correct - use read
ElevatedButton(
  onPressed: () {
    context.read<Counter>().increment();
  },
  child: Text('Increment'),
)
```

---

### Pitfall 2: Forgetting notifyListeners

```dart
// ❌ Bad - No notification
class Counter extends ChangeNotifier {
  int _count = 0;
  
  void increment() {
    _count++; // Changed but not notified!
  }
}

// ✅ Good
class Counter extends ChangeNotifier {
  int _count = 0;
  
  void increment() {
    _count++;
    notifyListeners(); // ✅ Notify
  }
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - ChangeNotifierProvider للـ mutable state
  - context.watch في build method
  - context.read في callbacks
  - Selector للـ performance
  - notifyListeners() بعد state changes
  - MultiProvider للـ multiple providers
  - ProxyProvider للـ dependencies

suggest:
  - استخدام Selector بدلاً من Consumer
  - provide at right level
  - extract widgets to reduce rebuilds
  - use const where possible

enforce:
  - لا context.watch في callbacks
  - notifyListeners() required
  - dispose() للـ resources
  - testing للـ models
```

---

## 📊 Summary Checklist

```markdown
- [ ] ChangeNotifierProvider setup
- [ ] context.watch/read/select used correctly
- [ ] Selector للـ performance
- [ ] notifyListeners() called
- [ ] MultiProvider للـ multiple providers
- [ ] ProxyProvider للـ dependencies
- [ ] Tests للـ models
```

---

## 🔗 Related Rules

- [State Management Comparison](./comparison.md)
- [Built-in Solutions](./built-in.md)
- [Riverpod](./riverpod.md) - Modern alternative

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Best For:** 5-50 Screens  
**Officially Recommended:** ✅  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

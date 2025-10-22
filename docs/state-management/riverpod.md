# Riverpod State Management

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: State Management
applies_to:
  - all_projects
  - modern_flutter
type_safe: true
ai_agent_tags:
  - state-management
  - riverpod
  - type-safety
  - no-context
  - modern
```

---

## 🎯 Overview

**Riverpod** هو نسخة محسّنة من Provider مع type safety أقوى ولا يحتاج `BuildContext`. مناسب لجميع أحجام المشاريع.

### Why Riverpod?
- ✅ Compile-time safety
- 🚫 No BuildContext needed
- 🧪 سهل الاختبار جداً
- 🔄 Auto-dispose
- 📦 Better DI

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للمشاريع الجديدة

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  flutter_riverpod: ^3.0.3  # ✅ Updated to latest (Major update!)
  
dev_dependencies:
  riverpod_generator: ^3.0.3  # ✅ Updated to match
  build_runner: ^2.4.14  # ✅ Updated to latest
```

> ⚠️ **Breaking Change:** Riverpod 3.x is a major rewrite.
> - `StateProvider` and `StateNotifierProvider` moved to `package:flutter_riverpod/legacy.dart`
> - New API with better type safety
> - Migration guide: https://riverpod.dev/docs/migration

#### Wrap App
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(  // Required!
      child: MyApp(),
    ),
  );
}
```

---

### 2. Provider Types

#### Provider - Immutable Data
```dart
// Simple value
final nameProvider = Provider<String>((ref) => 'Ahmed');

// Service instance
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Usage
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);
    return Text(name);
  }
}
```

#### StateProvider - Simple Mutable State
```dart
final counterProvider = StateProvider<int>((ref) => 0);

// Usage
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

#### StateNotifierProvider - Complex State
```dart
// State class
@immutable
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  
  const TodoState({
    this.todos = const [],
    this.isLoading = false,
  });
  
  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// StateNotifier
class TodoNotifier extends StateNotifier<TodoState> {
  final TodoRepository repository;
  
  TodoNotifier(this.repository) : super(const TodoState());
  
  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final todos = await repository.getTodos();
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
  
  void addTodo(Todo todo) {
    state = state.copyWith(
      todos: [...state.todos, todo],
    );
  }
  
  void removeTodo(String id) {
    state = state.copyWith(
      todos: state.todos.where((t) => t.id != id).toList(),
    );
  }
}

// Provider
final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoNotifier(repository);
});

// Usage
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoProvider);
    
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        final todo = state.todos[index];
        return ListTile(
          title: Text(todo.title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(todo.id);
            },
          ),
        );
      },
    );
  }
}
```

#### FutureProvider - Async Data
```dart
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.watch(apiClientProvider);
  return await api.getUser();
});

// Usage
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) => Text('Hello ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

#### StreamProvider - Continuous Data
```dart
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.messagesStream();
});

// Usage
class MessagesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);
    
    return messagesAsync.when(
      data: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => Text(messages[index].text),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

---

### 3. ConsumerWidget vs Consumer

```dart
// Option 1: ConsumerWidget - Entire widget rebuilds
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}

// Option 2: Consumer - Only part rebuilds
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Static'),  // Won't rebuild
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('$count');  // Only this rebuilds
          },
        ),
      ],
    );
  }
}

// Option 3: ConsumerStatefulWidget - For stateful widgets
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

---

### 4. ref.watch vs ref.read vs ref.listen

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch - Rebuilds when value changes
    final count = ref.watch(counterProvider);
    
    // read - No rebuild, for callbacks
    return ElevatedButton(
      onPressed: () {
        ref.read(counterProvider.notifier).state++;
      },
      child: Text('$count'),
    );
    
    // listen - For side effects
    ref.listen<int>(counterProvider, (previous, next) {
      if (next == 10) {
        showDialog(context: context, builder: (_) => Text('Reached 10!'));
      }
    });
    
    return Container();
  }
}
```

---

### 5. Provider Dependencies

```dart
// Provider depends on another
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final api = ref.watch(apiClientProvider);  // Dependency
  return UserRepository(api);
});

final currentUserProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getCurrentUser();
});
```

---

### 6. Family - Parameterized Providers

```dart
// Provider with parameter
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final api = ref.watch(apiClientProvider);
  return await api.getUser(userId);
});

// Usage
class UserScreen extends ConsumerWidget {
  final String userId;
  
  const UserScreen(this.userId);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));
    
    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error'),
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Auto-Dispose by Default

```dart
// ✅ Auto-dispose (default for most)
final counterProvider = StateProvider.autoDispose<int>((ref) => 0);
// Disposed when no longer used

// Keep alive if needed
final cacheProvider = StateProvider<Map<String, dynamic>>((ref) {
  // Won't auto-dispose
  return {};
});
```

---

### Rule 2: Select Specific Fields

```dart
// ❌ Bad - Rebuilds for any change
final name = ref.watch(userProvider).name;

// ✅ Good - Rebuilds only when name changes
final name = ref.watch(
  userProvider.select((user) => user.name),
);
```

---

### Rule 3: Computed Values

```dart
final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(...);

// Computed provider
final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  return todos.where((todo) => todo.completed).toList();
});

final completedCountProvider = Provider<int>((ref) {
  final completed = ref.watch(completedTodosProvider);
  return completed.length;
});
```

---

## 🎯 Real-World Example: Shopping Cart

```dart
// Models
@immutable
class CartItem {
  final Product product;
  final int quantity;
  
  const CartItem({
    required this.product,
    required this.quantity,
  });
  
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// State
@immutable
class CartState {
  final List<CartItem> items;
  
  const CartState({this.items = const []});
  
  int get itemCount => items.length;
  double get totalPrice => items.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
  
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

// Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());
  
  void addItem(Product product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    
    if (existingIndex >= 0) {
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
    }
  }
  
  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }
  
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    
    state = state.copyWith(items: updatedItems);
  }
  
  void clear() {
    state = const CartState();
  }
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Computed providers
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalPrice;
});

// UI - Product Card
class ProductCard extends ConsumerWidget {
  final Product product;
  
  const ProductCard(this.product);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl),
          Text(product.name),
          Text('\$${product.price}'),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(product);
              
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

// UI - Cart Screen
class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final itemCount = ref.watch(cartItemCountProvider);
    final total = ref.watch(cartTotalProvider);
    
    if (cartState.items.isEmpty) {
      return Center(child: Text('Cart is empty'));
    }
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return ListTile(
                leading: Image.network(item.product.imageUrl),
                title: Text(item.product.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                          item.product.id,
                          item.quantity - 1,
                        );
                      },
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                          item.product.id,
                          item.quantity + 1,
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        ref.read(cartProvider.notifier).removeItem(
                          item.product.id,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Total: \$${total.toStringAsFixed(2)}'),
              ElevatedButton(
                onPressed: () => _checkout(context, ref),
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _checkout(BuildContext context, WidgetRef ref) {
    // Process checkout
    ref.read(cartProvider.notifier).clear();
    Navigator.pop(context);
  }
}
```

---

## 🧪 Testing with Riverpod

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('counter starts at 0', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    
    expect(container.read(counterProvider), equals(0));
  });
  
  test('can increment counter', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    
    container.read(counterProvider.notifier).state++;
    
    expect(container.read(counterProvider), equals(1));
  });
  
  test('cart adds items', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    
    final product = Product(id: '1', name: 'Test', price: 10);
    container.read(cartProvider.notifier).addItem(product);
    
    final cart = container.read(cartProvider);
    expect(cart.itemCount, equals(1));
    expect(cart.totalPrice, equals(10));
  });
  
  // Override providers for testing
  test('with mock', () {
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(MockApiClient()),
      ],
    );
    addTearDown(container.dispose);
    
    // Test with mock
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - ProviderScope wrapping app
  - ConsumerWidget usage
  - ref.watch in build
  - ref.read in callbacks
  - autoDispose where appropriate
  - select for specific fields
  - immutable state classes
  - proper provider types

suggest:
  - use ConsumerWidget
  - add autoDispose
  - use select for optimization
  - extract computed providers
  - use family for parameters

enforce:
  - ProviderScope required
  - immutable states
  - no ref.watch in callbacks
  - proper provider disposal
```

---

## 📊 Summary Checklist

```markdown
- [ ] ProviderScope wrapping app
- [ ] ConsumerWidget/Consumer
- [ ] ref.watch/read/listen correctly
- [ ] autoDispose enabled
- [ ] select for optimization
- [ ] immutable states
- [ ] computed providers
- [ ] tests with ProviderContainer
```

---

## 🔗 Related Rules

- [State Management Comparison](./comparison.md)
- [Provider](./provider.md) - Predecessor
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Best For:** All Projects (especially new ones)  
**Type Safe:** ✅  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

# ⚖️ Value Equality with Equatable

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Core
applies_to:
  - all_projects
  - state_management
recommended_package: equatable
ai_agent_tags:
  - equality
  - comparison
  - equatable
  - value-objects
  - immutability
```

---

## 🎯 Overview

**Equatable** يبسّط مقارنة Objects في Dart. ضروري للـ State Management والـ Immutable Models.

### Why Equatable?
- ✅ **Less boilerplate** - لا حاجة لكتابة `==` و `hashCode`
- 🎯 **Correct equality** - مقارنة صحيحة للقيم
- 🔄 **Works everywhere** - Riverpod, Bloc, Redux
- 📝 **Easy debugging** - `stringify` للطباعة
- ⚡ **Performance** - Optimized implementation

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` لجميع المشاريع

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  equatable: ^2.0.7  # ✅ Latest (2025-10-22)
```

---

### 2. The Problem (Without Equatable)

```dart
class User {
  final String id;
  final String name;
  
  User({required this.id, required this.name});
}

void main() {
  final user1 = User(id: '1', name: 'Ahmed');
  final user2 = User(id: '1', name: 'Ahmed');
  
  print(user1 == user2);  // ❌ false (different instances!)
  
  // Lists won't work correctly
  final users = [user1];
  print(users.contains(user2));  // ❌ false
  
  // Sets won't work correctly
  final userSet = {user1, user2};
  print(userSet.length);  // ❌ 2 (should be 1!)
}
```

---

### 3. Manual Solution (Tedious!)

```dart
class User {
  final String id;
  final String name;
  
  User({required this.id, required this.name});
  
  // Manual equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;
  
  // Manual hashCode
  @override
  int get hashCode => Object.hash(id, name);
  
  // Manual toString
  @override
  String toString() => 'User(id: $id, name: $name)';
}

// ❌ Problems:
// - Lots of boilerplate
// - Error-prone (easy to forget fields)
// - Maintenance nightmare
```

---

### 4. Equatable Solution (Clean!)

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];  // ✅ That's it!
}

void main() {
  const user1 = User(id: '1', name: 'Ahmed');
  const user2 = User(id: '1', name: 'Ahmed');
  
  print(user1 == user2);  // ✅ true
  
  final users = [user1];
  print(users.contains(user2));  // ✅ true
  
  final userSet = {user1, user2};
  print(userSet.length);  // ✅ 1 (correct!)
}
```

---

### 5. Basic Usage

```dart
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
  
  @override
  List<Object?> get props => [id, name, price];
}

// Usage
const product1 = Product(id: '1', name: 'iPhone', price: 999);
const product2 = Product(id: '1', name: 'iPhone', price: 999);

print(product1 == product2);  // ✅ true
print(product1.hashCode == product2.hashCode);  // ✅ true
```

---

### 6. Nullable Properties

```dart
class User extends Equatable {
  final String id;
  final String name;
  final String? email;  // Nullable
  final int? age;       // Nullable
  
  const User({
    required this.id,
    required this.name,
    this.email,
    this.age,
  });
  
  @override
  List<Object?> get props => [id, name, email, age];  // ✅ Include nullables
}

// Works correctly with nulls
const user1 = User(id: '1', name: 'Ahmed');
const user2 = User(id: '1', name: 'Ahmed', email: null);

print(user1 == user2);  // ✅ true (both null)
```

---

### 7. Nested Objects

```dart
class Address extends Equatable {
  final String street;
  final String city;
  
  const Address({required this.street, required this.city});
  
  @override
  List<Object?> get props => [street, city];
}

class User extends Equatable {
  final String id;
  final String name;
  final Address address;  // Nested Equatable
  
  const User({
    required this.id,
    required this.name,
    required this.address,
  });
  
  @override
  List<Object?> get props => [id, name, address];
}

// Usage
const user1 = User(
  id: '1',
  name: 'Ahmed',
  address: Address(street: 'Main St', city: 'Cairo'),
);

const user2 = User(
  id: '1',
  name: 'Ahmed',
  address: Address(street: 'Main St', city: 'Cairo'),
);

print(user1 == user2);  // ✅ true (deep equality!)
```

---

### 8. Lists & Collections

```dart
class Cart extends Equatable {
  final String userId;
  final List<Product> items;
  
  const Cart({required this.userId, required this.items});
  
  @override
  List<Object?> get props => [userId, items];
}

// Usage
const cart1 = Cart(
  userId: '1',
  items: [
    Product(id: '1', name: 'iPhone', price: 999),
    Product(id: '2', name: 'iPad', price: 799),
  ],
);

const cart2 = Cart(
  userId: '1',
  items: [
    Product(id: '1', name: 'iPhone', price: 999),
    Product(id: '2', name: 'iPad', price: 799),
  ],
);

print(cart1 == cart2);  // ✅ true (compares list contents!)
```

---

### 9. Stringify (for Debugging)

```dart
class User extends Equatable {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
  
  // Enable stringify
  @override
  bool get stringify => true;
}

// Usage
const user = User(id: '1', name: 'Ahmed');
print(user);  // ✅ User(1, Ahmed)

// Without stringify:
// Instance of 'User'
```

---

### 10. EquatableMixin (for existing classes)

```dart
// When you can't extend Equatable (e.g., already extending another class)
class User with EquatableMixin {
  final String id;
  final String name;
  
  User({required this.id, required this.name});
  
  @override
  List<Object?> get props => [id, name];
}

// Works the same!
```

---

### 11. Custom Equality Logic

```dart
class User extends Equatable {
  final String id;
  final String name;
  final DateTime lastLogin;
  
  const User({
    required this.id,
    required this.name,
    required this.lastLogin,
  });
  
  // Only compare id and name, ignore lastLogin
  @override
  List<Object?> get props => [id, name];
}

// Usage
final user1 = User(
  id: '1',
  name: 'Ahmed',
  lastLogin: DateTime(2025, 1, 1),
);

final user2 = User(
  id: '1',
  name: 'Ahmed',
  lastLogin: DateTime(2025, 1, 2),  // Different!
);

print(user1 == user2);  // ✅ true (lastLogin ignored)
```

---

### 12. With Riverpod

```dart
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

// State class
class CounterState extends Equatable {
  final int count;
  final bool isLoading;
  
  const CounterState({
    required this.count,
    required this.isLoading,
  });
  
  @override
  List<Object?> get props => [count, isLoading];
  
  CounterState copyWith({int? count, bool? isLoading}) {
    return CounterState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Provider
final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>(
  (ref) => CounterNotifier(),
);

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(const CounterState(count: 0, isLoading: false));
  
  void increment() {
    state = state.copyWith(count: state.count + 1);
  }
}

// Widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterProvider);
    
    // Only rebuilds when state actually changes!
    // Equatable ensures correct comparison
    return Text('Count: ${state.count}');
  }
}
```

---

## 🎯 Real-World Example: E-commerce App

```dart
import 'package:equatable/equatable.dart';

// Product
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });
  
  @override
  List<Object?> get props => [id, name, price, imageUrl];
  
  @override
  bool get stringify => true;
}

// Cart Item
class CartItem extends Equatable {
  final Product product;
  final int quantity;
  
  const CartItem({
    required this.product,
    required this.quantity,
  });
  
  double get total => product.price * quantity;
  
  @override
  List<Object?> get props => [product, quantity];
  
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

// Cart State
class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;
  
  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });
  
  double get totalPrice => items.fold(0, (sum, item) => sum + item.total);
  
  int get itemCount => items.length;
  
  @override
  List<Object?> get props => [items, isLoading, error];
  
  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());
  
  void addItem(Product product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product == product,  // ✅ Uses Equatable!
    );
    
    if (existingIndex >= 0) {
      // Increase quantity
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
    }
  }
  
  void removeItem(Product product) {
    state = state.copyWith(
      items: state.items.where((item) => item.product != product).toList(),
    );
  }
  
  void clear() {
    state = const CartState();
  }
}

// Usage in UI
class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.itemCount})'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return ListTile(
            title: Text(item.product.name),
            subtitle: Text('Quantity: ${item.quantity}'),
            trailing: Text('\$${item.total.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ Use Equatable for all models
✅ Include all relevant fields in props
✅ Use const constructors when possible
✅ Enable stringify for debugging
✅ Use with State Management
✅ Include nested Equatable objects
```

### **❌ تجنب:**
```dart
❌ Forget fields in props
❌ Include computed properties in props
❌ Compare objects without Equatable
❌ Use mutable fields
❌ Forget nullable fields
```

---

## ⚖️ Equatable vs Manual Equality

| Feature | Manual | Equatable |
|---------|--------|-----------|
| **Boilerplate** | 🔴 High | ✅ **Low** |
| **Error-Prone** | ⚠️ Yes | ✅ **No** |
| **Maintenance** | 🔴 Hard | ✅ **Easy** |
| **Performance** | ✅ Good | ✅ **Optimized** |
| **Deep Equality** | ❌ Manual | ✅ **Automatic** |
| **Debugging** | ❌ No toString | ✅ **Stringify** |

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - Equatable on models
  - props implementation
  - all fields included
  - const constructors
  - nested Equatable objects

suggest:
  - add Equatable to models
  - include all fields in props
  - enable stringify
  - use const constructors
  - implement copyWith

enforce:
  - props includes all fields
  - no mutable fields
  - const when possible
```

---

## 📚 Related Files

- [Immutability](./immutability.md) - Immutable patterns
- [State Management](../state-management/comparison.md)
- [JSON Serialization](../data/json-serialization.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**For:** All Projects  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

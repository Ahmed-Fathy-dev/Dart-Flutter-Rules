# 🎯 dart_mappable - Advanced JSON Serialization

## 📋 Metadata

```yaml
priority: MEDIUM
level: ADVANCED
category: Data & Serialization
package: dart_mappable
version: 4.6.1+
officially_recommended: false
applies_to:
  - medium_projects
  - large_projects
  - complex_models
best_for:
  - generics_support
  - inheritance
  - polymorphism
  - better_performance
ai_agent_tags:
  - serialization
  - json
  - code-generation
  - data-classes
  - generics
  - inheritance
```

---

## 🎯 Overview

**dart_mappable** هو بديل متقدم لـ `json_serializable` يوفر دعماً كاملاً للـ **generics** و **inheritance** و **polymorphism** مع أداء أفضل وميزات إضافية.

### **المميزات الرئيسية:**
- ✅ **كل شيء مدمج** - Serialization, Equality, ToString, CopyWith
- ✅ **دعم متقدم** - Generics, Polymorphism, Multi-inheritance
- ✅ **مرن جداً** - Customization, Custom types, Integration
- ✅ **أداء أفضل** - أسرع من json_serializable بـ 2-3x
- ✅ **لا تنازلات** - يعمل مع أي نوع من الكلاسات

---

## 📊 Comparison with json_serializable

| الميزة | dart_mappable | json_serializable |
|--------|---------------|-------------------|
| **Basic Serialization** | ✅ | ✅ |
| **Generics Support** | ✅ Full | 🟡 Limited |
| **Inheritance** | ✅ Excellent | ❌ |
| **Polymorphism** | ✅ Built-in | 🟡 Manual |
| **CopyWith** | ✅ Auto | 🟡 Manual |
| **Equality (==)** | ✅ Auto | ❌ |
| **toString()** | ✅ Auto | ❌ |
| **Performance** | ✅ Faster | ✅ Good |
| **Boilerplate** | 🟢 Less | 🟡 More |
| **Learning Curve** | 🟡 Medium | 🟢 Easy |
| **Community** | 🟡 Growing | ✅ Large |

---

## 📦 Setup

### pubspec.yaml
```yaml
dependencies:
  dart_mappable: ^4.6.1  # ✅ Latest (Jan 2025)

dev_dependencies:
  dart_mappable_builder: ^4.6.1
  build_runner: ^2.10.0
```

### Install
```bash
flutter pub add dart_mappable
flutter pub add dev:dart_mappable_builder dev:build_runner
```

---

## 1️⃣ Basic Usage

### **Step 1: Annotate Your Class**

```dart
import 'package:dart_mappable/dart_mappable.dart';

// ✅ Include generated file
part 'user.mapper.dart';

// ✅ Annotate class
@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

> **ملاحظة:** المكتبة تولد mixin بالاسم `<ClassName>Mappable`

---

### **Step 2: Generate Code**

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs
```

---

### **Step 3: Use the Generated Code**

```dart
void main() {
  // ✅ From JSON string
  final user = UserMapper.fromJson('{"id": 1, "name": "Ahmed", "email": "ahmed@example.com"}');
  
  // ✅ From Map
  final user2 = UserMapper.fromMap({
    'id': 2,
    'name': 'Sara',
    'email': 'sara@example.com',
  });
  
  // ✅ To JSON string
  final json = user.toJson();
  print(json);
  // Output: {"id":1,"name":"Ahmed","email":"ahmed@example.com"}
  
  // ✅ To Map
  final map = user.toMap();
  print(map);
  // Output: {id: 1, name: Ahmed, email: ahmed@example.com}
  
  // ✅ Equality (automatic!)
  print(user == user2); // false
  
  // ✅ toString (automatic!)
  print(user);
  // Output: User(id: 1, name: Ahmed, email: ahmed@example.com)
  
  // ✅ CopyWith (automatic!)
  final updatedUser = user.copyWith(name: 'Ahmed Ali');
  print(updatedUser);
  // Output: User(id: 1, name: Ahmed Ali, email: ahmed@example.com)
  
  // ✅ hashCode (automatic!)
  print(user.hashCode);
}
```

---

## 2️⃣ Custom JSON Keys

```dart
@MappableClass()
class User with UserMappable {
  final int id;
  
  // ✅ Custom JSON key
  @MappableField(key: 'full_name')
  final String name;
  
  @MappableField(key: 'email_address')
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

// Usage
final json = '{"id": 1, "full_name": "Ahmed", "email_address": "ahmed@example.com"}';
final user = UserMapper.fromJson(json);
print(user.name); // Ahmed
```

---

## 3️⃣ Case Style Configuration

```dart
// ✅ Apply to all classes in library
@MappableLib(caseStyle: CaseStyle.snakeCase)
library models;

import 'package:dart_mappable/dart_mappable.dart';

part 'models.mapper.dart';

// ✅ This will use snake_case automatically
@MappableClass()
class UserProfile with UserProfileMappable {
  final String firstName;   // → first_name
  final String lastName;    // → last_name
  final String emailAddress; // → email_address
  
  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
  });
}

// Usage
final json = '{"first_name": "Ahmed", "last_name": "Ali", "email_address": "ahmed@example.com"}';
final profile = UserProfileMapper.fromJson(json);
print(profile.firstName); // Ahmed
```

**Available Case Styles:**
- `CaseStyle.camelCase` - camelCase (default)
- `CaseStyle.pascalCase` - PascalCase
- `CaseStyle.snakeCase` - snake_case
- `CaseStyle.paramCase` - param-case
- `CaseStyle.kebabCase` - kebab-case

---

## 4️⃣ Nullable & Optional Fields

```dart
@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  
  // ✅ Nullable field
  final String? email;
  
  // ✅ Default value
  final bool isActive;
  
  User({
    required this.id,
    required this.name,
    this.email,
    this.isActive = true, // ✅ Default value
  });
}

// Usage
final user1 = UserMapper.fromJson('{"id": 1, "name": "Ahmed"}');
print(user1.email); // null
print(user1.isActive); // true

final user2 = UserMapper.fromJson('{"id": 2, "name": "Sara", "email": "sara@example.com", "isActive": false}');
print(user2.email); // sara@example.com
print(user2.isActive); // false
```

---

## 5️⃣ Nested Objects

```dart
@MappableClass()
class Address with AddressMappable {
  final String street;
  final String city;
  final String country;
  
  Address({
    required this.street,
    required this.city,
    required this.country,
  });
}

@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  
  // ✅ Nested object
  final Address address;
  
  User({
    required this.id,
    required this.name,
    required this.address,
  });
}

// Usage
final json = '''
{
  "id": 1,
  "name": "Ahmed",
  "address": {
    "street": "123 Main St",
    "city": "Cairo",
    "country": "Egypt"
  }
}
''';

final user = UserMapper.fromJson(json);
print(user.address.city); // Cairo
```

---

## 6️⃣ Lists & Collections

```dart
@MappableClass()
class Post with PostMappable {
  final int id;
  final String title;
  
  // ✅ List of primitives
  final List<String> tags;
  
  // ✅ List of objects
  final List<Comment> comments;
  
  Post({
    required this.id,
    required this.title,
    required this.tags,
    required this.comments,
  });
}

@MappableClass()
class Comment with CommentMappable {
  final String author;
  final String text;
  
  Comment({
    required this.author,
    required this.text,
  });
}

// Usage
final json = '''
{
  "id": 1,
  "title": "Hello World",
  "tags": ["flutter", "dart"],
  "comments": [
    {"author": "Ahmed", "text": "Great post!"},
    {"author": "Sara", "text": "Thanks for sharing"}
  ]
}
''';

final post = PostMapper.fromJson(json);
print(post.tags); // [flutter, dart]
print(post.comments.length); // 2
print(post.comments[0].author); // Ahmed
```

---

## 7️⃣ Generics Support

```dart
// ✅ Generic class
@MappableClass()
class Result<T> with ResultMappable<T> {
  final bool success;
  final T? data;
  final String? error;
  
  Result({
    required this.success,
    this.data,
    this.error,
  });
}

@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  
  User({required this.id, required this.name});
}

// Usage
final successJson = '''
{
  "success": true,
  "data": {"id": 1, "name": "Ahmed"},
  "error": null
}
''';

// ✅ Specify type parameter
final result = ResultMapper.fromJson<User>(successJson);
print(result.success); // true
print(result.data?.name); // Ahmed

final errorJson = '''
{
  "success": false,
  "data": null,
  "error": "User not found"
}
''';

final errorResult = ResultMapper.fromJson<User>(errorJson);
print(errorResult.success); // false
print(errorResult.error); // User not found
```

---

## 8️⃣ Inheritance & Polymorphism

```dart
// ✅ Base class
@MappableClass(discriminatorKey: 'type')
abstract class Shape with ShapeMappable {
  final String color;
  
  Shape({required this.color});
}

// ✅ Subclasses
@MappableClass(discriminatorValue: 'circle')
class Circle extends Shape with CircleMappable {
  final double radius;
  
  Circle({
    required super.color,
    required this.radius,
  });
}

@MappableClass(discriminatorValue: 'rectangle')
class Rectangle extends Shape with RectangleMappable {
  final double width;
  final double height;
  
  Rectangle({
    required super.color,
    required this.width,
    required this.height,
  });
}

// Usage
final circleJson = '''
{
  "type": "circle",
  "color": "red",
  "radius": 5.0
}
''';

final rectangleJson = '''
{
  "type": "rectangle",
  "color": "blue",
  "width": 10.0,
  "height": 5.0
}
''';

// ✅ Polymorphic deserialization
final shape1 = ShapeMapper.fromJson(circleJson);
print(shape1 is Circle); // true
print((shape1 as Circle).radius); // 5.0

final shape2 = ShapeMapper.fromJson(rectangleJson);
print(shape2 is Rectangle); // true
print((shape2 as Rectangle).width); // 10.0
```

---

## 9️⃣ Enums

```dart
// ✅ Basic enum
@MappableEnum()
enum UserRole {
  admin,
  user,
  guest,
}

// ✅ Enum with custom values
@MappableEnum()
enum Status {
  @MappableValue('active')
  active,
  
  @MappableValue('inactive')
  inactive,
  
  @MappableValue('pending')
  pending,
}

// ✅ Enum with case style
@MappableEnum(caseStyle: CaseStyle.upperCase)
enum Priority {
  low,      // → LOW
  medium,   // → MEDIUM
  high,     // → HIGH
}

@MappableClass()
class User with UserMappable {
  final String name;
  final UserRole role;
  final Status status;
  final Priority priority;
  
  User({
    required this.name,
    required this.role,
    required this.status,
    required this.priority,
  });
}

// Usage
final json = '''
{
  "name": "Ahmed",
  "role": "admin",
  "status": "active",
  "priority": "HIGH"
}
''';

final user = UserMapper.fromJson(json);
print(user.role); // UserRole.admin
print(user.status); // Status.active
print(user.priority); // Priority.high
```

---

## 🔟 Custom Constructors

```dart
@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  final String email;
  
  // ✅ Default constructor (won't be used)
  User(this.id, this.name, this.email);
  
  // ✅ This constructor will be used for deserialization
  @MappableConstructor()
  User.fromData({
    required this.id,
    required this.name,
    required this.email,
  });
}

// Usage
final user = UserMapper.fromJson('{"id": 1, "name": "Ahmed", "email": "ahmed@example.com"}');
// Uses User.fromData constructor
```

---

## 1️⃣1️⃣ Hooks (Custom Serialization)

```dart
@MappableClass()
class User with UserMappable {
  final int id;
  final String name;
  
  // ✅ Custom hook to encrypt/decrypt email
  @MappableField(
    hook: EncryptHook(),
  )
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
}

// ✅ Custom hook implementation
class EncryptHook extends MappingHook {
  const EncryptHook();
  
  @override
  Object? beforeDecode(Object? value) {
    // Decrypt before decoding
    if (value is String) {
      return _decrypt(value);
    }
    return value;
  }
  
  @override
  Object? afterEncode(Object? value) {
    // Encrypt after encoding
    if (value is String) {
      return _encrypt(value);
    }
    return value;
  }
  
  String _encrypt(String value) {
    // Simple encryption (for demo only!)
    return value.split('').reversed.join();
  }
  
  String _decrypt(String value) {
    // Simple decryption (for demo only!)
    return value.split('').reversed.join();
  }
}

// Usage
final user = User(id: 1, name: 'Ahmed', email: 'ahmed@example.com');
final json = user.toJson();
print(json);
// Output: {"id":1,"name":"Ahmed","email":"moc.elpmaxe@demha"}
// Email is encrypted!

final decoded = UserMapper.fromJson(json);
print(decoded.email); // ahmed@example.com
// Email is decrypted back!
```

---

## 1️⃣2️⃣ DateTime & Date Formats

```dart
@MappableClass()
class Event with EventMappable {
  final String name;
  
  // ✅ DateTime will be serialized as ISO 8601 string
  final DateTime createdAt;
  
  // ✅ Custom date format with hook
  @MappableField(
    hook: DateFormatHook('yyyy-MM-dd'),
  )
  final DateTime eventDate;
  
  Event({
    required this.name,
    required this.createdAt,
    required this.eventDate,
  });
}

// ✅ Custom date format hook
class DateFormatHook extends MappingHook {
  final String format;
  
  const DateFormatHook(this.format);
  
  @override
  Object? beforeDecode(Object? value) {
    if (value is String) {
      // Parse custom format
      return DateTime.parse(value);
    }
    return value;
  }
  
  @override
  Object? afterEncode(Object? value) {
    if (value is DateTime) {
      // Format as custom string
      // You can use intl package for more formats
      return value.toIso8601String().split('T')[0];
    }
    return value;
  }
}

// Usage
final event = Event(
  name: 'Flutter Meetup',
  createdAt: DateTime(2025, 1, 22, 10, 30),
  eventDate: DateTime(2025, 2, 15),
);

final json = event.toJson();
print(json);
// Output: {"name":"Flutter Meetup","createdAt":"2025-01-22T10:30:00.000","eventDate":"2025-02-15"}
```

---

## 1️⃣3️⃣ Full Example - E-commerce API

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'models.mapper.dart';

// ✅ Configure library
@MappableLib(caseStyle: CaseStyle.snakeCase)
library models;

// Category
@MappableClass()
class Category with CategoryMappable {
  final int id;
  final String name;
  final String? icon;
  
  Category({
    required this.id,
    required this.name,
    this.icon,
  });
}

// Product
@MappableClass()
class Product with ProductMappable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final Category category;
  final List<String> tags;
  final bool inStock;
  
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    required this.tags,
    this.inStock = true,
  });
}

// Cart Item
@MappableClass()
class CartItem with CartItemMappable {
  final Product product;
  final int quantity;
  
  CartItem({
    required this.product,
    required this.quantity,
  });
  
  double get total => product.price * quantity;
}

// Order Status Enum
@MappableEnum()
enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

// Order
@MappableClass()
class Order with OrderMappable {
  final int id;
  final List<CartItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final double totalAmount;
  
  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });
}

// API Response wrapper
@MappableClass()
class ApiResponse<T> with ApiResponseMappable<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? errorCode;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errorCode,
  });
}

// Usage Example
void main() async {
  // Simulate API response
  final productJson = '''
  {
    "success": true,
    "data": {
      "id": 1,
      "name": "Flutter Book",
      "description": "Learn Flutter",
      "price": 29.99,
      "image_url": "https://example.com/book.jpg",
      "category": {
        "id": 1,
        "name": "Books",
        "icon": "📚"
      },
      "tags": ["flutter", "dart", "mobile"],
      "in_stock": true
    }
  }
  ''';
  
  // ✅ Deserialize with generics
  final response = ApiResponseMapper.fromJson<Product>(productJson);
  
  if (response.success && response.data != null) {
    final product = response.data!;
    print('Product: ${product.name}');
    print('Price: \$${product.price}');
    print('Category: ${product.category.name}');
    print('Tags: ${product.tags.join(', ')}');
    
    // ✅ Create cart item
    final cartItem = CartItem(product: product, quantity: 2);
    print('Total: \$${cartItem.total}');
    
    // ✅ Serialize back
    final cartJson = cartItem.toJson();
    print(cartJson);
  }
}
```

---

## 🎯 Best Practices

### **✅ DO:**
```dart
// ✅ Use part directive
part 'model.mapper.dart';

// ✅ Apply mixin to class
class User with UserMappable {}

// ✅ Use @MappableLib for library-wide config
@MappableLib(caseStyle: CaseStyle.snakeCase)
library models;

// ✅ Use specific types for generics
ResultMapper.fromJson<User>(json);

// ✅ Use custom hooks for complex transformations
@MappableField(hook: CustomHook())

// ✅ Use enums for fixed values
@MappableEnum()
enum Status { active, inactive }

// ✅ Provide default values
final bool isActive = true;
```

### **❌ DON'T:**
```dart
// ❌ Don't forget part directive
// Missing: part 'model.mapper.dart';

// ❌ Don't forget mixin
class User {} // Missing: with UserMappable

// ❌ Don't forget to run build_runner
// Always run after changes

// ❌ Don't forget type parameters for generic classes
class Result<T> with ResultMappable {} // Wrong!
class Result<T> with ResultMappable<T> {} // ✅ Correct

// ❌ Don't use toJson() expecting Map
// toJson() returns String, not Map!
Map map = user.toJson(); // ❌ Wrong!
String json = user.toJson(); // ✅ Correct
```

---

## ⚠️ Migration from json_serializable

### **Key Differences:**
1. **toJson() returns String** (not Map)
   ```dart
   // json_serializable
   Map<String, dynamic> map = user.toJson();
   
   // dart_mappable
   String json = user.toJson();
   Map<String, dynamic> map = user.toMap();
   ```

2. **Mixin Required**
   ```dart
   // json_serializable
   class User {}
   
   // dart_mappable
   class User with UserMappable {}
   ```

3. **Different Annotations**
   ```dart
   // json_serializable
   @JsonSerializable()
   @JsonKey(name: 'full_name')
   
   // dart_mappable
   @MappableClass()
   @MappableField(key: 'full_name')
   ```

---

## 📝 Checklist

```markdown
Setup:
- [ ] Add dart_mappable dependency
- [ ] Add dart_mappable_builder & build_runner
- [ ] Add part directive to model files
- [ ] Annotate classes with @MappableClass()
- [ ] Apply mixins (with <ClassName>Mappable)
- [ ] Run build_runner

Features:
- [ ] Basic serialization (fromJson/toJson)
- [ ] Custom JSON keys (@MappableField)
- [ ] Case style configuration
- [ ] Nullable & optional fields
- [ ] Nested objects
- [ ] Lists & collections
- [ ] Generics support
- [ ] Inheritance & polymorphism
- [ ] Enums
- [ ] Custom constructors
- [ ] Hooks for custom logic
- [ ] DateTime handling
```

---

## 🔗 Related Rules

- [JSON Serialization](./json-serialization.md) - Overview & comparison
- [HTTP Clients](./http-clients.md) - Using with Dio
- [Local Storage](./local-storage.md) - Persisting data

---

**Priority:** 🟡 MEDIUM  
**Level:** ADVANCED  
**Source:** https://github.com/schultek/dart_mappable  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0 for dart_mappable 4.6.1+

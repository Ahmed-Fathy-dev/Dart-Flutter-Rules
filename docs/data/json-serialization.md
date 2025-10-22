# JSON Serialization

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Data
applies_to:
  - all_projects_with_api
ai_agent_tags:
  - data
  - json
  - serialization
  - code-generation
  - type-safety
  - dart_mappable
  - json_serializable
alternatives:
  - json_serializable: maturity, community
  - dart_mappable: features, performance
```

---

## 🎯 Overview

**JSON Serialization** ضروري للتعامل مع APIs. يوجد حلان رئيسيان:
- **json_serializable** - الأكثر نضجاً والأوسع استخداماً
- **dart_mappable** - الأحدث والأكثر ميزات

### Why Code Generation?
- ✅ Type safety
- 🔄 Auto-generated code
- 🐛 Compile-time errors
- 📝 Less boilerplate
- ⚡ Better performance

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` لجميع المشاريع مع API

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  json_annotation: ^4.9.0  # ✅ Updated to latest

dev_dependencies:
  build_runner: ^2.4.15  # ✅ Updated to latest (2025-10-22)
  json_serializable: ^6.9.2  # ✅ Updated to latest
```

---

### 2. Basic Model

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
  
  // From JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  // To JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

#### Generate Code
```bash
# One time
flutter pub run build_runner build

# Watch mode (auto-regenerate)
flutter pub run build_runner watch

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 3. Field Mapping

```dart
@JsonSerializable()
class Product {
  final String id;
  
  // Map JSON field 'product_name' to 'name'
  @JsonKey(name: 'product_name')
  final String name;
  
  // Map 'product_price' to 'price'
  @JsonKey(name: 'product_price')
  final double price;
  
  // Default value if null
  @JsonKey(defaultValue: 0)
  final int stock;
  
  // Ignore field in JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? localData;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.localData,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
```

---

### 4. Nested Objects

```dart
@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String country;
  
  Address({
    required this.street,
    required this.city,
    required this.country,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String name;
  
  // Nested object
  final Address address;
  
  User({
    required this.id,
    required this.name,
    required this.address,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// JSON:
// {
//   "id": "123",
//   "name": "Ahmed",
//   "address": {
//     "street": "Main St",
//     "city": "Cairo",
//     "country": "Egypt"
//   }
// }
```

---

### 5. Lists

```dart
@JsonSerializable()
class Post {
  final String id;
  final String title;
  final String content;
  
  // List of strings
  final List<String> tags;
  
  // List of objects
  final List<Comment> comments;
  
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.comments,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Comment {
  final String id;
  final String text;
  final String authorId;
  
  Comment({
    required this.id,
    required this.text,
    required this.authorId,
  });
  
  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
```

---

### 6. Enums

```dart
enum UserRole {
  @JsonValue('admin')
  admin,
  
  @JsonValue('moderator')
  moderator,
  
  @JsonValue('user')
  user,
}

@JsonSerializable()
class User {
  final String id;
  final String name;
  final UserRole role;
  
  User({
    required this.id,
    required this.name,
    required this.role,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// JSON: {"role": "admin"}
// Converts to: UserRole.admin
```

---

### 7. DateTime

```dart
@JsonSerializable()
class Post {
  final String id;
  final String title;
  
  // ISO 8601 format (default)
  final DateTime createdAt;
  
  // Unix timestamp (milliseconds)
  @JsonKey(
    fromJson: _dateTimeFromMilliseconds,
    toJson: _dateTimeToMilliseconds,
  )
  final DateTime updatedAt;
  
  Post({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
  
  static DateTime _dateTimeFromMilliseconds(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }
  
  static int _dateTimeToMilliseconds(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }
}
```

---

### 8. Nullable Fields

```dart
@JsonSerializable()
class User {
  final String id;
  final String name;
  
  // Nullable fields
  final String? email;
  final int? age;
  final Address? address;
  
  User({
    required this.id,
    required this.name,
    this.email,
    this.age,
    this.address,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Works with:
// {"id": "1", "name": "Ahmed"}
// {"id": "1", "name": "Ahmed", "email": null}
// {"id": "1", "name": "Ahmed", "email": "ahmed@example.com"}
```

---

## 🚀 Alternative: dart_mappable (NEW!)

**dart_mappable** هو بديل حديث وأقوى لـ json_serializable مع ميزات متقدمة.

### Why dart_mappable?
- ✅ **أسرع** - Performance أفضل
- 🔄 **Polymorphism** - دعم كامل للـ inheritance
- 📝 **Less boilerplate** - كود أقل
- 🎯 **Type-safe** - أكثر أماناً
- 🆕 **Modern** - مبني على Dart 3.x features

---

### 1. Setup dart_mappable

#### pubspec.yaml
```yaml
dependencies:
  dart_mappable: ^4.4.0  # ✅ Latest version (2025-10-22)

dev_dependencies:
  build_runner: ^2.4.15
  dart_mappable_builder: ^4.3.1+1  # ✅ Latest
```

---

### 2. Basic Model with dart_mappable

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  final String email;
  final int age;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
  
  // ✅ No need for fromJson/toJson - auto-generated!
}

// Usage
final user = UserMapper.fromJson(jsonString);
final user2 = UserMapper.fromMap(jsonMap);
final json = user.toJson();
final map = user.toMap();
```

#### Generate Code
```bash
# Same as json_serializable
dart run build_runner build
dart run build_runner watch
```

---

### 3. Field Mapping

```dart
@MappableClass()
class Product with ProductMappable {
  final String id;
  
  // Map 'product_name' to 'name'
  @MappableField(key: 'product_name')
  final String name;
  
  @MappableField(key: 'product_price')
  final double price;
  
  // Default value
  @MappableField(defaultValue: 0)
  final int stock;
  
  // Ignore field
  @MappableField(ignore: true)
  final String? localData;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.stock = 0,
    this.localData,
  });
}
```

---

### 4. Polymorphism & Inheritance (🔥 Killer Feature!)

```dart
// Base class
@MappableClass(discriminatorKey: 'type')
abstract class PaymentMethod with PaymentMethodMappable {
  final String id;
  const PaymentMethod({required this.id});
}

// Subclass 1
@MappableClass(discriminatorValue: 'card')
class CreditCard extends PaymentMethod with CreditCardMappable {
  final String cardNumber;
  final String expiryDate;
  
  const CreditCard({
    required super.id,
    required this.cardNumber,
    required this.expiryDate,
  });
}

// Subclass 2
@MappableClass(discriminatorValue: 'paypal')
class PayPal extends PaymentMethod with PayPalMappable {
  final String email;
  
  const PayPal({
    required super.id,
    required this.email,
  });
}

// Usage - Auto-detects type!
final json1 = '{"type": "card", "id": "1", "cardNumber": "1234"}';
final payment1 = PaymentMethodMapper.fromJson(json1);
// Type: CreditCard ✅

final json2 = '{"type": "paypal", "id": "2", "email": "user@example.com"}';
final payment2 = PaymentMethodMapper.fromJson(json2);
// Type: PayPal ✅
```

---

### 5. Custom Mappers

```dart
// Custom DateTime mapper
class DateTimeMapper extends SimpleMapper<DateTime> {
  @override
  DateTime decode(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.parse(value as String);
  }
  
  @override
  dynamic encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

// Use in model
@MappableClass()
class Post with PostMappable {
  final String id;
  final String title;
  
  @MappableField(hook: DateTimeMapper())
  final DateTime createdAt;
  
  const Post({
    required this.id,
    required this.title,
    required this.createdAt,
  });
}
```

---

### 6. CopyWith (Built-in! 🎉)

```dart
@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  final int age;
  
  const User({
    required this.id,
    required this.name,
    required this.age,
  });
}

// ✅ copyWith auto-generated!
final user = User(id: '1', name: 'Ahmed', age: 25);
final updated = user.copyWith(age: 26);
// User(id: '1', name: 'Ahmed', age: 26)

// ✅ copyWith.ifNull - update only if current is null
final user2 = User(id: '2', name: 'Ali', age: null);
final updated2 = user2.copyWith.ifNull(age: 30);
```

---

### 7. Equality & HashCode (Built-in!)

```dart
@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
}

// ✅ Equality auto-implemented!
final user1 = User(id: '1', name: 'Ahmed');
final user2 = User(id: '1', name: 'Ahmed');

print(user1 == user2); // true ✅
print(user1.hashCode == user2.hashCode); // true ✅
```

---

### 8. Enum Support

```dart
@MappableEnum()
enum UserRole {
  @MappableValue('admin')
  admin,
  
  @MappableValue('moderator')
  moderator,
  
  @MappableValue('user')
  user,
}

@MappableClass()
class User with UserMappable {
  final String id;
  final UserRole role;
  
  const User({required this.id, required this.role});
}

// JSON: {"role": "admin"}
// Converts to: UserRole.admin ✅
```

---

### 9. Generic Models

```dart
@MappableClass(genericArgumentFactories: true)
class ApiResponse<T> with ApiResponseMappable<T> {
  final bool success;
  final T? data;
  final String? error;
  
  const ApiResponse({
    required this.success,
    this.data,
    this.error,
  });
}

// Usage
final response = ApiResponseMapper.fromMap<User>(
  jsonMap,
  (value) => UserMapper.fromMap(value as Map<String, dynamic>),
);
```

---

### 10. Real-World Example: E-commerce

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'models.mapper.dart';

// Product model
@MappableClass()
class Product with ProductMappable {
  final String id;
  
  @MappableField(key: 'product_name')
  final String name;
  
  @MappableField(key: 'price')
  final double price;
  
  @MappableField(key: 'image_url')
  final String? imageUrl;
  
  @MappableField(key: 'in_stock', defaultValue: true)
  final bool inStock;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.inStock = true,
  });
}

// Cart item
@MappableClass()
class CartItem with CartItemMappable {
  final Product product;
  final int quantity;
  
  const CartItem({
    required this.product,
    required this.quantity,
  });
  
  // Custom getter
  double get total => product.price * quantity;
}

// Cart
@MappableClass()
class Cart with CartMappable {
  final String userId;
  final List<CartItem> items;
  
  const Cart({
    required this.userId,
    required this.items,
  });
  
  double get totalPrice => items.fold(
        0,
        (sum, item) => sum + item.total,
      );
  
  int get itemCount => items.length;
}

// Usage
final cart = CartMapper.fromJson(jsonString);
print('Total: \$${cart.totalPrice}');

// Update cart
final updatedCart = cart.copyWith(
  items: [...cart.items, newItem],
);
```

---

## ⚖️ dart_mappable vs json_serializable

### **Comparison Table:**

| Feature | json_serializable | dart_mappable |
|---------|------------------|---------------|
| **Setup** | ✅ Easy | ✅ Easy |
| **Performance** | ✅ Good | ⚡ **Better** |
| **Polymorphism** | ❌ Limited | ✅ **Full Support** |
| **CopyWith** | ❌ Manual | ✅ **Auto-generated** |
| **Equality** | ❌ Manual or equatable | ✅ **Built-in** |
| **Generic Types** | ✅ Supported | ✅ Supported |
| **Custom Mappers** | ✅ Yes | ✅ **Easier** |
| **Boilerplate** | 🟡 Medium | 🟢 **Less** |
| **Maturity** | 🟢 Very Mature | 🟡 Newer (but stable) |
| **Community** | 🟢 Large | 🟡 Growing |
| **Learning Curve** | 🟢 Low | 🟡 Medium |

---

### **When to use json_serializable:**
```yaml
✅ Simple models only
✅ No inheritance needed
✅ Existing codebase using it
✅ Team familiar with it
✅ Prefer maturity over features
```

### **When to use dart_mappable:**
```yaml
✅ Complex models with inheritance
✅ Need polymorphism support
✅ Want built-in copyWith/equality
✅ New project from scratch
✅ Performance is critical
✅ Prefer modern features
```

---

### **Migration from json_serializable to dart_mappable:**

```dart
// BEFORE (json_serializable)
@JsonSerializable()
class User {
  final String id;
  final String name;
  
  User({required this.id, required this.name});
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  // Manual copyWith
  User copyWith({String? id, String? name}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
  
  // Manual equality (or use equatable)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && other.id == id && other.name == name;
      
  @override
  int get hashCode => Object.hash(id, name);
}

// AFTER (dart_mappable)
@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  
  const User({required this.id, required this.name});
  
  // ✅ fromJson/toJson auto-generated
  // ✅ copyWith auto-generated
  // ✅ equality auto-generated
  // ✅ hashCode auto-generated
}

// That's it! 🎉
```

---

### **Recommendation:**

```yaml
For New Projects:
  ⭐ Use dart_mappable
  - More features
  - Less code
  - Better DX

For Existing Projects:
  ⭐ Stick with json_serializable
  - Unless you need polymorphism
  - Migration effort may not be worth it

For Complex Models:
  ⭐ Definitely use dart_mappable
  - Inheritance support
  - Discriminated unions
  - Sealed classes
```

---

## ✅ Best Practices

### Rule 1: Use Immutable Models

```dart
// ✅ Good - Immutable
@JsonSerializable()
class User {
  final String id;
  final String name;
  
  const User({
    required this.id,
    required this.name,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  // CopyWith for updates
  User copyWith({String? id, String? name}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
```

---

### Rule 2: Handle API Changes

```dart
@JsonSerializable()
class User {
  final String id;
  final String name;
  
  // Old API: 'user_email'
  // New API: 'email'
  @JsonKey(name: 'email', unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final String? email;
  
  // Fallback for missing fields
  @JsonKey(defaultValue: 'Unknown')
  final String username;
  
  User({
    required this.id,
    required this.name,
    this.email,
    required this.username,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserFromJson(json);
    } catch (e) {
      print('Error parsing User: $e');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

### Rule 3: Generic Response Wrapper

```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;
  
  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

// Usage
final response = ApiResponse<User>.fromJson(
  jsonData,
  (json) => User.fromJson(json as Map<String, dynamic>),
);

final response2 = ApiResponse<List<Product>>.fromJson(
  jsonData,
  (json) => (json as List).map((e) => Product.fromJson(e)).toList(),
);
```

---

## 🎯 Real-World Example: Social Media App

```dart
// models/user.dart
@JsonSerializable()
class User {
  final String id;
  
  @JsonKey(name: 'username')
  final String userName;
  
  @JsonKey(name: 'display_name')
  final String displayName;
  
  final String email;
  
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  
  @JsonKey(name: 'bio')
  final String? biography;
  
  @JsonKey(name: 'follower_count', defaultValue: 0)
  final int followerCount;
  
  @JsonKey(name: 'following_count', defaultValue: 0)
  final int followingCount;
  
  @JsonKey(name: 'is_verified', defaultValue: false)
  final bool isVerified;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.userName,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.biography,
    required this.followerCount,
    required this.followingCount,
    required this.isVerified,
    required this.createdAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// models/post.dart
@JsonSerializable()
class Post {
  final String id;
  final String content;
  
  @JsonKey(name: 'author')
  final User author;
  
  @JsonKey(name: 'image_urls', defaultValue: [])
  final List<String> imageUrls;
  
  @JsonKey(name: 'like_count', defaultValue: 0)
  final int likeCount;
  
  @JsonKey(name: 'comment_count', defaultValue: 0)
  final int commentCount;
  
  @JsonKey(name: 'is_liked', defaultValue: false)
  final bool isLiked;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  Post({
    required this.id,
    required this.content,
    required this.author,
    required this.imageUrls,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
  });
  
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
  
  Post copyWith({
    bool? isLiked,
    int? likeCount,
  }) {
    return Post(
      id: id,
      content: content,
      author: author,
      imageUrls: imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }
}

// models/api_response.dart
@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T> {
  final List<T> data;
  
  @JsonKey(name: 'next_page')
  final String? nextPage;
  
  @JsonKey(name: 'has_more')
  final bool hasMore;
  
  @JsonKey(name: 'total_count')
  final int totalCount;
  
  PaginatedResponse({
    required this.data,
    this.nextPage,
    required this.hasMore,
    required this.totalCount,
  });
  
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

// Usage in repository
class PostRepository {
  final ApiClient _api;
  
  Future<PaginatedResponse<Post>> getPosts({String? page}) async {
    final response = await _api.get(
      '/posts',
      queryParameters: {'page': page},
    );
    
    return PaginatedResponse<Post>.fromJson(
      response.data,
      (json) => Post.fromJson(json as Map<String, dynamic>),
    );
  }
  
  Future<Post> getPostById(String id) async {
    final response = await _api.get('/posts/$id');
    return Post.fromJson(response.data);
  }
}
```

---

## 🧪 Testing Serialization

```dart
import 'package:test/test.dart';

void main() {
  group('User Serialization', () {
    test('fromJson creates valid User', () {
      final json = {
        'id': '123',
        'name': 'Ahmed',
        'email': 'ahmed@example.com',
        'age': 25,
      };
      
      final user = User.fromJson(json);
      
      expect(user.id, equals('123'));
      expect(user.name, equals('Ahmed'));
      expect(user.email, equals('ahmed@example.com'));
      expect(user.age, equals(25));
    });
    
    test('toJson creates valid JSON', () {
      final user = User(
        id: '123',
        name: 'Ahmed',
        email: 'ahmed@example.com',
        age: 25,
      );
      
      final json = user.toJson();
      
      expect(json['id'], equals('123'));
      expect(json['name'], equals('Ahmed'));
      expect(json['email'], equals('ahmed@example.com'));
      expect(json['age'], equals(25));
    });
    
    test('handles null values', () {
      final json = {
        'id': '123',
        'name': 'Ahmed',
        'email': null,
        'age': null,
      };
      
      final user = User.fromJson(json);
      
      expect(user.email, isNull);
      expect(user.age, isNull);
    });
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - @JsonSerializable annotation
  - fromJson factory constructor
  - toJson method
  - part directive
  - generated file exists
  - @JsonKey for field mapping
  - proper null handling

suggest:
  - add @JsonSerializable
  - generate code with build_runner
  - use @JsonKey for snake_case fields
  - add defaultValue for nullable primitives
  - create copyWith methods
  - add error handling in fromJson

enforce:
  - immutable models
  - part directive present
  - generated code up to date
  - proper field mapping
```

---

## 📊 Summary Checklist

```markdown
- [ ] json_serializable setup
- [ ] @JsonSerializable on models
- [ ] fromJson/toJson methods
- [ ] part directive
- [ ] Code generated
- [ ] @JsonKey for mapping
- [ ] Null handling
- [ ] Tests for serialization
```

---

## 🔗 Related Rules

- [HTTP Clients](./http-clients.md)
- [Error Handling](../core/error-handling.md)
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**For:** All Projects with API  
**Last Updated:** 2025-10-22  
**Version:** 2.0.0 - Added dart_mappable alternative

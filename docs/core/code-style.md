# Code Style & Naming Conventions

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Core
applies_to:
  - all_projects
  - all_platforms
ai_agent_tags:
  - code-style
  - naming
  - formatting
  - conventions
  - readability
  - critical
```

---

## 🎯 Overview

Code Style المتسق يجعل الكود أسهل للقراءة والصيانة والمراجعة. يجب اتباع قواعد واضحة في جميع المشاريع.

### Why It Matters
- 📖 Readability - سهولة القراءة
- 🤝 Teamwork - التعاون السلس
- 🐛 Fewer Bugs - أخطاء أقل
- ⚡ Faster Development - تطوير أسرع

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - إلزامي وغير قابل للتفاوض

### Why CRITICAL?

```dart
// ❌ Bad - غير واضح وصعب القراءة
class usr{
  String n;int a;bool act;
  usr(this.n,this.a,this.act);
  void upd(){if(act)a++;}
}

// ✅ Good - واضح وسهل الفهم
class User {
  final String name;
  final int age;
  final bool isActive;
  
  User({
    required this.name,
    required this.age,
    required this.isActive,
  });
  
  void updateAge() {
    if (isActive) {
      age++;
    }
  }
}
```

---

## 📚 Naming Conventions

### 1. Classes & Types - PascalCase

```dart
// ✅ Correct
class UserProfile {}
class ShoppingCart {}
class PaymentMethod {}
abstract class DataRepository {}
enum OrderStatus {}
typedef JsonMap = Map<String, dynamic>;

// ❌ Wrong
class user_profile {}
class shopping_cart {}
class paymentmethod {}
class PAYMENTMETHOD {}
```

### 2. Variables, Functions, Parameters - camelCase

```dart
// ✅ Correct
String userName = 'Ahmed';
int userAge = 25;
bool isLoggedIn = false;

void fetchUserData() {}
Future<User> getUserById(String userId) async {}
void calculateTotalPrice(List<Product> cartItems) {}

// ❌ Wrong
String UserName = 'Ahmed';
String user_name = 'Ahmed';
void FetchUserData() {}
void fetch_user_data() {}
```

### 3. Constants - lowerCamelCase

```dart
// ✅ Correct
const int maxRetryCount = 3;
const String apiBaseUrl = 'https://api.example.com';
const Duration requestTimeout = Duration(seconds: 30);

// ❌ Wrong
const int MAX_RETRY_COUNT = 3;
const int max_retry_count = 3;
```

### 4. Private Members - _prefix

```dart
class UserService {
  // ✅ Correct - Private
  String? _cachedToken;
  final ApiClient _apiClient;
  
  void _refreshCache() {}
  Future<void> _validateToken() async {}
  
  // ✅ Correct - Public
  User? currentUser;
  Future<void> login() async {}
}

// ❌ Wrong - No underscore for private
class UserService {
  String cachedToken; // Should be _cachedToken if private
}
```

### 5. Files & Folders - snake_case

```
✅ Correct:
lib/
├── main.dart
├── models/
│   ├── user_profile.dart
│   └── shopping_cart.dart
├── screens/
│   ├── home_screen.dart
│   └── product_details_screen.dart
└── services/
    └── authentication_service.dart

❌ Wrong:
lib/
├── Main.dart
├── UserProfile.dart
├── HomeScreen.dart
└── authentication-service.dart
```

---

## 📏 Code Formatting

### 1. Line Length

```dart
// ✅ Recommended: 80-120 characters
class UserService {
  Future<User> getUserById(String id) async {
    return await _repository.findById(id);
  }
}

// ⚠️ If line > 120, break it
final user = User(
  id: 'user-123',
  name: 'Ahmed Mohamed',
  email: 'ahmed@example.com',
  phoneNumber: '+20 123 456 7890',
  address: 'Cairo, Egypt',
);

// ❌ Too long
final user = User(id: 'user-123', name: 'Ahmed Mohamed', email: 'ahmed@example.com', phoneNumber: '+20 123 456 7890', address: 'Cairo, Egypt');
```

**Configuration:**
```yaml
# في rules-config.yaml
code_style:
  line_length: 120  # Recommended: 80, 100, or 120
```

---

### 2. Function Length

```dart
// ✅ Good - Short and focused (< 20 lines)
void validateEmail(String email) {
  if (email.isEmpty) {
    throw ValidationException('Email is required');
  }
  if (!email.contains('@')) {
    throw ValidationException('Invalid email format');
  }
}

// ⚠️ Warning - Too long (> 20 lines)
void processOrder() {
  // 50 lines of code...
  // Should be broken into smaller functions
}

// ✅ Better - Break down
void processOrder() {
  _validateOrder();
  _calculateTotal();
  _applyDiscounts();
  _processPayment();
  _sendConfirmation();
}
```

**Rule:** Strive for functions < 20 lines. Maximum 50 lines.

---

### 3. Indentation & Spacing

```dart
// ✅ Correct - 2 spaces
class User {
  final String name;
  
  User({required this.name});
  
  void greet() {
    if (name.isNotEmpty) {
      print('Hello $name');
    }
  }
}

// ❌ Wrong - Mixed tabs/spaces or wrong indentation
class User {
final String name;
    User({required this.name});
void greet() {
if(name.isNotEmpty){
print('Hello $name');
}}}
```

**Spacing Rules:**
```dart
// ✅ Space after keywords
if (condition) {}
for (var item in items) {}
while (isRunning) {}

// ✅ Space around operators
int sum = a + b;
bool isValid = x > 10 && y < 20;

// ✅ No space before comma, space after
foo(a, b, c);

// ❌ Wrong
if(condition){}
int sum=a+b;
foo( a , b , c );
```

---

### 4. Braces & Brackets

```dart
// ✅ Correct - Opening brace on same line
void myFunction() {
  if (condition) {
    doSomething();
  } else {
    doSomethingElse();
  }
}

// ❌ Wrong - Opening brace on new line
void myFunction()
{
  if (condition)
  {
    doSomething();
  }
}

// ✅ Single line is OK for short statements
if (x > 0) return true;

// ✅ But use braces for clarity
if (x > 0) {
  return true;
}
```

---

## 📝 Documentation & Comments

### 1. Documentation Comments

```dart
// ✅ Excellent - Complete documentation
/// Fetches user data from the API.
///
/// Returns a [User] object if successful.
/// Throws [NetworkException] if no internet connection.
/// Throws [AuthException] if not authenticated.
///
/// Example:
/// ```dart
/// final user = await getUserData('user-123');
/// print(user.name);
/// ```
Future<User> getUserData(String userId) async {
  // Implementation
}

// ✅ Good - Class documentation
/// Represents a user in the system.
///
/// Contains user profile information including [name], [email],
/// and [age].
class User {
  /// The user's full name.
  final String name;
  
  /// The user's email address.
  final String email;
  
  /// The user's age in years.
  final int age;
}

// ❌ Bad - No documentation
Future<User> getUserData(String userId) async {}

// ❌ Bad - Useless documentation
/// Gets user data.
Future<User> getUserData(String userId) async {}
```

---

### 2. Code Comments

```dart
// ✅ Good - Explain WHY
// Using cached value to avoid unnecessary API calls
// Cache expires after 5 minutes
if (_cacheExpiration.isAfter(DateTime.now())) {
  return _cachedUser;
}

// ✅ Good - Explain complex logic
// Sort products by: 1) availability, 2) price, 3) name
products.sort((a, b) {
  if (a.inStock != b.inStock) return a.inStock ? -1 : 1;
  if (a.price != b.price) return a.price.compareTo(b.price);
  return a.name.compareTo(b.name);
});

// ❌ Bad - Obvious comment
// Increment i
i++;

// ❌ Bad - Commented code (delete it!)
// void oldFunction() {
//   // old implementation
// }
```

---

### 3. TODO Comments

```dart
// ✅ Good - Clear TODO with context
// TODO(ahmed): Implement caching after backend adds cache headers
Future<List<Product>> getProducts() async {
  return await _api.get('/products');
}

// TODO: Add pagination support (ticket #123)
// TODO: Optimize for large datasets

// ❌ Bad - Vague TODO
// TODO: Fix this
// TODO: Improve performance
```

---

## 🏗️ Code Organization

### 1. Class Member Order

```dart
// ✅ Correct order
class UserService {
  // 1. Static constants
  static const int maxRetries = 3;
  
  // 2. Static variables
  static UserService? _instance;
  
  // 3. Instance variables (public first)
  User? currentUser;
  
  // 4. Instance variables (private)
  final ApiClient _apiClient;
  String? _cachedToken;
  
  // 5. Constructors
  UserService(this._apiClient);
  
  // 6. Named constructors
  UserService.withToken(this._apiClient, String token) {
    _cachedToken = token;
  }
  
  // 7. Static methods
  static UserService getInstance() {
    return _instance ??= UserService(ApiClient());
  }
  
  // 8. Public methods
  Future<void> login(String email, String password) async {}
  
  void logout() {}
  
  // 9. Private methods
  void _refreshToken() {}
  
  Future<void> _validateSession() async {}
  
  // 10. Getters/Setters (at the end)
  bool get isLoggedIn => currentUser != null;
}
```

---

### 2. Import Organization

```dart
// ✅ Correct order
// 1. Dart SDK imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

// 4. Relative imports (last)
import '../models/user.dart';
import '../services/api_client.dart';
import 'login_screen.dart';

// ❌ Wrong - Mixed order
import '../models/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
```

**Rule:** Always use `package:` imports, not relative imports for lib files.

```dart
// ✅ Correct
import 'package:myapp/models/user.dart';

// ❌ Wrong
import '../models/user.dart';
```

---

### 3. File Structure

```dart
// recommended_file_structure.dart

// 1. License/Copyright (optional)
// Copyright 2025 MyCompany

// 2. File documentation (if complex)
/// This file contains the UserService implementation...

// 3. Imports
import 'dart:async';
import 'package:flutter/material.dart';

// 4. Constants (if file-level)
const String apiVersion = 'v1';

// 5. Main class/classes
class UserService {
  // ...
}

// 6. Helper classes (private to this file)
class _UserCache {
  // ...
}

// 7. Extensions (if any)
extension UserExtension on User {
  // ...
}
```

---

## ✅ Best Practices

### Rule 1: Meaningful Names

```dart
// ❌ Bad - Cryptic
int d = 30;
String u = 'Ahmed';
void proc() {}

// ✅ Good - Clear intent
int daysSinceLastLogin = 30;
String userName = 'Ahmed';
void processPayment() {}

// ❌ Bad - Too generic
void handle() {}
String data = '';
int value = 0;

// ✅ Good - Specific
void handleLoginAttempt() {}
String userEmailAddress = '';
int maxRetryAttempts = 3;
```

---

### Rule 2: Avoid Abbreviations

```dart
// ❌ Bad - Abbreviations
class UsrMgr {}
String addr = '';
int qty = 5;
void procReq() {}

// ✅ Good - Full words
class UserManager {}
String address = '';
int quantity = 5;
void processRequest() {}

// ✅ OK - Well-known abbreviations
String id = 'user-123';    // OK
String url = 'https://...'; // OK
String html = '<div>...';   // OK
int maxCount = 10;          // OK
```

---

### Rule 3: Boolean Names

```dart
// ✅ Good - Use is/has/can prefixes
bool isLoggedIn = true;
bool hasPermission = false;
bool canEdit = true;
bool shouldUpdate = false;

// ❌ Bad - Unclear
bool loggedIn = true;
bool permission = false;
bool edit = true;

// ✅ Good - Positive names
bool isVisible = true;
bool isEnabled = false;

// ❌ Bad - Negative names (confusing)
bool isNotVisible = false;  // Double negative!
bool isDisabled = true;     // Prefer isEnabled = false
```

---

### Rule 4: Function Names - Verbs

```dart
// ✅ Good - Action verbs
void fetchUserData() {}
Future<void> saveToDatabase() async {}
bool validateEmail(String email) {}
User createUser(String name) {}
void updateProfile() {}
void deleteAccount() {}

// ❌ Bad - Nouns
void user() {}
void data() {}
void profile() {}
```

---

### Rule 5: Consistent Terminology

```dart
// ✅ Good - Consistent
void fetchUser() {}
void fetchProduct() {}
void fetchOrder() {}

// ❌ Bad - Inconsistent
void fetchUser() {}
void getProduct() {}
void retrieveOrder() {}
void loadCart() {}

// Pick one and stick with it:
// fetch*, get*, load*, retrieve*
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Magic Numbers

```dart
// ❌ Bad - Magic numbers
if (user.age < 18) {
  showWarning();
}
await Future.delayed(Duration(seconds: 5));
if (items.length > 100) {
  showPagination();
}

// ✅ Good - Named constants
const int minimumAge = 18;
const Duration defaultTimeout = Duration(seconds: 5);
const int paginationThreshold = 100;

if (user.age < minimumAge) {
  showWarning();
}
await Future.delayed(defaultTimeout);
if (items.length > paginationThreshold) {
  showPagination();
}
```

---

### Pitfall 2: Deeply Nested Code

```dart
// ❌ Bad - Too nested (> 3 levels)
void processOrder(Order order) {
  if (order.isValid) {
    if (order.isPaid) {
      if (order.items.isNotEmpty) {
        if (order.hasShippingAddress) {
          // Process order
        }
      }
    }
  }
}

// ✅ Good - Early returns
void processOrder(Order order) {
  if (!order.isValid) return;
  if (!order.isPaid) return;
  if (order.items.isEmpty) return;
  if (!order.hasShippingAddress) return;
  
  // Process order
}

// ✅ Better - Extract validation
void processOrder(Order order) {
  if (!_canProcessOrder(order)) return;
  
  _executeOrderProcessing(order);
}
```

---

### Pitfall 3: Hungarian Notation

```dart
// ❌ Bad - Hungarian notation (outdated)
String strName = 'Ahmed';
int intAge = 25;
bool bIsActive = true;
List<String> lstNames = [];

// ✅ Good - Dart has type inference
String name = 'Ahmed';
int age = 25;
bool isActive = true;
List<String> names = [];

// Type is clear from context or type annotation
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  naming:
    - Classes: PascalCase
    - Variables/Functions: camelCase
    - Files: snake_case
    - Private: _prefix
    - Constants: lowerCamelCase
    - Booleans: is/has/can prefix
  
  formatting:
    - Line length: 80-120 characters
    - Function length: < 20 lines (warn if > 50)
    - Consistent indentation (2 spaces)
    - Proper spacing around operators
  
  organization:
    - Imports ordered correctly
    - Class members in standard order
    - Public before private
  
  documentation:
    - Public APIs documented
    - Complex logic commented
    - No commented-out code

suggest:
  - Extract long functions
  - Replace magic numbers with constants
  - Use early returns to reduce nesting
  - Rename unclear variables
  - Add missing documentation
  - Remove abbreviations

enforce:
  - PascalCase for classes
  - camelCase for variables/functions
  - snake_case for files
  - _prefix for private members
  - No commented-out code
  - No magic numbers
  - Documentation for public APIs
```

---

## 📊 Summary Checklist

```markdown
Naming:
- [ ] Classes & types: PascalCase
- [ ] Variables & functions: camelCase
- [ ] Files & folders: snake_case
- [ ] Private members: _prefix
- [ ] Meaningful, descriptive names
- [ ] No abbreviations (except common ones)
- [ ] Boolean names: is/has/can
- [ ] Function names: verbs

Formatting:
- [ ] Line length: 80-120 characters
- [ ] Function length: < 20 lines
- [ ] Consistent indentation (2 spaces)
- [ ] Proper spacing
- [ ] Braces on same line

Documentation:
- [ ] Public APIs documented
- [ ] Complex logic commented
- [ ] No obvious comments
- [ ] No commented-out code

Organization:
- [ ] Imports ordered correctly
- [ ] Class members in standard order
- [ ] One class per file (usually)
- [ ] Consistent file structure
```

---

## 🔗 Related Rules

- [Null Safety](./null-safety.md) - naming nullable types
- [Error Handling](./error-handling.md) - exception naming
- [Testing](../testing/unit-testing.md) - test naming

---

## 📚 References

- [Effective Dart: Style](https://dart.dev/effective-dart/style)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

# Null Safety

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Core
applies_to:
  - all_projects
  - all_platforms
min_dart_version: "2.12.0"
ai_agent_tags:
  - null-safety
  - type-system
  - critical
```

---

## 🎯 Overview

**Null Safety** هي أحد أهم ميزات Dart الحديثة. تمنع `null reference errors` في compile-time بدلاً من runtime.

### Why It Matters
- 🐛 تمنع أكثر من 70% من الأخطاء الشائعة
- ✅ Type safety أقوى
- 🚀 أداء أفضل (compiler optimizations)
- 📝 كود أوضح وأكثر توثيقاً

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - لا يمكن تعطيله أبداً

### Why CRITICAL?
```dart
// بدون null safety - خطأ في runtime ❌
String name = getName();
print(name.length); // NullPointerException!

// مع null safety - خطأ في compile-time ✅
String? name = getName();
print(name.length); // Error: The property 'length' can't be 
                    // unconditionally accessed because the 
                    // receiver can be 'null'.
```

**النتيجة:** اكتشاف الأخطاء قبل وصولها للمستخدم.

---

## 📚 Core Concepts

### 1. Nullable vs Non-nullable Types

#### Non-nullable (Default)
```dart
// ✅ Cannot be null
String name = 'Ahmed';
int age = 25;
List<String> items = [];

// ❌ Compile error
String name = null; // Error!
```

#### Nullable (Explicit)
```dart
// ✅ Can be null
String? name = null;
int? age = null;
List<String>? items = null;

// يجب فحصها قبل الاستخدام
if (name != null) {
  print(name.length); // Safe
}
```

---

### 2. Null-aware Operators

#### `?.` - Safe Navigation
```dart
String? name = getUser()?.name;
// إذا كان getUser() null، name سيكون null

// بدلاً من:
String? name;
final user = getUser();
if (user != null) {
  name = user.name;
}
```

#### `??` - Null Coalescing
```dart
String name = userName ?? 'Guest';
// إذا userName null، استخدم 'Guest'

// استخدام متعدد
String name = userName ?? userEmail ?? 'Unknown';
```

#### `??=` - Null Assignment
```dart
String? name;
name ??= 'Default'; // فقط إذا كان null

// مثال عملي:
class Cache {
  Map<String, String>? _data;
  
  Map<String, String> get data {
    return _data ??= {}; // أنشئ إذا لم يكن موجود
  }
}
```

#### `!` - Null Assertion (استخدم بحذر)
```dart
String? name = getUserName();
print(name!.length); // ⚠️ Assertion: أنا متأكد أنه ليس null

// ⚠️ خطر: إذا كان null، ستحصل على runtime error
```

---

### 3. Late Variables

```dart
// للـ variables التي تُهيأ لاحقاً لكن guaranteed non-null
class UserProfile {
  late String name;
  late int age;
  
  void initialize(Map<String, dynamic> data) {
    name = data['name']; // يجب استدعاء initialize قبل استخدام name
    age = data['age'];
  }
}

// استخدام مع lazy initialization
class ExpensiveResource {
  late final String data = _loadData(); // يُحمّل عند أول استخدام فقط
  
  String _loadData() {
    print('Loading...');
    return 'Heavy data';
  }
}
```

---

## ✅ Best Practices

### Rule 1: استخدم Non-nullable بشكل افتراضي

```dart
// ✅ Good
class User {
  final String name;
  final String email;
  final int age;
  
  User({
    required this.name,
    required this.email,
    required this.age,
  });
}

// ❌ Bad - لا داعي للـ nullable
class User {
  final String? name;
  final String? email;
  final int? age;
}
```

**AI Agent Guidance:**
```
عند رؤية class جديد:
1. افحص: هل يمكن أن يكون field null فعلاً؟
2. إذا لا، اجعله non-nullable مع required
3. إذا نعم، اجعله nullable مع توثيق السبب
```

---

### Rule 2: تجنب `!` إلا عند الضرورة القصوى

```dart
// ❌ Bad - استخدام ! بدون سبب
void printUserName(String? name) {
  print(name!.toUpperCase()); // خطر!
}

// ✅ Good - فحص أولاً
void printUserName(String? name) {
  if (name != null) {
    print(name.toUpperCase());
  }
}

// ✅ Better - استخدم default value
void printUserName(String? name) {
  print((name ?? 'Guest').toUpperCase());
}

// ✅ Best - non-nullable من الأساس
void printUserName(String name) {
  print(name.toUpperCase());
}
```

**متى يمكن استخدام `!`؟**
```dart
// ✅ مقبول: عند استخدام RegExp
final match = RegExp(r'\d+').firstMatch('abc123')!;
final number = match.group(0)!;

// ✅ مقبول: بعد فحص explicit
if (value != null) {
  doSomething(value!); // الآن آمن
}

// ✅ مقبول: في tests
test('user must have name', () {
  final user = createUser();
  expect(user.name!, equals('Ahmed')); // في test بيئة محكومة
});
```

---

### Rule 3: استخدم `late` بحذر

```dart
// ✅ Good - lazy initialization
class ImageCache {
  late final Image _image = _loadImage();
  Image _loadImage() => Image.asset('path');
}

// ✅ Good - initialization في constructor/method
class DatabaseService {
  late Database db;
  
  Future<void> initialize() async {
    db = await openDatabase('path');
  }
}

// ❌ Bad - يمكن استخدام nullable بدلاً منه
class Config {
  late String? apiKey; // ❌ late + nullable = redundant
  
  // ✅ Better
  String? apiKey; // كافي
}

// ❌ Dangerous - قد تنسى التهيئة
class UserService {
  late User currentUser; // ⚠️ ماذا لو لم نهيئه؟
  
  void doSomething() {
    print(currentUser.name); // LateInitializationError!
  }
}
```

---

### Rule 4: Type Promotion

استفد من null check للحصول على non-nullable type:

```dart
void processUser(User? user) {
  // ❌ Bad - تكرار الفحص
  if (user != null) {
    print(user.name);
  }
  if (user != null) {
    print(user.email);
  }
  
  // ✅ Good - استخدم early return
  if (user == null) return;
  
  // الآن user هو non-nullable (promoted)
  print(user.name);
  print(user.email);
  print(user.age);
}

// ✅ Better - استخدم guard clause
void processUser(User? user) {
  if (user == null) {
    print('No user');
    return;
  }
  
  // user promoted to non-nullable
  _printUserDetails(user); // يمكن تمريره كـ non-nullable
}

void _printUserDetails(User user) {
  print(user.name);
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: فقدان Type Promotion

```dart
class UserService {
  User? _currentUser;
  
  void printUserName() {
    if (_currentUser != null) {
      // ❌ لا يعمل - field يمكن أن يتغير
      print(_currentUser.name); // Error!
    }
  }
  
  // ✅ الحل 1: نسخ محلية
  void printUserName() {
    final user = _currentUser;
    if (user != null) {
      print(user.name); // Works!
    }
  }
  
  // ✅ الحل 2: null-aware operator
  void printUserName() {
    print(_currentUser?.name ?? 'No user');
  }
}
```

**AI Agent Guidance:**
```
عند رؤية nullable field:
1. انتبه: لا يمكن promotion مباشرة
2. اقترح: نسخ لـ local variable أو استخدام ?.
3. وضح: السبب (field يمكن أن يتغير من thread آخر)
```

---

### Pitfall 2: Nullable Collections

```dart
// ❌ Confusing
List<String>? names;      // القائمة نفسها nullable
List<String?> names;      // العناصر nullable
List<String?>? names;     // كلاهما nullable

// ✅ Best Practice: تجنب nullable collections
class UserList {
  // ❌ Bad
  List<User>? users;
  
  // ✅ Good - استخدم empty list
  List<User> users = [];
  
  bool get hasUsers => users.isNotEmpty;
}

// استخدام
void printUsers(UserList userList) {
  // ❌ مع nullable
  if (userList.users != null) {
    for (var user in userList.users!) { // ! مطلوب
      print(user.name);
    }
  }
  
  // ✅ مع non-nullable
  for (var user in userList.users) { // مباشرة
    print(user.name);
  }
}
```

---

### Pitfall 3: Cascade Operator مع Nullable

```dart
User? user = getUser();

// ❌ Error
user..name = 'Ahmed'
    ..age = 25;

// ✅ الحل 1: فحص أولاً
if (user != null) {
  user..name = 'Ahmed'
      ..age = 25;
}

// ✅ الحل 2: null-aware cascade
user?..name = 'Ahmed'
    ..age = 25;
```

---

## 💡 Advanced Patterns

### Pattern 1: Required vs Optional Parameters

```dart
// ✅ Excellent - واضح ومباشر
class User {
  final String name;        // required, non-null
  final String? nickname;   // optional, can be null
  final int age;            // required, non-null
  final String? bio;        // optional, can be null
  
  User({
    required this.name,
    this.nickname,
    required this.age,
    this.bio,
  });
}

// الاستخدام
final user1 = User(name: 'Ahmed', age: 25);
final user2 = User(
  name: 'Sara',
  nickname: 'S',
  age: 30,
  bio: 'Developer',
);
```

---

### Pattern 2: Factory with Validation

```dart
class Email {
  final String value;
  
  // Private constructor
  Email._(this.value);
  
  // Factory that returns null for invalid
  static Email? parse(String input) {
    if (!_isValid(input)) return null;
    return Email._(input);
  }
  
  // Factory that throws for invalid
  factory Email(String input) {
    if (!_isValid(input)) {
      throw FormatException('Invalid email: $input');
    }
    return Email._(input);
  }
  
  static bool _isValid(String email) {
    return email.contains('@');
  }
}

// الاستخدام
void example() {
  // Option 1: nullable
  final email1 = Email.parse('invalid');
  if (email1 != null) {
    print(email1.value);
  }
  
  // Option 2: throws
  try {
    final email2 = Email('invalid');
    print(email2.value);
  } catch (e) {
    print('Error: $e');
  }
}
```

---

### Pattern 3: Extension Methods for Null Safety

```dart
extension NullableString on String? {
  // تحويل null إلى empty string
  String get orEmpty => this ?? '';
  
  // فحص إذا كان null أو empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  
  // تطبيق transformation فقط إذا لم يكن null
  String? mapIfNotNull(String Function(String) transform) {
    final value = this;
    return value != null ? transform(value) : null;
  }
}

// الاستخدام
void example(String? name) {
  print(name.orEmpty.toUpperCase());
  
  if (!name.isNullOrEmpty) {
    print('Hello, $name');
  }
  
  final upperName = name.mapIfNotNull((n) => n.toUpperCase());
}
```

---

## 🧪 Testing Null Safety

```dart
import 'package:test/test.dart';

void main() {
  group('Null Safety Tests', () {
    test('should handle nullable parameters', () {
      String? getName() => null;
      
      // ✅ Test null case
      expect(getName(), isNull);
      expect(getName() ?? 'Default', equals('Default'));
    });
    
    test('should not accept null for required', () {
      void printName(String name) {
        print(name);
      }
      
      // ❌ This won't compile
      // printName(null);
      
      // ✅ Must provide non-null
      printName('Ahmed');
    });
    
    test('should promote nullable to non-nullable', () {
      String? name = 'Ahmed';
      
      if (name != null) {
        // name is promoted to String (non-nullable)
        expect(name.length, equals(5));
      }
    });
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

#### عند قراءة Null Safety Rules:

```yaml
check_for:
  - تأكد أن جميع classes تستخدم non-nullable بشكل افتراضي
  - ابحث عن استخدامات ! غير ضرورية
  - تحقق من late variables بدون initialization
  - افحص nullable collections (غالباً يمكن تجنبها)

suggest:
  - تحويل nullable إلى non-nullable مع default values
  - استخدام ?? بدلاً من !
  - early returns للـ null checks
  - extension methods للحالات المتكررة

enforce:
  - لا null في production code بدون سبب واضح
  - توثيق كل nullable field (لماذا يمكن أن يكون null)
  - tests لكل null case
```

#### Prompt Template:

```markdown
عند مراجعة كود:
1. افحص كل `?` في التعريفات - هل ضروري؟
2. ابحث عن `!` - هل يمكن استبداله؟
3. تحقق من `late` - هل مضمون التهيئة؟
4. اقترح improvements مع الشرح

عند كتابة كود جديد:
1. ابدأ بـ non-nullable
2. أضف `?` فقط عند الحاجة الواضحة
3. استخدم required للـ parameters المهمة
4. وثّق السبب إذا كان nullable
```

---

## 📊 Summary Checklist

```markdown
- [ ] جميع classes تستخدم non-nullable بشكل افتراضي
- [ ] nullable فقط عند الضرورة مع توثيق
- [ ] تجنب ! إلا في حالات نادرة ومبررة
- [ ] استخدام ?? للـ default values
- [ ] استخدام ?. للـ safe navigation
- [ ] late فقط مع ضمان التهيئة
- [ ] تجنب nullable collections
- [ ] tests لجميع null cases
- [ ] type promotion في null checks
- [ ] extension methods للحالات المتكررة
```

---

## 🔗 Related Rules

- [Error Handling](./error-handling.md) - كيف تتعامل مع null بشكل آمن
- [Code Style](./code-style.md) - naming conventions للـ nullable
- [Testing](../testing/unit-testing.md) - اختبار null cases

---

## 📚 References

- [Dart Null Safety](https://dart.dev/null-safety)
- [Understanding Null Safety](https://dart.dev/null-safety/understanding-null-safety)
- [Migrating to Null Safety](https://dart.dev/null-safety/migration-guide)

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

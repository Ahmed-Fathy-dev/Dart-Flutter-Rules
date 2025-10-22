# 🚀 Windsurf + Claude Usage Guide

## دليل الاستخدام الشامل لنظام القواعد مع Windsurf

---

## 📋 المحتويات

1. [كيف يعمل النظام](#كيف-يعمل-النظام)
2. [الإعداد الأولي](#الإعداد-الأولي)
3. [طرق الاستخدام](#طرق-الاستخدام)
4. [أمثلة عملية](#أمثلة-عملية)
5. [أفضل الممارسات](#أفضل-الممارسات)
6. [نصائح متقدمة](#نصائح-متقدمة)

---

## 🎯 كيف يعمل النظام

### **Windsurf Memory System**

Windsurf يستخدم **نظام ذاكرة متقدم** لتخزين القواعد والتعليمات:

```yaml
كيف يعمل:
  1. عند فتح المشروع → Windsurf يقرأ الملفات في المجلد
  2. يخزن القواعد في الذاكرة التفاعلية
  3. Claude يستخدم الذاكرة عند الحاجة
  4. يطبق القواعد تلقائياً على الكود

أين تُخزن القواعد:
  - Global Rules: قواعد عامة تطبق دائماً
  - Project Rules: قواعد خاصة بالمشروع
  - Workspace Context: سياق المشروع الحالي
```

---

## ⚙️ الإعداد الأولي

### **الخطوة 1: التأكد من الهيكل**

تأكد أن المجلد موجود في مسار Windsurf يمكنه قراءته:

```
✅ المسار الحالي جيد:
d:\Development\agents rules\flutter\

البنية:
flutter/
├── README.md
├── rules-config.yaml  ← مهم جداً
├── AI-AGENT-INTEGRATION.md
└── docs/
    ├── core/
    ├── state-management/
    └── ...
```

### **الخطوة 2: إعداد rules-config.yaml**

افتح `rules-config.yaml` واختر profile:

```yaml
# اختر واحد:
active_profile: "medium"  # للمشاريع المتوسطة (موصى به)
# أو
active_profile: "small"   # للمشاريع الصغيرة
# أو
active_profile: "large"   # للمشاريع الكبيرة
```

### **الخطوة 3: إخبار Windsurf بالمجلد**

في Windsurf، افتح المشروع:

```bash
# طريقة 1: من Windsurf
File > Open Folder > اختر: d:\Development\agents rules\flutter

# طريقة 2: من Terminal
cd "d:\Development\agents rules\flutter"
code .  # أو windsurf .
```

---

## 💬 طرق الاستخدام

### **1. الإشارة المباشرة للقواعد**

```markdown
❌ طريقة ضعيفة:
"اكتب كود Flutter"

✅ طريقة قوية:
"اكتب كود Flutter باتباع قواعد null-safety و error-handling من نظام القواعد"

✅ طريقة أقوى:
"اتبع docs/core/null-safety.md عند كتابة هذا الكود"
```

### **2. الطلب العام**

```markdown
✅ أمثلة جيدة:

"اتبع نظام القواعد الموجود في هذا المشروع"

"طبق best practices من flutter rules عند كتابة UserService"

"تأكد من الالتزام بـ CRITICAL rules أثناء التطوير"

"راجع الكود وتأكد من مطابقته لـ rules-config.yaml"
```

### **3. السياق التلقائي**

Windsurf يقرأ الملفات تلقائياً! فقط:

```markdown
✅ اعمل بشكل طبيعي:

"أنشئ UserModel مع JSON serialization"
→ Claude سيتبع docs/data/json-serialization.md تلقائياً

"أضف state management للتطبيق"
→ Claude سيستخدم docs/state-management/comparison.md للاختيار

"أصلح هذا الخطأ"
→ Claude سيتبع docs/core/error-handling.md
```

---

## 🎯 أمثلة عملية

### **مثال 1: إنشاء Model Class**

#### الطلب:
```
أنشئ User model class مع:
- id, name, email, age
- JSON serialization
- اتبع قواعد null-safety و immutability
```

#### Claude سيطبق تلقائياً:
```dart
// ✅ يتبع: docs/core/null-safety.md
// ✅ يتبع: docs/flutter-basics/widget-immutability.md
// ✅ يتبع: docs/data/json-serialization.md

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final int? age; // nullable لأنه اختياري
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.age,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

### **مثال 2: إضافة State Management**

#### الطلب:
```
أضف state management للتطبيق
المشروع: متوسط الحجم (15 screens)
```

#### Claude سيفعل:
1. يقرأ `docs/state-management/comparison.md`
2. يختار **Provider** أو **Riverpod** (للمشاريع المتوسطة)
3. يطبق best practices من الملف المناسب

```dart
// ✅ سيقترح Riverpod للمشاريع الحديثة

// main.dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// user_provider.dart
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);
  
  void setUser(User user) {
    state = user;
  }
}

// في Widget
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    
    if (user == null) {
      return const Text('No user');
    }
    
    return Text(user.name);
  }
}
```

---

### **مثال 3: إصلاح أخطاء**

#### السيناريو:
```dart
// كود به مشاكل
class MyWidget extends StatelessWidget {
  Widget build(context) {  // ❌
    String? name;
    return Text(name);  // ❌
  }
}
```

#### الطلب:
```
راجع هذا الكود وأصلح المشاكل حسب نظام القواعد
```

#### Claude سيصلح:
```dart
// ✅ يطبق: docs/core/null-safety.md
// ✅ يطبق: docs/core/code-style.md
// ✅ يطبق: docs/flutter-basics/widget-immutability.md

class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // ✅ const constructor
  
  @override // ✅ annotation
  Widget build(BuildContext context) { // ✅ type annotation
    const String? name = null; // ✅ explicit null
    
    return Text(name ?? 'No name'); // ✅ null handling
  }
}
```

---

### **مثال 4: إنشاء API Service**

#### الطلب:
```
أنشئ UserApiService مع:
- getUser(id)
- getUsers()
- createUser(user)
- اتبع قواعد error handling و http clients
```

#### Claude سيطبق:
```dart
// ✅ يتبع: docs/data/http-clients.md
// ✅ يتبع: docs/core/error-handling.md
// ✅ يتبع: docs/architecture/repository-pattern.md

import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;
  
  UserApiService(this._dio);
  
  Future<User> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException('User not found');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('Connection timeout');
      }
      throw ServerException(e.message ?? 'Unknown error');
    }
  }
  
  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch users');
    }
  }
  
  Future<User> createUser(User user) async {
    try {
      final response = await _dio.post(
        '/users',
        data: user.toJson(),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException('Invalid user data');
      }
      throw ServerException(e.message ?? 'Failed to create user');
    }
  }
}

// Custom Exceptions
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
```

---

## ✅ أفضل الممارسات

### **1. كن محدداً في الطلب**

```markdown
❌ ضعيف:
"اكتب كود"

✅ جيد:
"اكتب UserService مع error handling"

✅ ممتاز:
"اكتب UserService باتباع:
- docs/core/error-handling.md
- docs/architecture/repository-pattern.md
- docs/data/http-clients.md"
```

### **2. اطلب المراجعة**

```markdown
✅ بعد كتابة الكود:

"راجع الكود وتأكد من مطابقته لـ:
- Null safety rules
- Error handling rules
- Code style rules"

أو ببساطة:
"راجع الكود حسب نظام القواعد"
```

### **3. استخدم السياق**

```markdown
✅ قبل البدء:

"هذا مشروع متوسط الحجم (20 screens)
اتبع medium profile من rules-config.yaml"

أو:
"مشروع MVP صغير - اتبع القواعد CRITICAL فقط"
```

### **4. اطلب الشرح**

```markdown
✅ للتعلم:

"لماذا استخدمت هذا النمط؟ أي قاعدة طبقت؟"

"اشرح لي best practices المطبقة في هذا الكود"

"ما هي القواعد التي يجب أن أتبعها عند كتابة Bloc؟"
```

---

## 🎓 أوامر مفيدة

### **للبدء السريع**

```markdown
1. "اعرض لي القواعد CRITICAL من نظام القواعد"

2. "ما هي القواعد الموصى بها لمشروع متوسط الحجم؟"

3. "اشرح لي الفرق بين Provider و Riverpod من ملف المقارنة"

4. "أنشئ مشروع Flutter جديد باتباع best practices"
```

### **أثناء التطوير**

```markdown
1. "راجع هذا الملف وتأكد من الالتزام بالقواعد"

2. "أصلح هذا الكود ليتبع null-safety rules"

3. "حسّن performance هذا Widget حسب القواعد"

4. "أضف proper error handling لهذه الدالة"
```

### **للمراجعة والتحسين**

```markdown
1. "راجع المشروع بالكامل وحدد المخالفات"

2. "اقترح تحسينات حسب نظام القواعد"

3. "ما هي القواعد التي لم أطبقها في هذا الكود؟"

4. "قارن الكود مع best practices من القواعد"
```

---

## 💡 نصائح متقدمة

### **1. استخدام Profiles بذكاء**

```yaml
# rules-config.yaml

# للبدء السريع (MVP)
active_profile: "mvp"

# للتطوير السريع (Prototype)
active_profile: "small"

# للمشاريع الحقيقية
active_profile: "medium"

# للمشاريع Enterprise
active_profile: "large"
```

### **2. تخصيص القواعد**

```yaml
# أضف قواعد مخصصة لفريقك
custom_rules:
  team_conventions:
    - always_use_riverpod: true
    - prefer_go_router: true
    - require_tests: true
    
  naming:
    - prefix_private_with_underscore: true
    - suffix_providers_with_provider: true
```

### **3. إنشاء Checklist مخصص**

```markdown
<!-- DEVELOPMENT-CHECKLIST.md -->

## Pre-Commit Checklist

- [ ] الكود يتبع null-safety rules
- [ ] Error handling موجود
- [ ] Tests مكتوبة
- [ ] Documentation محدثة
- [ ] Performance محسّن
- [ ] No console.log/print في production
```

### **4. Integration مع Git**

```bash
# .git/hooks/pre-commit

#!/bin/bash
echo "Checking code against Flutter rules..."

# اطلب من Claude المراجعة
# أو استخدم custom linter
```

---

## 🔥 سيناريوهات عملية

### **سيناريو 1: بداية مشروع جديد**

```markdown
الطلب:
"أنشئ مشروع Flutter جديد لتطبيق e-commerce متوسط الحجم باتباع:
- Medium profile من rules-config
- Clean Architecture
- Riverpod للـ state management
- GoRouter للـ navigation
- Dio للـ HTTP"

Claude سيفعل:
1. ينشئ الهيكل من docs/architecture/clean-architecture.md
2. يضيف dependencies
3. ينشئ folder structure
4. يضيف boilerplate code
5. يتبع best practices
```

### **سيناريو 2: إضافة ميزة جديدة**

```markdown
الطلب:
"أضف ميزة User Authentication مع:
- Login/Register screens
- Token management
- Secure storage
- Error handling
- اتبع القواعد الأمنية"

Claude سيطبق:
- docs/specialized/security.md
- docs/core/error-handling.md
- docs/data/local-storage.md
- docs/ui-design/material3-theming.md
```

### **سيناريو 3: Code Review**

```markdown
الطلب:
"راجع هذا Pull Request وتأكد من:
- الالتزام بالقواعد CRITICAL
- Best practices مطبقة
- Tests موجودة
- Documentation محدثة"

Claude سيفحص:
- Null safety
- Error handling
- Code style
- Performance
- Security
```

---

## 🎯 الخلاصة السريعة

### **للاستخدام اليومي:**

```markdown
1. افتح المشروع في Windsurf
   ✅ Windsurf يقرأ القواعد تلقائياً

2. اعمل بشكل طبيعي
   ✅ Claude يطبق القواعد تلقائياً

3. كن محدداً عند الحاجة
   ✅ "اتبع docs/core/null-safety.md"

4. اطلب المراجعة
   ✅ "راجع حسب نظام القواعد"
```

### **المفتاح الذهبي:**

```markdown
🔑 فقط اذكر "نظام القواعد" أو "rules" في طلبك
   وClaude سيستخدم الملفات تلقائياً!

مثال:
"اكتب UserBloc باتباع best practices من القواعد"
→ Claude يطبق docs/state-management/bloc.md تلقائياً
```

---

## 📚 موارد إضافية

```markdown
للمزيد:
- اقرأ README.md للنظرة العامة
- راجع QUICK-START.md للبدء السريع
- استخدم docs/INDEX.md للتصفح
- اطلع على AI-AGENT-INTEGRATION.md للتفاصيل التقنية
```

---

## ❓ أسئلة شائعة

### **Q: هل يجب أن أذكر الملف بالضبط؟**
```
A: لا! فقط اذكر الموضوع:
   "اتبع null safety rules" ✅
   "اتبع docs/core/null-safety.md" ✅ (كلاهما يعمل)
```

### **Q: كيف أعرف أن Claude استخدم القواعد؟**
```
A: اطلب منه:
   "أي قواعد طبقت في هذا الكود؟"
   "اشرح best practices المستخدمة"
```

### **Q: هل يمكنني تعطيل بعض القواعد؟**
```
A: نعم! عدّل rules-config.yaml:
   
   exclude_rules:
     - docs/specialized/animations.md
     - docs/tools/profiling.md
```

### **Q: كيف أخصص للمشروع؟**
```
A: انسخ rules-config.yaml إلى مجلد المشروع وعدّله
```

---

## 🚀 ابدأ الآن!

```markdown
1. افتح Windsurf
2. افتح مشروع Flutter
3. ابدأ المحادثة مع Claude:
   
   "مرحباً! لدي نظام قواعد Flutter/Dart شامل.
    أريدك أن تتبع القواعد الموجودة في:
    d:\Development\agents rules\flutter\
    
    ابدأ بمراجعة rules-config.yaml لفهم الإعدادات."

4. استمتع بالتطوير! 🎉
```

---

**نظام القواعد جاهز تماماً للاستخدام!** 🎊

**Version:** 1.0.0  
**Last Updated:** 2025-10-21  
**Optimized for:** Windsurf + Claude Sonnet 3.5

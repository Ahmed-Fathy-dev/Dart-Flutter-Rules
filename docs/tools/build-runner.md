# Build Runner & Code Generation

## 📋 Metadata

```yaml
priority: LOW
level: RECOMMENDED
category: Development Tools
applies_to:
  - code_generation_projects
ai_agent_tags:
  - build-runner
  - code-generation
  - productivity
  - automation
```

---

## 🎯 Overview

**build_runner** يُولّد كود تلقائياً (JSON serialization, routing, etc.). يوفر وقت ويقلل الأخطاء.

### Why build_runner?
- ⏱️ Save time
- 🐛 Fewer errors
- 📝 Less boilerplate
- ✅ Type-safe code
- 🔄 Automated updates

---

## 🔵 Priority Level: LOW

**Status:** `RECOMMENDED` للمشاريع مع code generation

---

## 📚 Core Concepts

### 1. Setup

```yaml
dependencies:
  json_annotation: ^4.9.0  # ✅ Updated

dev_dependencies:
  build_runner: ^2.4.15  # ✅ Updated (2025-10-22)
  json_serializable: ^6.9.2  # ✅ Updated
```

---

### 2. Basic Usage

```bash
# One-time build
flutter pub run build_runner build

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

---

### 3. JSON Serialization

```dart
// models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  
  User({
    required this.id,
    required this.name,
    required this.email,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Run: flutter pub run build_runner build
// Generates: user.g.dart
```

---

### 4. Multiple Packages

```yaml
dev_dependencies:
  build_runner: ^2.4.14  # ✅ Updated
  json_serializable: ^6.9.2  # ✅ Updated
  freezed: ^2.5.7  # ✅ Updated
  freezed_annotation: ^2.4.4  # ✅ Updated
  injectable_generator: ^2.6.2  # ✅ Updated
  mockito: ^5.4.4  # ✅ Updated
```

```bash
# Build all
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 5. Freezed (Immutable Models)

```yaml
dependencies:
  freezed_annotation: ^2.4.4  # ✅ Updated

dev_dependencies:
  build_runner: ^2.4.14  # ✅ Updated
  freezed: ^2.5.7  # ✅ Updated
  json_serializable: ^6.9.2  # ✅ Updated
```

```dart
// models/product.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    String? description,
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

// Generates:
// - product.freezed.dart (copyWith, ==, hashCode, etc.)
// - product.g.dart (JSON serialization)
```

---

### 6. Injectable (Dependency Injection)

```yaml
dependencies:
  get_it: ^8.0.3  # ✅ Updated (Major!)
  injectable: ^2.5.0  # ✅ Updated

dev_dependencies:
  build_runner: ^2.4.14  # ✅ Updated
  injectable_generator: ^2.6.2  # ✅ Updated
```

```dart
// injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// services/user_service.dart
@injectable
class UserService {
  final UserRepository repository;
  
  UserService(this.repository);
  
  Future<User> getUser(String id) async {
    return await repository.getUser(id);
  }
}

// repositories/user_repository.dart
@injectable
class UserRepository {
  final ApiClient api;
  
  UserRepository(this.api);
  
  Future<User> getUser(String id) async {
    // Implementation
  }
}

// Run: flutter pub run build_runner build
// Generates: injection.config.dart
```

---

### 7. Mockito (Test Mocks)

```yaml
dev_dependencies:
  build_runner: ^2.4.14  # ✅ Updated
  mockito: ^5.4.4  # ✅ Updated
```

```dart
// test/user_service_test.dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_service_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;
  late UserService service;
  
  setUp(() {
    mockRepository = MockUserRepository();
    service = UserService(mockRepository);
  });
  
  test('getUser returns user', () async {
    when(mockRepository.getUser('1')).thenAnswer(
      (_) async => User(id: '1', name: 'Test'),
    );
    
    final user = await service.getUser('1');
    
    expect(user.name, 'Test');
  });
}

// Run: flutter pub run build_runner build
// Generates: user_service_test.mocks.dart
```

---

### 8. build.yaml Configuration

```yaml
# build.yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          # Generate fromJson/toJson for all classes
          explicit_to_json: true
          any_map: false
          checked: true
          create_factory: true
          create_to_json: true
          disallow_unrecognized_keys: false
          field_rename: none
          ignore_unannotated: false
          include_if_null: true
      
      freezed:
        options:
          # Freezed options
          map_factory: true
          union_factory: true
```

---

### 9. Scripts (Makefile/package.json)

```makefile
# Makefile
.PHONY: build watch clean

build:
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

clean:
	flutter pub run build_runner clean
```

```json
// package.json (optional)
{
  "scripts": {
    "build": "flutter pub run build_runner build --delete-conflicting-outputs",
    "watch": "flutter pub run build_runner watch",
    "clean": "flutter pub run build_runner clean"
  }
}
```

---

## ✅ Best Practices

### Rule 1: Always Use --delete-conflicting-outputs

```bash
# ✅ Good - Resolves conflicts automatically
flutter pub run build_runner build --delete-conflicting-outputs

# ❌ Bad - May fail with conflicts
flutter pub run build_runner build
```

---

### Rule 2: Add Generated Files to .gitignore

```gitignore
# .gitignore
*.g.dart
*.freezed.dart
*.config.dart
*.mocks.dart
```

---

### Rule 3: Run Before Committing

```bash
# ✅ Always generate before commit
flutter pub run build_runner build --delete-conflicting-outputs
git add .
git commit -m "feat: add user model"
```

---

### Rule 4: Use Watch Mode During Development

```bash
# ✅ Auto-regenerate on file changes
flutter pub run build_runner watch --delete-conflicting-outputs

# Keep running while developing
# Files regenerate automatically
```

---

## 🎯 Common Packages

### JSON Serialization
```yaml
json_serializable: ^6.7.0
```

### Immutable Models
```yaml
freezed: ^2.4.0
```

### Dependency Injection
```yaml
injectable_generator: ^2.4.0
```

### Routing
```yaml
auto_route_generator: ^7.0.0
```

### Testing
```yaml
mockito: ^5.4.0
```

---

## 🚨 Common Issues

### Issue 1: Conflicting Outputs

```bash
# Error: Conflicting outputs were detected...

# Solution:
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 2: Part Directive Missing

```dart
// ❌ Error: part directive missing
@JsonSerializable()
class User {
  // ...
}

// ✅ Solution: Add part directive
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // Add this!

@JsonSerializable()
class User {
  // ...
}
```

### Issue 3: Outdated Generated Code

```bash
# Solution: Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - build_runner in dev_dependencies
  - part directives present
  - generated files in .gitignore
  - build.yaml configured
  - generators properly configured

suggest:
  - add --delete-conflicting-outputs
  - use watch mode
  - add to .gitignore
  - create build scripts
  - run before commit

enforce:
  - part directives required
  - generated files ignored in git
  - build before commit
  - up-to-date generated code
```

---

## 📊 Summary Checklist

```markdown
- [ ] build_runner installed
- [ ] Generators configured
- [ ] part directives added
- [ ] Generated files in .gitignore
- [ ] Build scripts created
- [ ] Run before commits
- [ ] Watch mode for development
- [ ] CI/CD integration
```

---

## 🔗 Related Rules

- [JSON Serialization](../data/json-serialization.md)
- [Dependency Injection](../architecture/dependency-injection.md)
- [Testing](../testing/mocking.md)

---

**Priority:** 🔵 LOW  
**Level:** RECOMMENDED  
**For:** Code Generation Projects  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

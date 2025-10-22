# Test Coverage

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Testing
applies_to:
  - all_projects
min_coverage: 80%
ai_agent_tags:
  - testing
  - coverage
  - quality
  - metrics
  - ci-cd
```

---

## 🎯 Overview

**Test Coverage** يقيس النسبة المئوية من الكود المختبر. هدف جيد هو **80%+ coverage** مع التركيز على **critical paths**.

### Why Coverage Matters?
- 📊 Measure test quality
- 🎯 Find untested code
- ✅ Confidence in changes
- 🚀 CI/CD metrics
- 📈 Track improvements

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` - Target 80%+

---

## 📚 Core Concepts

### 1. Generate Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Output: coverage/lcov.info
```

---

### 2. View Coverage Report

```bash
# Install lcov
# Mac
brew install lcov

# Ubuntu
sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

---

### 3. Coverage Configuration

#### analysis_options.yaml
```yaml
analyzer:
  exclude:
    - "**/*.g.dart"        # Generated files
    - "**/*.freezed.dart"  # Generated files
    - "**/generated/**"    # Generated code
    - "test/**"            # Test files
    - "integration_test/**"
```

---

### 4. Coverage Targets

```yaml
# Recommended coverage levels
Overall: 80%+
Critical Code: 90%+
  - Authentication
  - Payment
  - Data validation
  
Medium Priority: 70%+
  - Business logic
  - API calls
  - State management
  
Low Priority: 50%+
  - UI widgets
  - Simple getters
  - Constants
```

---

### 5. What to Test

```dart
// ✅ High Priority - Must Test
class UserService {
  // Critical business logic
  Future<User> createUser(UserData data) async {
    // Validation
    if (!_isValidEmail(data.email)) {
      throw ValidationException('Invalid email');
    }
    
    // Business rules
    if (data.age < 18) {
      throw ValidationException('Must be 18+');
    }
    
    // API call
    return await _repository.createUser(data);
  }
}

// ✅ Test this thoroughly
test('createUser validates email', () async {
  expect(
    () => service.createUser(UserData(email: 'invalid')),
    throwsA(isA<ValidationException>()),
  );
});

test('createUser validates age', () async {
  expect(
    () => service.createUser(UserData(age: 15)),
    throwsA(isA<ValidationException>()),
  );
});

test('createUser calls repository', () async {
  final user = await service.createUser(validData);
  verify(() => mockRepository.createUser(validData)).called(1);
});

// ⏸️ Lower Priority
class UserCard extends StatelessWidget {
  final User user;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(user.name), // Simple UI
    );
  }
}
```

---

### 6. Exclude Generated Files

#### coverage_helper.dart
```dart
// test/coverage_helper.dart
// Ignore coverage for this file
// coverage:ignore-file

// Import all files to include in coverage
import 'package:my_app/features/auth/data/models/user_model.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
// ... import all files

void main() {}
```

```bash
# Run with coverage helper
flutter test --coverage test/coverage_helper.dart
```

---

### 7. Ignore Specific Lines

```dart
class MyService {
  Future<void> doSomething() async {
    try {
      await api.call();
    } catch (e) {
      // coverage:ignore-start
      if (kDebugMode) {
        print('Debug: $e');
      }
      // coverage:ignore-end
    }
  }
  
  // coverage:ignore-line
  void debugOnly() => print('Debug');
}
```

---

### 8. CI/CD Integration

#### GitHub Actions
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests with coverage
        run: flutter test --coverage
      
      - name: Check coverage threshold
        run: |
          dart pub global activate coverage
          dart pub global run coverage:test_coverage \
            --min-coverage 80
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

---

### 9. Coverage Badges

```markdown
# README.md
[![Coverage](https://codecov.io/gh/username/repo/branch/main/graph/badge.svg)](https://codecov.io/gh/username/repo)
```

---

## ✅ Best Practices

### Rule 1: Focus on Critical Paths

```dart
// ✅ High Priority - Test thoroughly
class PaymentService {
  Future<PaymentResult> processPayment(Payment payment) async {
    // Critical: Test all paths
    if (payment.amount <= 0) {
      throw ValidationException('Invalid amount');
    }
    
    if (!_isValidCard(payment.card)) {
      throw ValidationException('Invalid card');
    }
    
    try {
      return await _paymentGateway.charge(payment);
    } on NetworkException {
      // Test network failure
      return PaymentResult.failed('Network error');
    } on InsufficientFundsException {
      // Test insufficient funds
      return PaymentResult.failed('Insufficient funds');
    }
  }
}

// Tests should cover:
// - Valid payment ✅
// - Invalid amount ✅
// - Invalid card ✅
// - Network failure ✅
// - Insufficient funds ✅
// - Success response ✅
```

---

### Rule 2: Don't Chase 100%

```dart
// ❌ Don't waste time testing simple code
class Constants {
  static const appName = 'My App';
  static const version = '1.0.0';
}

// ❌ Don't test getters/setters
class User {
  String name;
  String get displayName => name; // No need to test
}

// ✅ DO test complex logic
class User {
  String get displayName {
    // Complex logic - TEST THIS
    if (firstName.isEmpty) return email;
    if (lastName.isEmpty) return firstName;
    return '$firstName $lastName';
  }
}
```

---

### Rule 3: Test Edge Cases

```dart
class UserService {
  Future<List<User>> searchUsers(String query) async {
    // Test edge cases
    if (query.isEmpty) {
      return []; // ✅ Test empty query
    }
    
    if (query.length < 3) {
      throw ValidationException('Query too short'); // ✅ Test min length
    }
    
    final users = await _repository.search(query);
    
    if (users.isEmpty) {
      return []; // ✅ Test no results
    }
    
    return users;
  }
}

// Tests
test('returns empty list for empty query', () async {
  final result = await service.searchUsers('');
  expect(result, isEmpty);
});

test('throws for query < 3 chars', () {
  expect(
    () => service.searchUsers('ab'),
    throwsA(isA<ValidationException>()),
  );
});

test('handles no results', () async {
  when(() => mockRepo.search(any())).thenAnswer((_) async => []);
  final result = await service.searchUsers('xyz');
  expect(result, isEmpty);
});
```

---

## 🎯 Coverage Report Example

```
Overall Coverage: 85.4%

High Coverage (90%+):
  ✅ features/auth/domain/usecases/ - 95%
  ✅ features/auth/data/repositories/ - 92%
  ✅ core/utils/validators.dart - 100%

Medium Coverage (70-89%):
  ⚠️ features/home/presentation/bloc/ - 78%
  ⚠️ features/profile/data/ - 82%

Low Coverage (<70%):
  ❌ features/settings/presentation/pages/ - 45%
  ❌ shared/widgets/ - 60%

Uncovered Files:
  ❌ lib/generated/
  ❌ lib/**/*.g.dart
  ❌ lib/**/*.freezed.dart
```

---

## 🚀 Improving Coverage

### 1. Find Uncovered Code
```bash
# Generate coverage
flutter test --coverage

# View report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Red lines = not covered
# Green lines = covered
```

### 2. Write Missing Tests
```dart
// Found: LoginBloc._onLoginRequested not fully covered

// Add test for error case
test('emits error on login failure', () async {
  when(() => mockUseCase(any(), any())).thenAnswer(
    (_) async => Left(ServerFailure('Error')),
  );
  
  bloc.add(LoginRequested('email', 'pass'));
  
  await expectLater(
    bloc.stream,
    emitsInOrder([
      AuthLoading(),
      AuthError('Error'),
    ]),
  );
});
```

### 3. Refactor Untestable Code
```dart
// ❌ Hard to test
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Complex logic in build method
    final data = _processData();
    return Text(data);
  }
  
  String _processData() {
    // Logic here
  }
}

// ✅ Extract to testable class
class DataProcessor {
  String process() {
    // Logic here
  }
}

// Easy to unit test
test('processes data correctly', () {
  final processor = DataProcessor();
  expect(processor.process(), equals('expected'));
});
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - coverage enabled
  - min 80% overall
  - critical code 90%+
  - generated files excluded
  - CI/CD coverage checks
  - coverage badge

suggest:
  - add missing tests
  - focus on critical paths
  - exclude generated files
  - set up CI/CD
  - track coverage trends

enforce:
  - 80% minimum
  - critical code tested
  - no coverage regressions
  - CI fails below threshold
```

---

## 📊 Coverage Goals by Project Size

| Project Size | Min Coverage | Critical Code |
|--------------|--------------|---------------|
| **Small** (< 10k lines) | 75% | 85% |
| **Medium** (10-50k lines) | 80% | 90% |
| **Large** (50k+ lines) | 85% | 95% |

---

## 🔗 Related Rules

- [Unit Testing](./unit-testing.md)
- [Widget Testing](./widget-testing.md)
- [Integration Testing](./integration-testing.md)
- [Mocking](./mocking.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Target:** 80%+ Overall, 90%+ Critical  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

# Unit Testing

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Testing
applies_to:
  - all_projects
min_coverage: 80
ai_agent_tags:
  - testing
  - unit-tests
  - tdd
  - quality
  - critical
```

---

## 🎯 Overview

**Unit Testing** يختبر وحدات صغيرة من الكود (functions, methods, classes) بشكل منفصل. أساسي لضمان جودة الكود وتسهيل الصيانة.

### Why It Matters
- 🐛 اكتشاف bugs مبكراً
- 🔒 Refactoring بثقة
- 📝 Documentation الحية
- ⚡ Development أسرع

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - يجب اختبار كل business logic

### Why CRITICAL?

```dart
// Without tests:
// كود يعمل → تغيير بسيط → كود معطل → ساعات debugging

// With tests:
// كود يعمل → تغيير بسيط → tests fail → Fix في دقائق ✅
```

---

## 📚 Core Concepts

### 1. Test Structure - Arrange-Act-Assert (AAA)

```dart
import 'package:test/test.dart';

void main() {
  test('counter increments value', () {
    // Arrange - Setup
    final counter = Counter();
    
    // Act - Execute
    counter.increment();
    
    // Assert - Verify
    expect(counter.value, equals(1));
  });
}
```

### Alternative: Given-When-Then

```dart
test('counter starts at zero', () {
  // Given
  final counter = Counter();
  
  // When
  // (nothing - testing initial state)
  
  // Then
  expect(counter.value, equals(0));
});
```

---

### 2. Test Organization

```dart
void main() {
  // Group related tests
  group('Counter', () {
    test('starts at zero', () {
      final counter = Counter();
      expect(counter.value, equals(0));
    });
    
    test('increments value', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, equals(1));
    });
    
    test('decrements value', () {
      final counter = Counter();
      counter.decrement();
      expect(counter.value, equals(-1));
    });
    
    test('resets to zero', () {
      final counter = Counter();
      counter.increment();
      counter.increment();
      counter.reset();
      expect(counter.value, equals(0));
    });
  });
  
  group('Calculator', () {
    // More tests...
  });
}
```

---

### 3. setUp and tearDown

```dart
void main() {
  group('UserService', () {
    late UserService service;
    late MockApiClient api;
    
    setUp(() {
      // Runs before EACH test
      api = MockApiClient();
      service = UserService(api);
    });
    
    tearDown(() {
      // Runs after EACH test
      // Clean up resources
    });
    
    setUpAll(() {
      // Runs ONCE before all tests
    });
    
    tearDownAll(() {
      // Runs ONCE after all tests
    });
    
    test('fetches user successfully', () async {
      when(() => api.getUser('123'))
          .thenAnswer((_) async => User(id: '123', name: 'Ahmed'));
      
      final user = await service.getUser('123');
      
      expect(user.name, equals('Ahmed'));
    });
  });
}
```

---

## ✅ Best Practices

### Rule 1: Test One Thing Per Test

```dart
// ❌ Bad - Tests multiple things
test('counter works', () {
  final counter = Counter();
  
  counter.increment();
  expect(counter.value, equals(1));
  
  counter.increment();
  expect(counter.value, equals(2));
  
  counter.decrement();
  expect(counter.value, equals(1));
  
  counter.reset();
  expect(counter.value, equals(0));
});

// ✅ Good - One test per behavior
test('increment increases value by 1', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, equals(1));
});

test('decrement decreases value by 1', () {
  final counter = Counter();
  counter.decrement();
  expect(counter.value, equals(-1));
});

test('reset sets value to zero', () {
  final counter = Counter();
  counter.increment();
  counter.reset();
  expect(counter.value, equals(0));
});
```

---

### Rule 2: Use Descriptive Test Names

```dart
// ❌ Bad names
test('test1', () {});
test('counter test', () {});
test('it works', () {});

// ✅ Good names - Describe what is tested
test('increment increases counter value by 1', () {});
test('getUserById returns user when exists', () {});
test('getUserById throws NotFoundException when user not found', () {});
test('login fails with invalid credentials', () {});
test('password validator rejects passwords shorter than 8 characters', () {});
```

---

### Rule 3: Test Both Success and Failure Cases

```dart
group('EmailValidator', () {
  final validator = EmailValidator();
  
  // Success cases
  test('accepts valid email', () {
    expect(validator.isValid('user@example.com'), isTrue);
  });
  
  test('accepts email with subdomain', () {
    expect(validator.isValid('user@mail.example.com'), isTrue);
  });
  
  // Failure cases
  test('rejects email without @', () {
    expect(validator.isValid('userexample.com'), isFalse);
  });
  
  test('rejects email without domain', () {
    expect(validator.isValid('user@'), isFalse);
  });
  
  test('rejects empty email', () {
    expect(validator.isValid(''), isFalse);
  });
  
  test('rejects email with spaces', () {
    expect(validator.isValid('user @example.com'), isFalse);
  });
});
```

---

### Rule 4: Use expect Matchers

```dart
import 'package:test/test.dart';

test('various matchers', () {
  // Equality
  expect(1 + 1, equals(2));
  expect('hello', equals('hello'));
  
  // Types
  expect(123, isA<int>());
  expect('text', isA<String>());
  
  // Booleans
  expect(true, isTrue);
  expect(false, isFalse);
  
  // Null
  expect(null, isNull);
  expect('text', isNotNull);
  
  // Numbers
  expect(5, greaterThan(3));
  expect(5, lessThan(10));
  expect(5.001, closeTo(5.0, 0.01));
  
  // Strings
  expect('hello world', contains('world'));
  expect('hello', startsWith('he'));
  expect('hello', endsWith('lo'));
  expect('test@example.com', matches(r'.*@.*\..*'));
  
  // Collections
  expect([1, 2, 3], hasLength(3));
  expect([1, 2, 3], contains(2));
  expect([1, 2, 3], containsAll([1, 3]));
  expect([1, 2, 3], equals([1, 2, 3]));
  expect({'key': 'value'}, containsPair('key', 'value'));
  
  // Exceptions
  expect(() => throw Exception(), throwsException);
  expect(() => throw FormatException(), throwsA(isA<FormatException>()));
  
  // Async
  expect(Future.value(42), completion(equals(42)));
  expect(Future.error('error'), throwsA(anything));
  
  // Custom
  expect(5, predicate((n) => n > 0 && n < 10, 'between 0 and 10'));
});
```

---

### Rule 5: Test Edge Cases

```dart
group('divide', () {
  test('divides two positive numbers', () {
    expect(divide(10, 2), equals(5));
  });
  
  test('divides two negative numbers', () {
    expect(divide(-10, -2), equals(5));
  });
  
  test('divides positive by negative', () {
    expect(divide(10, -2), equals(-5));
  });
  
  // Edge cases
  test('divides by 1', () {
    expect(divide(10, 1), equals(10));
  });
  
  test('divides 0 by number', () {
    expect(divide(0, 5), equals(0));
  });
  
  test('throws when dividing by zero', () {
    expect(() => divide(10, 0), throwsA(isA<ArgumentError>()));
  });
  
  test('handles very large numbers', () {
    expect(divide(1e10, 1e5), closeTo(1e5, 0.01));
  });
  
  test('handles very small numbers', () {
    expect(divide(0.001, 0.1), closeTo(0.01, 0.0001));
  });
});
```

---

## 🧪 Testing Async Code

```dart
group('Async Tests', () {
  test('async function returns value', () async {
    final result = await fetchData();
    expect(result, equals('data'));
  });
  
  test('async function throws error', () {
    expect(
      () => fetchInvalidData(),
      throwsA(isA<NetworkException>()),
    );
  });
  
  test('future completes with value', () {
    expect(
      Future.value(42),
      completion(equals(42)),
    );
  });
  
  test('future throws error', () {
    expect(
      Future.error(Exception('error')),
      throwsException,
    );
  });
  
  test('stream emits values', () {
    final stream = Stream.fromIterable([1, 2, 3]);
    
    expect(
      stream,
      emitsInOrder([1, 2, 3]),
    );
  });
  
  test('stream emits error', () {
    final stream = Stream.error(Exception('error'));
    
    expect(
      stream,
      emitsError(isA<Exception>()),
    );
  });
});
```

---

## 🎭 Mocking with Mocktail

```dart
import 'package:mocktail/mocktail.dart';

// Mock class
class MockApiClient extends Mock implements ApiClient {}
class MockDatabase extends Mock implements Database {}

void main() {
  group('UserService', () {
    late UserService service;
    late MockApiClient api;
    late MockDatabase db;
    
    setUp(() {
      api = MockApiClient();
      db = MockDatabase();
      service = UserService(api, db);
    });
    
    test('getUser fetches from API', () async {
      // Arrange
      when(() => api.getUser('123'))
          .thenAnswer((_) async => User(id: '123', name: 'Ahmed'));
      
      // Act
      final user = await service.getUser('123');
      
      // Assert
      expect(user.name, equals('Ahmed'));
      verify(() => api.getUser('123')).called(1);
    });
    
    test('getUser caches result', () async {
      // Arrange
      when(() => api.getUser('123'))
          .thenAnswer((_) async => User(id: '123', name: 'Ahmed'));
      when(() => db.saveUser(any()))
          .thenAnswer((_) async => {});
      
      // Act
      await service.getUser('123');
      
      // Assert
      verify(() => db.saveUser(any())).called(1);
    });
    
    test('getUser throws when API fails', () {
      // Arrange
      when(() => api.getUser('123'))
          .thenThrow(NetworkException('No internet'));
      
      // Act & Assert
      expect(
        () => service.getUser('123'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Testing Implementation Instead of Behavior

```dart
// ❌ Bad - Tests internal implementation
test('counter uses _value field', () {
  final counter = Counter();
  // Accessing private field
  expect(counter._value, equals(0)); // Fragile!
});

// ✅ Good - Tests public behavior
test('counter starts at zero', () {
  final counter = Counter();
  expect(counter.value, equals(0)); // Public API
});
```

---

### Pitfall 2: Interdependent Tests

```dart
// ❌ Bad - Tests depend on each other
var counter = Counter();

test('increment works', () {
  counter.increment();
  expect(counter.value, equals(1));
});

test('increment again', () {
  counter.increment(); // Depends on previous test!
  expect(counter.value, equals(2));
});

// ✅ Good - Independent tests
test('increment from zero', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, equals(1));
});

test('increment twice', () {
  final counter = Counter();
  counter.increment();
  counter.increment();
  expect(counter.value, equals(2));
});
```

---

### Pitfall 3: Not Testing Edge Cases

```dart
// ❌ Incomplete - Only happy path
test('calculate age', () {
  expect(calculateAge(1990), equals(35));
});

// ✅ Complete - All cases
group('calculateAge', () {
  test('calculates current age', () {
    expect(calculateAge(1990), greaterThan(30));
  });
  
  test('handles future birth year', () {
    expect(
      () => calculateAge(2030),
      throwsArgumentError,
    );
  });
  
  test('handles very old birth year', () {
    expect(calculateAge(1900), greaterThan(100));
  });
  
  test('handles current year', () {
    expect(calculateAge(DateTime.now().year), equals(0));
  });
});
```

---

## 💡 Advanced Patterns

### Pattern 1: Test Data Builders

```dart
// Builder for test data
class UserBuilder {
  String _id = 'test-123';
  String _name = 'Test User';
  String _email = 'test@example.com';
  int _age = 25;
  
  UserBuilder withId(String id) {
    _id = id;
    return this;
  }
  
  UserBuilder withName(String name) {
    _name = name;
    return this;
  }
  
  UserBuilder withEmail(String email) {
    _email = email;
    return this;
  }
  
  UserBuilder withAge(int age) {
    _age = age;
    return this;
  }
  
  User build() {
    return User(
      id: _id,
      name: _name,
      email: _email,
      age: _age,
    );
  }
}

// Usage in tests
test('validates adult user', () {
  final user = UserBuilder()
      .withAge(18)
      .build();
  
  expect(validator.isAdult(user), isTrue);
});

test('validates minor user', () {
  final user = UserBuilder()
      .withAge(15)
      .build();
  
  expect(validator.isAdult(user), isFalse);
});
```

---

### Pattern 2: Custom Matchers

```dart
// Custom matcher
Matcher isValidEmail() {
  return predicate(
    (String email) => email.contains('@') && email.contains('.'),
    'a valid email address',
  );
}

// Usage
test('validates email format', () {
  expect('user@example.com', isValidEmail());
  expect('invalid', isNot(isValidEmail()));
});

// More complex matcher
class RangeMatcher extends Matcher {
  final num min;
  final num max;
  
  RangeMatcher(this.min, this.max);
  
  @override
  bool matches(item, Map matchState) {
    return item >= min && item <= max;
  }
  
  @override
  Description describe(Description description) {
    return description.add('in range $min to $max');
  }
}

Matcher inRange(num min, num max) => RangeMatcher(min, max);

test('age is in valid range', () {
  expect(25, inRange(18, 65));
});
```

---

## 📊 Test Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report
open coverage/html/index.html
```

### Target Coverage

```yaml
# في rules-config.yaml
testing:
  unit_tests:
    min_coverage: 80  # Aim for 80%+
```

### What to Cover

```markdown
✅ Must test:
- Business logic
- Data models
- Services/Repositories
- Utilities
- Validators
- Calculations

⚠️ Lower priority:
- UI widgets (use widget tests)
- Simple getters/setters
- Constants

❌ Don't test:
- Generated code (*.g.dart)
- Third-party packages
- Framework code
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - كل business logic لديه tests
  - test coverage > 80%
  - tests مستقلة (لا dependencies)
  - descriptive test names
  - AAA pattern متبع
  - success + failure cases
  - edge cases tested
  - mocks للـ dependencies

suggest:
  - إضافة tests للكود الجديد
  - تحسين test names
  - إضافة edge case tests
  - استخدام test builders
  - زيادة coverage

enforce:
  - tests لكل public method
  - لا interdependent tests
  - dispose للـ resources
  - async tests صحيحة
```

---

## 📊 Summary Checklist

```markdown
- [ ] AAA (Arrange-Act-Assert) pattern
- [ ] Descriptive test names
- [ ] One assertion per test
- [ ] Independent tests
- [ ] Success + failure cases
- [ ] Edge cases tested
- [ ] 80%+ code coverage
- [ ] Mocks للـ dependencies
- [ ] Async tests صحيحة
- [ ] setUp/tearDown for cleanup
```

---

## 🔗 Related Rules

- [Widget Testing](./widget-testing.md) - UI testing
- [Integration Testing](./integration-testing.md) - E2E testing
- [Error Handling](../core/error-handling.md) - testing errors

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Min Coverage:** 80%  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

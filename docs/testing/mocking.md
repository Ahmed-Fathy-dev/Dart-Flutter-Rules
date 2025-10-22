# Mocking & Test Doubles

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Testing
applies_to:
  - all_projects
recommended_package: mocktail
ai_agent_tags:
  - testing
  - mocking
  - test-doubles
  - isolation
  - unit-testing
```

---

## 🎯 Overview

**Mocking** يسمح باختبار الكود بمعزل عن dependencies. استخدم **Mocktail** للـ type-safe mocking بدون code generation.

### Why Mocking?
- 🎯 Isolate code under test
- ⚡ Fast tests
- 🎭 Control behavior
- 🧪 Test edge cases
- 📊 Verify interactions

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` لجميع المشاريع

---

## 📚 Core Concepts

### 1. Setup Mocktail

#### pubspec.yaml
```yaml
dev_dependencies:
  mocktail: ^1.0.4  # ✅ Updated to latest
  test: ^1.25.8  # ✅ Updated to latest
```

#### Basic Mock
```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Interface to mock
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
}

// Create mock
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late UserService service;
  
  setUp(() {
    mockRepository = MockUserRepository();
    service = UserService(mockRepository);
  });
  
  test('getUser calls repository', () async {
    // Arrange
    final user = User(id: '1', name: 'Ahmed');
    when(() => mockRepository.getUser('1')).thenAnswer(
      (_) async => user,
    );
    
    // Act
    final result = await service.getUser('1');
    
    // Assert
    expect(result, equals(user));
    verify(() => mockRepository.getUser('1')).called(1);
  });
}
```

---

### 2. When/ThenAnswer

```dart
test('mock return values', () async {
  final mock = MockUserRepository();
  
  // Return simple value
  when(() => mock.getUser('1')).thenAnswer(
    (_) async => User(id: '1', name: 'Ahmed'),
  );
  
  // Return different values on successive calls
  when(() => mock.getUser('1')).thenAnswer((_) async => user1);
  when(() => mock.getUser('2')).thenAnswer((_) async => user2);
  
  // Throw exception
  when(() => mock.getUser('999')).thenThrow(
    NotFoundException('User not found'),
  );
  
  // Return based on argument
  when(() => mock.getUser(any())).thenAnswer((invocation) {
    final id = invocation.positionalArguments[0] as String;
    return Future.value(User(id: id, name: 'User $id'));
  });
});
```

---

### 3. Verify Calls

```dart
test('verify method calls', () async {
  final mock = MockUserRepository();
  when(() => mock.getUser(any())).thenAnswer(
    (_) async => User(id: '1', name: 'Ahmed'),
  );
  
  // Call method
  await service.getUser('1');
  
  // Verify called once
  verify(() => mock.getUser('1')).called(1);
  
  // Verify called multiple times
  await service.getUser('1');
  await service.getUser('1');
  verify(() => mock.getUser('1')).called(3);
  
  // Verify never called
  verifyNever(() => mock.deleteUser('1'));
  
  // Verify call order
  verifyInOrder([
    () => mock.getUser('1'),
    () => mock.saveUser(any()),
  ]);
});
```

---

### 4. Argument Matchers

```dart
test('argument matchers', () async {
  final mock = MockUserRepository();
  
  // Any argument
  when(() => mock.getUser(any())).thenAnswer(
    (_) async => User(id: '1', name: 'Test'),
  );
  
  // Specific value
  when(() => mock.getUser('123')).thenAnswer(
    (_) async => User(id: '123', name: 'Specific'),
  );
  
  // Capture arguments
  await service.saveUser(user);
  
  final captured = verify(() => mock.saveUser(captureAny())).captured;
  expect(captured.first, isA<User>());
  expect((captured.first as User).name, equals('Ahmed'));
  
  // Custom matcher
  when(() => mock.getUser(any(that: startsWith('user_')))).thenAnswer(
    (_) async => User(id: '1', name: 'Test'),
  );
});
```

---

### 5. Fallback Values

```dart
class FakeUser extends Fake implements User {}

void main() {
  setUpAll(() {
    // Register fallback for non-nullable types
    registerFallbackValue(FakeUser());
  });
  
  test('with fallback', () async {
    final mock = MockUserRepository();
    
    // Now 'any()' works with User type
    when(() => mock.saveUser(any())).thenAnswer((_) async => {});
    
    await service.saveUser(User(id: '1', name: 'Test'));
    
    verify(() => mock.saveUser(any())).called(1);
  });
}
```

---

### 6. Mock Complex Objects

```dart
// API Client
abstract class ApiClient {
  Future<Response> get(String path);
  Future<Response> post(String path, {Object? data});
}

class MockApiClient extends Mock implements ApiClient {}

test('mock API client', () async {
  final mockApi = MockApiClient();
  final repository = UserRepository(mockApi);
  
  // Mock GET response
  when(() => mockApi.get('/users/1')).thenAnswer(
    (_) async => Response(
      data: {'id': '1', 'name': 'Ahmed'},
      statusCode: 200,
      requestOptions: RequestOptions(path: '/users/1'),
    ),
  );
  
  final user = await repository.getUser('1');
  
  expect(user.id, equals('1'));
  verify(() => mockApi.get('/users/1')).called(1);
});

// Mock POST
test('mock POST request', () async {
  final mockApi = MockApiClient();
  
  when(() => mockApi.post(
        any(),
        data: any(named: 'data'),
      )).thenAnswer(
    (_) async => Response(
      data: {'id': '2', 'name': 'New User'},
      statusCode: 201,
      requestOptions: RequestOptions(path: '/users'),
    ),
  );
  
  final user = await repository.createUser(
    User(id: '2', name: 'New User'),
  );
  
  expect(user.id, equals('2'));
  
  // Verify POST data
  final captured = verify(() => mockApi.post(
        '/users',
        data: captureAny(named: 'data'),
      )).captured;
  
  expect(captured.first, containsPair('name', 'New User'));
});
```

---

### 7. Mock Streams

```dart
abstract class MessageService {
  Stream<Message> messagesStream();
}

class MockMessageService extends Mock implements MessageService {}

test('mock stream', () async {
  final mock = MockMessageService();
  
  // Create stream
  final controller = StreamController<Message>();
  when(() => mock.messagesStream()).thenAnswer(
    (_) => controller.stream,
  );
  
  // Subscribe
  final messages = <Message>[];
  final subscription = service.messagesStream().listen(messages.add);
  
  // Emit values
  controller.add(Message(id: '1', text: 'Hello'));
  controller.add(Message(id: '2', text: 'World'));
  
  await Future.delayed(Duration(milliseconds: 100));
  
  expect(messages.length, equals(2));
  expect(messages[0].text, equals('Hello'));
  
  await subscription.cancel();
  await controller.close();
});
```

---

### 8. Test Bloc with Mocks

```dart
void main() {
  late UserBloc bloc;
  late MockGetUserUseCase mockGetUser;
  late MockUpdateUserUseCase mockUpdateUser;
  
  setUp(() {
    mockGetUser = MockGetUserUseCase();
    mockUpdateUser = MockUpdateUserUseCase();
    
    bloc = UserBloc(
      getUserUseCase: mockGetUser,
      updateUserUseCase: mockUpdateUser,
    );
  });
  
  tearDown(() {
    bloc.close();
  });
  
  test('emits UserLoaded when LoadUser succeeds', () async {
    // Arrange
    final user = User(id: '1', name: 'Ahmed');
    when(() => mockGetUser('1')).thenAnswer(
      (_) async => Right(user),
    );
    
    // Act
    bloc.add(LoadUser('1'));
    
    // Assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        UserLoading(),
        UserLoaded(user),
      ]),
    );
    
    verify(() => mockGetUser('1')).called(1);
  });
  
  test('emits UserError when LoadUser fails', () async {
    // Arrange
    when(() => mockGetUser('1')).thenAnswer(
      (_) async => Left(ServerFailure('Server error')),
    );
    
    // Act
    bloc.add(LoadUser('1'));
    
    // Assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        UserLoading(),
        UserError('Server error'),
      ]),
    );
  });
}
```

---

## ✅ Best Practices

### Rule 1: Mock Interfaces, Not Implementations

```dart
// ✅ Good - Mock interface
abstract class UserRepository {
  Future<User> getUser(String id);
}

class MockUserRepository extends Mock implements UserRepository {}

// ❌ Bad - Mock concrete class
class UserRepositoryImpl {
  Future<User> getUser(String id) async {
    // Implementation
  }
}

class MockUserRepository extends Mock implements UserRepositoryImpl {} // ❌
```

---

### Rule 2: Verify Important Interactions

```dart
// ✅ Good - Verify important calls
test('saves user after update', () async {
  await service.updateUser(user);
  
  verify(() => mockRepository.saveUser(user)).called(1);
});

// ✅ Good - Verify never called
test('does not save if validation fails', () async {
  await service.updateUser(invalidUser);
  
  verifyNever(() => mockRepository.saveUser(any()));
});
```

---

### Rule 3: Use Fallback Values

```dart
// ✅ Good - Register fallbacks
setUpAll(() {
  registerFallbackValue(FakeUser());
  registerFallbackValue(FakeProduct());
});

test('with any()', () {
  when(() => mock.saveUser(any())).thenAnswer((_) async => {});
  // Works!
});

// ❌ Bad - No fallback
test('fails without fallback', () {
  when(() => mock.saveUser(any())).thenAnswer((_) async => {});
  // Error! No fallback for User
});
```

---

## 🎯 Real-World Example

```dart
// Test UserService
void main() {
  late UserService service;
  late MockUserRepository mockRepository;
  late MockAuthService mockAuth;
  late MockAnalytics mockAnalytics;
  
  setUp(() {
    mockRepository = MockUserRepository();
    mockAuth = MockAuthService();
    mockAnalytics = MockAnalytics();
    
    service = UserService(
      repository: mockRepository,
      auth: mockAuth,
      analytics: mockAnalytics,
    );
  });
  
  setUpAll(() {
    registerFallbackValue(FakeUser());
  });
  
  group('getUser', () {
    test('returns user when found', () async {
      // Arrange
      final user = User(id: '1', name: 'Ahmed', email: 'ahmed@example.com');
      when(() => mockRepository.getUser('1')).thenAnswer(
        (_) async => Right(user),
      );
      
      // Act
      final result = await service.getUser('1');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return user'),
        (u) => expect(u.name, equals('Ahmed')),
      );
      
      verify(() => mockRepository.getUser('1')).called(1);
      verify(() => mockAnalytics.logEvent('user_viewed', any())).called(1);
    });
    
    test('returns failure when not found', () async {
      // Arrange
      when(() => mockRepository.getUser('999')).thenAnswer(
        (_) async => Left(NotFoundFailure('User not found')),
      );
      
      // Act
      final result = await service.getUser('999');
      
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains('not found')),
        (_) => fail('Should return failure'),
      );
    });
  });
  
  group('updateUser', () {
    test('updates user successfully', () async {
      // Arrange
      final user = User(id: '1', name: 'Ahmed Updated');
      when(() => mockAuth.getCurrentUserId()).thenReturn('1');
      when(() => mockRepository.updateUser(any())).thenAnswer(
        (_) async => Right(user),
      );
      
      // Act
      final result = await service.updateUser(user);
      
      // Assert
      expect(result.isRight(), true);
      
      // Verify interactions
      verify(() => mockAuth.getCurrentUserId()).called(1);
      verify(() => mockRepository.updateUser(user)).called(1);
      verify(() => mockAnalytics.logEvent('user_updated', any())).called(1);
    });
    
    test('fails when user not authorized', () async {
      // Arrange
      final user = User(id: '2', name: 'Other User');
      when(() => mockAuth.getCurrentUserId()).thenReturn('1');
      
      // Act
      final result = await service.updateUser(user);
      
      // Assert
      expect(result.isLeft(), true);
      
      // Verify repository NOT called
      verifyNever(() => mockRepository.updateUser(any()));
    });
  });
  
  group('deleteUser', () {
    test('deletes user and clears cache', () async {
      // Arrange
      when(() => mockAuth.isAdmin()).thenReturn(true);
      when(() => mockRepository.deleteUser('1')).thenAnswer(
        (_) async => Right(unit),
      );
      when(() => mockRepository.clearCache()).thenAnswer(
        (_) async => {},
      );
      
      // Act
      final result = await service.deleteUser('1');
      
      // Assert
      expect(result.isRight(), true);
      
      // Verify order
      verifyInOrder([
        () => mockAuth.isAdmin(),
        () => mockRepository.deleteUser('1'),
        () => mockRepository.clearCache(),
        () => mockAnalytics.logEvent('user_deleted', any()),
      ]);
    });
  });
}
```

---

## 🧪 Advanced Techniques

### Spy Pattern
```dart
class SpyUserRepository extends Mock implements UserRepository {
  final List<User> savedUsers = [];
  
  @override
  Future<void> saveUser(User user) async {
    savedUsers.add(user);
    return super.noSuchMethod(
      Invocation.method(#saveUser, [user]),
      returnValue: Future.value(),
    );
  }
}

test('spy collects calls', () async {
  final spy = SpyUserRepository();
  
  await service.saveUser(user1);
  await service.saveUser(user2);
  
  expect(spy.savedUsers.length, equals(2));
  expect(spy.savedUsers.first, equals(user1));
});
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - mock creation
  - when/thenAnswer usage
  - verify calls
  - fallback values registered
  - proper setup/tearDown
  - isolated tests

suggest:
  - mock dependencies
  - verify important interactions
  - test error scenarios
  - use argument matchers
  - register fallbacks

enforce:
  - mock interfaces not implementations
  - verify or verifyNever
  - proper cleanup
  - isolated unit tests
```

---

## 📊 Summary Checklist

```markdown
- [ ] Mocktail setup
- [ ] Mocks created
- [ ] when/thenAnswer configured
- [ ] Verify calls
- [ ] Fallback values registered
- [ ] Error scenarios tested
- [ ] Cleanup in tearDown
```

---

## 🔗 Related Rules

- [Unit Testing](./unit-testing.md)
- [Widget Testing](./widget-testing.md)
- [Integration Testing](./integration-testing.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Package:** mocktail  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

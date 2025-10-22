# Dependency Injection

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Architecture
applies_to:
  - all_projects
recommended_package: get_it
ai_agent_tags:
  - architecture
  - dependency-injection
  - di
  - testability
  - modularity
```

---

## 🎯 Overview

**Dependency Injection (DI)** يفصل إنشاء الكائنات عن استخدامها. يسهل الاختبار ويجعل الكود أكثر مرونة.

### Why DI?
- 🧪 Easier testing
- 🔄 Loose coupling
- 📦 Better modularity
- 🎯 Single Responsibility
- 🚀 Scalability

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` لجميع المشاريع

---

## 📚 Core Concepts

### 1. get_it - Service Locator

#### Setup
```yaml
dependencies:
  get_it: ^8.0.3  # ✅ Updated to latest (Major update!)
```

> ⚠️ **Breaking Change:** GetIt 8.x has API changes
> - Better async initialization support
> - Improved null safety
> - Check migration guide if upgrading from 7.x

#### Basic Usage
```dart
import 'package:get_it/get_it.dart';

// Global instance
final getIt = GetIt.instance;

// Setup dependencies
void setupDependencies() {
  // Register singleton
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  // Register lazy singleton (created when first accessed)
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt()),
  );
  
  // Register factory (new instance every time)
  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt()),
  );
}

// Usage
final apiClient = getIt<ApiClient>();
final repository = getIt<UserRepository>();
final bloc = getIt<UserBloc>();

// In main
void main() {
  setupDependencies();
  runApp(MyApp());
}
```

---

### 2. Registration Types

```dart
void setupDependencies() {
  // 1. Singleton - Single instance for app lifetime
  getIt.registerSingleton<ApiClient>(
    ApiClient(baseUrl: 'https://api.example.com'),
  );
  
  // 2. Lazy Singleton - Created when first accessed
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>()),
  );
  
  // 3. Factory - New instance every time
  getIt.registerFactory<UserBloc>(
    () => UserBloc(
      getUserUseCase: getIt(),
      updateUserUseCase: getIt(),
    ),
  );
  
  // 4. Factory with parameter
  getIt.registerFactoryParam<ProductBloc, String, void>(
    (productId, _) => ProductBloc(
      productId: productId,
      repository: getIt(),
    ),
  );
}

// Usage with parameter
final bloc = getIt<ProductBloc>(param1: 'product-123');
```

---

### 3. Dependency Graph

```dart
// injection.dart
Future<void> setupDependencies() async {
  // External dependencies
  getIt.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 30),
    ),
  ));
  
  getIt.registerLazySingleton(() => InternetConnectionChecker());
  
  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>()),
  );
  
  // Data sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );
  
  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteUserUseCase(getIt()));
  
  // Bloc/Cubit
  getIt.registerFactory(
    () => UserBloc(
      getUserUseCase: getIt(),
      updateUserUseCase: getIt(),
      deleteUserUseCase: getIt(),
    ),
  );
}
```

---

### 4. Multiple Environments

```dart
enum Environment { dev, staging, production }

Future<void> setupDependencies(Environment env) async {
  // Environment-specific config
  final baseUrl = switch (env) {
    Environment.dev => 'https://dev-api.example.com',
    Environment.staging => 'https://staging-api.example.com',
    Environment.production => 'https://api.example.com',
  };
  
  // Register with environment
  getIt.registerLazySingleton(() => Dio(
    BaseOptions(baseUrl: baseUrl),
  ));
  
  // Different implementations per environment
  if (env == Environment.dev) {
    getIt.registerLazySingleton<Logger>(
      () => DebugLogger(),
    );
  } else {
    getIt.registerLazySingleton<Logger>(
      () => ProductionLogger(),
    );
  }
  
  // Rest of dependencies...
}

// main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const environment = Environment.production;
  await setupDependencies(environment);
  
  runApp(MyApp());
}
```

---

### 5. Modules Pattern

```dart
// injection/user_module.dart
class UserModule {
  static Future<void> setup() async {
    // Data sources
    getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(getIt()),
    );
    
    getIt.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(),
    );
    
    // Repository
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    );
    
    // Use cases
    getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
    getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
    
    // Bloc
    getIt.registerFactory(() => UserBloc(
      getUserUseCase: getIt(),
      updateUserUseCase: getIt(),
    ));
  }
}

// injection/product_module.dart
class ProductModule {
  static Future<void> setup() async {
    // Product dependencies...
  }
}

// injection.dart
Future<void> setupDependencies() async {
  // Core
  await CoreModule.setup();
  
  // Features
  await UserModule.setup();
  await ProductModule.setup();
  await OrderModule.setup();
}
```

---

### 6. Testing with DI

```dart
void main() {
  setUp(() {
    // Reset GetIt before each test
    getIt.reset();
    
    // Register test doubles
    getIt.registerLazySingleton<UserRepository>(
      () => MockUserRepository(),
    );
    
    getIt.registerFactory(
      () => UserBloc(
        getUserUseCase: GetUserUseCase(getIt()),
        updateUserUseCase: UpdateUserUseCase(getIt()),
      ),
    );
  });
  
  test('bloc uses mocked repository', () async {
    final mockRepo = getIt<UserRepository>() as MockUserRepository;
    when(() => mockRepo.getUser('1')).thenAnswer(
      (_) async => Right(User(id: '1', name: 'Test')),
    );
    
    final bloc = getIt<UserBloc>();
    bloc.add(LoadUser('1'));
    
    await expectLater(
      bloc.stream,
      emits(isA<UserLoaded>()),
    );
  });
}
```

---

## ✅ Best Practices

### Rule 1: Register Before Use

```dart
// ✅ Good - Register in main before runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies(); // Register first
  runApp(MyApp());
}

// ❌ Bad - Use before registration
void main() {
  runApp(MyApp());
  setupDependencies(); // Too late!
}
```

---

### Rule 2: Use Interfaces

```dart
// ✅ Good - Register interface
abstract class UserRepository {
  Future<User> getUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    // Implementation
  }
}

getIt.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(getIt()),
);

// ❌ Bad - Register concrete class
getIt.registerLazySingleton(
  () => UserRepositoryImpl(getIt()),
);
```

---

### Rule 3: Lazy Loading

```dart
// ✅ Good - Lazy singleton for expensive objects
getIt.registerLazySingleton<Database>(
  () => Database(), // Only created when needed
);

// ❌ Bad - Eager singleton for all
getIt.registerSingleton<Database>(
  Database(), // Created immediately, even if never used
);
```

---

### Rule 4: Factory for Stateful Objects

```dart
// ✅ Good - Factory for Bloc (has state)
getIt.registerFactory(() => UserBloc(getIt()));

// ❌ Bad - Singleton for stateful object
getIt.registerSingleton(UserBloc(getIt())); // Shared state!
```

---

## 🎯 Real-World Example

```dart
// injection.dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // =========== External ==========
  // Dio
  getIt.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
    ),
  ));
  
  // Hive
  await Hive.initFlutter();
  await Hive.openBox('cache');
  getIt.registerLazySingleton(() => Hive.box('cache'));
  
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => prefs);
  
  // =========== Core ===========
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
  
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<Dio>()),
  );
  
  getIt.registerLazySingleton<CacheManager>(
    () => CacheManager(getIt()),
  );
  
  getIt.registerLazySingleton<PreferencesService>(
    () => PreferencesService(getIt()),
  );
  
  // =========== Auth Feature ===========
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  
  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  
  // Bloc
  getIt.registerFactory(() => AuthBloc(
    loginUseCase: getIt(),
    logoutUseCase: getIt(),
    getCurrentUserUseCase: getIt(),
  ));
  
  // =========== User Feature ===========
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
  
  getIt.registerFactory(() => UserBloc(
    getUserUseCase: getIt(),
    updateUserUseCase: getIt(),
  ));
  
  // =========== Product Feature ===========
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductByIdUseCase(getIt()));
  
  getIt.registerFactory(() => ProductBloc(
    getProductsUseCase: getIt(),
    getProductByIdUseCase: getIt(),
  ));
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp());
}

// Usage in widgets
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserBloc>()..add(LoadUser()),
      child: Scaffold(
        appBar: AppBar(title: Text('User')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            // Build UI
          },
        ),
      ),
    );
  }
}
```

---

## 🧪 Testing

```dart
// test/injection_test.dart
void main() {
  setUp(() async {
    await setupTestDependencies();
  });
  
  tearDown(() {
    getIt.reset();
  });
  
  test('dependencies are registered correctly', () {
    expect(getIt.isRegistered<ApiClient>(), true);
    expect(getIt.isRegistered<UserRepository>(), true);
    expect(getIt.isRegistered<UserBloc>(), true);
  });
  
  test('factory creates new instances', () {
    final bloc1 = getIt<UserBloc>();
    final bloc2 = getIt<UserBloc>();
    
    expect(bloc1, isNot(same(bloc2)));
  });
  
  test('singleton returns same instance', () {
    final repo1 = getIt<UserRepository>();
    final repo2 = getIt<UserRepository>();
    
    expect(repo1, same(repo2));
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - getIt setup in main
  - proper registration types
  - interface registration
  - dependency graph order
  - test setup with mocks

suggest:
  - use lazy singleton
  - register interfaces
  - factory for stateful
  - modules for features
  - reset in tests

enforce:
  - setup before runApp
  - register interfaces not implementations
  - proper lifecycle (singleton vs factory)
  - reset in test tearDown
```

---

## 📊 Registration Guide

| Type | Use For | Lifecycle |
|------|---------|-----------|
| **Singleton** | Immediate creation | App lifetime |
| **LazySingleton** | Services, Repositories | App lifetime |
| **Factory** | Blocs, Controllers | Per request |
| **FactoryParam** | With parameters | Per request |

---

## 🔗 Related Rules

- [Clean Architecture](./clean-architecture.md)
- [Repository Pattern](./repository-pattern.md)
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Package:** get_it  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

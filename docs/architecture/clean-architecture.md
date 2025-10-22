# Clean Architecture

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Architecture
applies_to:
  - medium_to_large_projects
complexity: high
ai_agent_tags:
  - architecture
  - clean-architecture
  - separation-of-concerns
  - testability
  - scalability
```

---

## 🎯 Overview

**Clean Architecture** يفصل التطبيق إلى طبقات مستقلة. كل طبقة لها مسؤولية واحدة ولا تعتمد على التفاصيل الخارجية.

### Why Clean Architecture?
- 🎯 Separation of concerns
- 🧪 سهولة الاختبار
- 🔄 سهولة تبديل المكونات
- 📊 Business logic مستقل
- 🚀 Scalability

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` للمشاريع المتوسطة والكبيرة

---

## 📚 Core Concepts

### 1. The Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, State Management)        │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│         Application Layer               │
│     (Use Cases, Business Logic)         │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│          Domain Layer                   │
│    (Entities, Repository Interfaces)    │
└───────────────┬─────────────────────────┘
                │
┌───────────────▼─────────────────────────┐
│           Data Layer                    │
│  (Repository Impl, Data Sources, API)   │
└─────────────────────────────────────────┘
```

**Dependency Rule:** Outer layers depend on inner layers, **never the reverse**.

---

### 2. Domain Layer - The Core

#### Entities
```dart
// domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  
  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

#### Repository Interfaces
```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(UserParams params);
  Future<Either<Failure, Unit>> deleteUser(String id);
}
```

#### Failures
```dart
// domain/failures/failure.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
```

---

### 3. Application Layer - Use Cases

```dart
// application/usecases/get_user_usecase.dart
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUser(userId);
  }
}

// application/usecases/create_user_usecase.dart
class CreateUserUseCase {
  final UserRepository repository;
  
  CreateUserUseCase(this.repository);
  
  Future<Either<Failure, User>> call(CreateUserParams params) async {
    // Business logic validation
    if (params.name.isEmpty) {
      return Left(ValidationFailure('Name cannot be empty'));
    }
    
    if (!_isValidEmail(params.email)) {
      return Left(ValidationFailure('Invalid email'));
    }
    
    return await repository.createUser(params);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class CreateUserParams {
  final String name;
  final String email;
  
  CreateUserParams({
    required this.name,
    required this.email,
  });
}
```

---

### 4. Data Layer - Implementation

#### Models (Data Transfer Objects)
```dart
// data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  // Convert to Domain Entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: DateTime.parse(createdAt),
    );
  }
  
  // Convert from Domain Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toIso8601String(),
    );
  }
}
```

#### Data Sources
```dart
// data/datasources/user_remote_datasource.dart
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(CreateUserParams params);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient client;
  
  UserRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> getUser(String id) async {
    try {
      final response = await client.get('/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
  
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await client.get('/users');
      return (response.data as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
  
  @override
  Future<UserModel> createUser(CreateUserParams params) async {
    try {
      final response = await client.post(
        '/users',
        data: {
          'name': params.name,
          'email': params.email,
        },
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
  
  @override
  Future<void> deleteUser(String id) async {
    try {
      await client.delete('/users/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
```

```dart
// data/datasources/user_local_datasource.dart
abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser(String id);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> cacheBox;
  
  UserLocalDataSourceImpl(this.cacheBox);
  
  @override
  Future<UserModel?> getCachedUser(String id) async {
    return cacheBox.get(id);
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await cacheBox.put(user.id, user);
  }
  
  @override
  Future<void> clearCache() async {
    await cacheBox.clear();
  }
}
```

#### Repository Implementation
```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.getUser(id);
        await localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final userModel = await localDataSource.getCachedUser(id);
        if (userModel != null) {
          return Right(userModel.toEntity());
        } else {
          return Left(CacheFailure('No cached data'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final userModels = await remoteDataSource.getUsers();
      return Right(userModels.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, User>> createUser(CreateUserParams params) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final userModel = await remoteDataSource.createUser(params);
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> deleteUser(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    
    try {
      await remoteDataSource.deleteUser(id);
      return Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

---

### 5. Presentation Layer

#### State Management with Bloc
```dart
// presentation/bloc/user_bloc.dart
sealed class UserEvent {}

class LoadUser extends UserEvent {
  final String userId;
  LoadUser(this.userId);
}

class CreateUser extends UserEvent {
  final CreateUserParams params;
  CreateUser(this.params);
}

sealed class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  final CreateUserUseCase createUserUseCase;
  
  UserBloc({
    required this.getUserUseCase,
    required this.createUserUseCase,
  }) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<CreateUser>(_onCreateUser);
  }
  
  Future<void> _onLoadUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    final result = await getUserUseCase(event.userId);
    
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
  
  Future<void> _onCreateUser(
    CreateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    
    final result = await createUserUseCase(event.params);
    
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
```

#### UI
```dart
// presentation/pages/user_page.dart
class UserPage extends StatelessWidget {
  final String userId;
  
  const UserPage({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserBloc>()..add(LoadUser(userId)),
      child: Scaffold(
        appBar: AppBar(title: Text('User Details')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return switch (state) {
              UserInitial() || UserLoading() => 
                Center(child: CircularProgressIndicator()),
              
              UserLoaded(:final user) => _UserContent(user: user),
              
              UserError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(LoadUser(userId));
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _UserContent extends StatelessWidget {
  final User user;
  
  const _UserContent({required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
          Text('Created: ${user.createdAt}'),
        ],
      ),
    );
  }
}
```

---

### 6. Dependency Injection

```dart
// injection.dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => Hive);
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  // Data sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(getIt()),
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
  getIt.registerLazySingleton(() => CreateUserUseCase(getIt()));
  
  // Bloc
  getIt.registerFactory(
    () => UserBloc(
      getUserUseCase: getIt(),
      createUserUseCase: getIt(),
    ),
  );
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(MyApp());
}
```

---

## ✅ Best Practices

### Rule 1: Keep Domain Layer Pure

```dart
// ✅ Good - Pure domain entity
class User {
  final String id;
  final String name;
  final String email;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
  });
}

// ❌ Bad - Domain depends on external package
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()  // ❌ NO! This is data layer concern
class User {
  final String id;
  final String name;
}
```

---

### Rule 2: Use Either for Results

```dart
// ✅ Good - Explicit error handling
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await api.getUser(id);
    return Right(user);
  } catch (e) {
    return Left(ServerFailure('Failed to get user'));
  }
}

// Usage
final result = await getUser('123');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Success: ${user.name}'),
);
```

---

## 🧪 Testing Clean Architecture

```dart
// Test Use Case
void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });
  
  test('should return User from repository', () async {
    // Arrange
    final user = User(id: '1', name: 'Ahmed', email: 'ahmed@example.com');
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => Right(user));
    
    // Act
    final result = await useCase('1');
    
    // Assert
    expect(result, Right(user));
    verify(() => mockRepository.getUser('1')).called(1);
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - proper layer separation
  - domain layer purity
  - repository interfaces in domain
  - use cases for business logic
  - Either for error handling
  - dependency injection
  - proper folder structure

suggest:
  - extract use cases
  - create repository interfaces
  - implement data sources
  - add dependency injection
  - use Either type

enforce:
  - no framework imports in domain
  - repository pattern
  - use case per feature
  - proper error handling
```

---

## 📊 Folder Structure

```
lib/
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── user_repository.dart
│   └── failures/
│       └── failure.dart
├── application/
│   └── usecases/
│       ├── get_user_usecase.dart
│       └── create_user_usecase.dart
├── data/
│   ├── models/
│   │   └── user_model.dart
│   ├── datasources/
│   │   ├── user_remote_datasource.dart
│   │   └── user_local_datasource.dart
│   └── repositories/
│       └── user_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   └── user_bloc.dart
│   ├── pages/
│   │   └── user_page.dart
│   └── widgets/
│       └── user_card.dart
└── injection.dart
```

---

## 🔗 Related Rules

- [Layered Architecture](./layered-arch.md)
- [Repository Pattern](./repository-pattern.md)
- [Dependency Injection](./dependency-injection.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**For:** Medium-Large Projects  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

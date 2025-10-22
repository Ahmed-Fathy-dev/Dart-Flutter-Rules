# Feature-Based Organization

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Architecture
applies_to:
  - medium_to_large_projects
scalability: high
ai_agent_tags:
  - architecture
  - organization
  - features
  - modularity
  - scalability
```

---

## 🎯 Overview

**Feature-Based Organization** يقسم التطبيق حسب الـ features بدلاً من الأنواع. كل feature مستقل ويحتوي على كل ما يحتاجه.

### Why Feature-Based?
- 📦 Easy to scale
- 🎯 Clear boundaries
- 👥 Team collaboration
- 🔄 Easy to add/remove features
- 📊 Better code organization

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` للمشاريع المتوسطة-الكبيرة

---

## 📚 Core Concepts

### 1. Feature Structure

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   ├── home/
│   ├── profile/
│   └── settings/
├── core/
│   ├── network/
│   ├── utils/
│   └── constants/
└── shared/
    ├── widgets/
    └── models/
```

---

### 2. Auth Feature Example

```dart
// features/auth/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String name;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
  });
}

// features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}

// features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<Either<Failure, User>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return Left(ValidationFailure('Email and password required'));
    }
    
    return await repository.login(email, password);
  }
}

// features/auth/data/models/user_model.dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  User toEntity() => User(id: id, email: email, name: name);
}

// features/auth/data/datasources/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response.data);
  }
  
  @override
  Future<void> logout() async {
    await client.post('/auth/logout');
  }
}

// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      return Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    // Implementation
    throw UnimplementedError();
  }
}

// features/auth/presentation/bloc/auth_bloc.dart
sealed class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

sealed class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUseCase(event.email, event.password);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
  
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}

// features/auth/presentation/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            return _LoginForm();
          },
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                LoginRequested(
                  _emailController.text,
                  _passwordController.text,
                ),
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

---

### 3. Dependency Injection Per Feature

```dart
// features/auth/injection.dart
Future<void> setupAuthDependencies() async {
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  
  // Bloc
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );
}

// main.dart
Future<void> setupDependencies() async {
  await setupCoreDependencies();
  await setupAuthDependencies();
  await setupHomeDependencies();
  await setupProfileDependencies();
}
```

---

### 4. Feature Routes

```dart
// features/auth/routes.dart
class AuthRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  
  static List<GoRoute> routes = [
    GoRoute(
      path: login,
      name: 'login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: register,
      name: 'register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => ForgotPasswordPage(),
    ),
  ];
}

// app/router.dart
final router = GoRouter(
  routes: [
    ...AuthRoutes.routes,
    ...HomeRoutes.routes,
    ...ProfileRoutes.routes,
  ],
);
```

---

### 5. Shared Components

```dart
// shared/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

// shared/models/api_response.dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}
```

---

### 6. Core Components

```dart
// core/network/api_client.dart
class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio);
  
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
  
  Future<Response> post(String path, {Object? data}) async {
    return await _dio.post(path, data: data);
  }
}

// core/utils/validators.dart
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }
}

// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'My App';
  static const Duration timeout = Duration(seconds: 30);
}
```

---

## ✅ Best Practices

### Rule 1: Feature Independence

```dart
// ✅ Good - Feature is self-contained
features/auth/
├── data/
├── domain/
├── presentation/
├── injection.dart
└── routes.dart

// ❌ Bad - Features depend on each other directly
// auth feature imports from profile feature ❌
import '../profile/domain/entities/profile.dart';
```

---

### Rule 2: Shared vs Feature-Specific

```dart
// ✅ Shared - Used by multiple features
shared/widgets/custom_button.dart
shared/models/api_response.dart

// ✅ Feature-specific - Only used in one feature
features/auth/presentation/widgets/login_form.dart
features/profile/presentation/widgets/avatar_picker.dart

// ❌ Bad - Feature-specific in shared
shared/widgets/login_form.dart  // ❌ Only used in auth!
```

---

## 🎯 Complete Structure Example

```
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
│
├── core/
│   ├── di/
│   │   └── injection.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── constants/
│       └── app_constants.dart
│
├── shared/
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   │   └── error_widget.dart
│   └── models/
│       └── api_response.dart
│
└── features/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   ├── presentation/
    │   ├── injection.dart
    │   └── routes.dart
    │
    ├── home/
    │   ├── data/
    │   ├── domain/
    │   ├── presentation/
    │   ├── injection.dart
    │   └── routes.dart
    │
    ├── profile/
    │   ├── data/
    │   ├── domain/
    │   ├── presentation/
    │   ├── injection.dart
    │   └── routes.dart
    │
    └── settings/
        ├── data/
        ├── domain/
        ├── presentation/
        ├── injection.dart
        └── routes.dart
```

---

## 🧪 Testing Per Feature

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  group('LoginUseCase', () {
    test('should return User on successful login', () async {
      // Test implementation
    });
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - feature folders
  - feature independence
  - proper shared/core usage
  - DI per feature
  - routes per feature
  - clean folder structure

suggest:
  - organize by features
  - extract shared components
  - implement core utilities
  - add feature-specific DI
  - create feature routes

enforce:
  - no cross-feature imports
  - shared for common code
  - core for infrastructure
  - features are self-contained
```

---

## 📊 Benefits

| Aspect | Benefit |
|--------|---------|
| **Scalability** | Easy to add new features |
| **Team Work** | Clear feature ownership |
| **Maintenance** | Changes isolated to features |
| **Testing** | Test features independently |
| **Code Review** | Smaller, focused PRs |

---

## 🔗 Related Rules

- [Clean Architecture](./clean-architecture.md)
- [Layered Architecture](./layered-arch.md)
- [Dependency Injection](./dependency-injection.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**For:** Medium-Large Projects  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

# Repository Pattern

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Architecture
applies_to:
  - all_projects_with_data
ai_agent_tags:
  - architecture
  - repository
  - data-layer
  - abstraction
  - testability
```

---

## 🎯 Overview

**Repository Pattern** يفصل منطق الوصول للبيانات عن Business Logic. يوفر واجهة موحدة للتعامل مع مصادر البيانات المختلفة.

### Why Repository?
- 🎯 Single source of truth
- 🔄 Easy data source switching
- 🧪 Easier testing
- 📦 Cleaner architecture
- 🚀 Better caching

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` لجميع المشاريع مع بيانات

---

## 📚 Core Concepts

### 1. Basic Repository

```dart
// Domain layer - Interface
abstract class UserRepository {
  Future<User> getUser(String id);
  Future<List<User>> getUsers();
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
  Future<void> deleteUser(String id);
}

// Data layer - Implementation
class UserRepositoryImpl implements UserRepository {
  final ApiClient _api;
  
  UserRepositoryImpl(this._api);
  
  @override
  Future<User> getUser(String id) async {
    final response = await _api.get('/users/$id');
    return User.fromJson(response.data);
  }
  
  @override
  Future<List<User>> getUsers() async {
    final response = await _api.get('/users');
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
  
  @override
  Future<User> createUser(User user) async {
    final response = await _api.post(
      '/users',
      data: user.toJson(),
    );
    return User.fromJson(response.data);
  }
  
  @override
  Future<User> updateUser(User user) async {
    final response = await _api.put(
      '/users/${user.id}',
      data: user.toJson(),
    );
    return User.fromJson(response.data);
  }
  
  @override
  Future<void> deleteUser(String id) async {
    await _api.delete('/users/$id');
  }
}
```

---

### 2. Multi-Source Repository

```dart
// Data sources
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getUsers();
}

abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser(String id);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

// Implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _api;
  
  UserRemoteDataSourceImpl(this._api);
  
  @override
  Future<UserModel> getUser(String id) async {
    final response = await _api.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
  
  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _api.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> _box;
  
  UserLocalDataSourceImpl(this._box);
  
  @override
  Future<UserModel?> getCachedUser(String id) async {
    return _box.get(id);
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await _box.put(user.id, user);
  }
  
  @override
  Future<void> clearCache() async {
    await _box.clear();
  }
}

// Repository with cache
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;
  final NetworkInfo _networkInfo;
  
  UserRepositoryImpl({
    required UserRemoteDataSource remote,
    required UserLocalDataSource local,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _local = local,
        _networkInfo = networkInfo;
  
  @override
  Future<User> getUser(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        // Get from remote
        final userModel = await _remote.getUser(id);
        
        // Cache it
        await _local.cacheUser(userModel);
        
        // Return entity
        return userModel.toEntity();
      } catch (e) {
        // If remote fails, try cache
        final cached = await _local.getCachedUser(id);
        if (cached != null) {
          return cached.toEntity();
        }
        rethrow;
      }
    } else {
      // No internet, use cache
      final cached = await _local.getCachedUser(id);
      if (cached != null) {
        return cached.toEntity();
      }
      throw NetworkException('No internet and no cached data');
    }
  }
  
  @override
  Future<List<User>> getUsers() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }
    
    final userModels = await _remote.getUsers();
    return userModels.map((m) => m.toEntity()).toList();
  }
}
```

---

### 3. Repository with Either (Error Handling)

```dart
// Using dartz package
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;
  
  UserRepositoryImpl(this._remote, this._local);
  
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final userModel = await _remote.getUser(id);
      await _local.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Try cache
      try {
        final cached = await _local.getCachedUser(id);
        if (cached != null) {
          return Right(cached.toEntity());
        }
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('No cached data'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final userModels = await _remote.getUsers();
      return Right(userModels.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final created = await _remote.createUser(userModel);
      await _local.cacheUser(created);
      return Right(created.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

// Usage
final result = await repository.getUser('123');
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Success: ${user.name}'),
);
```

---

### 4. Generic Repository

```dart
// Generic interface
abstract class Repository<T, ID> {
  Future<T> getById(ID id);
  Future<List<T>> getAll();
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<void> delete(ID id);
}

// Generic implementation
class BaseRepository<T, ID> implements Repository<T, ID> {
  final ApiClient _api;
  final String _endpoint;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;
  
  BaseRepository({
    required ApiClient api,
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  })  : _api = api,
        _endpoint = endpoint,
        _fromJson = fromJson,
        _toJson = toJson;
  
  @override
  Future<T> getById(ID id) async {
    final response = await _api.get('$_endpoint/$id');
    return _fromJson(response.data);
  }
  
  @override
  Future<List<T>> getAll() async {
    final response = await _api.get(_endpoint);
    return (response.data as List)
        .map((json) => _fromJson(json))
        .toList();
  }
  
  @override
  Future<T> create(T entity) async {
    final response = await _api.post(
      _endpoint,
      data: _toJson(entity),
    );
    return _fromJson(response.data);
  }
  
  @override
  Future<T> update(T entity) async {
    final id = (entity as dynamic).id; // Assumes entity has id
    final response = await _api.put(
      '$_endpoint/$id',
      data: _toJson(entity),
    );
    return _fromJson(response.data);
  }
  
  @override
  Future<void> delete(ID id) async {
    await _api.delete('$_endpoint/$id');
  }
}

// Usage
final userRepository = BaseRepository<User, String>(
  api: apiClient,
  endpoint: '/users',
  fromJson: User.fromJson,
  toJson: (user) => user.toJson(),
);

final productRepository = BaseRepository<Product, String>(
  api: apiClient,
  endpoint: '/products',
  fromJson: Product.fromJson,
  toJson: (product) => product.toJson(),
);
```

---

### 5. Repository with Pagination

```dart
class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int totalPages;
  final int totalItems;
  final bool hasMore;
  
  PaginatedResult({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.hasMore,
  });
}

abstract class UserRepository {
  Future<PaginatedResult<User>> getUsers({
    int page = 1,
    int limit = 20,
  });
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient _api;
  
  UserRepositoryImpl(this._api);
  
  @override
  Future<PaginatedResult<User>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _api.get(
      '/users',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    
    final data = response.data;
    final users = (data['items'] as List)
        .map((json) => User.fromJson(json))
        .toList();
    
    return PaginatedResult(
      items: users,
      page: data['page'],
      totalPages: data['total_pages'],
      totalItems: data['total_items'],
      hasMore: data['has_more'],
    );
  }
}
```

---

### 6. Repository with Filtering

```dart
class UserFilter {
  final String? search;
  final UserRole? role;
  final bool? isActive;
  final DateTime? createdAfter;
  
  UserFilter({
    this.search,
    this.role,
    this.isActive,
    this.createdAfter,
  });
  
  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null) 'search': search,
      if (role != null) 'role': role!.name,
      if (isActive != null) 'is_active': isActive,
      if (createdAfter != null) 
        'created_after': createdAfter!.toIso8601String(),
    };
  }
}

abstract class UserRepository {
  Future<List<User>> getUsers({
    UserFilter? filter,
    int page = 1,
    int limit = 20,
  });
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient _api;
  
  UserRepositoryImpl(this._api);
  
  @override
  Future<List<User>> getUsers({
    UserFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      ...?filter?.toQueryParameters(),
    };
    
    final response = await _api.get(
      '/users',
      queryParameters: queryParams,
    );
    
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
}

// Usage
final users = await repository.getUsers(
  filter: UserFilter(
    search: 'ahmed',
    role: UserRole.admin,
    isActive: true,
  ),
  page: 1,
  limit: 20,
);
```

---

## ✅ Best Practices

### Rule 1: Interface in Domain, Implementation in Data

```dart
// ✅ Good - Clear separation
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
}

// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    // Implementation
  }
}

// ❌ Bad - No interface
// data/repositories/user_repository.dart
class UserRepository {  // ❌ No abstraction
  Future<User> getUser(String id) async {
    // Implementation
  }
}
```

---

### Rule 2: Handle Errors Properly

```dart
// ✅ Good - Clear error handling
@override
Future<Either<Failure, User>> getUser(String id) async {
  try {
    final user = await _remote.getUser(id);
    return Right(user.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(e.message));
  }
}

// ❌ Bad - Swallowing errors
@override
Future<User?> getUser(String id) async {
  try {
    return await _remote.getUser(id);
  } catch (e) {
    return null; // ❌ Lost error information
  }
}
```

---

### Rule 3: Repository Returns Domain Entities

```dart
// ✅ Good - Returns domain entity
abstract class UserRepository {
  Future<User> getUser(String id);  // Domain entity
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    final userModel = await _remote.getUser(id);  // Data model
    return userModel.toEntity();  // Convert to entity
  }
}

// ❌ Bad - Returns data model
abstract class UserRepository {
  Future<UserModel> getUser(String id);  // ❌ Data layer leaking
}
```

---

## 🎯 Real-World Example: E-commerce

```dart
// Domain
abstract class ProductRepository {
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, PaginatedResult<Product>>> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
}

// Data sources
abstract class ProductRemoteDataSource {
  Future<ProductModel> getProduct(String id);
  Future<PaginatedResponse<ProductModel>> getProducts({
    Map<String, dynamic>? queryParams,
  });
}

abstract class ProductLocalDataSource {
  Future<ProductModel?> getCachedProduct(String id);
  Future<void> cacheProduct(ProductModel product);
  Future<List<ProductModel>> getCachedFeaturedProducts();
  Future<void> cacheFeaturedProducts(List<ProductModel> products);
}

// Implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;
  final NetworkInfo _networkInfo;
  
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _local = local,
        _networkInfo = networkInfo;
  
  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final productModel = await _remote.getProduct(id);
        await _local.cacheProduct(productModel);
        return Right(productModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        // Try cache
        final cached = await _local.getCachedProduct(id);
        if (cached != null) {
          return Right(cached.toEntity());
        }
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      // Use cache
      final cached = await _local.getCachedProduct(id);
      if (cached != null) {
        return Right(cached.toEntity());
      }
      return Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, PaginatedResult<Product>>> getProducts({
    ProductFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        ...?filter?.toQueryParameters(),
      };
      
      final response = await _remote.getProducts(
        queryParams: queryParams,
      );
      
      final products = response.items
          .map((m) => m.toEntity())
          .toList();
      
      return Right(PaginatedResult(
        items: products,
        page: response.page,
        totalPages: response.totalPages,
        totalItems: response.totalItems,
        hasMore: response.hasMore,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remote.getProducts(
          queryParams: {'featured': true, 'limit': 10},
        );
        
        final products = response.items;
        
        // Cache for offline
        await _local.cacheFeaturedProducts(products);
        
        return Right(products.map((m) => m.toEntity()).toList());
      } catch (e) {
        // Try cache
        final cached = await _local.getCachedFeaturedProducts();
        if (cached.isNotEmpty) {
          return Right(cached.map((m) => m.toEntity()).toList());
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // Use cache
      final cached = await _local.getCachedFeaturedProducts();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(NetworkFailure('No internet and no cached data'));
    }
  }
  
  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    
    try {
      final response = await _remote.getProducts(
        queryParams: {'search': query, 'limit': 50},
      );
      
      return Right(response.items.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

## 🧪 Testing Repository

```dart
void main() {
  late ProductRepository repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;
  late MockNetworkInfo mockNetworkInfo;
  
  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    
    repository = ProductRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      networkInfo: mockNetworkInfo,
    );
  });
  
  group('getProduct', () {
    test('returns product from remote when connected', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      final productModel = ProductModel(id: '1', name: 'Test');
      when(() => mockRemote.getProduct('1'))
          .thenAnswer((_) async => productModel);
      when(() => mockLocal.cacheProduct(any()))
          .thenAnswer((_) async => {});
      
      // Act
      final result = await repository.getProduct('1');
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return product'),
        (product) => expect(product.id, '1'),
      );
      verify(() => mockRemote.getProduct('1')).called(1);
      verify(() => mockLocal.cacheProduct(productModel)).called(1);
    });
    
    test('returns cached product when no internet', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      final cachedModel = ProductModel(id: '1', name: 'Cached');
      when(() => mockLocal.getCachedProduct('1'))
          .thenAnswer((_) async => cachedModel);
      
      // Act
      final result = await repository.getProduct('1');
      
      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemote.getProduct(any()));
      verify(() => mockLocal.getCachedProduct('1')).called(1);
    });
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - repository interface
  - implementation class
  - data source separation
  - error handling
  - caching strategy
  - entity conversion
  - network check

suggest:
  - create repository interface
  - separate data sources
  - implement caching
  - use Either for errors
  - convert models to entities
  - add offline support

enforce:
  - interface in domain layer
  - implementation in data layer
  - proper error handling
  - entity returns (not models)
  - tests for repository
```

---

## 📊 Summary Checklist

```markdown
- [ ] Repository interface created
- [ ] Implementation in data layer
- [ ] Data sources separated
- [ ] Error handling with Either
- [ ] Caching implemented
- [ ] Models converted to entities
- [ ] Offline support
- [ ] Tests written
```

---

## 🔗 Related Rules

- [Clean Architecture](./clean-architecture.md)
- [Dependency Injection](./dependency-injection.md)
- [Error Handling](../core/error-handling.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**For:** All Projects with Data  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

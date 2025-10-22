# HTTP Clients & API Communication

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Data
applies_to:
  - all_projects_with_api
recommended_package: dio
ai_agent_tags:
  - data
  - http
  - api
  - networking
  - dio
```

---

## 🎯 Overview

**HTTP Client** للتواصل مع APIs. استخدام **Dio** موصى به لمزاياه العديدة.

### Why Dio?
- ✅ Interceptors
- 🔄 Retry logic
- ⏱️ Timeout handling
- 📊 Progress tracking
- 🚫 Request cancellation

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` - استخدم Dio

---

## 📚 Core Concepts

### 1. Setup Dio

#### pubspec.yaml
```yaml
dependencies:
  dio: ^5.9.0  # ✅ Latest stable (Aug 2025)
```

#### Basic Client
```dart
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://api.example.com',
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }
  
  Dio get dio => _dio;
}
```

---

### 2. Basic Requests

```dart
class ApiClient {
  final Dio _dio;
  
  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // POST request
  Future<Response> post(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // PUT request
  Future<Response> put(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // DELETE request
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException('Request timeout');
        
      case DioExceptionType.badResponse:
        return ApiException(
          statusCode: error.response?.statusCode,
          message: error.response?.data['message'] ?? 'Server error',
        );
        
      case DioExceptionType.cancel:
        return RequestCancelledException();
        
      default:
        return NetworkException('Network error: ${error.message}');
    }
  }
}
```

---

### 3. Interceptors

#### Auth Interceptor
```dart
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  
  AuthInterceptor(this._tokenStorage);
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - refresh token
    if (err.response?.statusCode == 401) {
      try {
        // Refresh token
        final newToken = await _tokenStorage.refreshToken();
        
        // Retry original request
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';
        
        final response = await Dio().fetch(options);
        handler.resolve(response);
        return;
      } catch (e) {
        // Refresh failed - logout
        await _tokenStorage.clearToken();
        handler.next(err);
        return;
      }
    }
    
    handler.next(err);
  }
}
```

#### Retry Interceptor
```dart
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.unknown;
    
    if (!shouldRetry) {
      handler.next(err);
      return;
    }
    
    final retryCount = err.requestOptions.extra['retry_count'] as int? ?? 0;
    
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }
    
    // Wait before retry
    await Future.delayed(retryDelay * (retryCount + 1));
    
    // Retry request
    err.requestOptions.extra['retry_count'] = retryCount + 1;
    
    try {
      final response = await Dio().fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}
```

#### Cache Interceptor
```dart
class CacheInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};
  final Duration cacheDuration;
  
  CacheInterceptor({
    this.cacheDuration = const Duration(minutes: 5),
  });
  
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Only cache GET requests
    if (options.method != 'GET') {
      handler.next(options);
      return;
    }
    
    final cacheKey = _getCacheKey(options);
    final cached = _cache[cacheKey];
    
    if (cached != null && !cached.isExpired) {
      handler.resolve(cached.response);
      return;
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.method == 'GET') {
      final cacheKey = _getCacheKey(response.requestOptions);
      _cache[cacheKey] = CacheEntry(
        response: response,
        expiry: DateTime.now().add(cacheDuration),
      );
    }
    
    handler.next(response);
  }
  
  String _getCacheKey(RequestOptions options) {
    return '${options.path}${options.queryParameters}';
  }
}

class CacheEntry {
  final Response response;
  final DateTime expiry;
  
  CacheEntry({required this.response, required this.expiry});
  
  bool get isExpired => DateTime.now().isAfter(expiry);
}
```

#### Pretty Dio Logger (Recommended! 🎨)

**pretty_dio_logger** يوفر logs جميلة وقابلة للقراءة. أفضل من `LogInterceptor` الافتراضي!

##### Setup
```yaml
dependencies:
  dio: ^5.9.0
  pretty_dio_logger: ^1.4.0  # ✅ Latest (2025-10-22)
```

##### Basic Usage
```dart
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    
    // Add pretty logger
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}
```

##### Conditional Logging (Production)
```dart
class ApiClient {
  ApiClient() {
    _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    
    // Only log in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,  // More detailed in debug
        ),
      );
    }
  }
}
```

##### Custom Configuration
```dart
_dio.interceptors.add(
  PrettyDioLogger(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
    // Colors
    colors: {
      'request': AnsiPen()..cyan(),
      'response': AnsiPen()..green(),
      'error': AnsiPen()..red(),
    },
    // Filter sensitive data
    filter: (log, args) {
      // Remove sensitive headers
      if (log.contains('Authorization')) {
        return 'Authorization: [REDACTED]';
      }
      return log;
    },
  ),
);
```

##### Output Example
```bash
╔╣ Request ║ POST ║ https://api.example.com/users
╟ Headers:
║  Content-Type: application/json
║  Authorization: Bearer [REDACTED]
╟ Body:
║  {
║    "name": "Ahmed",
║    "email": "ahmed@example.com"
║  }
╚═══════════════════════════════════════════

╔╣ Response ║ POST ║ https://api.example.com/users ║ Status: 201 ║ 234ms
╟ Body:
║  {
║    "id": "123",
║    "name": "Ahmed",
║    "email": "ahmed@example.com",
║    "createdAt": "2025-10-22T00:00:00Z"
║  }
╚═══════════════════════════════════════════
```

##### With Talker Integration
```dart
import 'package:talker_dio_logger/talker_dio_logger.dart';

class ApiClient {
  ApiClient({required Talker talker}) {
    _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    
    // Use Talker logger (even better!)
    _dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: false,
          printRequestData: true,
          printResponseData: true,
        ),
      ),
    );
  }
}
```

##### Comparison: LogInterceptor vs Pretty Dio Logger

| Feature | LogInterceptor | PrettyDioLogger |
|---------|---------------|-----------------|
| **Readability** | ⚠️ Poor | ✅ **Excellent** |
| **Colors** | ❌ No | ✅ **Yes** |
| **Formatting** | ❌ Basic | ✅ **Beautiful** |
| **Compact Mode** | ❌ No | ✅ **Yes** |
| **Filter Sensitive** | ❌ Manual | ✅ **Built-in** |
| **Size** | 🟢 Small | 🟡 Medium |

**Recommendation:** Use `PrettyDioLogger` for development, `TalkerDioLogger` for production!

---

### 4. File Upload/Download

#### Upload
```dart
class ApiClient {
  Future<Response> uploadFile(
    String path,
    File file, {
    Map<String, dynamic>? data,
    ProgressCallback? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      ...?data,
    });
    
    return await _dio.post(
      path,
      data: formData,
      onSendProgress: onProgress,
    );
  }
  
  Future<Response> uploadMultipleFiles(
    String path,
    List<File> files, {
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData.fromMap({
      'files': [
        for (var file in files)
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
      ],
      ...?data,
    });
    
    return await _dio.post(path, data: formData);
  }
}
```

#### Download
```dart
class ApiClient {
  Future<void> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );
  }
}

// Usage
final cancelToken = CancelToken();

await apiClient.downloadFile(
  'https://example.com/file.pdf',
  '/path/to/save/file.pdf',
  onProgress: (received, total) {
    final progress = (received / total * 100).toStringAsFixed(0);
    print('Download progress: $progress%');
  },
  cancelToken: cancelToken,
);

// Cancel download
cancelToken.cancel('User cancelled');
```

---

## ✅ Best Practices

### Rule 1: Repository Pattern

```dart
// repository/user_repository.dart
class UserRepository {
  final ApiClient _api;
  
  UserRepository(this._api);
  
  Future<User> getUser(String id) async {
    try {
      final response = await _api.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw RepositoryException('Failed to get user', originalError: e);
    }
  }
  
  Future<List<User>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _api.get(
      '/users',
      queryParameters: {'page': page, 'limit': limit},
    );
    
    return (response.data as List)
        .map((json) => User.fromJson(json))
        .toList();
  }
  
  Future<User> createUser(UserCreateDto dto) async {
    final response = await _api.post(
      '/users',
      data: dto.toJson(),
    );
    return User.fromJson(response.data);
  }
  
  Future<User> updateUser(String id, UserUpdateDto dto) async {
    final response = await _api.put(
      '/users/$id',
      data: dto.toJson(),
    );
    return User.fromJson(response.data);
  }
  
  Future<void> deleteUser(String id) async {
    await _api.delete('/users/$id');
  }
}
```

---

### Rule 2: Custom Exceptions

```dart
// exceptions.dart
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;
  
  ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException implements Exception {
  final String message;
  
  TimeoutException(this.message);
  
  @override
  String toString() => 'TimeoutException: $message';
}

class RequestCancelledException implements Exception {
  @override
  String toString() => 'Request was cancelled';
}
```

---

### Rule 3: Environment Configuration

```dart
// config/api_config.dart
enum Environment { dev, staging, production }

class ApiConfig {
  static Environment _environment = Environment.dev;
  
  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }
  
  static Duration get timeout {
    return _environment == Environment.dev
        ? Duration(seconds: 60)
        : Duration(seconds: 30);
  }
  
  static bool get enableLogging {
    return _environment != Environment.production;
  }
  
  static void setEnvironment(Environment env) {
    _environment = env;
  }
}

// Usage
void main() {
  ApiConfig.setEnvironment(Environment.production);
  
  final apiClient = ApiClient(
    baseUrl: ApiConfig.baseUrl,
    timeout: ApiConfig.timeout,
    enableLogging: ApiConfig.enableLogging,
  );
  
  runApp(MyApp());
}
```

---

## 🎯 Real-World Example: E-commerce API

```dart
// api_client.dart
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      if (ApiConfig.enableLogging)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      AuthInterceptor(TokenStorage()),
      RetryInterceptor(maxRetries: 3),
      CacheInterceptor(cacheDuration: Duration(minutes: 5)),
    ]);
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {Object? data}) async {
    return await _dio.post(path, data: data);
  }
}

// repositories/product_repository.dart
class ProductRepository {
  final ApiClient _api;
  
  ProductRepository(this._api);
  
  Future<PaginatedResponse<Product>> getProducts({
    int page = 1,
    String? category,
    String? search,
  }) async {
    final response = await _api.get(
      '/products',
      queryParameters: {
        'page': page,
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );
    
    return PaginatedResponse<Product>.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }
  
  Future<Product> getProductById(String id) async {
    final response = await _api.get('/products/$id');
    return Product.fromJson(response.data);
  }
}

// repositories/order_repository.dart
class OrderRepository {
  final ApiClient _api;
  
  OrderRepository(this._api);
  
  Future<Order> createOrder(OrderCreateDto dto) async {
    final response = await _api.post(
      '/orders',
      data: dto.toJson(),
    );
    return Order.fromJson(response.data);
  }
  
  Future<List<Order>> getMyOrders() async {
    final response = await _api.get('/orders/me');
    return (response.data as List)
        .map((json) => Order.fromJson(json))
        .toList();
  }
  
  Future<Order> trackOrder(String orderId) async {
    final response = await _api.get('/orders/$orderId/track');
    return Order.fromJson(response.data);
  }
}
```

---

## 🧪 Testing HTTP Clients

```dart
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('UserRepository', () {
    late MockDio mockDio;
    late UserRepository repository;
    
    setUp(() {
      mockDio = MockDio();
      repository = UserRepository(ApiClient(dio: mockDio));
    });
    
    test('getUser returns User on success', () async {
      when(mockDio.get('/users/123')).thenAnswer(
        (_) async => Response(
          data: {'id': '123', 'name': 'Ahmed'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/123'),
        ),
      );
      
      final user = await repository.getUser('123');
      
      expect(user.id, equals('123'));
      expect(user.name, equals('Ahmed'));
    });
    
    test('getUser throws on network error', () async {
      when(mockDio.get('/users/123')).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/users/123'),
        ),
      );
      
      expect(
        () => repository.getUser('123'),
        throwsA(isA<TimeoutException>()),
      );
    });
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - Dio setup with BaseOptions
  - timeout configuration
  - interceptors for auth/logging
  - error handling
  - repository pattern
  - custom exceptions
  - progress tracking for uploads
  - cancel tokens

suggest:
  - add retry interceptor
  - implement cache
  - use repository pattern
  - extract environment config
  - add progress callbacks
  - implement cancellation

enforce:
  - proper error handling
  - timeout configuration
  - auth interceptor
  - typed responses
  - repository pattern
```

---

## 📊 Summary Checklist

```markdown
- [ ] Dio configured
- [ ] BaseOptions setup
- [ ] Timeout configured
- [ ] Auth interceptor
- [ ] Error handling
- [ ] Retry logic
- [ ] Repository pattern
- [ ] Custom exceptions
- [ ] Environment config
- [ ] Tests for API calls
```

---

## 🔗 Related Rules

- [JSON Serialization](./json-serialization.md)
- [Error Handling](../core/error-handling.md)
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Recommended Package:** Dio  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

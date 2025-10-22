# Layered Architecture

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Architecture
applies_to:
  - small_to_medium_projects
complexity: medium
ai_agent_tags:
  - architecture
  - layered
  - mvc
  - mvvm
  - separation
```

---

## 🎯 Overview

**Layered Architecture** يقسم التطبيق إلى طبقات أفقية (Presentation, Business, Data). أبسط من Clean Architecture ومناسب للمشاريع الصغيرة والمتوسطة.

### Common Patterns
- 🎨 **MVC** - Model View Controller
- 📱 **MVVM** - Model View ViewModel
- 🔄 **MVI** - Model View Intent

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` للمشاريع الصغيرة-المتوسطة

---

## 📚 Core Concepts

### 1. Three-Layer Architecture

```
┌─────────────────────────────────┐
│     Presentation Layer          │
│   (UI, Widgets, ViewModels)     │
└───────────┬─────────────────────┘
            │
┌───────────▼─────────────────────┐
│      Business Layer             │
│   (Services, Business Logic)    │
└───────────┬─────────────────────┘
            │
┌───────────▼─────────────────────┐
│        Data Layer               │
│  (Repositories, Data Sources)   │
└─────────────────────────────────┘
```

---

### 2. MVVM Pattern

#### Model
```dart
// models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
```

#### ViewModel
```dart
// viewmodels/user_viewmodel.dart
class UserViewModel extends ChangeNotifier {
  final UserService _userService;
  
  UserViewModel(this._userService);
  
  // State
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  
  // Actions
  Future<void> loadUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _user = await _userService.getUser(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _user = await _userService.updateUser(updatedUser);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

#### View
```dart
// views/user_screen.dart
class UserScreen extends StatelessWidget {
  final String userId;
  
  const UserScreen({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(
        context.read<UserService>(),
      )..loadUser(userId),
      child: Scaffold(
        appBar: AppBar(title: Text('User Profile')),
        body: Consumer<UserViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${viewModel.errorMessage}'),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.loadUser(userId);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            final user = viewModel.user;
            if (user == null) {
              return Center(child: Text('No user found'));
            }
            
            return _UserContent(user: user);
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
        children: [
          if (user.avatarUrl != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl!),
            ),
          SizedBox(height: 16),
          Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
          Text(user.email),
        ],
      ),
    );
  }
}
```

---

### 3. Service Layer

```dart
// services/user_service.dart
class UserService {
  final UserRepository _repository;
  
  UserService(this._repository);
  
  Future<User> getUser(String id) async {
    try {
      return await _repository.getUser(id);
    } catch (e) {
      throw ServiceException('Failed to get user: $e');
    }
  }
  
  Future<List<User>> getUsers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _repository.getUsers(page: page, limit: limit);
    } catch (e) {
      throw ServiceException('Failed to get users: $e');
    }
  }
  
  Future<User> updateUser(User user) async {
    // Business logic validation
    if (user.name.isEmpty) {
      throw ValidationException('Name cannot be empty');
    }
    
    if (!_isValidEmail(user.email)) {
      throw ValidationException('Invalid email format');
    }
    
    try {
      return await _repository.updateUser(user);
    } catch (e) {
      throw ServiceException('Failed to update user: $e');
    }
  }
  
  Future<void> deleteUser(String id) async {
    try {
      await _repository.deleteUser(id);
    } catch (e) {
      throw ServiceException('Failed to delete user: $e');
    }
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

---

### 4. Repository Layer

```dart
// repositories/user_repository.dart
class UserRepository {
  final ApiClient _api;
  final CacheManager _cache;
  
  UserRepository(this._api, this._cache);
  
  Future<User> getUser(String id) async {
    // Try cache first
    final cachedUser = _cache.get<User>('user_$id');
    if (cachedUser != null) {
      return cachedUser;
    }
    
    // Fetch from API
    final response = await _api.get('/users/$id');
    final user = User.fromJson(response.data);
    
    // Cache it
    await _cache.put('user_$id', user);
    
    return user;
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
  
  Future<User> updateUser(User user) async {
    final response = await _api.put(
      '/users/${user.id}',
      data: user.toJson(),
    );
    
    final updatedUser = User.fromJson(response.data);
    
    // Update cache
    await _cache.put('user_${user.id}', updatedUser);
    
    return updatedUser;
  }
  
  Future<void> deleteUser(String id) async {
    await _api.delete('/users/$id');
    await _cache.remove('user_$id');
  }
}
```

---

### 5. MVC Pattern

#### Model
```dart
// models/todo.dart
class Todo {
  final String id;
  final String title;
  final bool completed;
  
  const Todo({
    required this.id,
    required this.title,
    required this.completed,
  });
  
  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
```

#### Controller
```dart
// controllers/todo_controller.dart
class TodoController extends ChangeNotifier {
  final TodoService _service;
  
  TodoController(this._service);
  
  List<Todo> _todos = [];
  bool _isLoading = false;
  
  List<Todo> get todos => List.unmodifiable(_todos);
  bool get isLoading => _isLoading;
  int get completedCount => _todos.where((t) => t.completed).length;
  
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _todos = await _service.getTodos();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addTodo(String title) async {
    final todo = await _service.createTodo(title);
    _todos.add(todo);
    notifyListeners();
  }
  
  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final updated = await _service.updateTodo(
        todo.copyWith(completed: !todo.completed),
      );
      _todos[index] = updated;
      notifyListeners();
    }
  }
  
  Future<void> deleteTodo(String id) async {
    await _service.deleteTodo(id);
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
```

#### View
```dart
// views/todo_screen.dart
class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoController(
        context.read<TodoService>(),
      )..loadTodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todos'),
          actions: [
            Consumer<TodoController>(
              builder: (context, controller, _) {
                return Text('${controller.completedCount}/${controller.todos.length}');
              },
            ),
          ],
        ),
        body: Consumer<TodoController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            return ListView.builder(
              itemCount: controller.todos.length,
              itemBuilder: (context, index) {
                final todo = controller.todos[index];
                return CheckboxListTile(
                  title: Text(todo.title),
                  value: todo.completed,
                  onChanged: (_) => controller.toggleTodo(todo.id),
                  secondary: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => controller.deleteTodo(todo.id),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDialog(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
  
  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Todo'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TodoController>().addTodo(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Keep Layers Separated

```dart
// ✅ Good - Clear separation
// Presentation
class UserViewModel {
  final UserService service; // Depends on service
}

// Business
class UserService {
  final UserRepository repository; // Depends on repository
}

// Data
class UserRepository {
  final ApiClient api; // Depends on external
}

// ❌ Bad - Direct dependency
class UserViewModel {
  final ApiClient api; // ❌ Skips business layer
}
```

---

### Rule 2: ViewModels Don't Know About Widgets

```dart
// ✅ Good - ViewModel is pure logic
class UserViewModel extends ChangeNotifier {
  User? _user;
  
  Future<void> loadUser(String id) async {
    _user = await service.getUser(id);
    notifyListeners();
  }
}

// ❌ Bad - ViewModel knows about widgets
class UserViewModel extends ChangeNotifier {
  Future<void> loadUser(String id, BuildContext context) async {
    // ❌ NO BuildContext in ViewModel!
    _user = await service.getUser(id);
    notifyListeners();
  }
}
```

---

## 🎯 Folder Structure

```
lib/
├── models/
│   ├── user.dart
│   └── todo.dart
├── services/
│   ├── user_service.dart
│   └── todo_service.dart
├── repositories/
│   ├── user_repository.dart
│   └── todo_repository.dart
├── viewmodels/
│   ├── user_viewmodel.dart
│   └── todo_viewmodel.dart
├── views/
│   ├── user_screen.dart
│   └── todo_screen.dart
└── widgets/
    ├── user_card.dart
    └── todo_item.dart
```

---

## 🧪 Testing

```dart
// Test ViewModel
void main() {
  late UserViewModel viewModel;
  late MockUserService mockService;
  
  setUp(() {
    mockService = MockUserService();
    viewModel = UserViewModel(mockService);
  });
  
  test('loads user successfully', () async {
    // Arrange
    final user = User(id: '1', name: 'Ahmed', email: 'ahmed@example.com');
    when(() => mockService.getUser('1')).thenAnswer((_) async => user);
    
    // Act
    await viewModel.loadUser('1');
    
    // Assert
    expect(viewModel.user, equals(user));
    expect(viewModel.isLoading, false);
    expect(viewModel.hasError, false);
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - three layer separation
  - viewmodels/controllers
  - service layer
  - repository layer
  - proper dependencies
  - no UI logic in services

suggest:
  - extract viewmodels
  - create service layer
  - implement repositories
  - use Provider/Riverpod for DI

enforce:
  - layer separation
  - no BuildContext in viewmodels
  - services depend on repositories
  - viewmodels depend on services
```

---

## 📊 Summary

| Pattern | Best For | Complexity |
|---------|----------|------------|
| **MVVM** | Modern Flutter apps | Medium |
| **MVC** | Simple apps | Low |
| **Layered** | Team projects | Medium |

---

## 🔗 Related Rules

- [Clean Architecture](./clean-architecture.md) - Advanced
- [Feature-Based](./feature-based.md) - Alternative
- [Repository Pattern](./repository-pattern.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**For:** Small-Medium Projects  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

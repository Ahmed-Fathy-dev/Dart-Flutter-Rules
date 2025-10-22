# Bloc (Business Logic Component)

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: State Management
applies_to:
  - medium_to_large_projects
project_size: 15+ screens
complexity: medium_to_high
version: 9.1.0+  # ✅ Updated (Aug 2025)
ai_agent_tags:
  - state-management
  - bloc
  - events
  - states
  - testability
  - architecture
```

---

## 🎯 Overview

**Bloc** هو نمط architecture يفصل بشكل كامل بين UI و Business Logic باستخدام Streams. مناسب للمشاريع الكبيرة والمعقدة.

### Why Bloc?
- 🎯 فصل واضح بين UI و Logic
- 🧪 قابلية اختبار عالية جداً
- 📊 سلوك متوقع (predictable)
- 🛠️ DevTools ممتازة
- 📚 توثيق شامل

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للمشاريع 15+ screen أو معقدة

---

## 📚 Core Concepts

### 1. Bloc Pattern Basics

```
User Action → Event → Bloc → State → UI Update
```

#### Components
```dart
// 1. Events - User actions
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// 2. States - UI states
class CounterState {
  final int count;
  CounterState(this.count);
}

// 3. Bloc - Business logic
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) {
      emit(CounterState(state.count + 1));
    });
    
    on<Decrement>((event, emit) {
      emit(CounterState(state.count - 1));
    });
  }
}
```

---

### 2. Setup

#### pubspec.yaml
```yaml
dependencies:
  flutter_bloc: ^9.1.1  # ✅ Latest (Aug 2025)
  bloc: ^9.1.0  # ✅ Latest (Aug 2025)
  equatable: ^2.0.7  # ✅ Latest (Aug 2025)

dev_dependencies:
  bloc_test: ^9.1.7  # ✅ Latest (Aug 2025)
```

#### Basic Bloc
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
class Reset extends CounterEvent {}

// State
class CounterState extends Equatable {
  final int count;
  final bool isEven;
  
  CounterState(this.count) : isEven = count % 2 == 0;
  
  @override
  List<Object?> get props => [count];
}

// Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) {
      emit(CounterState(state.count + 1));
    });
    
    on<Decrement>((event, emit) {
      emit(CounterState(state.count - 1));
    });
    
    on<Reset>((event, emit) {
      emit(CounterState(0));
    });
  }
}
```

---

### 3. BlocProvider Setup

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: MaterialApp(
        home: CounterScreen(),
      ),
    );
  }
}

// Multiple Blocs
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
```

---

### 4. BlocBuilder - Display State

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Count: ${state.count}'),
            Text(state.isEven ? 'Even' : 'Odd'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Increment());
                  },
                  child: Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Decrement());
                  },
                  child: Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterBloc>().add(Reset());
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
```

---

### 5. BlocListener - Side Effects

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Side effects (navigation, snackbars, etc.)
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return CircularProgressIndicator();
          }
          
          return LoginForm();
        },
      ),
    );
  }
}

// Or use BlocConsumer (Listener + Builder)
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(context, HomeScreen());
        } else if (state is AuthFailure) {
          showError(state.error);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator();
        }
        return LoginForm();
      },
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: States Should Be Immutable

```dart
// ✅ Good - Immutable state
class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;
  
  const TodoState({
    required this.todos,
    this.isLoading = false,
  });
  
  // CopyWith for updates
  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  List<Object?> get props => [todos, isLoading];
}

// Usage in Bloc
emit(state.copyWith(isLoading: true));
```

---

### Rule 2: Use Sealed Classes for States

```dart
// ✅ Excellent - Sealed states
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
  
  @override
  List<Object?> get props => [error];
}

// Usage with exhaustive checking
Widget buildAuth(AuthState state) {
  return switch (state) {
    AuthInitial() => LoginForm(),
    AuthLoading() => CircularProgressIndicator(),
    AuthSuccess() => HomeScreen(user: state.user),
    AuthFailure() => ErrorWidget(error: state.error),
  };
}
```

---

### Rule 3: Async Events

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  
  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final user = await repository.login(
        event.email,
        event.password,
      );
      emit(AuthSuccess(user));
    } on NetworkException catch (e) {
      emit(AuthFailure('No internet connection'));
    } on AuthException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure('Unknown error'));
    }
  }
}
```

---

### Rule 4: buildWhen & listenWhen

```dart
// Optimize rebuilds
BlocBuilder<CounterBloc, CounterState>(
  buildWhen: (previous, current) {
    // Only rebuild if count changed
    return previous.count != current.count;
  },
  builder: (context, state) {
    return Text('${state.count}');
  },
)

// Optimize listeners
BlocListener<AuthBloc, AuthState>(
  listenWhen: (previous, current) {
    // Only listen to success or failure
    return current is AuthSuccess || current is AuthFailure;
  },
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.push(context, HomeScreen());
    }
  },
  child: MyWidget(),
)
```

---

## 🎯 Real-World Example: Todo App

```dart
// Events
sealed class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodosLoadRequested extends TodoEvent {}

class TodoAdded extends TodoEvent {
  final String title;
  TodoAdded(this.title);
  
  @override
  List<Object?> get props => [title];
}

class TodoToggled extends TodoEvent {
  final String id;
  TodoToggled(this.id);
  
  @override
  List<Object?> get props => [id];
}

class TodoDeleted extends TodoEvent {
  final String id;
  TodoDeleted(this.id);
  
  @override
  List<Object?> get props => [id];
}

// States
sealed class TodoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final int completedCount;
  
  TodoLoaded(this.todos)
      : completedCount = todos.where((t) => t.completed).length;
  
  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Bloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  
  TodoBloc(this.repository) : super(TodoInitial()) {
    on<TodosLoadRequested>(_onTodosLoadRequested);
    on<TodoAdded>(_onTodoAdded);
    on<TodoToggled>(_onTodoToggled);
    on<TodoDeleted>(_onTodoDeleted);
  }
  
  Future<void> _onTodosLoadRequested(
    TodosLoadRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    
    try {
      final todos = await repository.getTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos'));
    }
  }
  
  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: event.title,
      completed: false,
    );
    
    try {
      await repository.addTodo(newTodo);
      emit(TodoLoaded([...currentState.todos, newTodo]));
    } catch (e) {
      emit(TodoError('Failed to add todo'));
      emit(currentState); // Restore previous state
    }
  }
  
  Future<void> _onTodoToggled(
    TodoToggled event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    final updatedTodos = currentState.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    
    emit(TodoLoaded(updatedTodos));
    
    try {
      final todo = updatedTodos.firstWhere((t) => t.id == event.id);
      await repository.updateTodo(todo);
    } catch (e) {
      emit(TodoError('Failed to update todo'));
      emit(currentState);
    }
  }
  
  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoaded) return;
    
    final currentState = state as TodoLoaded;
    final updatedTodos = currentState.todos
        .where((todo) => todo.id != event.id)
        .toList();
    
    emit(TodoLoaded(updatedTodos));
    
    try {
      await repository.deleteTodo(event.id);
    } catch (e) {
      emit(TodoError('Failed to delete todo'));
      emit(currentState);
    }
  }
}

// UI
class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(
        context.read<TodoRepository>(),
      )..add(TodosLoadRequested()),
      child: Scaffold(
        appBar: AppBar(title: Text('Todos')),
        body: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state is TodoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              TodoInitial() || TodoLoading() => 
                Center(child: CircularProgressIndicator()),
              
              TodoLoaded(:final todos, :final completedCount) => Column(
                children: [
                  Text('Completed: $completedCount/${todos.length}'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return CheckboxListTile(
                          title: Text(todo.title),
                          value: todo.completed,
                          onChanged: (_) {
                            context.read<TodoBloc>().add(
                              TodoToggled(todo.id),
                            );
                          },
                          secondary: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                TodoDeleted(todo.id),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              TodoError() => Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TodoBloc>().add(TodosLoadRequested());
                  },
                  child: Text('Retry'),
                ),
              ),
            };
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
                context.read<TodoBloc>().add(
                  TodoAdded(controller.text),
                );
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

## 🧪 Testing Bloc

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('TodoBloc', () {
    late TodoRepository repository;
    
    setUp(() {
      repository = MockTodoRepository();
    });
    
    test('initial state is TodoInitial', () {
      final bloc = TodoBloc(repository);
      expect(bloc.state, equals(TodoInitial()));
    });
    
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when todos are loaded',
      build: () {
        when(() => repository.getTodos())
            .thenAnswer((_) async => [
              Todo(id: '1', title: 'Test', completed: false),
            ]);
        return TodoBloc(repository);
      },
      act: (bloc) => bloc.add(TodosLoadRequested()),
      expect: () => [
        TodoLoading(),
        isA<TodoLoaded>()
            .having((s) => s.todos.length, 'todos length', 1),
      ],
    );
    
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoError] when loading fails',
      build: () {
        when(() => repository.getTodos())
            .thenThrow(Exception('Error'));
        return TodoBloc(repository);
      },
      act: (bloc) => bloc.add(TodosLoadRequested()),
      expect: () => [
        TodoLoading(),
        TodoError('Failed to load todos'),
      ],
    );
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - sealed classes للـ events/states
  - Equatable implementation
  - immutable states
  - copyWith methods
  - proper event handlers
  - error handling في async operations
  - BlocProvider setup
  - buildWhen/listenWhen للـ optimization

suggest:
  - استخدام sealed classes
  - extract event handlers
  - add tests للـ blocs
  - use BlocConsumer when needed
  - optimize with buildWhen

enforce:
  - events/states extend Equatable
  - states are immutable
  - proper error handling
  - tests للـ all blocs
```

---

## 📊 Summary Checklist

```markdown
- [ ] Events sealed/abstract classes
- [ ] States sealed/immutable
- [ ] Equatable implemented
- [ ] Async event handlers
- [ ] Error handling
- [ ] BlocProvider setup
- [ ] Tests with bloc_test
- [ ] buildWhen optimization
```

---

## 🔗 Related Rules

- [State Management Comparison](./comparison.md)
- [Testing](../testing/unit-testing.md)
- [Architecture](../architecture/clean.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Best For:** 15+ Screens, Complex Logic  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

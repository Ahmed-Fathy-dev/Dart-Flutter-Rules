# Riverpod State Management

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: State Management
applies_to:
  - all_projects
  - modern_flutter
type_safe: true
version: 3.0+
ai_agent_tags:
  - state-management
  - riverpod
  - riverpod-3.0
  - type-safety
  - no-context
  - code-generation
  - modern
```

---

## 🎯 Overview

**Riverpod 3.0** هو نسخة محسّنة بشكل كبير من Provider مع type safety أقوى، ولا يحتاج `BuildContext`، ومع ميزات جديدة قوية.

### Why Riverpod 3.0?
- ✅ **Compile-time safety** - Type-safe بالكامل
- 🚫 **No BuildContext needed** - استخدام Providers في أي مكان
- 🧪 **سهل الاختبار جداً** - Testing utilities محسّنة
- 🔄 **Auto-dispose & Auto-retry** - إدارة تلقائية للذاكرة وإعادة المحاولة
- 📦 **Better DI** - Dependency injection أفضل
- 💾 **Offline Persistence** - حفظ البيانات تلقائياً (تجريبي)
- 🔀 **Mutations** - إدارة Side-effects بشكل أفضل (تجريبي)
- 🎨 **Code Generation** - Syntax أبسط وأقوى
- 🪝 **Hooks Support** - دعم كامل لـ flutter_hooks

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للمشاريع الجديدة والحديثة

---

## 📚 Setup & Installation

### 1. Basic Setup (Without Code Generation)

#### pubspec.yaml
```yaml
dependencies:
  flutter_riverpod: ^3.0.0  # For Flutter apps
  # riverpod: ^3.0.0  # For Dart-only apps
```

#### main.dart
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // ProviderScope مطلوب لتشغيل Riverpod
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

---

### 2. With Code Generation (RECOMMENDED)

Code Generation يوفر:
- ✅ Syntax أبسط وأسهل
- ✅ Better performance
- ✅ Named parameters support
- ✅ Auto-type inference
- ✅ Generic support

#### pubspec.yaml
```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^2.0.0
  
dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.0.0
  riverpod_lint: ^2.0.0  # Recommended for better linting
```

#### Run build_runner
```bash
# One-time generation
dart run build_runner build

# Continuous watch mode
dart run build_runner watch --delete-conflicting-outputs
```

---

### 3. With Hooks Support

إذا كنت تستخدم `flutter_hooks`:

#### pubspec.yaml
```yaml
dependencies:
  flutter_riverpod: ^3.0.0
  hooks_riverpod: ^3.0.0  # For hooks support
  flutter_hooks: ^0.20.0
```

#### Usage
```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

// استخدم HookConsumerWidget بدلاً من ConsumerWidget
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // يمكنك استخدام hooks و providers معاً
    final counter = useState(0);
    final user = ref.watch(userProvider);
    
    return Text('Counter: ${counter.value}, User: ${user.name}');
  }
}
```

## 📊 Provider Types - Comparison

| نوع Provider | الاستخدام | Code Generation | Manual |
|-------------|-----------|----------------|--------|
| **Provider** | قيم ثابتة، Services | `@riverpod` function | `Provider<T>()` |
| **NotifierProvider** | State قابل للتعديل | `@riverpod` class | `NotifierProvider<>()` |
| **AsyncNotifierProvider** | Async state قابل للتعديل | `@riverpod` async class | `AsyncNotifierProvider<>()` |
| **FutureProvider** | بيانات async مرة واحدة | `@riverpod Future<T>` | `FutureProvider<T>()` |
| **StreamProvider** | بيانات مستمرة | `@riverpod Stream<T>` | `StreamProvider<T>()` |

> ⚠️ **مهم**: `StateProvider` و `StateNotifierProvider` تم نقلهم لـ `package:flutter_riverpod/legacy.dart` ولا يُنصح باستخدامهم.

---

## 🎨 Provider Types - WITH Code Generation (RECOMMENDED)

### 1. Simple Provider - Immutable Data

```dart
// example.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example.g.dart';

// ✅ Simple value provider
@riverpod
String greeting(Ref ref) {
  return 'Hello Riverpod 3.0!';
}

// ✅ Service/Repository provider
@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(baseUrl: 'https://api.example.com');
}

// ✅ Computed provider (depends on another)
@riverpod
String fullGreeting(Ref ref) {
  final name = ref.watch(userNameProvider);
  return 'Hello $name!';
}

// Usage in Widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider);
    return Text(greeting);
  }
}
```

---

### 2. NotifierProvider - Mutable State (Synchronous)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter.g.dart';

// ✅ Modern way - NotifierProvider with code generation
@riverpod
class Counter extends _$Counter {
  // build() يحدد القيمة الابتدائية
  @override
  int build() => 0;
  
  // Methods لتعديل الـ state
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
  void setValue(int value) => state = value;
}

// Usage
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

### 3. AsyncNotifierProvider - Async Mutable State

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list.g.dart';

@immutable
class Todo {
  final String id;
  final String title;
  final bool completed;
  
  const Todo({required this.id, required this.title, this.completed = false});
  
  Todo copyWith({String? id, String? title, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

// ✅ Modern AsyncNotifier
@riverpod
class TodoList extends _$TodoList {
  // build() يُنفّذ مرة واحدة عند الاشتراك
  @override
  Future<List<Todo>> build() async {
    // Fetch من API أو Database
    return await _fetchTodos();
  }
  
  // Methods لتعديل الـ state
  Future<void> addTodo(String title) async {
    // Set loading state
    state = const AsyncLoading();
    
    // Perform async operation
    state = await AsyncValue.guard(() async {
      final newTodo = await _createTodo(title);
      final currentTodos = await future; // Get current value
      return [...currentTodos, newTodo];
    });
  }
  
  Future<void> removeTodo(String id) async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      await _deleteTodo(id);
      final currentTodos = await future;
      return currentTodos.where((todo) => todo.id != id).toList();
    });
  }
  
  Future<void> toggleTodo(String id) async {
    state = await AsyncValue.guard(() async {
      final currentTodos = await future;
      return currentTodos.map((todo) {
        return todo.id == id ? todo.copyWith(completed: !todo.completed) : todo;
      }).toList();
    });
  }
  
  Future<List<Todo>> _fetchTodos() async {
    final api = ref.watch(apiClientProvider);
    return await api.getTodos();
  }
  
  Future<Todo> _createTodo(String title) async {
    final api = ref.watch(apiClientProvider);
    return await api.createTodo(title);
  }
  
  Future<void> _deleteTodo(String id) async {
    final api = ref.watch(apiClientProvider);
    await api.deleteTodo(id);
  }
}

// Usage
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    
    return todosAsync.when(
      data: (todos) => ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (_) {
                ref.read(todoListProvider.notifier).toggleTodo(todo.id);
              },
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

---

### 4. FutureProvider - One-time Async Data

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user.g.dart';

// ✅ بيانات async تُحمّل مرة واحدة
@riverpod
Future<User> currentUser(Ref ref) async {
  final api = ref.watch(apiClientProvider);
  return await api.getCurrentUser();
}

// ✅ مع معاملات (Family)
@riverpod
Future<User> user(Ref ref, String userId) async {
  final api = ref.watch(apiClientProvider);
  return await api.getUser(userId);
}

// Usage
class UserProfile extends ConsumerWidget {
  final String userId;
  
  const UserProfile(this.userId);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));
    
    return userAsync.when(
      data: (user) => Column(
        children: [
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

---

### 5. StreamProvider - Continuous Data

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages.g.dart';

// ✅ Stream provider للبيانات المستمرة
@riverpod
Stream<List<Message>> messages(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return api.messagesStream();
}

// Usage
class MessagesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);
    
    return messagesAsync.when(
      data: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => MessageTile(messages[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## 🔧 Provider Types - WITHOUT Code Generation (Manual)

إذا كنت لا تريد استخدام Code Generation:

### 1. Provider - Simple Values

```dart
// ✅ Simple value
final nameProvider = Provider<String>((ref) => 'Ahmed');

// ✅ Service
final apiProvider = Provider<ApiClient>((ref) => ApiClient());

// Usage
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);
    return Text(name);
  }
}
```

### 2. NotifierProvider - Mutable State

```dart
// ✅ Modern Notifier (Riverpod 3.0)
class Counter extends Notifier<int> {
  @override
  int build() => 0;
  
  void increment() => state++;
  void decrement() => state--;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

// Usage
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).increment();
```

### 3. AsyncNotifierProvider - Async State

```dart
class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    return await _fetchTodos();
  }
  
  Future<void> addTodo(Todo todo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final todos = await future;
      return [...todos, todo];
    });
  }
}

final todoListProvider = AsyncNotifierProvider<TodoList, List<Todo>>(
  TodoList.new,
);
```

### 4. FutureProvider

```dart
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.watch(apiProvider);
  return await api.getUser();
});
```

### 5. StreamProvider

```dart
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final api = ref.watch(apiProvider);
  return api.messagesStream();
});
```

> 💡 **توصية**: استخدم Code Generation للحصول على syntax أبسط وأفضل.

---

## 🎯 Core Concepts

### 1. Consumers - Widget Types

```dart
// ✅ Option 1: ConsumerWidget (الأكثر استخداماً)
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}

// ✅ Option 2: ConsumerStatefulWidget
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  void initState() {
    super.initState();
    // يمكنك استخدام ref هنا
  }
  
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}

// ✅ Option 3: Consumer - Partial rebuild
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Static'),  // ❌ Won't rebuild
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('$count');  // ✅ Only this rebuilds
          },
        ),
      ],
    );
  }
}

// ✅ Option 4: HookConsumerWidget (مع hooks_riverpod)
class MyScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final textController = useTextEditingController();
    
    return TextField(controller: textController);
  }
}
```

---

### 2. Ref Methods - watch vs read vs listen

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ ref.watch - يعيد بناء الـ widget عند التغيير
    // استخدمه في build() فقط
    final count = ref.watch(counterProvider);
    
    // ✅ ref.read - لا يعيد البناء، للـ callbacks فقط
    // لا تستخدمه في build()
    return ElevatedButton(
      onPressed: () {
        ref.read(counterProvider.notifier).increment();
      },
      child: Text('Count: $count'),
    );
  }
}

// ✅ ref.listen - لـ Side effects (Navigation, SnackBar, etc.)
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen للتغييرات وإظهار رسالة
    ref.listen<int>(counterProvider, (previous, next) {
      if (next == 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reached 10!')),
        );
      }
    });
    
    // Listen لـ AsyncValue للتعامل مع الأخطاء
    ref.listen<AsyncValue<User>>(userProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
      );
    });
    
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}

// ✅ ref.invalidate - لإعادة تحميل provider
ElevatedButton(
  onPressed: () {
    ref.invalidate(userProvider); // Refresh the provider
  },
  child: Text('Refresh'),
)

// ✅ ref.refresh - لإعادة التحميل والحصول على القيمة
final user = await ref.refresh(userProvider.future);
```

### 3. Provider Dependencies

```dart
// ✅ With Code Generation
@riverpod
ApiClient apiClient(Ref ref) => ApiClient();

@riverpod
UserRepository userRepository(Ref ref) {
  final api = ref.watch(apiClientProvider);
  return UserRepository(api);
}

@riverpod
Future<User> currentUser(Ref ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getCurrentUser();
}

// ✅ Without Code Generation
final apiProvider = Provider((ref) => ApiClient());

final repoProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  return UserRepository(api);
});

final userProvider = FutureProvider((ref) async {
  final repo = ref.watch(repoProvider);
  return await repo.getCurrentUser();
});
```

---

### 4. Family - Parameters Support

Family يسمح بتمرير معاملات للـ providers:

```dart
// ✅ With Code Generation (أبسط - يدعم named parameters)
@riverpod
Future<User> user(
  Ref ref,
  String userId, {  // Required parameter
  bool includeDetails = false,  // Optional with default
}) async {
  final api = ref.watch(apiClientProvider);
  return await api.getUser(userId, includeDetails: includeDetails);
}

// Usage
final user = ref.watch(userProvider('123', includeDetails: true));

// ✅ Without Code Generation (يدعم parameter واحد فقط)
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final api = ref.watch(apiProvider);
  return await api.getUser(userId);
});

// Usage
final user = ref.watch(userProvider('123'));

// ✅ مع معاملات متعددة (استخدم class)
@immutable
class UserParams {
  final String userId;
  final bool includeDetails;
  
  const UserParams(this.userId, {this.includeDetails = false});
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is UserParams &&
    userId == other.userId &&
    includeDetails == other.includeDetails;
  
  @override
  int get hashCode => Object.hash(userId, includeDetails);
}

final userProvider = FutureProvider.family<User, UserParams>((ref, params) async {
  final api = ref.watch(apiProvider);
  return await api.getUser(params.userId, includeDetails: params.includeDetails);
});

// Usage
final user = ref.watch(userProvider(UserParams('123', includeDetails: true)));
```

---

### 5. AutoDispose - Automatic Memory Management

```dart
// ✅ With Code Generation (autoDispose بشكل افتراضي)
@riverpod
Future<User> user(Ref ref) async {
  // يتم تنظيف الذاكرة تلقائياً عند عدم الاستخدام
  return await fetchUser();
}

// إيقاف autoDispose
@Riverpod(keepAlive: true)
Future<User> cachedUser(Ref ref) async {
  // لن يتم تنظيف الذاكرة
  return await fetchUser();
}

// ✅ Without Code Generation
// autoDispose يدوي
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return await fetchUser();
});

// بدون autoDispose
final cachedUserProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});

// ✅ keepAlive ديناميكي - إبقاء البيانات لمدة محددة
@riverpod
Future<Data> cachedData(Ref ref) async {
  // إبقاء البيانات في الذاكرة لمدة 5 دقائق بعد آخر استخدام
  final link = ref.keepAlive();
  
  Timer(const Duration(minutes: 5), () {
    link.close(); // السماح بـ autoDispose بعد 5 دقائق
  });
  
  return await fetchData();
}

// ✅ ref.onDispose - تنظيف الموارد
@riverpod
Stream<int> timer(Ref ref) {
  final controller = StreamController<int>();
  
  // تنظيف عند dispose
  ref.onDispose(() {
    controller.close();
  });
  
  return controller.stream;
}
```

## 🆕 New Features in Riverpod 3.0

### 1. Automatic Retry (جديد في 3.0)

Riverpod 3.0 يعيد المحاولة تلقائياً عند فشل Provider:

```dart
// ✅ Automatic retry مع exponential backoff
@riverpod
Future<Data> data(Ref ref) async {
  // سيعيد المحاولة تلقائياً حتى 10 مرات
  // مع backoff من 200ms إلى 6.4 ثانية
  return await fetchData();
}

// ✅ تخصيص retry logic
@riverpod
Future<Data> customRetry(Ref ref) async {
  // تخصيص عدد المحاولات والـ delay
  ref.retry(
    maxAttempts: 5,
    delay: (attempt) => Duration(seconds: attempt * 2),
  );
  
  return await fetchData();
}

// ✅ إيقاف retry
@riverpod
Future<Data> noRetry(Ref ref) async {
  ref.retry(maxAttempts: 0); // No retry
  return await fetchData();
}
```

---

### 2. Mutations (تجريبي - جديد في 3.0)

Mutations لإدارة Side-effects بشكل أفضل:

```dart
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/experimental/mutation.dart';

// ✅ تعريف mutation
final addTodoMutation = Mutation<Todo>();

// ✅ استخدام mutation في UI
class AddTodoButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutationState = ref.watch(addTodoMutation);
    
    return ElevatedButton(
      style: ButtonStyle(
        // عرض اللون الأحمر عند الخطأ
        backgroundColor: switch (mutationState) {
          MutationError() => WidgetStatePropertyAll(Colors.red),
          _ => null,
        },
      ),
      onPressed: mutationState is MutationPending
        ? null  // Disable عند التحميل
        : () {
            addTodoMutation.run(ref, (tsx) async {
              final title = 'New Todo';
              await ref.read(todoListProvider.notifier).addTodo(title);
            });
          },
      child: Row(
        children: [
          Text('Add Todo'),
          if (mutationState is MutationPending) ...[
            SizedBox(width: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }
}

// ✅ الاستماع للـ mutation state
ref.listen(addTodoMutation, (previous, next) {
  switch (next) {
    case MutationSuccess<Todo>(:final data):
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo added: ${data.title}')),
      );
    case MutationError(:final error):
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    default:
      break;
  }
});
```

---

### 3. Offline Persistence (تجريبي - جديد في 3.0)

حفظ state تلقائياً للعمل Offline:

```dart
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/experimental/persist.dart';

// ✅ 1. إنشاء Storage
@riverpod
Future<Storage> storage(Ref ref) async {
  // استخدم أي storage تريده (SharedPreferences, Hive, etc.)
  return await SharedPreferencesStorage.create();
}

// ✅ 2. Provider مع persistence
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    // تفعيل persistence
    persist(
      ref.watch(storageProvider.future),
      key: 'todo_list',  // Unique key
      encode: (todos) => todos.map((t) => t.toJson()).toList(),
      decode: (json) => (json as List).map((t) => Todo.fromJson(t)).toList(),
    );
    
    // سيتم تحميل البيانات المحفوظة أولاً
    // ثم fetch من Server
    return await fetchTodosFromServer();
  }
  
  Future<void> addTodo(Todo todo) async {
    state = await AsyncValue.guard(() async {
      final todos = await future;
      final newTodos = [...todos, todo];
      
      // سيتم حفظ الـ state تلقائياً
      return newTodos;
    });
  }
}

// ✅ 3. Storage implementation مع SharedPreferences
class SharedPreferencesStorage implements Storage {
  final SharedPreferences _prefs;
  
  SharedPreferencesStorage._(this._prefs);
  
  static Future<SharedPreferencesStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage._(prefs);
  }
  
  @override
  Future<Object?> read(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }
  
  @override
  Future<void> write(String key, Object? value) async {
    if (value == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, jsonEncode(value));
    }
  }
}
```

---

### 4. ref.mounted (جديد في 3.0)

مثل `BuildContext.mounted` للتحقق من أن Provider لا يزال نشطاً:

```dart
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() => 0;
  
  Future<void> fetchData() async {
    final data = await longRunningOperation();
    
    // ✅ التحقق قبل تحديث الـ state
    if (!ref.mounted) return;
    
    state = data;
  }
}
```

---

## ✅ Best Practices (Updated for 3.0)

### Rule 1: استخدم Code Generation

```dart
// ✅ GOOD - مع code generation
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}

// ❌ AVOID - بدون code generation (إلا للضرورة)
final counterProvider = NotifierProvider<Counter, int>(Counter.new);
```

---

### Rule 2: Select لتقليل Rebuilds

```dart
// ❌ BAD - يعيد البناء عند أي تغيير في User
final name = ref.watch(userProvider).name;

// ✅ GOOD - يعيد البناء فقط عند تغيير name
final name = ref.watch(userProvider.select((user) => user.name));

// ✅ GOOD - select متعدد
final fullName = ref.watch(
  userProvider.select((user) => (user.firstName, user.lastName)),
);
```

---

### Rule 3: Computed Providers

```dart
// ✅ Provider لحساب قيم مشتقة
@riverpod
List<Todo> completedTodos(Ref ref) {
  final todos = ref.watch(todoListProvider).value ?? [];
  return todos.where((todo) => todo.completed).toList();
}

@riverpod
int completedCount(Ref ref) {
  return ref.watch(completedTodosProvider).length;
}

// Usage
final count = ref.watch(completedCountProvider);
```

---

### Rule 4: استخدم AsyncValue.guard للأخطاء

```dart
// ✅ GOOD - يتعامل مع الأخطاء تلقائياً
Future<void> addTodo(String title) async {
  state = const AsyncLoading();
  
  state = await AsyncValue.guard(() async {
    final newTodo = await createTodo(title);
    final todos = await future;
    return [...todos, newTodo];
  });
}

// ❌ AVOID - try-catch يدوي
Future<void> addTodo(String title) async {
  try {
    state = const AsyncLoading();
    final newTodo = await createTodo(title);
    final todos = await future;
    state = AsyncData([...todos, newTodo]);
  } catch (error, stack) {
    state = AsyncError(error, stack);
  }
}
```

---

### Rule 5: ref.watch في build() فقط

```dart
// ✅ GOOD
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);  // ✅ في build
    
    return ElevatedButton(
      onPressed: () {
        ref.read(counterProvider.notifier).increment();  // ✅ read في callback
      },
      child: Text('$count'),
    );
  }
}

// ❌ WRONG
onPressed: () {
  final count = ref.watch(counterProvider);  // ❌ لا تستخدم watch في callbacks
}
```

---

## 🎯 Real-World Example: Shopping Cart (Riverpod 3.0)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart.g.dart';

// ============= Models =============
@immutable
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

@immutable
class CartItem {
  final Product product;
  final int quantity;
  
  const CartItem({required this.product, required this.quantity});
  
  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
  
  double get totalPrice => product.price * quantity;
}

// ============= Providers =============

// ✅ Cart Provider مع Code Generation
@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() => [];
  
  void addProduct(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );
    
    if (existingIndex >= 0) {
      // زيادة الكمية
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      // إضافة منتج جديد
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }
  
  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }
  
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }
  
  void clear() => state = [];
}

// ✅ Computed Providers
@riverpod
int cartItemCount(Ref ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
}

@riverpod
double cartTotal(Ref ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.totalPrice);
}

@riverpod
bool isInCart(Ref ref, String productId) {
  final items = ref.watch(cartProvider);
  return items.any((item) => item.product.id == productId);
}

// ============= UI - Product Card =============
class ProductCard extends ConsumerWidget {
  final Product product;
  
  const ProductCard(this.product);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inCart = ref.watch(isInCartProvider(product.id));
    
    return Card(
      child: Column(
        children: [
          Image.network(product.imageUrl, height: 150, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${product.price.toStringAsFixed(2)}'),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(inCart ? Icons.check : Icons.add_shopping_cart),
                  label: Text(inCart ? 'In Cart' : 'Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============= UI - Cart Badge =============
class CartBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);
    
    return Badge(
      label: Text('$itemCount'),
      isLabelVisible: itemCount > 0,
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CartScreen()),
          );
        },
      ),
    );
  }
}

// ============= UI - Cart Screen =============
class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemTile(item);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('\$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _checkout(context, ref),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('Checkout', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
  
  void _checkout(BuildContext context, WidgetRef ref) {
    // Process checkout
    ref.read(cartProvider.notifier).clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );
    
    Navigator.pop(context);
  }
}

// ============= UI - Cart Item Tile =============
class CartItemTile extends ConsumerWidget {
  final CartItem item;
  
  const CartItemTile(this.item);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Image.network(item.product.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${item.product.price.toStringAsFixed(2)}'),
                  Text('Subtotal: \$${item.totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                          item.product.id,
                          item.quantity - 1,
                        );
                      },
                    ),
                    Text('${item.quantity}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                          item.product.id,
                          item.quantity + 1,
                        );
                      },
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: Icon(Icons.delete, size: 18),
                  label: Text('Remove'),
                  onPressed: () {
                    ref.read(cartProvider.notifier).removeProduct(item.product.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🧪 Testing with Riverpod 3.0

### 1. Unit Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  // ✅ استخدم ProviderContainer.test (جديد في 3.0)
  test('counter starts at 0', () {
    final container = ProviderContainer.test();
    // يتم الـ dispose تلقائياً
    
    expect(container.read(counterProvider), equals(0));
  });
  
  test('can increment counter', () {
    final container = ProviderContainer.test();
    
    container.read(counterProvider.notifier).increment();
    
    expect(container.read(counterProvider), equals(1));
  });
  
  // ✅ Test async providers
  test('fetches user data', () async {
    final container = ProviderContainer.test();
    
    final userAsync = container.read(userProvider);
    
    expect(userAsync, isA<AsyncLoading>());
    
    // انتظر حتى يكتمل التحميل
    final user = await container.read(userProvider.future);
    
    expect(user.name, equals('Ahmed'));
  });
  
  // ✅ Test with overrides (Mocking)
  test('with mock api client', () async {
    final mockApi = MockApiClient();
    
    final container = ProviderContainer.test(
      overrides: [
        apiClientProvider.overrideWithValue(mockApi),
      ],
    );
    
    final user = await container.read(userProvider.future);
    
    expect(user, isNotNull);
    verify(mockApi.getUser()).called(1);
  });
  
  // ✅ Test cart operations
  test('cart operations', () {
    final container = ProviderContainer.test();
    
    final product = Product(id: '1', name: 'Test', price: 10, imageUrl: '');
    
    // Add product
    container.read(cartProvider.notifier).addProduct(product);
    expect(container.read(cartProvider).length, equals(1));
    expect(container.read(cartTotalProvider), equals(10));
    
    // Add same product again (should increase quantity)
    container.read(cartProvider.notifier).addProduct(product);
    expect(container.read(cartProvider).length, equals(1));
    expect(container.read(cartProvider).first.quantity, equals(2));
    expect(container.read(cartTotalProvider), equals(20));
    
    // Remove product
    container.read(cartProvider.notifier).removeProduct(product.id);
    expect(container.read(cartProvider), isEmpty);
  });
  
  // ✅ Test with spy/listener
  test('listen to provider changes', () {
    final container = ProviderContainer.test();
    final changes = <int>[];
    
    container.listen(
      counterProvider,
      (previous, next) {
        changes.add(next);
      },
    );
    
    container.read(counterProvider.notifier).increment();
    container.read(counterProvider.notifier).increment();
    
    expect(changes, equals([1, 2]));
  });
}
```

---

### 2. Widget Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('displays counter value', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: CounterScreen()),
      ),
    );
    
    // ✅ استخدم tester.container() للوصول للـ container
    final container = tester.container();
    
    // Verify initial value
    expect(find.text('0'), findsOneWidget);
    
    // Tap increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    
    // Verify value changed
    expect(find.text('1'), findsOneWidget);
    expect(container.read(counterProvider), equals(1));
  });
  
  // ✅ Test with overrides
  testWidgets('with mock data', (tester) async {
    final mockUser = User(id: '1', name: 'Mock User', email: 'mock@test.com');
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProvider.overrideWith((ref) async => mockUser),
        ],
        child: MaterialApp(home: UserProfile()),
      ),
    );
    
    // Wait for async provider
    await tester.pumpAndSettle();
    
    expect(find.text('Mock User'), findsOneWidget);
  });
  
  // ✅ Test async loading states
  testWidgets('shows loading indicator', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: UserProfile()),
      ),
    );
    
    // Verify loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Wait for data
    await tester.pumpAndSettle();
    
    // Verify data loaded
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Ahmed'), findsOneWidget);
  });
}
```

---

### 3. Mocking with NotifierProvider.overrideWithBuild (New in 3.0)

```dart
test('mock only the build method', () {
  final container = ProviderContainer.test(
    overrides: [
      // ✅ Mock فقط build() بدون mock الـ notifier كاملاً
      todoListProvider.overrideWithBuild((ref) async {
        return [
          Todo(id: '1', title: 'Test Todo', completed: false),
        ];
      }),
    ],
  );
  
  final todos = await container.read(todoListProvider.future);
  expect(todos.length, equals(1));
  
  // Methods الأخرى تعمل بشكل طبيعي
  await container.read(todoListProvider.notifier).addTodo('New Todo');
  
  final updatedTodos = await container.read(todoListProvider.future);
  expect(updatedTodos.length, equals(2));
});
```

## 🤖 AI Agent Integration Rules

عند استخدام AI Agent لتوليد كود Riverpod:

```yaml
# Riverpod 3.0 Rules for AI Agents

mandatory_checks:
  - ProviderScope wrapping main app: REQUIRED
  - Use ConsumerWidget for widgets that need providers: REQUIRED
  - Code generation setup when applicable: RECOMMENDED
  - No BuildContext needed for providers: ENFORCE
  - Immutable state classes: REQUIRED

code_generation_preference:
  - Prefer @riverpod annotation over manual providers: HIGH_PRIORITY
  - Use @riverpod for functions: SIMPLE_PROVIDERS
  - Use @riverpod class for stateful providers: NOTIFIER_PROVIDERS
  - Include part directive: REQUIRED
  - Run build_runner: REQUIRED

ref_usage:
  - ref.watch: USE_IN_BUILD_ONLY
  - ref.read: USE_IN_CALLBACKS_ONLY
  - ref.listen: USE_FOR_SIDE_EFFECTS
  - ref.invalidate: USE_FOR_REFRESH
  - ref.refresh: USE_TO_RELOAD_AND_GET_VALUE

provider_types:
  simple_values: "@riverpod T functionName(Ref ref)"
  mutable_sync: "@riverpod class ClassName extends _$ClassName"
  mutable_async: "@riverpod class ClassName extends _$ClassName with AsyncNotifier"
  one_time_async: "@riverpod Future<T> functionName(Ref ref)"
  streaming_data: "@riverpod Stream<T> functionName(Ref ref)"

best_practices:
  - use_select_for_optimization: true
  - use_computed_providers: true
  - use_async_value_guard: true
  - check_ref_mounted: true
  - enable_auto_dispose_by_default: true

new_features_3_0:
  - automatic_retry: ENABLED_BY_DEFAULT
  - offline_persistence: EXPERIMENTAL
  - mutations: EXPERIMENTAL
  - ref_mounted: AVAILABLE
  - generic_support: CODE_GEN_ONLY

legacy_providers:
  - StateProvider: MOVED_TO_LEGACY_IMPORT
  - StateNotifierProvider: MOVED_TO_LEGACY_IMPORT
  - ChangeNotifierProvider: MOVED_TO_LEGACY_IMPORT
  - import_from: "package:flutter_riverpod/legacy.dart"

testing:
  - use_provider_container_test: RECOMMENDED
  - use_tester_container: FOR_WIDGET_TESTS
  - use_override_with_build: FOR_PARTIAL_MOCKS
  - auto_dispose_in_tests: HANDLED_AUTOMATICALLY
```

---

## 📊 Summary Checklist

### Setup
- [ ] ✅ `ProviderScope` wrapping app in `main()`
- [ ] ✅ Add `flutter_riverpod` to dependencies
- [ ] ✅ (Optional) Add `riverpod_annotation` & `riverpod_generator` for code generation
- [ ] ✅ (Optional) Add `riverpod_lint` for better linting
- [ ] ✅ (Optional) Add `hooks_riverpod` for hooks support

### Implementation
- [ ] ✅ Use `@riverpod` annotation (with code generation)
- [ ] ✅ Extend `ConsumerWidget` or `ConsumerStatefulWidget`
- [ ] ✅ Use `ref.watch()` in `build()` method
- [ ] ✅ Use `ref.read()` in callbacks
- [ ] ✅ Use `ref.listen()` for side effects
- [ ] ✅ Immutable state classes with `@immutable`
- [ ] ✅ Use `.select()` to reduce rebuilds
- [ ] ✅ Use `AsyncValue.guard()` for error handling
- [ ] ✅ Check `ref.mounted` before updating state in async operations

### Advanced Features
- [ ] ✅ Use family for parameterized providers
- [ ] ✅ Configure autoDispose with `@Riverpod(keepAlive: true)`
- [ ] ✅ Use computed providers for derived values
- [ ] ✅ (Optional) Enable offline persistence
- [ ] ✅ (Optional) Use mutations for side-effects
- [ ] ✅ Configure automatic retry if needed

### Testing
- [ ] ✅ Use `ProviderContainer.test()` for unit tests
- [ ] ✅ Use `tester.container()` for widget tests
- [ ] ✅ Override providers for mocking
- [ ] ✅ Test async states (loading, data, error)
- [ ] ✅ Verify provider state changes

---

## ⚠️ Migration from Riverpod 2.x

إذا كنت تنتقل من Riverpod 2.x:

### Breaking Changes
1. **StateProvider & StateNotifierProvider** → تم نقلهم لـ `package:flutter_riverpod/legacy.dart`
2. **AutoDispose interfaces** → تم إزالتهم (استخدم `Notifier` بدلاً من `AutoDisposeNotifier`)
3. **FamilyNotifier** → تم دمجه مع `Notifier`
4. **Ref types** → تم توحيدهم لـ `Ref` واحد
5. **AutoDispose default** → مع code generation، autoDispose افتراضي

### Migration Steps
```dart
// ❌ Old (Riverpod 2.x)
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class Counter extends AutoDisposeNotifier<int> {
  @override
  int build() => 0;
}

// ✅ New (Riverpod 3.0 - Without Code Gen)
import 'package:flutter_riverpod/legacy.dart'; // For StateProvider

final counterProvider = StateProvider<int>((ref) => 0);

// OR better, use Notifier
class Counter extends Notifier<int> {
  @override
  int build() => 0;
}

// ✅✅ Best (Riverpod 3.0 - With Code Gen)
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  
  void increment() => state++;
}
```

---

## 🔗 Related Resources

### Official Documentation
- [Riverpod Official Docs](https://riverpod.dev)
- [What's New in 3.0](https://riverpod.dev/docs/whats_new)
- [Migration Guide](https://riverpod.dev/docs/3.0_migration)
- [Code Generation Guide](https://riverpod.dev/docs/concepts/about_code_generation)
- [Hooks Guide](https://riverpod.dev/docs/concepts/about_hooks)

### Examples & Tutorials
- [First Riverpod App](https://riverpod.dev/docs/tutorials/first_app)
- [Testing Guide](https://riverpod.dev/docs/how_to/testing)
- [Select Optimization](https://riverpod.dev/docs/how_to/select)

### Related Rules
- [State Management Comparison](./comparison.md)
- [Provider (Legacy)](./provider.md)
- [Testing](../testing/unit-testing.md)
- [Code Organization](../architecture/folder-structure.md)

---

## 📝 Quick Reference Card

| الاحتياج | الحل مع Code Generation | الحل بدون Code Generation |
|---------|------------------------|--------------------------|
| قيمة ثابتة | `@riverpod T name(Ref ref)` | `Provider<T>()` |
| State قابل للتعديل | `@riverpod class X extends _$X` | `NotifierProvider<>()` |
| Async state | `@riverpod class X extends _$X` | `AsyncNotifierProvider<>()` |
| Async مرة واحدة | `@riverpod Future<T> name(Ref ref)` | `FutureProvider<T>()` |
| Stream مستمر | `@riverpod Stream<T> name(Ref ref)` | `StreamProvider<T>()` |
| مع معاملات | `name(Ref ref, String param)` | `.family<T, Param>()` |
| بدون auto-dispose | `@Riverpod(keepAlive: true)` | `Provider<T>()` (no .autoDispose) |
| مع hooks | `HookConsumerWidget` | `HookConsumerWidget` |

---

**Priority:** 🟡 **HIGH**  
**Level:** ⭐ **RECOMMENDED**  
**Best For:** جميع المشاريع (خصوصاً الجديدة)  
**Type Safe:** ✅ **YES**  
**Version:** Riverpod 3.0+  
**Last Updated:** 2025-10-22  
**Document Version:** 2.0.0

---

> 💡 **نصيحة نهائية**: استخدم **Code Generation** دائماً للمشاريع الجديدة. إنه أبسط وأكثر أماناً ويوفر ميزات إضافية.

# 🚀 ObjectBox - Super-Fast NoSQL Database

## 📋 Metadata

```yaml
priority: MEDIUM
level: ADVANCED
category: Data & Local Storage
package: objectbox
version: 5.0.0+
officially_recommended: false
applies_to:
  - medium_projects
  - large_projects
  - performance_critical
  - offline_first
best_for:
  - high_performance
  - large_datasets
  - real_time_apps
  - offline_support
  - vector_search
ai_agent_tags:
  - database
  - nosql
  - local-storage
  - objectbox
  - performance
  - vector-database
```

---

## 🎯 Overview

**ObjectBox** هو database محلي عالي الأداء لـ Flutter/Dart، **أسرع 10x** من Hive و **أسرع 2x** من Isar، مع دعم **vector search** للـ AI applications.

### **المميزات الرئيسية:**
- ✅ **أداء خيالي** - أسرع database محلي لـ Flutter
- ✅ **NoSQL** - بدون SQL، APIs بديهية
- ✅ **ACID compliant** - معاملات آمنة
- ✅ **Relations** - دعم كامل للعلاقات
- ✅ **Vector Search** - أول database محلي يدعم AI vectors
- ✅ **Cross-platform** - Android, iOS, macOS, Linux, Windows
- ✅ **Data Sync** - مزامنة بين الأجهزة (optional)

---

## 📊 Performance Comparison

### **Benchmarks (Official):**

| Operation | ObjectBox | Hive | Isar | sqflite |
|-----------|-----------|------|------|---------|
| **Create (1000 items)** | ⚡ 7ms | 🐢 70ms | 🏃 15ms | 🐌 200ms |
| **Read (1000 items)** | ⚡ 2ms | 🐢 25ms | 🏃 5ms | 🐌 80ms |
| **Update (1000 items)** | ⚡ 6ms | 🐢 65ms | 🏃 12ms | 🐌 180ms |
| **Delete (1000 items)** | ⚡ 3ms | 🐢 45ms | 🏃 8ms | 🐌 120ms |

**الخلاصة:** ObjectBox هو الأسرع، خاصةً للعمليات الكبيرة!

---

## 🆚 Comparison Table

| الميزة | ObjectBox | Hive | Isar | sqflite |
|--------|-----------|------|------|---------|
| **Performance** | ✅ Fastest | 🟡 Good | ✅ Fast | 🟡 Medium |
| **NoSQL** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ SQL |
| **Relations** | ✅ Built-in | ❌ | ✅ Built-in | 🟡 Manual |
| **Queries** | ✅ Advanced | 🟡 Basic | ✅ Advanced | ✅ SQL |
| **ACID** | ✅ Yes | ❌ | ✅ Yes | ✅ Yes |
| **Vector Search** | ✅ Yes | ❌ | ❌ | ❌ |
| **Data Sync** | ✅ Official | ❌ | ❌ | ❌ |
| **Cross-platform** | ✅ All | ✅ All | ✅ All | ✅ Mobile |
| **Learning Curve** | 🟡 Medium | 🟢 Easy | 🟡 Medium | 🔴 Hard |
| **File Size** | 🟡 ~2MB | 🟢 ~100KB | 🟡 ~1.5MB | 🟢 Built-in |

---

## 📦 Setup

### pubspec.yaml
```yaml
dependencies:
  objectbox: ^5.0.0  # ✅ Latest (Jan 2025)
  objectbox_flutter_libs: ^5.0.0

dev_dependencies:
  build_runner: ^2.10.0
  objectbox_generator: ^5.0.0
```

### Install
```bash
flutter pub add objectbox objectbox_flutter_libs
flutter pub add dev:build_runner dev:objectbox_generator
```

---

## 1️⃣ Basic Setup

### **Step 1: Create Entity**

```dart
import 'package:objectbox/objectbox.dart';

// ✅ Annotate class with @Entity()
@Entity()
class User {
  // ✅ Every entity needs an ID
  @Id()
  int id;
  
  String name;
  String email;
  int age;
  
  User({
    this.id = 0,  // ✅ 0 for auto-increment
    required this.name,
    required this.email,
    required this.age,
  });
}
```

---

### **Step 2: Generate ObjectBox Files**

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs
```

This will generate `objectbox.g.dart` and `objectbox-model.json`.

---

### **Step 3: Initialize Store**

```dart
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart'; // ✅ Generated file

class ObjectBoxManager {
  late final Store store;
  late final Box<User> userBox;
  
  ObjectBoxManager._create(this.store) {
    userBox = store.box<User>();
  }
  
  static Future<ObjectBoxManager> create() async {
    // ✅ Open store
    final store = await openStore();
    return ObjectBoxManager._create(store);
  }
  
  void close() {
    store.close();
  }
}

// Usage in main.dart
late ObjectBoxManager objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize ObjectBox
  objectBox = await ObjectBoxManager.create();
  
  runApp(MyApp());
}
```

---

## 2️⃣ CRUD Operations

### **Create (Insert)**

```dart
// Single object
final user = User(
  name: 'Ahmed',
  email: 'ahmed@example.com',
  age: 25,
);

final id = objectBox.userBox.put(user);
print('User created with ID: $id');

// Multiple objects
final users = [
  User(name: 'Sara', email: 'sara@example.com', age: 22),
  User(name: 'Ali', email: 'ali@example.com', age: 30),
  User(name: 'Mona', email: 'mona@example.com', age: 27),
];

final ids = objectBox.userBox.putMany(users);
print('Created ${ids.length} users');
```

---

### **Read (Get)**

```dart
// Get by ID
final user = objectBox.userBox.get(1);
if (user != null) {
  print('User: ${user.name}');
}

// Get all
final allUsers = objectBox.userBox.getAll();
print('Total users: ${allUsers.length}');

// Get many by IDs
final users = objectBox.userBox.getMany([1, 2, 3]);
```

---

### **Update**

```dart
// Get user
final user = objectBox.userBox.get(1);

if (user != null) {
  // ✅ Modify object
  user.name = 'Ahmed Ali';
  user.age = 26;
  
  // ✅ Put it back (same ID)
  objectBox.userBox.put(user);
  print('User updated!');
}
```

---

### **Delete**

```dart
// Delete by ID
objectBox.userBox.remove(1);

// Delete multiple
objectBox.userBox.removeMany([1, 2, 3]);

// Delete all
objectBox.userBox.removeAll();
```

---

## 3️⃣ Queries

### **Simple Queries**

```dart
// Find users by name
final query = objectBox.userBox
    .query(User_.name.equals('Ahmed'))
    .build();

final results = query.find();
query.close(); // ✅ Always close queries!

// Using query with conditions
final query2 = objectBox.userBox
    .query(User_.age.greaterThan(25))
    .build();

final adults = query2.find();
query2.close();
```

---

### **Advanced Queries**

```dart
// Multiple conditions (AND)
final query = objectBox.userBox
    .query(
      User_.age.greaterThan(20) & User_.age.lessThan(30),
    )
    .build();

final results = query.find();
query.close();

// Multiple conditions (OR)
final query2 = objectBox.userBox
    .query(
      User_.name.equals('Ahmed') | User_.name.equals('Sara'),
    )
    .build();

final results2 = query2.find();
query2.close();

// String operations
final query3 = objectBox.userBox
    .query(User_.email.contains('@gmail.com'))
    .build();

final gmailUsers = query3.find();
query3.close();

// Starts with
final query4 = objectBox.userBox
    .query(User_.name.startsWith('A'))
    .build();

final aNames = query4.find();
query4.close();
```

---

### **Sorting & Limiting**

```dart
// Sort ascending
final query = objectBox.userBox
    .query()
    .order(User_.name)
    .build();

final sortedUsers = query.find();
query.close();

// Sort descending
final query2 = objectBox.userBox
    .query()
    .order(User_.age, flags: Order.descending)
    .build();

final oldestFirst = query2.find();
query2.close();

// Limit results
final query3 = objectBox.userBox
    .query()
    .build()
    ..limit = 10;

final first10 = query3.find();
query3.close();

// Offset + Limit (pagination)
final query4 = objectBox.userBox
    .query()
    .build()
    ..offset = 20
    ..limit = 10;

final page3 = query4.find();
query4.close();
```

---

## 4️⃣ Relations

### **To-One Relationship**

```dart
@Entity()
class Address {
  @Id()
  int id;
  
  String street;
  String city;
  String country;
  
  Address({
    this.id = 0,
    required this.street,
    required this.city,
    required this.country,
  });
}

@Entity()
class User {
  @Id()
  int id;
  
  String name;
  String email;
  
  // ✅ To-One relation
  final address = ToOne<Address>();
  
  User({
    this.id = 0,
    required this.name,
    required this.email,
  });
}

// Usage
final address = Address(
  street: '123 Main St',
  city: 'Cairo',
  country: 'Egypt',
);

final user = User(
  name: 'Ahmed',
  email: 'ahmed@example.com',
);

// ✅ Set relation
user.address.target = address;

// ✅ Put user (address will be saved automatically)
objectBox.userBox.put(user);

// ✅ Access relation
final savedUser = objectBox.userBox.get(1);
print('City: ${savedUser?.address.target?.city}');
```

---

### **To-Many Relationship**

```dart
@Entity()
class Post {
  @Id()
  int id;
  
  String title;
  String content;
  DateTime createdAt;
  
  Post({
    this.id = 0,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

@Entity()
class User {
  @Id()
  int id;
  
  String name;
  
  // ✅ To-Many relation
  final posts = ToMany<Post>();
  
  User({
    this.id = 0,
    required this.name,
  });
}

// Usage
final user = User(name: 'Ahmed');

final post1 = Post(
  title: 'Hello World',
  content: 'My first post',
  createdAt: DateTime.now(),
);

final post2 = Post(
  title: 'Flutter Tips',
  content: 'Amazing tips',
  createdAt: DateTime.now(),
);

// ✅ Add posts to user
user.posts.add(post1);
user.posts.add(post2);

// ✅ Save user (posts will be saved automatically)
objectBox.userBox.put(user);

// ✅ Access relation
final savedUser = objectBox.userBox.get(1);
print('User has ${savedUser?.posts.length} posts');
for (final post in savedUser!.posts) {
  print('- ${post.title}');
}
```

---

## 5️⃣ Indexes

```dart
@Entity()
class User {
  @Id()
  int id;
  
  // ✅ Regular index (faster queries)
  @Index()
  String email;
  
  // ✅ Unique index (no duplicates)
  @Unique()
  String username;
  
  // ✅ Hash index (for exact matches only, faster)
  @Index(type: IndexType.hash)
  String phoneNumber;
  
  String name;
  
  User({
    this.id = 0,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.name,
  });
}

// Usage
final user1 = User(
  email: 'ahmed@example.com',
  username: 'ahmed123', // ✅ Must be unique
  phoneNumber: '+201234567890',
  name: 'Ahmed',
);

objectBox.userBox.put(user1);

// ❌ This will throw error (duplicate username)
final user2 = User(
  email: 'sara@example.com',
  username: 'ahmed123', // ❌ Duplicate!
  phoneNumber: '+201111111111',
  name: 'Sara',
);

try {
  objectBox.userBox.put(user2);
} catch (e) {
  print('Error: Duplicate username!');
}
```

---

## 6️⃣ Transactions

```dart
// ✅ Run multiple operations in a transaction
objectBox.store.runInTransaction(TxMode.write, () {
  // All operations here are atomic
  final user1 = User(name: 'Ahmed', email: 'ahmed@example.com', age: 25);
  final user2 = User(name: 'Sara', email: 'sara@example.com', age: 22);
  
  objectBox.userBox.put(user1);
  objectBox.userBox.put(user2);
  
  // If any operation fails, all will be rolled back
});

// ✅ Read transaction
final count = objectBox.store.runInTransaction(TxMode.read, () {
  return objectBox.userBox.count();
});

print('Total users: $count');
```

---

## 7️⃣ Streams & Reactive Queries

```dart
// ✅ Listen to box changes
final stream = objectBox.userBox.query().watch();

stream.listen((query) {
  final users = query.find();
  print('Users updated: ${users.length}');
  query.close();
});

// ✅ Listen with trigger
final stream2 = objectBox.userBox
    .query()
    .watch(triggerImmediately: true); // ✅ Emit current data immediately

stream2.listen((query) {
  final users = query.find();
  print('Users: ${users.length}');
  query.close();
});

// ✅ Use in StreamBuilder
StreamBuilder<Query<User>>(
  stream: objectBox.userBox.query().watch(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    
    final query = snapshot.data!;
    final users = query.find();
    query.close();
    
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  },
);
```

---

## 8️⃣ Full Example - Task Manager

```dart
import 'package:objectbox/objectbox.dart';

// Models
@Entity()
class Task {
  @Id()
  int id;
  
  String title;
  String? description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;
  
  // ✅ Relation to category
  final category = ToOne<Category>();
  
  Task({
    this.id = 0,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });
}

@Entity()
class Category {
  @Id()
  int id;
  
  @Unique()
  String name;
  
  @Property(type: PropertyType.int)
  int color; // Store Color as int
  
  // ✅ Back-reference to tasks
  @Backlink('category')
  final tasks = ToMany<Task>();
  
  Category({
    this.id = 0,
    required this.name,
    required this.color,
  });
}

// Manager
class TaskManager {
  late final Store store;
  late final Box<Task> taskBox;
  late final Box<Category> categoryBox;
  
  TaskManager._create(this.store) {
    taskBox = store.box<Task>();
    categoryBox = store.box<Category>();
  }
  
  static Future<TaskManager> create() async {
    final store = await openStore();
    return TaskManager._create(store);
  }
  
  // Create task
  int createTask(String title, String? description, int categoryId) {
    final category = categoryBox.get(categoryId);
    if (category == null) throw Exception('Category not found');
    
    final task = Task(
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    task.category.target = category;
    
    return taskBox.put(task);
  }
  
  // Get all tasks
  List<Task> getAllTasks() {
    return taskBox.getAll();
  }
  
  // Get active tasks
  List<Task> getActiveTasks() {
    final query = taskBox
        .query(Task_.isCompleted.equals(false))
        .order(Task_.createdAt, flags: Order.descending)
        .build();
    
    final tasks = query.find();
    query.close();
    return tasks;
  }
  
  // Get completed tasks
  List<Task> getCompletedTasks() {
    final query = taskBox
        .query(Task_.isCompleted.equals(true))
        .order(Task_.completedAt!, flags: Order.descending)
        .build();
    
    final tasks = query.find();
    query.close();
    return tasks;
  }
  
  // Toggle task completion
  void toggleTask(int taskId) {
    final task = taskBox.get(taskId);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      taskBox.put(task);
    }
  }
  
  // Delete task
  void deleteTask(int taskId) {
    taskBox.remove(taskId);
  }
  
  // Create category
  int createCategory(String name, int color) {
    final category = Category(name: name, color: color);
    return categoryBox.put(category);
  }
  
  // Get all categories
  List<Category> getAllCategories() {
    return categoryBox.getAll();
  }
  
  // Get tasks by category
  List<Task> getTasksByCategory(int categoryId) {
    final query = taskBox
        .query(Task_.category.equals(categoryId))
        .build();
    
    final tasks = query.find();
    query.close();
    return tasks;
  }
  
  // Watch tasks stream
  Stream<Query<Task>> watchTasks() {
    return taskBox.query().watch(triggerImmediately: true);
  }
  
  void close() {
    store.close();
  }
}
```

---

## 🎯 Best Practices

### **✅ DO:**
```dart
// ✅ Always close queries
final query = box.query().build();
final results = query.find();
query.close(); // Important!

// ✅ Use transactions for multiple operations
store.runInTransaction(TxMode.write, () {
  box.put(obj1);
  box.put(obj2);
});

// ✅ Use indexes for frequently queried fields
@Index()
String email;

// ✅ Use unique constraints
@Unique()
String username;

// ✅ Use putMany for bulk operations
box.putMany([obj1, obj2, obj3]); // Faster than multiple put()

// ✅ Initialize ObjectBox before runApp()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxManager.create();
  runApp(MyApp());
}
```

### **❌ DON'T:**
```dart
// ❌ Don't forget to close queries
final query = box.query().build();
final results = query.find();
// Missing query.close()!

// ❌ Don't use multiple put() in loops
for (final item in items) {
  box.put(item); // ❌ Slow!
}
// ✅ Use putMany instead
box.putMany(items);

// ❌ Don't forget ID field
@Entity()
class User {
  // Missing @Id() field!
  String name;
}

// ❌ Don't forget to set ID to 0 for auto-increment
User({this.id = 1}); // ❌ Wrong!
User({this.id = 0}); // ✅ Correct

// ❌ Don't close store in normal operations
objectBox.store.close(); // Only close when app is closing!
```

---

## 📝 Checklist

```markdown
Setup:
- [ ] Add objectbox dependency
- [ ] Add objectbox_flutter_libs
- [ ] Add objectbox_generator & build_runner
- [ ] Create entities with @Entity()
- [ ] Add @Id() field to each entity
- [ ] Run build_runner
- [ ] Initialize store before runApp()

Features:
- [ ] CRUD operations (Create, Read, Update, Delete)
- [ ] Queries with conditions
- [ ] Sorting & pagination
- [ ] Relations (ToOne, ToMany)
- [ ] Indexes for performance
- [ ] Unique constraints
- [ ] Transactions
- [ ] Reactive queries (streams)
```

---

## 🔗 Related Rules

- [Local Storage](./local-storage.md) - Overview & comparison
- [JSON Serialization](./json-serialization.md) - For API data
- [HTTP Clients](./http-clients.md) - Fetching data

---

**Priority:** 🟡 MEDIUM  
**Level:** ADVANCED  
**Source:** https://github.com/objectbox/objectbox-dart  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0 for ObjectBox 5.0.0+

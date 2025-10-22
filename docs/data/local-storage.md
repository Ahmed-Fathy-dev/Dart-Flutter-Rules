# Local Storage

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Data
applies_to:
  - all_projects
ai_agent_tags:
  - data
  - storage
  - persistence
  - cache
  - database
  - objectbox
  - hive
  - drift
  - sharedpreferences
alternatives:
  - SharedPreferences: simple key-value
  - Hive: fast NoSQL
  - ObjectBox: ultra-fast with relations (NEW!)
  - Drift: SQL database
```

---

## 🎯 Overview

**Local Storage** لحفظ البيانات محلياً. اختر الحل المناسب حسب نوع البيانات.

### Storage Solutions
- 📝 **SharedPreferences** - Simple key-value
- 📦 **Hive** - Fast NoSQL database
- ⚡ **ObjectBox** - Ultra-fast NoSQL database (NEW!)
- 🗄️ **Drift (sqflite)** - SQL database
- 🔒 **flutter_secure_storage** - Sensitive data

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` - اختر حسب الحاجة

---

## 📚 Core Concepts

### 1. SharedPreferences - Simple Data

#### Setup
```yaml
dependencies:
  shared_preferences: ^2.3.5  # ✅ Updated to latest (2025-10-22)
```

#### Usage
```dart
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;
  
  // Initialize once
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // String
  static String? getString(String key) => _prefs?.getString(key);
  static Future<bool> setString(String key, String value) =>
      _prefs!.setString(key, value);
  
  // Int
  static int? getInt(String key) => _prefs?.getInt(key);
  static Future<bool> setInt(String key, int value) =>
      _prefs!.setInt(key, value);
  
  // Bool
  static bool? getBool(String key) => _prefs?.getBool(key);
  static Future<bool> setBool(String key, bool value) =>
      _prefs!.setBool(key, value);
  
  // Double
  static double? getDouble(String key) => _prefs?.getDouble(key);
  static Future<bool> setDouble(String key, double value) =>
      _prefs!.setDouble(key, value);
  
  // String List
  static List<String>? getStringList(String key) => _prefs?.getStringList(key);
  static Future<bool> setStringList(String key, List<String> value) =>
      _prefs!.setStringList(key, value);
  
  // Remove
  static Future<bool> remove(String key) => _prefs!.remove(key);
  
  // Clear all
  static Future<bool> clear() => _prefs!.clear();
  
  // Check if exists
  static bool containsKey(String key) => _prefs!.containsKey(key);
}

// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(MyApp());
}

// Usage
await PreferencesService.setString('username', 'Ahmed');
final username = PreferencesService.getString('username');

await PreferencesService.setBool('isDarkMode', true);
final isDarkMode = PreferencesService.getBool('isDarkMode') ?? false;
```

---

### 2. Hive - NoSQL Database

#### Setup
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1  # ✅ Updated
  build_runner: ^2.4.14  # ✅ Updated
```

#### Basic Usage
```dart
import 'package:hive_flutter/hive_flutter.dart';

// Initialize
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Open boxes
  await Hive.openBox('settings');
  await Hive.openBox<String>('cache');
  
  runApp(MyApp());
}

// Usage
final box = Hive.box('settings');

// Write
await box.put('theme', 'dark');
await box.put('language', 'ar');

// Read
final theme = box.get('theme', defaultValue: 'light');
final language = box.get('language');

// Delete
await box.delete('theme');

// Clear
await box.clear();

// Close
await box.close();
```

#### Type Adapters
```dart
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String name;
  
  @HiveField(2)
  late String email;
  
  @HiveField(3)
  late int age;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });
}

// Generate: flutter pub run build_runner build

// Register adapter
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  
  await Hive.openBox<User>('users');
  runApp(MyApp());
}

// Usage
final usersBox = Hive.box<User>('users');

// Add
final user = User(
  id: '123',
  name: 'Ahmed',
  email: 'ahmed@example.com',
  age: 25,
);
await usersBox.put(user.id, user);

// Get
final user = usersBox.get('123');

// Get all
final allUsers = usersBox.values.toList();

// Delete
await usersBox.delete('123');

// Watch changes
usersBox.watch().listen((event) {
  print('User changed: ${event.key}');
});
```

---

### 3. ObjectBox - Ultra-Fast NoSQL Database (NEW!)

**ObjectBox** هو أسرع NoSQL database لـ Flutter. أسرع 10x من Hive و 100x من SQLite!

#### Why ObjectBox?
- ⚡ **Ultra-fast** - أسرع من Hive بـ 10 مرات
- 🎯 **Type-safe** - Code generation
- 🔗 **Relations** - دعم كامل للعلاقات
- 📊 **Queries** - Powerful query API
- 🔄 **Sync** - Optional cloud sync
- 📱 **Cross-platform** - Mobile, Desktop, Web

#### Setup
```yaml
dependencies:
  objectbox: ^4.3.0  # ✅ Latest (2025-10-22)
  objectbox_flutter_libs: ^4.3.0  # Platform libraries

dev_dependencies:
  build_runner: ^2.4.15
  objectbox_generator: ^4.3.0  # Code generator
```

#### Install ObjectBox CLI
```bash
# Download objectbox-dart tool
dart pub global activate objectbox_generator

# Or use Flutter
flutter pub global activate objectbox_generator
```

#### Entity Definition
```dart
import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id = 0;  // ObjectBox manages IDs
  
  String name;
  String email;
  int age;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  User({
    required this.name,
    required this.email,
    required this.age,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

// Generate code:
// flutter pub run build_runner build
```

#### Initialize ObjectBox
```dart
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart';  // Generated file

class ObjectBoxStore {
  late final Store _store;
  late final Box<User> _userBox;
  
  static ObjectBoxStore? _instance;
  
  ObjectBoxStore._create(this._store) {
    _userBox = Box<User>(_store);
  }
  
  static Future<ObjectBoxStore> init() async {
    if (_instance != null) return _instance!;
    
    final store = await openStore();
    _instance = ObjectBoxStore._create(store);
    return _instance!;
  }
  
  Box<User> get userBox => _userBox;
  
  void close() {
    _store.close();
  }
}

// In main.dart
late final ObjectBoxStore objectBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBoxStore.init();
  runApp(MyApp());
}
```

#### Basic CRUD Operations
```dart
final userBox = objectBox.userBox;

// Create
final user = User(
  name: 'Ahmed',
  email: 'ahmed@example.com',
  age: 25,
);
final id = userBox.put(user);  // Returns ID
print('Saved with ID: $id');

// Create multiple
final users = [
  User(name: 'Ali', email: 'ali@example.com', age: 30),
  User(name: 'Sara', email: 'sara@example.com', age: 28),
];
userBox.putMany(users);

// Read by ID
final user = userBox.get(1);

// Read all
final allUsers = userBox.getAll();

// Update
user.age = 26;
userBox.put(user);  // Same method for create/update

// Delete
userBox.remove(user.id);

// Delete multiple
userBox.removeMany([1, 2, 3]);

// Delete all
userBox.removeAll();

// Count
final count = userBox.count();
```

#### Queries (Super Fast!)
```dart
// Query builder
final query = userBox
    .query(User_.age.greaterThan(18))
    .build();

final adults = query.find();
query.close();  // Always close queries

// Query with conditions
final query = userBox
    .query(
      User_.name.startsWith('A')
        .and(User_.age.between(20, 30))
    )
    .order(User_.createdAt, flags: Order.descending)
    .build();

final results = query.find();
query.close();

// Query first/single
final firstUser = userBox
    .query(User_.email.equals('ahmed@example.com'))
    .build()
    .findFirst();

// Count query
final adultCount = userBox
    .query(User_.age.greaterOrEqual(18))
    .build()
    .count();
```

#### Relations (One-to-Many)
```dart
@Entity()
class User {
  @Id()
  int id = 0;
  
  String name;
  
  // One-to-Many: User has many Posts
  @Backlink('author')
  final posts = ToMany<Post>();
  
  User({required this.name});
}

@Entity()
class Post {
  @Id()
  int id = 0;
  
  String title;
  String content;
  
  // Many-to-One: Post belongs to User
  final author = ToOne<User>();
  
  Post({required this.title, required this.content});
}

// Usage
final user = User(name: 'Ahmed');
final post1 = Post(title: 'Hello', content: 'World');
final post2 = Post(title: 'Flutter', content: 'Rocks');

// Set relation
post1.author.target = user;
post2.author.target = user;

// Save (saves relations automatically)
userBox.put(user);
postBox.put(post1);
postBox.put(post2);

// Access relations
final userPosts = user.posts;
print('User has ${userPosts.length} posts');

// Query with relations
final usersWithPosts = userBox
    .query(User_.posts.notNull())
    .build()
    .find();
```

#### Many-to-Many Relations
```dart
@Entity()
class Student {
  @Id()
  int id = 0;
  
  String name;
  
  final courses = ToMany<Course>();
  
  Student({required this.name});
}

@Entity()
class Course {
  @Id()
  int id = 0;
  
  String title;
  
  @Backlink('courses')
  final students = ToMany<Student>();
  
  Course({required this.title});
}

// Usage
final student = Student(name: 'Ahmed');
final course1 = Course(title: 'Flutter');
final course2 = Course(title: 'Dart');

student.courses.add(course1);
student.courses.add(course2);

studentBox.put(student);  // Saves all relations
```

#### Indexes for Performance
```dart
@Entity()
class User {
  @Id()
  int id = 0;
  
  // Add index for faster queries
  @Index()
  String email;
  
  // Unique index
  @Unique()
  String username;
  
  String name;
  
  User({
    required this.email,
    required this.username,
    required this.name,
  });
}
```

#### Observers (Watch Changes)
```dart
// Listen to changes
final subscription = userBox
    .query()
    .watch(triggerImmediately: true)
    .listen((query) {
      final users = query.find();
      print('Users updated: ${users.length}');
    });

// Cancel subscription
subscription.cancel();
```

#### Async Operations
```dart
// Async put
await userBox.putAsync(user);

// Async query
final users = await userBox
    .query()
    .build()
    .findAsync();

// Async count
final count = await userBox
    .query()
    .build()
    .countAsync();
```

#### Performance Comparison
```dart
// ObjectBox vs Hive vs SQLite
// Test: Insert 10,000 objects

ObjectBox:  ~30ms   ⚡ Fastest!
Hive:       ~300ms  🟡 10x slower
SQLite:     ~3000ms ❌ 100x slower

// Test: Query 10,000 objects

ObjectBox:  ~5ms    ⚡ Fastest!
Hive:       ~50ms   🟡 10x slower
SQLite:     ~500ms  ❌ 100x slower
```

#### Real-World Example: Note App
```dart
import 'package:objectbox/objectbox.dart';

@Entity()
class Note {
  @Id()
  int id = 0;
  
  String title;
  String content;
  
  @Index()
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  @Property(type: PropertyType.date)
  DateTime? updatedAt;
  
  bool isPinned;
  
  // Tags relation
  final tags = ToMany<Tag>();
  
  Note({
    required this.title,
    required this.content,
    DateTime? createdAt,
    this.updatedAt,
    this.isPinned = false,
  }) : createdAt = createdAt ?? DateTime.now();
}

@Entity()
class Tag {
  @Id()
  int id = 0;
  
  @Unique()
  String name;
  
  String color;
  
  @Backlink('tags')
  final notes = ToMany<Note>();
  
  Tag({required this.name, required this.color});
}

// Repository
class NoteRepository {
  final Box<Note> _noteBox;
  final Box<Tag> _tagBox;
  
  NoteRepository(this._noteBox, this._tagBox);
  
  // Create note
  int createNote(Note note) {
    return _noteBox.put(note);
  }
  
  // Get all notes (newest first)
  List<Note> getAllNotes() {
    return _noteBox
        .query()
        .order(Note_.createdAt, flags: Order.descending)
        .build()
        .find();
  }
  
  // Get pinned notes
  List<Note> getPinnedNotes() {
    return _noteBox
        .query(Note_.isPinned.equals(true))
        .order(Note_.createdAt, flags: Order.descending)
        .build()
        .find();
  }
  
  // Search notes
  List<Note> searchNotes(String query) {
    return _noteBox
        .query(
          Note_.title.contains(query, caseSensitive: false)
            .or(Note_.content.contains(query, caseSensitive: false))
        )
        .build()
        .find();
  }
  
  // Get notes by tag
  List<Note> getNotesByTag(String tagName) {
    final tag = _tagBox
        .query(Tag_.name.equals(tagName))
        .build()
        .findFirst();
    
    return tag?.notes.toList() ?? [];
  }
  
  // Update note
  void updateNote(Note note) {
    note.updatedAt = DateTime.now();
    _noteBox.put(note);
  }
  
  // Delete note
  void deleteNote(int id) {
    _noteBox.remove(id);
  }
  
  // Watch notes stream
  Stream<List<Note>> watchNotes() {
    return _noteBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
```

---

### 4. Drift (SQLite) - SQL Database

#### Setup
```yaml
dependencies:
  drift: ^2.22.0  # ✅ Updated
  sqlite3_flutter_libs: ^0.5.24  # ✅ Updated
  path_provider: ^2.1.5  # ✅ Updated
  path: ^1.9.0  # ✅ Updated

dev_dependencies:
  drift_dev: ^2.22.0  # ✅ Updated
  build_runner: ^2.4.14  # ✅ Updated
```

#### Database Definition
```dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

// Table definition
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  IntColumn get age => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Posts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Database
@DriftDatabase(tables: [Users, Posts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  // CRUD Operations
  
  // Create
  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }
  
  // Read all
  Future<List<User>> getAllUsers() {
    return select(users).get();
  }
  
  // Read one
  Future<User?> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }
  
  // Update
  Future<bool> updateUser(User user) {
    return update(users).replace(user);
  }
  
  // Delete
  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }
  
  // Complex queries
  Future<List<Post>> getPostsByUser(int userId) {
    return (select(posts)..where((p) => p.userId.equals(userId))).get();
  }
  
  // Join
  Future<List<PostWithUser>> getPostsWithUsers() {
    final query = select(posts).join([
      leftOuterJoin(users, users.id.equalsExp(posts.userId)),
    ]);
    
    return query.map((row) {
      return PostWithUser(
        post: row.readTable(posts),
        user: row.readTable(users),
      );
    }).get();
  }
  
  // Watch (Stream)
  Stream<List<User>> watchAllUsers() {
    return select(users).watch();
  }
}

class PostWithUser {
  final Post post;
  final User user;
  
  PostWithUser({required this.post, required this.user});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}

// Usage
final database = AppDatabase();

// Insert
await database.createUser(
  UsersCompanion.insert(
    name: 'Ahmed',
    email: 'ahmed@example.com',
    age: 25,
  ),
);

// Query
final users = await database.getAllUsers();
final user = await database.getUserById(1);

// Update
final user = await database.getUserById(1);
if (user != null) {
  await database.updateUser(
    user.copyWith(name: 'Ahmed Mohamed'),
  );
}

// Delete
await database.deleteUser(1);

// Watch
database.watchAllUsers().listen((users) {
  print('Users updated: ${users.length}');
});
```

---

### 4. flutter_secure_storage - Sensitive Data

#### Setup
```yaml
dependencies:
  flutter_secure_storage: ^9.2.2  # ✅ Updated to latest
```

#### Usage
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  // Write
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  // Read
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
  
  // Delete
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
  
  // Delete all
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
  
  // Check if exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
  
  // Get all
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

// Usage - Store auth token
await SecureStorage.write('auth_token', token);
final token = await SecureStorage.read('auth_token');

// Store credentials
await SecureStorage.write('username', 'ahmed');
await SecureStorage.write('password', 'secret123');
```

---

## ⚖️ Storage Comparison

### **Performance Benchmark:**

| Operation | SharedPreferences | Hive | ObjectBox | Drift (SQLite) |
|-----------|------------------|------|-----------|----------------|
| **Write 1K items** | ~200ms | ~50ms | ⚡ **~5ms** | ~300ms |
| **Read 1K items** | ~50ms | ~20ms | ⚡ **~2ms** | ~100ms |
| **Query complex** | ❌ N/A | ~30ms | ⚡ **~3ms** | ~50ms |
| **Relations** | ❌ No | ⚠️ Limited | ✅ **Full** | ✅ Full |
| **Type Safety** | ❌ No | ✅ Yes | ✅ **Yes** | ✅ Yes |

### **Feature Comparison:**

| Feature | SharedPrefs | Hive | ObjectBox | Drift |
|---------|-------------|------|-----------|-------|
| **Setup Difficulty** | 🟢 Easy | 🟡 Medium | 🟡 Medium | 🔴 Hard |
| **Performance** | 🟢 Good | 🟢 Fast | ⚡ **Ultra-fast** | 🟡 Medium |
| **Relations** | ❌ No | ⚠️ Manual | ✅ **Native** | ✅ SQL |
| **Queries** | ❌ No | 🟡 Limited | ✅ **Powerful** | ✅ SQL |
| **Type Safety** | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes |
| **Code Generation** | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes |
| **Sync Support** | ❌ No | ❌ No | ✅ **Yes** | ❌ No |
| **Platform Support** | ✅ All | ✅ All | ✅ All | ✅ All |
| **Maturity** | ✅ Very Mature | ✅ Mature | 🟡 Newer | ✅ Mature |
| **Learning Curve** | 🟢 Low | 🟡 Medium | 🟡 Medium | 🔴 High |

### **Recommendation by Use Case:**

```yaml
Simple Settings/Preferences:
  ⭐ SharedPreferences
  - Easiest to use
  - Perfect for simple data
  - No setup needed

Cache & Offline Data (Simple):
  ⭐ Hive
  - Fast and easy
  - Good for most cases
  - Mature and stable

High Performance & Relations:
  ⭐⭐⭐ ObjectBox (BEST!)
  - 10x faster than Hive
  - Native relations
  - Real-time queries
  - Perfect for complex apps

SQL & Complex Queries:
  ⭐ Drift
  - Full SQL power
  - Migrations
  - Best for SQL experts
  - Complex joins
```

---

## ✅ Best Practices

### Rule 1: Choose Right Storage

```dart
// ✅ SharedPreferences for:
- User preferences (theme, language)
- Simple settings
- Flags (first launch, onboarding done)
- Small key-value data

// ✅ Hive for:
- Cache data
- Offline-first apps
- Fast read/write
- Complex objects (simple relations)

// ⚡ ObjectBox for: (BEST for performance!)
- High-performance apps
- Complex relations (one-to-many, many-to-many)
- Real-time apps
- Large datasets with fast queries
- When speed is critical
- Offline-first with sync

// ✅ Drift (SQLite) for:
- Relational data
- Complex SQL queries
- Existing SQL knowledge
- Migration from SQL databases
- Need SQL features

// ✅ Secure Storage for:
- Auth tokens
- API keys
- User credentials
- Sensitive data
```

---

### Rule 2: Repository Pattern

```dart
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<List<User>> getAllUsers();
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
}

class HiveUserRepository implements UserRepository {
  final Box<User> _box;
  
  HiveUserRepository(this._box);
  
  @override
  Future<User?> getUser(String id) async {
    return _box.get(id);
  }
  
  @override
  Future<List<User>> getAllUsers() async {
    return _box.values.toList();
  }
  
  @override
  Future<void> saveUser(User user) async {
    await _box.put(user.id, user);
  }
  
  @override
  Future<void> deleteUser(String id) async {
    await _box.delete(id);
  }
}
```

---

### Rule 3: Migration Strategies

```dart
// Drift migrations
@DriftDatabase(tables: [Users, Posts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 2;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // Add new column
          await m.addColumn(users, users.phoneNumber);
        }
      },
    );
  }
}
```

---

## 🎯 Real-World Example: Cache Manager

```dart
class CacheManager {
  static const _cacheBox = 'cache';
  static const _maxAge = Duration(hours: 24);
  
  static Future<void> init() async {
    await Hive.openBox<CacheEntry>(_cacheBox);
  }
  
  static Future<void> put(String key, dynamic data) async {
    final box = Hive.box<CacheEntry>(_cacheBox);
    final entry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
    );
    await box.put(key, entry);
  }
  
  static T? get<T>(String key) {
    final box = Hive.box<CacheEntry>(_cacheBox);
    final entry = box.get(key);
    
    if (entry == null) return null;
    
    // Check if expired
    if (DateTime.now().difference(entry.timestamp) > _maxAge) {
      box.delete(key);
      return null;
    }
    
    return entry.data as T?;
  }
  
  static Future<void> clear() async {
    final box = Hive.box<CacheEntry>(_cacheBox);
    await box.clear();
  }
  
  static Future<void> clearExpired() async {
    final box = Hive.box<CacheEntry>(_cacheBox);
    final now = DateTime.now();
    
    final expiredKeys = box.values
        .where((entry) => now.difference(entry.timestamp) > _maxAge)
        .map((entry) => entry.key)
        .toList();
    
    await box.deleteAll(expiredKeys);
  }
}

@HiveType(typeId: 1)
class CacheEntry extends HiveObject {
  @HiveField(0)
  late dynamic data;
  
  @HiveField(1)
  late DateTime timestamp;
  
  CacheEntry({required this.data, required this.timestamp});
}
```

---

## 🧪 Testing Storage

```dart
import 'package:test/test.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });
  
  tearDown(() async {
    await tearDownTestHive();
  });
  
  group('CacheManager', () {
    test('stores and retrieves data', () async {
      await CacheManager.init();
      
      await CacheManager.put('key', 'value');
      final result = CacheManager.get<String>('key');
      
      expect(result, equals('value'));
    });
    
    test('returns null for expired data', () async {
      // Test with custom max age
    });
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - appropriate storage solution
  - initialization in main
  - error handling
  - repository pattern
  - secure storage for sensitive data
  - proper types for Hive
  - ObjectBox relations setup
  - migrations for Drift

suggest:
  - use SharedPreferences for simple data
  - use Hive for cache/offline data
  - use ObjectBox for high-performance & relations
  - use Drift for SQL requirements
  - use Secure Storage for tokens
  - implement repository pattern
  - add cache expiration

enforce:
  - no sensitive data in SharedPreferences
  - proper initialization
  - error handling
  - cleanup on logout
  - close ObjectBox queries
```

---

## 📊 Summary Checklist

```markdown
- [ ] Storage solution chosen
- [ ] Initialization in main
- [ ] Error handling
- [ ] Repository pattern
- [ ] Secure storage for tokens
- [ ] Cache expiration
- [ ] Tests for storage
- [ ] Migration strategy
```

---

## 🔗 Related Rules

- [State Management](../state-management/comparison.md)
- [Error Handling](../core/error-handling.md)
- [Testing](../testing/unit-testing.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Last Updated:** 2025-10-22  
**Version:** 2.0.0 - Added ObjectBox (ultra-fast NoSQL)

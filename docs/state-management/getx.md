# 📦 GetX - All-in-One Solution

## 📋 Metadata

```yaml
priority: MEDIUM
level: OPTIONAL
category: State Management
package: get
version: 4.7.2+
officially_recommended: false
applies_to:
  - small_projects
  - rapid_prototyping
  - solo_developers
best_for:
  - quick_development
  - less_boilerplate
  - all_in_one_solution
ai_agent_tags:
  - state-management
  - navigation
  - dependency-injection
  - getx
  - reactive
  - simple-state
```

---

## 🎯 Overview

**GetX** هو حل شامل وخفيف الوزن لـ Flutter يجمع بين:
- ✅ **State Management** (إدارة الحالة)
- ✅ **Route Management** (إدارة التنقل)
- ✅ **Dependency Injection** (حقن الاعتماديات)

### **المبادئ الثلاثة:**
1. **PRODUCTIVITY** - إنتاجية عالية
2. **PERFORMANCE** - أداء ممتاز (لا Streams أو ChangeNotifier)
3. **ORGANIZATION** - تنظيم كامل للكود

---

## 📊 Comparison

### **مقارنة مع الحلول الأخرى:**

| الميزة | GetX | Riverpod | Bloc | Provider |
|--------|------|----------|------|----------|
| **State Management** | ✅ | ✅ | ✅ | ✅ |
| **Navigation** | ✅ Built-in | ❌ | ❌ | ❌ |
| **DI** | ✅ Built-in | ✅ | ❌ | ✅ |
| **Boilerplate** | 🟢 قليل جداً | 🟡 متوسط | 🔴 كثير | 🟡 متوسط |
| **Learning Curve** | 🟢 سهل | 🟡 متوسط | 🔴 صعب | 🟢 سهل |
| **Performance** | ✅ ممتاز | ✅ ممتاز | ✅ جيد | ✅ جيد |
| **Context Required** | ❌ لا | 🟡 أحياناً | ✅ نعم | ✅ نعم |
| **Testability** | 🟡 جيد | ✅ ممتاز | ✅ ممتاز | ✅ جيد |

---

## 📦 Setup

### pubspec.yaml
```yaml
dependencies:
  get: ^4.7.2  # ✅ Latest (Jan 2025)
```

### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(  // ✅ استبدل MaterialApp بـ GetMaterialApp
      title: 'GetX App',
      home: HomeScreen(),
      // Optional configs
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    ),
  );
}
```

> ⚠️ **ملاحظة:** `GetMaterialApp` مطلوب فقط لـ Navigation و Dialogs. إذا كنت تستخدم GetX للـ State Management فقط، يمكنك استخدام `MaterialApp` العادي.

---

## 1️⃣ State Management

GetX يوفر **طريقتين** لإدارة الحالة:

### **A. Reactive State Manager (GetX/Obx)** ⭐ موصى به

#### **مثال بسيط - Counter:**

```dart
import 'package:get/get.dart';

// 1. Controller
class CounterController extends GetxController {
  // ✅ اجعل المتغير observable بإضافة .obs
  var count = 0.obs;
  
  void increment() => count++;
  void decrement() => count--;
  void reset() => count.value = 0;
}

// 2. View
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ أنشئ Controller باستخدام Get.put()
    final controller = Get.put(CounterController());
    
    return Scaffold(
      appBar: AppBar(
        // ✅ استخدم Obx() للتحديث التلقائي
        title: Obx(() => Text('Count: ${controller.count}')),
      ),
      body: Center(
        child: Obx(
          () => Text(
            '${controller.count}',
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: controller.increment,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: controller.decrement,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

---

### **مثال متقدم - Todo List:**

```dart
// Models
class Todo {
  final String id;
  final String title;
  final bool isDone;
  
  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
  });
  
  Todo copyWith({String? title, bool? isDone}) {
    return Todo(
      id: this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

// Controller
class TodoController extends GetxController {
  // ✅ Observable List
  final todos = <Todo>[].obs;
  
  // ✅ Observable variables
  final isLoading = false.obs;
  final filter = 'all'.obs;  // all, active, completed
  
  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }
  
  Future<void> loadTodos() async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      todos.value = [
        Todo(id: '1', title: 'Learn GetX'),
        Todo(id: '2', title: 'Build App', isDone: true),
      ];
    } finally {
      isLoading.value = false;
    }
  }
  
  void addTodo(String title) {
    todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
    ));
  }
  
  void toggleTodo(String id) {
    final index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(
        isDone: !todos[index].isDone,
      );
      todos.refresh();  // ✅ Force update
    }
  }
  
  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
  }
  
  // Computed property (Getter)
  List<Todo> get filteredTodos {
    switch (filter.value) {
      case 'active':
        return todos.where((todo) => !todo.isDone).toList();
      case 'completed':
        return todos.where((todo) => todo.isDone).toList();
      default:
        return todos;
    }
  }
  
  int get activeCount => todos.where((todo) => !todo.isDone).length;
}

// View
class TodoScreen extends StatelessWidget {
  final controller = Get.put(TodoController());
  final textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Todo'),
        actions: [
          Obx(() => Chip(
            label: Text('Active: ${controller.activeCount}'),
          )),
        ],
      ),
      body: Column(
        children: [
          // Filter buttons
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterButton('all', 'All', controller),
              FilterButton('active', 'Active', controller),
              FilterButton('completed', 'Completed', controller),
            ],
          )),
          
          // Todo list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              final todos = controller.filteredTodos;
              
              if (todos.isEmpty) {
                return Center(child: Text('No todos'));
              }
              
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: todo.isDone,
                      onChanged: (_) => controller.toggleTodo(todo.id),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteTodo(todo.id),
                    ),
                  );
                },
              );
            }),
          ),
          
          // Add todo
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter todo...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      controller.addTodo(textController.text);
                      textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String value;
  final String label;
  final TodoController controller;
  
  FilterButton(this.value, this.label, this.controller);
  
  @override
  Widget build(BuildContext context) {
    final isSelected = controller.filter.value == value;
    return ElevatedButton(
      onPressed: () => controller.filter.value = value,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
      child: Text(label),
    );
  }
}
```

---

### **B. Simple State Manager (GetBuilder)** 

للحالات البسيطة حيث لا تحتاج Reactive:

```dart
class SimpleController extends GetxController {
  int count = 0;
  
  void increment() {
    count++;
    update();  // ✅ استدعي update() يدوياً
  }
}

class SimpleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SimpleController>(
        init: SimpleController(),
        builder: (controller) {
          return Text('Count: ${controller.count}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.find<SimpleController>().increment(),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

## 2️⃣ Route Management

### **Basic Navigation:**

```dart
// Navigate to screen
Get.to(() => NextScreen());

// Navigate with name
Get.toNamed('/details');

// Navigate with arguments
Get.to(() => UserScreen(), arguments: {'id': 123});

// Go back
Get.back();

// Go back with result
Get.back(result: 'success');
```

---

### **Advanced Navigation:**

```dart
// Replace current screen (no back)
Get.off(() => LoginScreen());

// Clear all and go to screen
Get.offAll(() => HomeScreen());

// Navigate until condition
Get.until((route) => route.settings.name == '/home');

// Navigate with transition
Get.to(
  () => NextScreen(),
  transition: Transition.fadeIn,
  duration: Duration(milliseconds: 300),
);
```

---

### **Named Routes:**

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/details', page: () => DetailsScreen()),
        GetPage(
          name: '/user/:id',
          page: () => UserScreen(),
        ),
      ],
    ),
  );
}

// Usage
Get.toNamed('/details');
Get.toNamed('/user/123');

// Get parameters
final id = Get.parameters['id'];

// Get arguments
final args = Get.arguments;
```

---

### **Dialogs & Snackbars (بدون Context):**

```dart
// Snackbar
Get.snackbar(
  'Title',
  'Message',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.green,
  colorText: Colors.white,
);

// Dialog
Get.defaultDialog(
  title: 'Delete',
  middleText: 'Are you sure?',
  onConfirm: () => Get.back(result: true),
  onCancel: () => Get.back(result: false),
);

// Bottom Sheet
Get.bottomSheet(
  Container(
    height: 200,
    color: Colors.white,
    child: Center(child: Text('Bottom Sheet')),
  ),
);
```

---

## 3️⃣ Dependency Injection

### **Basic DI:**

```dart
// Register dependency
final controller = Get.put(MyController());

// Find dependency
final controller = Get.find<MyController>();

// Lazy registration (only when first used)
Get.lazyPut(() => MyController());

// Keep in memory permanently
Get.put(MyController(), permanent: true);

// Register as Singleton
Get.putAsync(() async => await MyService.init());
```

---

### **Bindings (Recommended for large apps):**

```dart
// 1. Create Binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ApiService());
  }
}

// 2. Use in routes
GetMaterialApp(
  getPages: [
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      binding: HomeBinding(),  // ✅ Auto inject dependencies
    ),
  ],
);

// 3. Use in controller
class HomeController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  @override
  void onInit() {
    super.onInit();
    // Controller ready - dependencies injected
  }
}
```

---

## 🎯 GetX Controller Lifecycle

```dart
class LifecycleController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // ✅ Called when controller is created
    print('Controller initialized');
  }
  
  @override
  void onReady() {
    super.onReady();
    // ✅ Called after build() - safe to call APIs
    print('Controller ready');
    loadData();
  }
  
  @override
  void onClose() {
    // ✅ Called when controller is removed from memory
    print('Controller closed');
    super.onClose();
  }
  
  Future<void> loadData() async {
    // Load data here
  }
}
```

---

## 📚 Full Example - Login App

```dart
// Model
class User {
  final String id;
  final String name;
  final String email;
  
  User({required this.id, required this.name, required this.email});
}

// Auth Controller
class AuthController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final isLoading = false.obs;
  
  bool get isLoggedIn => user.value != null;
  
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      user.value = User(
        id: '1',
        name: 'Ahmed',
        email: email,
      );
      
      Get.offAll(() => HomeScreen());
      Get.snackbar('Success', 'Logged in successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  void logout() {
    user.value = null;
    Get.offAll(() => LoginScreen());
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  final controller = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => controller.login(
                      emailController.text,
                      passwordController.text,
                    ),
                    child: Text('Login'),
                  )),
          ],
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatelessWidget {
  final controller = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Welcome ${controller.user.value?.name}')),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Obx(() => Text('Email: ${controller.user.value?.email}')),
      ),
    );
  }
}
```

---

## ⚠️ When NOT to Use GetX

### **تجنب GetX في:**
1. ❌ **Large enterprise apps** - استخدم Riverpod أو Bloc
2. ❌ **Apps needing strict architecture** - استخدم Clean Architecture + Bloc
3. ❌ **Teams with many developers** - قد يؤدي لـ "God Objects"
4. ❌ **Apps requiring heavy testing** - GetX testing أصعب من Bloc/Riverpod

### **استخدم GetX في:**
1. ✅ **Small to medium apps**
2. ✅ **MVPs and prototypes**
3. ✅ **Solo developers**
4. ✅ **Apps needing quick development**
5. ✅ **Apps without complex state**

---

## 🎯 Best Practices

### **✅ DO:**
```dart
// ✅ Use meaningful names
class ProductsController extends GetxController {}

// ✅ Keep controllers small and focused
class ProductListController extends GetxController {}
class ProductDetailsController extends GetxController {}

// ✅ Use Bindings for dependency management
class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsController());
  }
}

// ✅ Clean up resources
@override
void onClose() {
  textController.dispose();
  super.onClose();
}

// ✅ Use .obs for reactive variables
final count = 0.obs;

// ✅ Use Obx() for small reactive widgets
Obx(() => Text('${controller.count}'))
```

### **❌ DON'T:**
```dart
// ❌ Don't put everything in one controller
class AppController extends GetxController {
  // Auth, Products, Cart, Profile... (too much!)
}

// ❌ Don't overuse Get.find()
// Bad:
Get.find<Controller1>().doSomething();
Get.find<Controller2>().doSomething();
Get.find<Controller3>().doSomething();

// ✅ Good: Use Bindings

// ❌ Don't forget to dispose
// Always override onClose() for cleanup

// ❌ Don't use GetX everywhere
// Use it where it makes sense
```

---

## 📝 Checklist

```markdown
Setup:
- [ ] Add get package
- [ ] Replace MaterialApp with GetMaterialApp
- [ ] Define routes (if using named routes)

State Management:
- [ ] Create controllers extending GetxController
- [ ] Use .obs for reactive variables
- [ ] Use Obx() or GetX() in UI
- [ ] Implement onInit/onReady/onClose

Navigation:
- [ ] Use Get.to() instead of Navigator.push()
- [ ] Use Get.back() instead of Navigator.pop()
- [ ] Define named routes if needed

Dependency Injection:
- [ ] Use Get.put() to register
- [ ] Use Get.find() to retrieve
- [ ] Create Bindings for related dependencies
- [ ] Clean up in onClose()
```

---

## 🔗 Related Rules

- [Riverpod](./riverpod.md) - Alternative (Recommended)
- [Bloc](./bloc.md) - Alternative
- [Provider](./provider.md) - Alternative
- [Comparison Guide](./comparison.md) - Compare all options

---

**Priority:** 🟡 MEDIUM  
**Level:** OPTIONAL  
**Source:** https://github.com/jonataslaw/getx  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0 for GetX 4.7.2+

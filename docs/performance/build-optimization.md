# Build Method Optimization

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Performance
applies_to:
  - all_flutter_projects
performance_impact: high
ai_agent_tags:
  - performance
  - optimization
  - build-method
  - rebuilds
  - widgets
```

---

## 🎯 Overview

**Build Method Optimization** يقلل rebuilds غير الضرورية ويحسن performance. كل rebuild يكلف CPU و Memory.

### Why Optimize Build?
- ⚡ Faster UI
- 🔋 Better battery life
- 📱 Smoother animations
- 🎯 Better UX
- 📊 Less jank

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` - Critical for complex UIs

---

## 📚 Core Concepts

### 1. Const Constructors

```dart
// ❌ Bad - Rebuilds every time
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello'),
    );
  }
}

// ✅ Good - const constructors
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Container(
      child: Text('Hello'),
    );
  }
}

// ✅ Even better - const widget
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Container(
      child: Text('Hello'),
    );
  }
}
```

---

### 2. Extract Widgets

```dart
// ❌ Bad - Entire widget rebuilds
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return Column(
          children: [
            // Header rebuilds unnecessarily
            Container(
              height: 200,
              child: Text('Profile'),
            ),
            // Only this needs to rebuild
            Text(user.name),
            Text(user.email),
          ],
        );
      },
    );
  }
}

// ✅ Good - Extract static parts
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Header(), // Doesn't rebuild
        Consumer<UserModel>(
          builder: (context, user, child) {
            return Column(
              children: [
                Text(user.name),
                Text(user.email),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: const Text('Profile'),
    );
  }
}
```

---

### 3. Use child Parameter

```dart
// ❌ Bad - Everything rebuilds
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Column(
          children: [
            Text('Count: ${counter.value}'),
            // This rebuilds every time! ❌
            Container(
              height: 200,
              color: Colors.blue,
              child: const Text('Static Content'),
            ),
          ],
        );
      },
    );
  }
}

// ✅ Good - Use child parameter
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (context, counter, child) {
        return Column(
          children: [
            Text('Count: ${counter.value}'),
            child!, // Reused, doesn't rebuild ✅
          ],
        );
      },
      child: Container(
        height: 200,
        color: Colors.blue,
        child: const Text('Static Content'),
      ),
    );
  }
}
```

---

### 4. Avoid Creating Objects in build()

```dart
// ❌ Bad - Creates new objects every rebuild
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // New object every rebuild ❌
        backgroundColor: Colors.blue,
        padding: EdgeInsets.all(16),
      ),
      onPressed: () {},
      child: const Text('Click'),
    );
  }
}

// ✅ Good - Static objects
class MyWidget extends StatelessWidget {
  static final _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: const EdgeInsets.all(16),
  );
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle, // Reused ✅
      onPressed: () {},
      child: const Text('Click'),
    );
  }
}
```

---

### 5. Localize setState

```dart
// ❌ Bad - Entire screen rebuilds
class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rebuilds ❌
        ExpensiveWidget(),
        // Rebuilds ❌
        AnotherExpensiveWidget(),
        // Only this needs to rebuild
        Text('$_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

// ✅ Good - Extract stateful part
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(), // Doesn't rebuild ✅
        const AnotherExpensiveWidget(), // Doesn't rebuild ✅
        const _Counter(), // Only this rebuilds ✅
      ],
    );
  }
}

class _Counter extends StatefulWidget {
  const _Counter();
  
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

---

### 6. Use Keys Wisely

```dart
// ✅ Good - ValueKey for list items
class TodoList extends StatelessWidget {
  final List<Todo> todos;
  
  const TodoList(this.todos);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          key: ValueKey(todo.id), // ✅ Preserves state
          todo: todo,
        );
      },
    );
  }
}

// ✅ Good - GlobalKey for maintaining state
class MyWidget extends StatefulWidget {
  static final key = GlobalKey<_MyWidgetState>();
  
  MyWidget() : super(key: key);
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}
```

---

### 7. Avoid Functions in build()

```dart
// ❌ Bad - Function called every rebuild
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getColor(), // ❌ Called every rebuild
      child: Text(_formatText()), // ❌ Called every rebuild
    );
  }
  
  Color _getColor() => Colors.blue;
  String _formatText() => 'Hello';
}

// ✅ Good - Compute once
class MyWidget extends StatelessWidget {
  static const _color = Colors.blue;
  static const _text = 'Hello';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color, // ✅ Constant
      child: const Text(_text), // ✅ Constant
    );
  }
}

// ✅ Good - For dynamic values, cache in State
class _MyWidgetState extends State<MyWidget> {
  late final _color = _computeColor();
  late final _text = _formatText();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color, // ✅ Computed once
      child: Text(_text), // ✅ Computed once
    );
  }
}
```

---

### 8. RepaintBoundary for Complex Widgets

```dart
// ✅ Good - Isolate repaints
class ExpensiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ComplexPainter(),
        child: Container(
          // Complex widget tree
        ),
      ),
    );
  }
}

// ✅ Good - Isolate animations
class AnimatedWidget extends StatefulWidget {
  @override
  State<AnimatedWidget> createState() => _AnimatedWidgetState();
}

class _AnimatedWidgetState extends State<AnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: child,
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Profile First

```dart
// Use DevTools to find performance issues
// 1. Open DevTools
// 2. Go to Performance tab
// 3. Record a session
// 4. Look for:
//    - Long frame times (> 16ms)
//    - Excessive builds
//    - Expensive operations

// ✅ Good - Measure before optimizing
void main() {
  debugProfileBuildsEnabled = true; // Enable in debug
  runApp(MyApp());
}
```

---

### Rule 2: const Everything Possible

```dart
// ✅ Good - Maximum const usage
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Column(
        children: [
          Text('Static Text'),
          SizedBox(height: 16),
          Icon(Icons.home),
        ],
      ),
    );
  }
}
```

---

### Rule 3: Extract Large Widgets

```dart
// ❌ Bad - Large build method
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 100 lines of header widgets
          Container(...),
          Row(...),
          // 200 lines of content widgets
          ListView(...),
          // 50 lines of footer widgets
          BottomAppBar(...),
        ],
      ),
    );
  }
}

// ✅ Good - Extracted widgets
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          _Header(),
          Expanded(child: _Content()),
          _Footer(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    // Header implementation
  }
}
```

---

## 🎯 Performance Checklist

```markdown
- [ ] Use const constructors
- [ ] Extract static widgets
- [ ] Localize setState
- [ ] Avoid expensive operations in build
- [ ] Use RepaintBoundary
- [ ] Cache computed values
- [ ] Use appropriate keys
- [ ] Profile with DevTools
- [ ] Check rebuild count
- [ ] Optimize list rendering
```

---

## 🔍 Debugging Rebuilds

```dart
// Add debugPrintRebuild
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('MyWidget rebuilt'); // Track rebuilds
    return Container();
  }
}

// Or use PerformanceOverlay
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true, // Show FPS
      home: HomeScreen(),
    );
  }
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - const constructors
  - extracted widgets
  - localized setState
  - child parameter usage
  - no expensive operations in build
  - RepaintBoundary usage
  - proper keys

suggest:
  - add const where possible
  - extract large widgets
  - localize state changes
  - use child parameter
  - add RepaintBoundary
  - cache computed values

enforce:
  - const constructors
  - no setState in root widgets
  - widget extraction for > 100 lines
  - proper key usage in lists
```

---

## 📊 Summary

| Technique | Impact | Difficulty |
|-----------|--------|------------|
| **const** | High | Easy |
| **Extract widgets** | High | Easy |
| **Localize setState** | High | Medium |
| **child parameter** | Medium | Easy |
| **RepaintBoundary** | Medium | Medium |
| **Keys** | Medium | Hard |

---

## 🔗 Related Rules

- [Performance Basics](../flutter-basics/performance-basics.md)
- [List Optimization](./list-optimization.md)
- [Image Optimization](./image-optimization.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Impact:** High  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

# Performance Basics

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Flutter Basics
applies_to:
  - all_flutter_projects
ai_agent_tags:
  - performance
  - optimization
  - const
  - listview
  - build-method
  - critical
```

---

## 🎯 Overview

**Performance** مهم لتجربة مستخدم سلسة. Flutter يستهدف 60 FPS (16ms per frame)، وهناك قواعد أساسية يجب اتباعها لتحقيق ذلك.

### Why It Matters
- ⚡ Smooth UI (60 FPS)
- 🔋 Battery efficient
- 📱 Better UX
- 🚀 Faster app

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - أساسيات لكل تطبيق

### Why CRITICAL?

```dart
// ❌ Bad - App lags (drops frames)
ListView(
  children: List.generate(10000, (i) => Text('Item $i')),
) // Creates 10000 widgets at once!

// ✅ Good - Smooth 60 FPS
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, i) => Text('Item $i'),
) // Creates only visible widgets
```

---

## 📚 Core Concepts

### 1. Use const Constructors

#### Why const?
```dart
// Without const:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Hello'),  // New instance every build
        Icon(Icons.star), // New instance every build
      ],
    );
  }
}
// On each rebuild: creates 3 new objects (Column, Text, Icon)

// With const:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Hello'),  // Reused ⚡
        const Icon(Icons.star), // Reused ⚡
      ],
    );
  }
}
// On rebuild: reuses existing objects!
```

#### When to use const

```dart
// ✅ Static values
const Text('Welcome')
const SizedBox(height: 16)
const Icon(Icons.home)
const Divider()
const Padding(padding: EdgeInsets.all(8))

// ✅ Static configurations
const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
const BorderRadius.circular(8)

// ❌ Can't use const with:
Text(userName) // Dynamic value
Icon(selectedIcon) // Dynamic value
Container(color: Theme.of(context).primaryColor) // Runtime value
```

#### const deep in widget tree

```dart
// ✅ Excellent - const as deep as possible
class MyScreen extends StatelessWidget {
  final String title;
  
  const MyScreen(this.title, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Can't be const (dynamic)
      ),
      body: Column(
        children: [
          Text(title), // Can't be const
          const SizedBox(height: 16), // ✅ const
          const Divider(), // ✅ const
          const _StaticContent(), // ✅ const widget
        ],
      ),
    );
  }
}

class _StaticContent extends StatelessWidget {
  const _StaticContent();
  
  @override
  Widget build(BuildContext context) {
    // Entire subtree is const ⚡
    return const Column(
      children: [
        Text('Static Text'),
        SizedBox(height: 8),
        Icon(Icons.info),
      ],
    );
  }
}
```

---

### 2. ListView.builder for Long Lists

```dart
// ❌ Bad - Creates ALL widgets at once
ListView(
  children: [
    for (var item in items) // ALL items
      ItemWidget(item),
  ],
)
// If items = 1000 → creates 1000 widgets immediately!
// Memory: HIGH, Performance: BAD

// ✅ Good - Lazy loading
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)
// Creates only visible widgets (~10-15)
// Memory: LOW, Performance: GOOD ⚡

// ✅ Also good - for GridView
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(items[index]),
)
```

#### When to use .builder?

```dart
// Use ListView (regular) when:
- Small list (< 20 items)
- All widgets needed (e.g., different widget types)
- Items are very lightweight

// Use ListView.builder when:
- Large list (> 20 items) ✅
- Same widget type repeated
- Performance matters ✅
```

---

### 3. Avoid Expensive Operations in build()

```dart
// ❌ Bad - Heavy work in build()
class MyWidget extends StatelessWidget {
  final List<int> numbers;
  
  @override
  Widget build(BuildContext context) {
    // ❌ Sorts on EVERY rebuild!
    final sorted = numbers.toList()..sort();
    
    // ❌ Filter on EVERY rebuild!
    final evens = sorted.where((n) => n % 2 == 0).toList();
    
    // ❌ Complex calculation
    final sum = evens.fold(0, (a, b) => a + b * b);
    
    return Text('Sum: $sum');
  }
}
// This runs 60 times per second if rebuilding!

// ✅ Good - Cache or compute once
class MyWidget extends StatefulWidget {
  final List<int> numbers;
  const MyWidget(this.numbers, {super.key});
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final int _sum; // Computed once
  
  @override
  void initState() {
    super.initState();
    // ✅ Compute ONCE in initState
    final sorted = widget.numbers.toList()..sort();
    final evens = sorted.where((n) => n % 2 == 0);
    _sum = evens.fold(0, (a, b) => a + b * b);
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Sum: $_sum'); // Just display
  }
}
```

#### What to avoid in build():

```dart
❌ Network calls
❌ File I/O
❌ Database queries
❌ Heavy computations
❌ Large data sorting/filtering
❌ Complex calculations
❌ Creating new controllers/streams

✅ Simple widget composition
✅ Accessing cached data
✅ Simple conditionals
✅ Accessing state/properties
```

---

### 4. Use compute() for Heavy Tasks

```dart
// ❌ Bad - Blocks UI thread
Future<void> parseJson() async {
  final response = await api.getData();
  final parsed = jsonDecode(response); // Blocks UI!
  setState(() => data = parsed);
}

// ✅ Good - Use compute (Isolate)
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<void> parseJson() async {
  final response = await api.getData();
  
  // Run in separate isolate
  final parsed = await compute(_parseInIsolate, response);
  
  setState(() => data = parsed);
}

// Top-level or static function
Map<String, dynamic> _parseInIsolate(String json) {
  return jsonDecode(json);
}
```

#### When to use compute():

```dart
Use compute() for:
✅ Parsing large JSON (> 100KB)
✅ Image processing
✅ Complex calculations
✅ Large data transformations
✅ Encryption/Decryption

Threshold: If operation takes > 16ms (1 frame)
```

---

### 5. Extract Widgets to Reduce Rebuilds

```dart
// ❌ Bad - Entire screen rebuilds
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ❌ These rebuild even though they don't change
        Text('Static Header'),
        SizedBox(height: 16),
        Icon(Icons.info),
        Divider(),
        
        // Only this needs to rebuild
        Text('Count: $_count'),
        
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// ✅ Good - Extract static parts
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ const - never rebuilds
        const _StaticHeader(),
        
        // ✅ Only this rebuilds
        Text('Count: $_count'),
        
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

class _StaticHeader extends StatelessWidget {
  const _StaticHeader();
  
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Static Header'),
        SizedBox(height: 16),
        Icon(Icons.info),
        Divider(),
      ],
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Keep build() Pure and Fast

```dart
// ❌ Bad
@override
Widget build(BuildContext context) {
  final user = getCurrentUser(); // ❌ Side effect
  saveToCache(user); // ❌ Side effect
  log('Building widget'); // ❌ Side effect
  
  return Text(user.name);
}

// ✅ Good
@override
Widget build(BuildContext context) {
  // Pure function - just returns widgets
  return Text(widget.user.name);
}
```

---

### Rule 2: Use RepaintBoundary for Complex Widgets

```dart
// ✅ Isolate expensive repaints
RepaintBoundary(
  child: ComplexChart(data: chartData),
)
// Chart won't trigger repaints of parent
```

---

### Rule 3: Avoid Opacity for Animations

```dart
// ❌ Bad - Expensive
Opacity(
  opacity: _animation.value,
  child: ExpensiveWidget(),
)

// ✅ Good - Use FadeTransition
FadeTransition(
  opacity: _animation,
  child: ExpensiveWidget(),
)

// Or AnimatedOpacity for simple cases
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: ExpensiveWidget(),
)
```

---

### Rule 4: Image Optimization

```dart
// ❌ Bad - Full size image
Image.network('https://example.com/huge-image.jpg')

// ✅ Good - Cached and sized
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// ✅ Good - Precache important images
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(
    AssetImage('assets/important-image.png'),
    context,
  );
}
```

---

### Rule 5: Efficient State Updates

```dart
// ❌ Bad - Updates entire list
setState(() {
  _items.add(newItem);
})
// Rebuilds entire ListView!

// ✅ Good - Use state management
// With Provider/Riverpod/Bloc
final items = ref.watch(itemsProvider);
// Only affected widgets rebuild

// ✅ Good - AnimatedList for list updates
AnimatedList(
  key: _listKey,
  itemBuilder: (context, index, animation) {
    return _buildItem(_items[index], animation);
  },
)

// Add with animation
_listKey.currentState!.insertItem(_items.length);
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Creating Objects in build()

```dart
// ❌ Bad - New controller every build
@override
Widget build(BuildContext context) {
  final controller = TextEditingController(); // ❌
  return TextField(controller: controller);
}

// ✅ Good - Create once
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

---

### Pitfall 2: Unnecessary setState()

```dart
// ❌ Bad - setState for entire screen
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget1(), // ❌ Rebuilds
        ExpensiveWidget2(), // ❌ Rebuilds
        Text('Counter: $_counter'), // Only this needs rebuild
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// ✅ Good - Localized state
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget1(), // ✅ Never rebuilds
        ExpensiveWidget2(), // ✅ Never rebuilds
        _Counter(), // ✅ Only this rebuilds
      ],
    );
  }
}

class _Counter extends StatefulWidget {
  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

### Pitfall 3: Large Widgets in ListView

```dart
// ❌ Bad - Complex widget for each item
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Many nested widgets...
        ],
      ),
    );
  },
)

// ✅ Good - Extract and optimize
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ItemCard(items[index]),
)

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard(this.item, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(item.name[0])),
        title: Text(item.name),
        subtitle: Text(item.description),
      ),
    );
  }
}
```

---

## 💡 Performance Monitoring

### 1. Performance Overlay

```dart
MaterialApp(
  showPerformanceOverlay: true, // Shows FPS
  home: MyHomePage(),
)
```

### 2. DevTools Timeline

```dart
import 'dart:developer' as developer;

void expensiveOperation() {
  developer.Timeline.startSync('ExpensiveOperation');
  // ... code ...
  developer.Timeline.finishSync();
}
```

### 3. Performance Metrics

```dart
import 'package:flutter/scheduler.dart';

SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
  for (final timing in timings) {
    final buildTime = timing.buildDuration;
    final rasterTime = timing.rasterDuration;
    
    if (buildTime > Duration(milliseconds: 16)) {
      print('Frame drop! Build took: $buildTime');
    }
  }
});
```

---

## 🧪 Testing Performance

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ListView should not create all items', (tester) async {
    final items = List.generate(1000, (i) => 'Item $i');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Text(items[index]),
          ),
        ),
      ),
    );
    
    // Only visible items should be created
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 999'), findsNothing);
  });
  
  testWidgets('const widgets are reused', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Text('Hello'),
              Text('Hello'),
            ],
          ),
        ),
      ),
    );
    
    final texts = tester.widgetList<Text>(find.byType(Text));
    expect(identical(texts.first, texts.last), isTrue);
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - const constructors وconst widgets
  - ListView.builder للقوائم الطويلة (> 20 items)
  - لا عمليات ثقيلة في build()
  - compute() للـ heavy computations
  - extract widgets لتقليل rebuilds
  - RepaintBoundary للـ complex widgets
  - CachedNetworkImage للصور
  - لا objects جديدة في build()

suggest:
  - إضافة const حيثما أمكن
  - تحويل ListView إلى ListView.builder
  - نقل computations من build() إلى initState()
  - استخدام compute() للـ JSON parsing
  - extract static parts إلى const widgets
  - FadeTransition بدلاً من Opacity

warn_if:
  - ListView مع أكثر من 20 item
  - expensive operations في build()
  - setState() للـ entire screen
  - objects جديدة في build()

enforce:
  - const للـ static widgets
  - ListView.builder للقوائم الطويلة
  - dispose للـ controllers
  - لا network calls في build()
```

---

## 📊 Summary Checklist

```markdown
- [ ] const constructors محددة
- [ ] const widgets مستخدمة
- [ ] ListView.builder للقوائم الطويلة
- [ ] لا عمليات ثقيلة في build()
- [ ] compute() للـ heavy tasks
- [ ] extracted widgets لتقليل rebuilds
- [ ] RepaintBoundary للـ complex widgets
- [ ] CachedNetworkImage للصور
- [ ] لا objects جديدة في build()
- [ ] setState() localized
```

---

## 🔗 Related Rules

- [Widget Immutability](./widget-immutability.md) - const importance
- [Async/Await](../core/async-await.md) - compute() usage
- [Performance Optimization](../performance/optimization.md) - advanced tips

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

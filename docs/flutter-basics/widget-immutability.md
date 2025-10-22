# Widget Immutability

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Flutter Basics
applies_to:
  - all_flutter_projects
ai_agent_tags:
  - widgets
  - immutability
  - stateless
  - stateful
  - performance
  - critical
```

---

## 🎯 Overview

**Widget Immutability** هو مبدأ أساسي في Flutter. الـ Widgets يجب أن تكون immutable (غير قابلة للتعديل)، والـ State منفصل عنها.

### Why It Matters
- ⚡ أداء أفضل (Flutter optimization)
- 🐛 أخطاء أقل (predictable behavior)
- 🔄 Rebuild efficient
- 🧪 Testing أسهل

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - أساس عمل Flutter

### Why CRITICAL?

```dart
// ❌ Bad - Mutable widget
class Counter extends StatelessWidget {
  int count = 0; // ❌ Mutable field!
  
  @override
  Widget build(BuildContext context) {
    return Text('$count'); // Won't update correctly!
  }
}

// ✅ Good - Immutable widget
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0; // ✅ State is mutable
  
  @override
  Widget build(BuildContext context) {
    return Text('$count'); // Updates correctly!
  }
}
```

---

## 📚 Core Concepts

### 1. StatelessWidget - Immutable UI

```dart
// ✅ Perfect StatelessWidget
class UserCard extends StatelessWidget {
  final String name;       // ✅ final
  final int age;           // ✅ final
  final String? imageUrl;  // ✅ final
  
  const UserCard({         // ✅ const constructor
    required this.name,
    required this.age,
    this.imageUrl,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Age: $age'),
        leading: imageUrl != null 
            ? Image.network(imageUrl!)
            : Icon(Icons.person),
      ),
    );
  }
}

// Usage
const UserCard(
  name: 'Ahmed',
  age: 25,
  imageUrl: 'https://...',
)
```

---

### 2. StatefulWidget - Mutable State

```dart
// ✅ Correct - Widget immutable, State mutable
class Counter extends StatefulWidget {
  final String title;      // ✅ Widget fields are final
  final int initialValue;  // ✅ final
  
  const Counter({
    required this.title,
    this.initialValue = 0,
    super.key,
  });
  
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int _count; // ✅ State can be mutable
  
  @override
  void initState() {
    super.initState();
    _count = widget.initialValue; // Access widget properties
  }
  
  void _increment() {
    setState(() {
      _count++; // ✅ Modify state, triggers rebuild
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),     // Access widget property
        Text('Count: $_count'), // Access state
        ElevatedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

### 3. When to Use StatelessWidget vs StatefulWidget

#### Use StatelessWidget When:
```dart
// ✅ Static content
class WelcomeMessage extends StatelessWidget {
  final String message;
  const WelcomeMessage(this.message, {super.key});
  
  @override
  Widget build(BuildContext context) => Text(message);
}

// ✅ Composition only
class UserInfo extends StatelessWidget {
  final User user;
  const UserInfo(this.user, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(user.avatarUrl),
        UserName(user.name),
        UserBio(user.bio),
      ],
    );
  }
}

// ✅ Depends only on passed data
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  
  const ProductCard({
    required this.product,
    required this.onTap,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(product.imageUrl),
            Text(product.name),
            Text('\$${product.price}'),
          ],
        ),
      ),
    );
  }
}
```

#### Use StatefulWidget When:
```dart
// ✅ Has local state
class CheckboxField extends StatefulWidget {
  const CheckboxField({super.key});
  
  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  bool _isChecked = false; // Local state
  
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (value) => setState(() => _isChecked = value!),
    );
  }
}

// ✅ Has animations
class AnimatedBox extends StatefulWidget {
  const AnimatedBox({super.key});
  
  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * pi,
        child: Container(width: 100, height: 100, color: Colors.blue),
      ),
    );
  }
}

// ✅ Needs lifecycle methods
class DataLoader extends StatefulWidget {
  const DataLoader({super.key});
  
  @override
  State<DataLoader> createState() => _DataLoaderState();
}

class _DataLoaderState extends State<DataLoader> {
  List<String> _data = [];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final data = await api.getData();
    setState(() => _data = data);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) => Text(_data[index]),
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: All Widget Fields Must Be Final

```dart
// ❌ Bad - Mutable fields
class UserCard extends StatelessWidget {
  String name;  // ❌ Not final!
  int age;      // ❌ Not final!
  
  UserCard(this.name, this.age);
  
  @override
  Widget build(BuildContext context) => Text('$name, $age');
}

// ✅ Good - All fields final
class UserCard extends StatelessWidget {
  final String name;  // ✅ final
  final int age;      // ✅ final
  
  const UserCard(this.name, this.age, {super.key});
  
  @override
  Widget build(BuildContext context) => Text('$name, $age');
}
```

---

### Rule 2: Use const Constructors

```dart
// ❌ Bad - No const
class MyWidget extends StatelessWidget {
  final String title;
  
  MyWidget(this.title); // ❌ Not const
  
  @override
  Widget build(BuildContext context) => Text(title);
}

// ✅ Good - const constructor
class MyWidget extends StatelessWidget {
  final String title;
  
  const MyWidget(this.title, {super.key}); // ✅ const
  
  @override
  Widget build(BuildContext context) => Text(title);
}

// ✅ Use const when creating
const MyWidget('Hello') // ✅ const instance
```

**Why const?**
```dart
// Without const:
build() {
  return Column(
    children: [
      MyWidget('A'), // New instance every build
      MyWidget('B'), // New instance every build
    ],
  );
}

// With const:
build() {
  return Column(
    children: [
      const MyWidget('A'), // Same instance reused ⚡
      const MyWidget('B'), // Same instance reused ⚡
    ],
  );
}
```

---

### Rule 3: Extract Widgets, Don't Use Methods

```dart
// ❌ Bad - Helper method
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),  // ❌ Method
        _buildBody(),    // ❌ Method
      ],
    );
  }
  
  Widget _buildHeader() {
    return Container(
      child: Text('Header'),
    );
  }
  
  Widget _buildBody() {
    return Text('Body');
  }
}

// ✅ Good - Private widget classes
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),  // ✅ Widget
        _Body(),    // ✅ Widget
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Header'),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  
  @override
  Widget build(BuildContext context) {
    return Text('Body');
  }
}
```

**Why?**
- Widget classes can be `const` → better performance
- Can have their own lifecycle
- Better for testing
- Flutter DevTools shows widget tree correctly

---

### Rule 4: Composition Over Inheritance

```dart
// ❌ Bad - Inheritance
class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const BaseButton(this.label, this.onPressed, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class PrimaryButton extends BaseButton {
  const PrimaryButton(String label, VoidCallback onPressed, {Key? key})
      : super(label, onPressed, key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: Text(label),
    );
  }
}

// ✅ Good - Composition
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  
  const AppButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: backgroundColor != null
          ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
          : null,
      child: Text(label),
    );
  }
}

// Usage
AppButton(
  label: 'Submit',
  onPressed: () {},
  backgroundColor: Colors.blue, // Customize via parameter
)
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Mutable Collections in Widget

```dart
// ❌ Bad - Mutable list
class ItemList extends StatelessWidget {
  final List<String> items; // ⚠️ List is mutable!
  
  const ItemList(this.items, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}

// Someone can do:
final items = ['A', 'B'];
ItemList(items);
items.add('C'); // ⚠️ Mutates the list! Unexpected behavior

// ✅ Good - Make defensive copy or use unmodifiable
class ItemList extends StatelessWidget {
  final List<String> items;
  
  const ItemList(this.items, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}

// Better usage - create unmodifiable list
ItemList(List.unmodifiable(['A', 'B', 'C']))

// Or in the widget
class ItemList extends StatelessWidget {
  final List<String> _items;
  
  ItemList(List<String> items, {super.key})
      : _items = List.unmodifiable(items);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) => Text(_items[index]),
    );
  }
}
```

---

### Pitfall 2: Using setState in StatelessWidget

```dart
// ❌ Wrong - No setState in StatelessWidget
class Counter extends StatelessWidget {
  int count = 0; // ❌ Mutable!
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        count++; // ❌ Won't trigger rebuild!
        // setState(() {}); // ❌ No setState!
      },
      child: Text('$count'),
    );
  }
}

// ✅ Correct - Use StatefulWidget
class Counter extends StatefulWidget {
  const Counter({super.key});
  
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),
      child: Text('$_count'),
    );
  }
}
```

---

### Pitfall 3: Storing Controllers in StatelessWidget

```dart
// ❌ Bad - Controller in StatelessWidget
class MyForm extends StatelessWidget {
  final TextEditingController controller = TextEditingController(); // ❌
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller);
  }
  // ❌ No dispose! Memory leak!
}

// ✅ Good - Controller in StatefulWidget
class MyForm extends StatefulWidget {
  const MyForm({super.key});
  
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  late final TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose(); // ✅ Cleanup
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

---

## 💡 Advanced Patterns

### Pattern 1: Widget Configuration Objects

```dart
// ✅ Use configuration objects for complex widgets
@immutable
class ButtonConfig {
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  
  const ButtonConfig({
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
  });
  
  ButtonConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? borderRadius,
  }) {
    return ButtonConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class ConfigurableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonConfig config;
  
  const ConfigurableButton({
    required this.label,
    required this.onPressed,
    this.config = const ButtonConfig(),
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        foregroundColor: config.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
      ),
      child: Text(label),
    );
  }
}
```

---

## 🧪 Testing Immutability

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Immutability Tests', () {
    test('widget fields should be final', () {
      final widget = UserCard(name: 'Ahmed', age: 25);
      
      // This should not compile if fields are mutable:
      // widget.name = 'Sara'; // Error!
      
      expect(widget.name, equals('Ahmed'));
      expect(widget.age, equals(25));
    });
    
    testWidgets('const widgets are reused', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              const Text('Hello'),
              const Text('Hello'),
            ],
          ),
        ),
      );
      
      final texts = tester.widgetList<Text>(find.byType(Text));
      // Same instance due to const
      expect(identical(texts.first, texts.last), isTrue);
    });
  });
}
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - جميع widget fields هي final
  - const constructors حيثما أمكن
  - لا mutable state في StatelessWidget
  - استخدام StatefulWidget للـ mutable state
  - dispose للـ controllers في StatefulWidget
  - private widget classes بدلاً من methods
  - composition بدلاً من inheritance

suggest:
  - تحويل methods إلى widget classes
  - إضافة const للـ constructors
  - استخدام const عند إنشاء widgets
  - استخراج widgets معقدة لـ classes منفصلة
  - تحويل StatelessWidget إلى StatefulWidget إذا احتاج state

enforce:
  - final للـ widget fields
  - لا mutable fields في StatelessWidget
  - dispose للـ resources
  - const constructors للـ static widgets
```

---

## 📊 Summary Checklist

```markdown
- [ ] جميع widget fields هي final
- [ ] const constructors محددة
- [ ] const widgets مستخدمة في build
- [ ] لا mutable state في StatelessWidget
- [ ] StatefulWidget للـ state management
- [ ] private widget classes (not methods)
- [ ] composition over inheritance
- [ ] dispose للـ controllers
- [ ] unmodifiable collections
- [ ] @immutable annotation لـ data classes
```

---

## 🔗 Related Rules

- [Performance Basics](./performance-basics.md) - const performance
- [Code Style](../core/code-style.md) - widget naming
- [State Management](../state-management/built-in.md) - managing state

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

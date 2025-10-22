# 🪝 Flutter Hooks - React-Style Hooks

## 📋 Metadata

```yaml
priority: MEDIUM
level: OPTIONAL
category: State Management
applies_to:
  - riverpod_projects
  - complex_widgets
recommended_package: flutter_hooks
ai_agent_tags:
  - hooks
  - state-management
  - riverpod
  - hooks_riverpod
  - react
```

---

## 🎯 Overview

**Flutter Hooks** يجلب مفهوم React Hooks لـ Flutter. يبسّط State Management في Widgets.

### Why Flutter Hooks?
- ✅ **Less boilerplate** - بدون StatefulWidget
- 🔄 **Reusable logic** - Custom hooks
- 🧹 **Auto cleanup** - dispose تلقائي
- 🎯 **Composable** - دمج hooks
- 💡 **React-like** - مألوف لمطوري React

---

## 🟠 Priority Level: MEDIUM

**Status:** `OPTIONAL` - موصى به مع Riverpod

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  flutter_hooks: ^0.21.3  # ✅ Latest (Aug 2025)
  hooks_riverpod: ^3.0.3  # ✅ Latest - Riverpod 3.0 + Hooks (Aug 2025)
```

---

### 2. Basic Usage

```dart
import 'package:flutter_hooks/flutter_hooks.dart';

// ❌ OLD WAY - StatefulWidget
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

// ✅ NEW WAY - Hook Widget
class CounterWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useState(0);  // 🪝 Hook!
    
    return Column(
      children: [
        Text('Count: ${counter.value}'),
        ElevatedButton(
          onPressed: () => counter.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

---

### 3. Common Hooks

#### **useState** - State Management
```dart
class ExampleWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    final name = useState('Ahmed');
    final isLoading = useState(false);
    
    return Column(
      children: [
        Text('Count: ${count.value}'),
        Text('Name: ${name.value}'),
        if (isLoading.value) CircularProgressIndicator(),
        ElevatedButton(
          onPressed: () => count.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

#### **useEffect** - Side Effects
```dart
class TimerWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final seconds = useState(0);
    
    useEffect(() {
      // Setup: Runs on mount
      final timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => seconds.value++,
      );
      
      // Cleanup: Runs on unmount
      return timer.cancel;
    }, []);  // Empty dependencies = run once
    
    return Text('Seconds: ${seconds.value}');
  }
}
```

#### **useMemoized** - Expensive Computations
```dart
class ExpensiveWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    
    // Only recomputes when count changes
    final expensiveValue = useMemoized(
      () {
        print('Computing expensive value...');
        return count.value * 1000;
      },
      [count.value],  // Dependencies
    );
    
    return Column(
      children: [
        Text('Count: ${count.value}'),
        Text('Expensive: $expensiveValue'),
        ElevatedButton(
          onPressed: () => count.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

#### **useTextEditingController** - Text Controllers
```dart
class FormWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController(text: 'initial@example.com');
    
    // Auto-disposed! ✅
    
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Name: ${nameController.text}');
            print('Email: ${emailController.text}');
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
```

#### **useAnimationController** - Animations
```dart
class AnimatedWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    );
    
    final animation = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(controller),
    );
    
    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, []);
    
    return Opacity(
      opacity: animation,
      child: const FlutterLogo(size: 100),
    );
  }
}
```

#### **useFuture** - Async Data
```dart
class AsyncWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userFuture = useMemoized(() => fetchUser());
    final snapshot = useFuture(userFuture);
    
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    
    final user = snapshot.data;
    return Text('User: ${user?.name}');
  }
}

Future<User> fetchUser() async {
  await Future.delayed(const Duration(seconds: 2));
  return User(name: 'Ahmed');
}
```

#### **useStream** - Stream Data
```dart
class StreamWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final stream = useMemoized(() => Stream.periodic(
      const Duration(seconds: 1),
      (count) => count,
    ));
    
    final snapshot = useStream(stream);
    
    return Text('Count: ${snapshot.data ?? 0}');
  }
}
```

---

### 4. Custom Hooks

```dart
// Custom hook for debouncing
ValueNotifier<String> useDebounce(String value, Duration duration) {
  final debounced = useState(value);
  
  useEffect(() {
    final timer = Timer(duration, () {
      debounced.value = value;
    });
    
    return timer.cancel;
  }, [value]);
  
  return debounced;
}

// Usage
class SearchWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final search = useState('');
    final debouncedSearch = useDebounce(search.value, const Duration(milliseconds: 500));
    
    // API call only happens after 500ms of no typing
    useFuture(useMemoized(
      () => searchAPI(debouncedSearch.value),
      [debouncedSearch.value],
    ));
    
    return TextField(
      onChanged: (value) => search.value = value,
      decoration: const InputDecoration(labelText: 'Search'),
    );
  }
}
```

#### Custom Hook for Form Validation
```dart
class FormValidation {
  final String? error;
  final bool isValid;
  
  FormValidation({this.error, required this.isValid});
}

FormValidation useFormValidation(String value, String Function(String) validator) {
  final validation = useState<FormValidation>(FormValidation(isValid: true));
  
  useEffect(() {
    final error = validator(value);
    validation.value = FormValidation(
      error: error.isEmpty ? null : error,
      isValid: error.isEmpty,
    );
    return null;
  }, [value]);
  
  return validation.value;
}

// Usage
class ValidatedForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final email = useState('');
    final emailValidation = useFormValidation(
      email.value,
      (value) {
        if (value.isEmpty) return 'Email is required';
        if (!value.contains('@')) return 'Invalid email';
        return '';
      },
    );
    
    return Column(
      children: [
        TextField(
          onChanged: (value) => email.value = value,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: emailValidation.error,
          ),
        ),
        ElevatedButton(
          onPressed: emailValidation.isValid ? () {} : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
```

---

### 5. Hooks + Riverpod Integration

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider
final counterProvider = StateProvider((ref) => 0);

// ✅ HookConsumerWidget - Best of both!
class CounterWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod
    final counter = ref.watch(counterProvider);
    
    // Hook
    final localState = useState(0);
    
    return Column(
      children: [
        Text('Global Counter: $counter'),
        Text('Local State: ${localState.value}'),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment Global'),
            ),
            ElevatedButton(
              onPressed: () => localState.value++,
              child: const Text('Increment Local'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### 6. Real-World Example: Search Screen

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final debouncedQuery = useDebounce(searchQuery.value, const Duration(milliseconds: 500));
    final isLoading = useState(false);
    
    // Search when debounced query changes
    useEffect(() {
      if (debouncedQuery.value.isEmpty) return null;
      
      isLoading.value = true;
      
      // Trigger search
      Future.microtask(() async {
        await ref.read(searchRepositoryProvider).search(debouncedQuery.value);
        isLoading.value = false;
      });
      
      return null;
    }, [debouncedQuery.value]);
    
    // Focus effect
    final focusNode = useFocusNode();
    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          focusNode: focusNode,
          onChanged: (value) => searchQuery.value = value,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                      )
                    : null,
          ),
        ),
      ),
      body: SearchResults(query: debouncedQuery.value),
    );
  }
}
```

---

### 7. Migration from StatefulWidget

```dart
// BEFORE
class OldWidget extends StatefulWidget {
  @override
  _OldWidgetState createState() => _OldWidgetState();
}

class _OldWidgetState extends State<OldWidget> {
  late TextEditingController _controller;
  late AnimationController _animController;
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _subscription = someStream.listen((data) {
      // Handle data
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// AFTER
class NewWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final animController = useAnimationController(
      duration: const Duration(seconds: 1),
    );
    
    useEffect(() {
      final subscription = someStream.listen((data) {
        // Handle data
      });
      
      return subscription.cancel;  // Auto cleanup!
    }, []);
    
    return Container();
  }
}
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ Use hooks_riverpod for best experience
✅ Create custom hooks for reusable logic
✅ Use useMemoized for expensive computations
✅ Clean up in useEffect return
✅ Specify dependencies correctly
```

### **❌ تجنب:**
```dart
❌ Mix StatefulWidget with HookWidget
❌ Call hooks conditionally
❌ Call hooks in loops
❌ Forget dependencies in useEffect
❌ Overuse hooks for simple cases
```

---

## ⚖️ Hooks vs StatefulWidget

| Feature | StatefulWidget | HookWidget |
|---------|---------------|-----------|
| **Boilerplate** | 🔴 High | ✅ **Low** |
| **Reusability** | ❌ Limited | ✅ **High (custom hooks)** |
| **Auto Cleanup** | ❌ Manual | ✅ **Automatic** |
| **Learning Curve** | 🟢 Low | 🟡 Medium |
| **Best For** | Simple widgets | Complex logic |

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - HookWidget usage
  - proper dependencies
  - cleanup in useEffect
  - hooks_riverpod integration
  - custom hooks for reusability

suggest:
  - use hooks for complex state
  - create custom hooks
  - combine with Riverpod
  - use useMemoized for performance
  - proper cleanup

enforce:
  - no conditional hooks
  - hooks in correct order
  - dependencies specified
  - cleanup implemented
```

---

## 📚 Related Files

- [Riverpod](./riverpod.md) - Riverpod integration
- [Widget Immutability](../flutter-basics/widget-immutability.md)
- [State Management Comparison](./comparison.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** OPTIONAL  
**For:** Riverpod Projects  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

# Animations

## 📋 Metadata

```yaml
priority: LOW
level: OPTIONAL
category: Specialized
applies_to:
  - ui_rich_apps
  - modern_design
ai_agent_tags:
  - animations
  - transitions
  - motion
  - ux
  - performance
```

---

## 🎯 Overview

**Animations** تحسّن تجربة المستخدم وتجعل التطبيق أكثر حيوية واحترافية.

### Why Animations?
- ✨ Better UX
- 🎨 Modern design
- 👁️ Visual feedback
- 🎯 Guide attention
- ⚡ Smooth transitions

---

## 🔵 Priority Level: LOW

**Status:** `OPTIONAL` - مهم للتطبيقات الحديثة

---

## 📚 Core Concepts

### 1. Implicit Animations

```dart
// ✅ AnimatedContainer
class AnimatedBox extends StatefulWidget {
  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,
        color: _isExpanded ? Colors.blue : Colors.red,
        child: Center(
          child: Text(_isExpanded ? 'Expanded' : 'Collapsed'),
        ),
      ),
    );
  }
}

// ✅ AnimatedOpacity
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  child: Text('Fading text'),
)

// ✅ AnimatedAlign
AnimatedAlign(
  alignment: _isLeft ? Alignment.centerLeft : Alignment.centerRight,
  duration: const Duration(milliseconds: 300),
  child: Icon(Icons.star),
)
```

---

### 2. Explicit Animations

```dart
class ExplicitAnimation extends StatefulWidget {
  @override
  State<ExplicitAnimation> createState() => _ExplicitAnimationState();
}

class _ExplicitAnimationState extends State<ExplicitAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: const Icon(Icons.favorite, size: 100),
    );
  }
}
```

---

### 3. Hero Animations

```dart
// Screen 1
class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: Hero(
            tag: 'product-${product.id}',
            child: Image.network(product.imageUrl, width: 50, height: 50),
          ),
          title: Text(product.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}

// Screen 2
class DetailScreen extends StatelessWidget {
  final Product product;
  
  const DetailScreen({required this.product});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 300,
            ),
          ),
          Text(product.name),
          Text(product.description),
        ],
      ),
    );
  }
}
```

---

### 4. Page Transitions

```dart
// Custom page route
class FadePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  
  FadePageRoute({required this.builder});
  
  @override
  Color? get barrierColor => null;
  
  @override
  String? get barrierLabel => null;
  
  @override
  bool get maintainState => true;
  
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}

// Usage
Navigator.push(
  context,
  FadePageRoute(builder: (_) => DetailScreen()),
);

// Slide transition
class SlidePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  
  SlidePageRoute({required this.builder});
  
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      )),
      child: builder(context),
    );
  }
  
  @override
  Color? get barrierColor => null;
  
  @override
  String? get barrierLabel => null;
  
  @override
  bool get maintainState => true;
  
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
```

---

### 5. Staggered Animations

```dart
class StaggeredList extends StatefulWidget {
  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Create staggered animations
    _animations = List.generate(
      5,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2, // Start time
            (index + 1) * 0.2, // End time
            curve: Curves.easeOut,
          ),
        ),
      ),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _animations[index].value)),
              child: Opacity(
                opacity: _animations[index].value,
                child: child,
              ),
            );
          },
          child: Card(
            child: ListTile(
              title: Text('Item ${index + 1}'),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### 6. Lottie Animations

```yaml
dependencies:
  lottie: ^3.3.1  # ✅ Updated to latest (2025-10-22)
```

```dart
import 'package:lottie/lottie.dart';

// From assets
Lottie.asset(
  'assets/animations/loading.json',
  width: 200,
  height: 200,
)

// From network
Lottie.network(
  'https://assets.lottiefiles.com/packages/lf20_xyz.json',
)

// With controller
class ControlledLottie extends StatefulWidget {
  @override
  State<ControlledLottie> createState() => _ControlledLottieState();
}

class _ControlledLottieState extends State<ControlledLottie>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/loading.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.repeat();
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _controller.forward(),
              child: Text('Play'),
            ),
            ElevatedButton(
              onPressed: () => _controller.stop(),
              child: Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### 7. Shimmer Effect (Loading)

```yaml
dependencies:
  shimmer: ^3.0.0  # ✅ Added version
```

```dart
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Column(
    children: [
      Container(
        width: double.infinity,
        height: 200,
        color: Colors.white,
      ),
      SizedBox(height: 16),
      Container(
        width: double.infinity,
        height: 20,
        color: Colors.white,
      ),
      SizedBox(height: 8),
      Container(
        width: double.infinity,
        height: 20,
        color: Colors.white,
      ),
    ],
  ),
)
```

---

### 8. AnimatedList

```dart
class AnimatedListExample extends StatefulWidget {
  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  
  void _addItem() {
    final newItem = 'Item ${_items.length + 1}';
    _items.insert(0, newItem);
    _listKey.currentState?.insertItem(0);
  }
  
  void _removeItem(int index) {
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation),
    );
  }
  
  Widget _buildItem(String item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              final index = _items.indexOf(item);
              if (index != -1) _removeItem(index);
            },
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addItem,
          child: Text('Add Item'),
        ),
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(_items[index], animation);
            },
          ),
        ),
      ],
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Keep Animations Short

```dart
// ❌ Bad - Too slow
AnimatedContainer(
  duration: Duration(seconds: 2), // Too long!
  ...
)

// ✅ Good - Quick & snappy
AnimatedContainer(
  duration: Duration(milliseconds: 300), // Just right
  curve: Curves.easeInOut,
  ...
)
```

---

### Rule 2: Dispose Controllers

```dart
// ✅ Always dispose
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

---

### Rule 3: Use Curves

```dart
// ❌ Bad - Linear (robotic)
CurvedAnimation(
  parent: _controller,
  curve: Curves.linear,
)

// ✅ Good - Natural curves
CurvedAnimation(
  parent: _controller,
  curve: Curves.easeInOut, // Natural
)

// Popular curves:
// - Curves.easeInOut (most common)
// - Curves.easeOut (settling)
// - Curves.bounceOut (playful)
// - Curves.elasticOut (springy)
```

---

## 🎯 Animation Guidelines

```yaml
Duration Guidelines:
  - Micro (< 100ms): Hover effects, ripples
  - Short (100-300ms): Most UI transitions
  - Medium (300-500ms): Page transitions
  - Long (> 500ms): Complex animations

Performance:
  - Use Transform (GPU-accelerated)
  - Avoid expensive rebuilds
  - Use RepaintBoundary
  - Profile with DevTools
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - controller disposal
  - appropriate durations
  - curves usage
  - performance (RepaintBoundary)
  - implicit vs explicit choice
  - Hero tag uniqueness

suggest:
  - use implicit when possible
  - add curves
  - shorter durations
  - dispose controllers
  - use AnimatedBuilder
  - add RepaintBoundary

enforce:
  - controllers disposed
  - durations < 500ms (usually)
  - Hero tags unique
  - no jank (60fps)
```

---

## 📊 Summary Checklist

```markdown
- [ ] Implicit animations for simple cases
- [ ] Explicit animations for complex
- [ ] Hero animations for navigation
- [ ] Controllers disposed
- [ ] Durations appropriate
- [ ] Curves applied
- [ ] Performance tested
- [ ] No jank (60 FPS)
```

---

## 🔗 Related Rules

- [Performance Basics](../flutter-basics/performance-basics.md)
- [Build Optimization](../performance/build-optimization.md)

---

**Priority:** 🔵 LOW  
**Level:** OPTIONAL  
**For:** Modern Apps  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

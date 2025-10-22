# List & ScrollView Optimization

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Performance
applies_to:
  - all_flutter_projects
performance_impact: critical
ai_agent_tags:
  - performance
  - lists
  - scrolling
  - listview
  - optimization
```

---

## 🎯 Overview

**List Optimization** ضروري لأداء سلس. Lists غير المُحسّنة تسبب jank وتستهلك memory.

### Why Optimize Lists?
- ⚡ Smooth scrolling (60 FPS)
- 🧠 Lower memory usage
- 🔋 Better battery life
- 📱 Handle large datasets
- ✅ Better UX

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` - Critical للقوائم الطويلة

---

## 📚 Core Concepts

### 1. ListView.builder vs ListView

```dart
// ❌ Bad - Creates ALL items at once
class BadList extends StatelessWidget {
  final List<Item> items; // 1000 items
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items.map((item) => ItemWidget(item)).toList(),
      // Creates 1000 widgets immediately! ❌
    );
  }
}

// ✅ Good - Lazy loading
class GoodList extends StatelessWidget {
  final List<Item> items; // 1000 items
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemWidget(items[index]);
        // Creates only visible items ✅
      },
    );
  }
}
```

---

### 2. Item Extent for Fixed Height

```dart
// ❌ Bad - Flutter measures each item
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return Container(
      height: 100, // Fixed height
      child: Text('Item $index'),
    );
  },
)

// ✅ Good - Specify itemExtent
ListView.builder(
  itemCount: 1000,
  itemExtent: 100, // ✅ Skip measuring
  itemBuilder: (context, index) {
    return Text('Item $index');
  },
)

// ✅ Even better - prototypeItem
ListView.builder(
  itemCount: 1000,
  prototypeItem: const ListTile(
    title: Text('Prototype'),
  ), // Flutter measures once
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item $index'),
    );
  },
)
```

---

### 3. ListView.separated

```dart
// ✅ Good - Built-in dividers
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].name),
    );
  },
  separatorBuilder: (context, index) {
    return const Divider(); // Efficient separators
  },
)
```

---

### 4. Sliver Lists

```dart
// ✅ Good - For complex scroll views
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: const Text('Products'),
      floating: true,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ProductCard(products[index]),
        childCount: products.length,
      ),
    ),
  ],
)

// ✅ With fixed extent
CustomScrollView(
  slivers: [
    SliverFixedExtentList(
      itemExtent: 100,
      delegate: SliverChildBuilderDelegate(
        (context, index) => ItemWidget(items[index]),
        childCount: items.length,
      ),
    ),
  ],
)
```

---

### 5. GridView Optimization

```dart
// ❌ Bad - GridView without builder
GridView(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  children: products.map((p) => ProductCard(p)).toList(),
  // Creates all items! ❌
)

// ✅ Good - GridView.builder
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(products[index]);
  },
)

// ✅ Even better - with extent
GridView.builder(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200, // Max width per item
    childAspectRatio: 0.7,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(products[index]);
  },
)
```

---

### 6. addAutomaticKeepAlives

```dart
// ✅ Control keep-alive behavior
ListView.builder(
  itemCount: items.length,
  addAutomaticKeepAlives: false, // Don't keep offscreen items
  addRepaintBoundaries: true, // Isolate repaints
  addSemanticIndexes: true, // Accessibility
  itemBuilder: (context, index) {
    return ItemWidget(items[index]);
  },
)
```

---

### 7. Pagination & Infinite Scroll

```dart
class InfiniteList extends StatefulWidget {
  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  final _scrollController = ScrollController();
  final List<Item> _items = [];
  bool _isLoading = false;
  int _page = 1;
  
  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Near bottom, load more
      _loadMore();
    }
  }
  
  Future<void> _loadMore() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final newItems = await api.getItems(page: _page, limit: 20);
      setState(() {
        _items.addAll(newItems);
        _page++;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ItemWidget(_items[index]);
      },
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

### 8. CachedNetworkImage in Lists

```dart
import 'package:cached_network_image/cached_network_image.dart';

// ✅ Good - Cached images
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: product.imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        memCacheWidth: 100, // ✅ Resize in memory
        memCacheHeight: 100,
      ),
      title: Text(product.name),
    );
  },
)
```

---

### 9. AutomaticKeepAliveClientMixin

```dart
// ✅ Keep expensive widgets alive
class ExpensiveListItem extends StatefulWidget {
  final Item item;
  
  const ExpensiveListItem(this.item);
  
  @override
  State<ExpensiveListItem> createState() => _ExpensiveListItemState();
}

class _ExpensiveListItemState extends State<ExpensiveListItem>
    with AutomaticKeepAliveClientMixin {
  late final _processedData = _expensiveComputation();
  
  @override
  bool get wantKeepAlive => true; // Keep alive when scrolled offscreen
  
  String _expensiveComputation() {
    // Heavy computation here
    return 'Result';
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required!
    
    return ListTile(
      title: Text(_processedData),
    );
  }
}
```

---

### 10. Virtual Scrolling with Sliver

```dart
class OptimizedScrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Pinned header
        SliverPersistentHeader(
          pinned: true,
          delegate: HeaderDelegate(),
        ),
        
        // List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ItemWidget(items[index]),
            childCount: items.length,
          ),
        ),
        
        // Grid
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => GridItem(products[index]),
            childCount: products.length,
          ),
        ),
      ],
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Always Use Builder

```dart
// ❌ Bad - For ANY list > 10 items
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ Good - Always use builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

---

### Rule 2: Specify Extent When Possible

```dart
// ✅ Good - Save layout calculations
ListView.builder(
  itemExtent: 80, // All items 80px height
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

---

### Rule 3: Optimize Images

```dart
// ❌ Bad - Full resolution images
ListView.builder(
  itemBuilder: (context, index) {
    return Image.network(
      items[index].imageUrl, // Might be 4K! ❌
    );
  },
)

// ✅ Good - Resized & cached
ListView.builder(
  itemBuilder: (context, index) {
    return CachedNetworkImage(
      imageUrl: items[index].imageUrl,
      memCacheWidth: 200, // Resize for display
      memCacheHeight: 200,
    );
  },
)
```

---

## 🎯 Performance Comparison

```dart
// Benchmark: 1000 items list

// ListView with children: 
// - Initial render: 2000ms
// - Memory: 150MB
// - FPS: 30

// ListView.builder:
// - Initial render: 100ms
// - Memory: 30MB
// - FPS: 60

// ListView.builder with itemExtent:
// - Initial render: 50ms
// - Memory: 25MB
// - FPS: 60
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - ListView.builder usage
  - GridView.builder usage
  - itemExtent specified
  - CachedNetworkImage for images
  - pagination implemented
  - scroll controller disposed
  - addAutomaticKeepAlives set

suggest:
  - use .builder constructors
  - add itemExtent
  - implement pagination
  - cache images
  - add loading indicators
  - optimize item widgets

enforce:
  - .builder for lists > 10 items
  - itemExtent for fixed height
  - dispose scroll controllers
  - no expensive operations in itemBuilder
```

---

## 📊 Summary Checklist

```markdown
- [ ] ListView.builder used
- [ ] itemExtent specified (if fixed height)
- [ ] Images cached & resized
- [ ] Pagination for large lists
- [ ] Scroll controller disposed
- [ ] Item widgets optimized
- [ ] RepaintBoundary where needed
- [ ] Tested with 1000+ items
```

---

## 🔗 Related Rules

- [Build Optimization](./build-optimization.md)
- [Image Optimization](./image-optimization.md)
- [Performance Basics](../flutter-basics/performance-basics.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Impact:** Critical  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

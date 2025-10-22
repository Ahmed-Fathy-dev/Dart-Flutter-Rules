# 🎨 Layout Patterns - أنماط التخطيط

## 🎯 Overview

**Category:** `UI/UX`  
**Priority:** `HIGH`  
**Difficulty:** `MEDIUM`  
**Status:** `RECOMMENDED`

أنماط التخطيط الشائعة والفعالة في Flutter لبناء واجهات احترافية.

---

## 📚 Core Patterns

### 1. Standard Scaffold Layout

```dart
class StandardLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

---

### 2. List-Detail Pattern (Master-Detail)

```dart
// للـ Tablet/Desktop
class ListDetailLayout extends StatelessWidget {
  final List<Item> items;
  final Item? selectedItem;
  final ValueChanged<Item> onItemSelected;
  
  const ListDetailLayout({
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    if (isMobile) {
      // Mobile: Navigate to detail screen
      return ItemListView(
        items: items,
        onItemTap: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItemDetailScreen(item: item),
            ),
          );
        },
      );
    } else {
      // Tablet/Desktop: Side-by-side
      return Row(
        children: [
          SizedBox(
            width: 300,
            child: ItemListView(
              items: items,
              onItemTap: onItemSelected,
              selectedItem: selectedItem,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: selectedItem != null
                ? ItemDetailView(item: selectedItem!)
                : const Center(child: Text('Select an item')),
          ),
        ],
      );
    }
  }
}
```

---

### 3. Card Grid Pattern

```dart
class CardGridPattern extends StatelessWidget {
  final List<Product> products;
  
  const CardGridPattern({required this.products, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
  
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;      // Mobile
    if (width < 900) return 3;      // Tablet
    return 4;                       // Desktop
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  
  const ProductCard({required this.product, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 4. Tab Layout Pattern

```dart
class TabLayoutPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            SearchTab(),
            ProfileTab(),
          ],
        ),
      ),
    );
  }
}
```

---

### 5. Bottom Sheet Pattern

```dart
class BottomSheetPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
  
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                const Center(
                  child: SizedBox(
                    width: 40,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bottom Sheet Title',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                // Content...
                ...List.generate(
                  20,
                  (index) => ListTile(title: Text('Item $index')),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
```

---

### 6. App Bar Variations

```dart
// Collapsing App Bar
class CollapsingAppBarPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Collapsing Title'),
              background: Image.network(
                'https://example.com/header.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text('Item $index'),
              ),
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}

// Search App Bar
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            )
          : const Text('Title'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
      ],
    );
  }
}
```

---

### 7. Navigation Rail Pattern (Desktop)

```dart
class NavigationRailPattern extends StatefulWidget {
  @override
  State<NavigationRailPattern> createState() => _NavigationRailPatternState();
}

class _NavigationRailPatternState extends State<NavigationRailPattern> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _getSelectedScreen(),
          ),
        ],
      ),
    );
  }
  
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
```

---

### 8. Feed/Timeline Pattern

```dart
class FeedPattern extends StatelessWidget {
  final List<Post> posts;
  
  const FeedPattern({required this.posts, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: posts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return PostCard(post: posts[index]);
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  
  const PostCard({required this.post, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.userAvatar),
            ),
            title: Text(post.userName),
            subtitle: Text(post.timestamp),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          // Content
          if (post.text != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(post.text!),
            ),
          if (post.imageUrl != null)
            Image.network(post.imageUrl!),
          // Actions
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

### 9. Form Layout Pattern

```dart
class FormLayoutPattern extends StatefulWidget {
  @override
  State<FormLayoutPattern> createState() => _FormLayoutPatternState();
}

class _FormLayoutPatternState extends State<FormLayoutPattern> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter email';
                }
                if (!value!.contains('@')) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Submit
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 10. Empty State Pattern

```dart
class EmptyStatePattern extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  const EmptyStatePattern({
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 120,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
EmptyStatePattern(
  title: 'No items yet',
  message: 'Start by adding your first item',
  icon: Icons.shopping_bag_outlined,
  actionLabel: 'Add Item',
  onAction: () {
    // Navigate to add screen
  },
)
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ استخدم Scaffold كـ base
✅ استخدم SafeArea للـ notches
✅ استخدم Material Design components
✅ استخدم const constructors
✅ اجعل الـ layouts responsive
```

### **❌ تجنب:**
```dart
❌ Deep widget nesting (>5 levels)
❌ Hardcoded dimensions
❌ نسيان empty/loading states
❌ عدم اختبار على أحجام مختلفة
❌ تجاهل accessibility
```

---

## 🎯 AI Agent Instructions

### **Check:**
```yaml
- Is Scaffold used correctly?
- Are layouts responsive?
- Are empty states handled?
- Is SafeArea used where needed?
```

### **Suggest:**
```yaml
- Use appropriate layout pattern
- Add loading/empty states
- Make it responsive
- Follow Material Design guidelines
```

### **Enforce:**
```yaml
- Must use Scaffold for screens
- Must handle empty states
- Must be responsive
- Must use Material components
```

---

## 📚 Related Files

- [Responsive Design](./responsive-design.md) - Responsive patterns
- [Material 3 Theming](./material3-theming.md) - Theming
- [Custom Widgets](./custom-widgets.md) - Reusable widgets

---

**Last Updated:** 2025-10-22  
**Status:** `RECOMMENDED`  
**Priority:** `HIGH`

# 🚦 AutoRoute - Declarative Routing Generator

## 📋 Metadata

```yaml
priority: MEDIUM
level: ADVANCED
category: Navigation
package: auto_route
version: 10.2.0+
officially_recommended: false
applies_to:
  - medium_projects
  - large_projects
  - complex_navigation
best_for:
  - type_safe_navigation
  - deep_linking
  - nested_navigation
  - tab_navigation
  - route_guards
ai_agent_tags:
  - navigation
  - routing
  - code-generation
  - type-safe
  - nested-navigation
  - deep-linking
```

---

## 🎯 Overview

**AutoRoute** هو حل تنقل تصريحي لـ Flutter يستخدم **code generation** لإنشاء navigation logic بشكل تلقائي، مع دعم **strongly-typed arguments** و **deep-linking** و **nested navigation**.

### **لماذا AutoRoute؟**
- ✅ **Type-safe navigation** - لا أخطاء runtime
- ✅ **Code generation** - تقليل boilerplate
- ✅ **Deep linking** - دعم كامل
- ✅ **Nested navigation** - سهل وبديهي
- ✅ **Tab navigation** - مدمج ومحسّن
- ✅ **Route guards** - Authentication & Authorization
- ✅ **Path parameters** - مع type safety

---

## 📊 Comparison

| الميزة | AutoRoute | GoRouter | Navigator |
|--------|-----------|----------|-----------|
| **Type Safety** | ✅ Full | ✅ With Builder | ❌ |
| **Code Generation** | ✅ Required | 🟡 Optional | ❌ |
| **Deep Linking** | ✅ Excellent | ✅ Excellent | 🟡 Manual |
| **Nested Navigation** | ✅ Excellent | ✅ Good | 🟡 Complex |
| **Tab Navigation** | ✅ Built-in | 🟡 Manual | 🟡 Manual |
| **Route Guards** | ✅ Built-in | 🟡 Manual | ❌ |
| **Learning Curve** | 🔴 Steep | 🟡 Medium | 🟢 Easy |
| **Boilerplate** | 🟢 Low | 🟡 Medium | 🔴 High |
| **Performance** | ✅ Excellent | ✅ Excellent | ✅ Good |

---

## 📦 Setup

### pubspec.yaml
```yaml
dependencies:
  auto_route: ^10.2.0  # ✅ Latest (Jan 2025)

dev_dependencies:
  auto_route_generator: ^10.1.0
  build_runner: ^2.10.0
```

### Install
```bash
flutter pub add auto_route
flutter pub add dev:auto_route_generator dev:build_runner
```

---

## 1️⃣ Basic Setup

### **Step 1: Create Router Class**

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';  // ✅ Generated file

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: SettingsRoute.page),
  ];
}
```

---

### **Step 2: Annotate Pages**

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// ✅ Mark pages with @RoutePage()
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          // ✅ Type-safe navigation
          onPressed: () => context.router.push(const ProfileRoute()),
          child: const Text('Go to Profile'),
        ),
      ),
    );
  }
}

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}
```

---

### **Step 3: Generate Routes**

```bash
# Generate once
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild)
dart run build_runner watch --delete-conflicting-outputs
```

---

### **Step 4: Hook Up Router**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ✅ Create router instance (outside build!)
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AutoRoute App',
      routerConfig: _appRouter.config(),
    );
  }
}
```

---

## 2️⃣ Passing Arguments

AutoRoute automatically detects and handles page arguments!

```dart
// Screen with arguments
@RoutePage()
class UserScreen extends StatelessWidget {
  const UserScreen({
    super.key,
    required this.userId,
    required this.name,
    this.email,  // ✅ Optional
  });

  final int userId;
  final String name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          children: [
            Text('User ID: $userId'),
            Text('Name: $name'),
            if (email != null) Text('Email: $email'),
          ],
        ),
      ),
    );
  }
}

// Router config
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: UserRoute.page),
  ];
}

// Navigation - Type-safe!
context.router.push(
  UserRoute(
    userId: 123,
    name: 'Ahmed',
    email: 'ahmed@example.com',  // ✅ Optional
  ),
);
```

---

## 3️⃣ Path Parameters

```dart
// Router with path parameters
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/'),
    AutoRoute(page: UserRoute.page, path: '/user/:userId'),
    AutoRoute(page: ProductRoute.page, path: '/product/:id/:category'),
  ];
}

// Screen
@RoutePage()
class UserScreen extends StatelessWidget {
  const UserScreen({
    super.key,
    @PathParam('userId') required this.userId,  // ✅ Path parameter
  });

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
    );
  }
}

// Navigation
context.router.push(UserRoute(userId: 123));
// URL: /user/123

// Deep link support automatically!
// Opening /user/456 will navigate to UserScreen(userId: 456)
```

---

## 4️⃣ Query Parameters

```dart
@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
    @QueryParam() this.query,
    @QueryParam() this.category,
    @QueryParam() this.minPrice,
  });

  final String? query;
  final String? category;
  final double? minPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Text('Query: $query, Category: $category, Min: $minPrice'),
      ),
    );
  }
}

// Navigation
context.router.push(
  SearchRoute(
    query: 'flutter',
    category: 'books',
    minPrice: 10.0,
  ),
);
// URL: /search?query=flutter&category=books&minPrice=10.0
```

---

## 5️⃣ Nested Navigation

```dart
// Router with nested routes
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(
      page: DashboardRoute.page,
      path: '/dashboard',
      children: [
        AutoRoute(page: UsersRoute.page, path: 'users'),
        AutoRoute(page: PostsRoute.page, path: 'posts'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
  ];
}

// Dashboard screen with nested routes
@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Users'),
              onTap: () => context.router.push(const UsersRoute()),
            ),
            ListTile(
              title: const Text('Posts'),
              onTap: () => context.router.push(const PostsRoute()),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => context.router.push(const SettingsRoute()),
            ),
          ],
        ),
      ),
      // ✅ Nested routes render here
      body: const AutoRouter(),
    );
  }
}

// Child screens
@RoutePage()
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Users Screen'));
  }
}
```

---

## 6️⃣ Tab Navigation

AutoRoute provides `AutoTabsRouter` for tab navigation with state preservation:

```dart
@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      // ✅ List of tab routes
      routes: const [
        UsersRoute(),
        PostsRoute(),
        SettingsRoute(),
      ],
      // ✅ Bottom navigation
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Posts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
```

**Or manually with more control:**

```dart
@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        UsersRoute(),
        PostsRoute(),
        SettingsRoute(),
      ],
      transitionBuilder: (context, child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        
        return Scaffold(
          body: child,  // ✅ Active tab
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
              BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Posts'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 7️⃣ Route Guards (Authentication)

```dart
// Create guard
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if user is authenticated
    if (isAuthenticated()) {
      // ✅ Allow navigation
      resolver.next(true);
    } else {
      // ❌ Redirect to login
      resolver.redirect(
        LoginRoute(
          onResult: (success) {
            // Resume navigation if login successful
            resolver.next(success);
          },
        ),
      );
    }
  }
  
  bool isAuthenticated() {
    // Your authentication logic
    return false;
  }
}

// Apply guard to routes
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
      guards: [AuthGuard()],  // ✅ Protected route
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
      guards: [AuthGuard()],  // ✅ Protected route
    ),
  ];
}

// Global guards (applied to all routes)
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRouteGuard> guards = [
    AuthGuard(),  // ✅ Applied to all routes
  ];
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: ProfileRoute.page),
  ];
}
```

---

## 8️⃣ Navigation Methods

```dart
// Push route
context.router.push(const ProfileRoute());

// Push by path
context.router.pushPath('/profile');

// Replace current route
context.router.replace(const ProfileRoute());

// Navigate (push or update if exists)
context.router.navigate(const ProfileRoute());

// Pop
context.router.pop();

// Pop with result
context.router.pop<bool>(true);

// Pop until condition
context.router.popUntil((route) => route.settings.name == 'HomeRoute');

// Pop until route name
context.router.popUntilRouteWithName('HomeRoute');

// Pop to root
context.router.popUntilRoot();

// Push multiple routes
context.router.pushAll([
  const UsersRoute(),
  UserRoute(userId: 123),
]);

// Replace all routes (new stack)
context.router.replaceAll([
  const HomeRoute(),
]);

// Remove specific route
context.router.removeWhere((route) => route.name == 'SomeRoute');

// Maybe pop (respects WillPopScope)
context.router.maybePop();

// Back (web: history.back, native: pop)
context.router.back();
```

---

## 9️⃣ Return Results

```dart
// Screen that returns result
@RoutePage()
class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.router.pop<bool>(true),
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () => context.router.pop<bool>(false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// Calling screen
Future<void> _showConfirm(BuildContext context) async {
  final result = await context.router.push<bool>(const ConfirmRoute());
  
  if (result == true && context.mounted) {
    // User confirmed
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Confirmed!')),
    );
  }
}
```

---

## 🔟 Custom Transitions

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();
  
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page),
    
    // Custom transition
    CustomRoute(
      page: ProfileRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 300,
    ),
    
    // Fade transition
    CustomRoute(
      page: SettingsRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ];
}

// Available transitions:
// - TransitionsBuilders.slideLeft
// - TransitionsBuilders.slideRight
// - TransitionsBuilders.slideTop
// - TransitionsBuilders.slideBottom
// - TransitionsBuilders.fadeIn
// - TransitionsBuilders.zoomIn
```

---

## 1️⃣1️⃣ Full Example - E-commerce App

```dart
// app_router.dart
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRouteGuard> guards = [AuthGuard()];
  
  @override
  RouteType get defaultRouteType => const RouteType.material();
  
  @override
  List<AutoRoute> get routes => [
    // Auth routes (no guard)
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      guards: [],  // ✅ Bypass global guard
    ),
    
    // Main app (with tabs)
    AutoRoute(
      page: MainRoute.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: CategoriesRoute.page, path: 'categories'),
        AutoRoute(page: CartRoute.page, path: 'cart'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    
    // Product details
    AutoRoute(
      page: ProductDetailsRoute.page,
      path: '/product/:id',
    ),
    
    // Checkout flow
    AutoRoute(
      page: CheckoutRoute.page,
      path: '/checkout',
      children: [
        AutoRoute(page: ShippingRoute.page, path: 'shipping'),
        AutoRoute(page: PaymentRoute.page, path: 'payment'),
        AutoRoute(page: ConfirmRoute.page, path: 'confirm'),
      ],
    ),
  ];
}

// main.dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}

// Screens
@RoutePage()
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        CategoriesRoute(),
        CartRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}

@RoutePage()
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    @PathParam('id') required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.router.push(const CheckoutRoute()),
          child: const Text('Buy Now'),
        ),
      ),
    );
  }
}
```

---

## ⚠️ When to Use AutoRoute vs GoRouter

### **استخدم AutoRoute إذا:**
- ✅ تريد **type safety** قوي مع code generation
- ✅ لديك **nested navigation** معقد
- ✅ تحتاج **tab navigation** محسّن
- ✅ تحتاج **route guards** مدمجة
- ✅ تفضل أقل boilerplate ممكن
- ✅ المشروع متوسط أو كبير

### **استخدم GoRouter إذا:**
- ✅ تريد حل **رسمي من Flutter team**
- ✅ تفضل **declarative routing** بدون code generation
- ✅ تريد **أداء أفضل قليلاً** (no code gen overhead)
- ✅ تحتاج **integration أسهل** مع packages أخرى
- ✅ المشروع صغير أو متوسط

---

## 🎯 Best Practices

### **✅ DO:**
```dart
// ✅ Create router outside build
class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _appRouter.config());
  }
}

// ✅ Use replaceInRouteName for cleaner route names
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')

// ✅ Use path parameters with annotations
@PathParam('id') required this.id

// ✅ Use guards for authentication
guards: [AuthGuard()]

// ✅ Use AutoTabsScaffold for tabs
AutoTabsScaffold(routes: const [...])
```

### **❌ DON'T:**
```dart
// ❌ Don't create router in build
@override
Widget build(BuildContext context) {
  final router = AppRouter();  // DON'T!
  return MaterialApp.router(routerConfig: router.config());
}

// ❌ Don't forget part directive
// Missing: part 'app_router.gr.dart';

// ❌ Don't use context outside build
// Store router reference if needed outside build

// ❌ Don't forget to run build_runner
// Always run after changing routes
```

---

## 📝 Checklist

```markdown
Setup:
- [ ] Add auto_route & auto_route_generator
- [ ] Create router class with @AutoRouterConfig
- [ ] Add part directive
- [ ] Define routes list
- [ ] Annotate screens with @RoutePage()
- [ ] Run build_runner
- [ ] Hook up router in MaterialApp.router

Features:
- [ ] Path parameters for dynamic routes
- [ ] Query parameters for filters/search
- [ ] Nested routes for complex UI
- [ ] Tab navigation with AutoTabsRouter
- [ ] Route guards for authentication
- [ ] Custom transitions
- [ ] Deep linking support
```

---

## 🔗 Related Rules

- [GoRouter](./go-router.md) - Alternative (Official)
- [GoRouter Builder](./go-router-builder-advanced.md) - GoRouter with type-safety
- [Navigator](./navigator.md) - Basic navigation
- [Deep Linking](./deep-linking.md) - Deep linking guide

---

**Priority:** 🟡 MEDIUM  
**Level:** ADVANCED  
**Source:** https://github.com/Milad-Akarie/auto_route_library  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0 for AutoRoute 10.2.0+

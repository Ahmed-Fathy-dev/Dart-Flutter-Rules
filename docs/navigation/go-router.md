# GoRouter Navigation

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Navigation
applies_to:
  - all_projects
  - web_support
officially_recommended: true
ai_agent_tags:
  - navigation
  - routing
  - go-router
  - deep-linking
  - web
```

---

## 🎯 Overview

**GoRouter** هو الحل الموصى به رسمياً للـ navigation في Flutter. يدعم declarative routing, deep linking, و web URLs.

### Why GoRouter?
- ✅ موصى به رسمياً
- 🌐 Web support ممتاز
- 🔗 Deep linking مدمج
- 📱 Type-safe navigation
- 🎯 Declarative routing

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` لجميع المشاريع

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  go_router: ^16.2.5  # ✅ Updated to latest (Major update!)
```

> ⚠️ **Breaking Change:** GoRouter 16.x includes significant changes from 12.x
> - Shell routes API improved
> - Better deep linking support
> - Requires Flutter SDK ≥3.27 / Dart ≥3.6
> - Check changelog: https://pub.dev/packages/go_router/changelog

#### Basic Router
```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

---

### 2. Navigation Methods

```dart
// Navigate to route
context.go('/profile');

// Push (keep previous in stack)
context.push('/details');

// Replace current
context.replace('/login');

// Go back
context.pop();

// Pop with result
context.pop(result);

// Named routes
context.goNamed('profile');
context.pushNamed('details');
```

---

### 3. Named Routes

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);

// Usage
context.goNamed('home');
context.pushNamed('profile');
```

---

### 4. Path Parameters

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/product/:category/:id',
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        final productId = state.pathParameters['id']!;
        return ProductScreen(
          category: category,
          productId: productId,
        );
      },
    ),
  ],
);

// Navigation
context.go('/user/123');
context.go('/product/electronics/456');

// Named with params
GoRoute(
  path: '/user/:id',
  name: 'user',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return UserScreen(id);
  },
)

context.goNamed('user', pathParameters: {'id': '123'});
```

---

### 5. Query Parameters

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final category = state.uri.queryParameters['category'];
        
        return SearchScreen(
          query: query,
          category: category,
        );
      },
    ),
  ],
);

// Navigation
context.go('/search?q=flutter&category=tutorial');

// Named with query params
context.goNamed(
  'search',
  queryParameters: {
    'q': 'flutter',
    'category': 'tutorial',
  },
);
```

---

### 6. Nested Routes

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      routes: [
        // /profile
        GoRoute(
          path: 'profile',
          builder: (context, state) => ProfileScreen(),
          routes: [
            // /profile/edit
            GoRoute(
              path: 'edit',
              builder: (context, state) => EditProfileScreen(),
            ),
          ],
        ),
        // /settings
        GoRoute(
          path: 'settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
  ],
);

// Navigation
context.go('/profile');
context.go('/profile/edit');
context.go('/settings');
```

---

### 7. Shell Routes - Persistent UI

```dart
final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => ExploreScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  
  const ScaffoldWithNavBar({required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
  
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/explore');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }
}
```

---

### 8. Redirects & Guards

```dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = // check auth state
    final isGoingToLogin = state.uri.toString() == '/login';
    
    // Redirect to login if not authenticated
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }
    
    // Redirect to home if already logged in
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }
    
    return null; // No redirect
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);

// Per-route redirect
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final isAdmin = // check admin status
    return isAdmin ? null : '/';
  },
  builder: (context, state) => AdminScreen(),
)
```

---

### 9. Error Handling

```dart
final router = GoRouter(
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error.toString(),
  ),
  routes: [
    // routes...
  ],
);

class ErrorScreen extends StatelessWidget {
  final String error;
  
  const ErrorScreen({required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Page not found'),
            SizedBox(height: 8),
            Text(error, style: TextStyle(fontSize: 12)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Use Named Routes

```dart
// ❌ Bad - String paths everywhere
context.go('/user/123');
context.go('/product/electronics/456');

// ✅ Good - Named routes
context.goNamed('user', pathParameters: {'id': '123'});
context.goNamed('product', pathParameters: {
  'category': 'electronics',
  'id': '456',
});
```

---

### Rule 2: Extract Route Configuration

```dart
// router.dart
final router = GoRouter(
  routes: $appRoutes,
  redirect: _handleRedirect,
  errorBuilder: _buildErrorPage,
);

final $appRoutes = [
  GoRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => HomeScreen(),
  ),
  // more routes...
];

String? _handleRedirect(BuildContext context, GoRouterState state) {
  // redirect logic
}

Widget _buildErrorPage(BuildContext context, GoRouterState state) {
  return ErrorScreen(error: state.error.toString());
}
```

---

### Rule 3: Type-Safe Navigation

```dart
// Create navigation extension
extension AppNavigation on BuildContext {
  void goToUser(String userId) {
    goNamed('user', pathParameters: {'id': userId});
  }
  
  void goToProduct(String category, String productId) {
    goNamed('product', pathParameters: {
      'category': category,
      'id': productId,
    });
  }
  
  void goToSearch(String query, {String? category}) {
    goNamed('search', queryParameters: {
      'q': query,
      if (category != null) 'category': category,
    });
  }
}

// Usage
context.goToUser('123');
context.goToProduct('electronics', '456');
context.goToSearch('flutter', category: 'tutorial');
```

---

## 🎯 Real-World Example: E-commerce App

```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: _authGuard,
  routes: [
    // Public routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    
    // Main shell with bottom nav
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/categories',
          name: 'categories',
          builder: (context, state) => CategoriesScreen(),
          routes: [
            GoRoute(
              path: ':categoryId',
              name: 'category',
              builder: (context, state) {
                final categoryId = state.pathParameters['categoryId']!;
                return CategoryScreen(categoryId: categoryId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => CartScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
    
    // Product details (full screen)
    GoRoute(
      path: '/product/:id',
      name: 'product',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: productId);
      },
    ),
    
    // Search
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        final category = state.uri.queryParameters['category'];
        return SearchScreen(query: query, category: category);
      },
    ),
    
    // Checkout flow
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      redirect: _requireAuth,
      builder: (context, state) => CheckoutScreen(),
      routes: [
        GoRoute(
          path: 'shipping',
          name: 'shipping',
          builder: (context, state) => ShippingScreen(),
        ),
        GoRoute(
          path: 'payment',
          name: 'payment',
          builder: (context, state) => PaymentScreen(),
        ),
        GoRoute(
          path: 'confirm',
          name: 'confirm',
          builder: (context, state) => ConfirmOrderScreen(),
        ),
      ],
    ),
    
    // Order success
    GoRoute(
      path: '/order-success/:orderId',
      name: 'orderSuccess',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderSuccessScreen(orderId: orderId);
      },
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(),
);

String? _authGuard(BuildContext context, GoRouterState state) {
  final isLoggedIn = // check auth
  final isGoingToLogin = state.matchedLocation == '/login';
  
  if (!isLoggedIn && !isGoingToLogin) {
    return '/login';
  }
  
  if (isLoggedIn && isGoingToLogin) {
    return '/';
  }
  
  return null;
}

String? _requireAuth(BuildContext context, GoRouterState state) {
  final isLoggedIn = // check auth
  return isLoggedIn ? null : '/login';
}
```

---

## 🧪 Testing GoRouter

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('navigates to profile', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    );
    
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    
    // Initially at home
    expect(find.byType(HomeScreen), findsOneWidget);
    
    // Navigate to profile
    router.go('/profile');
    await tester.pumpAndSettle();
    
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - GoRouter setup in MaterialApp.router
  - named routes defined
  - proper path parameters
  - redirect/guard logic
  - error handling
  - ShellRoute for persistent UI
  - type-safe navigation helpers

suggest:
  - use named routes
  - extract router config
  - create navigation extensions
  - add redirects for auth
  - implement error pages

enforce:
  - MaterialApp.router usage
  - unique route names
  - error builder defined
  - path parameters validated
```

---

## 📊 Summary Checklist

```markdown
- [ ] GoRouter configured
- [ ] Named routes defined
- [ ] Path/query parameters
- [ ] Redirects for auth
- [ ] Error handling
- [ ] ShellRoute for persistent UI
- [ ] Type-safe navigation
- [ ] Tests for navigation
```

---

## 🔗 Related Rules

- [Navigator](./navigator.md) - Alternative
- [Deep Linking](./deep-linking.md) - Advanced
- [Testing](../testing/widget-testing.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Officially Recommended:** ✅  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

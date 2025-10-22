# 🔥 GoRouter Builder - Advanced Examples

## 📋 Metadata

```yaml
priority: HIGH
level: ADVANCED
category: Navigation
applies_to:
  - type_safe_navigation
  - large_projects
recommended_package: go_router_builder
version: 4.1.1+
ai_agent_tags:
  - navigation
  - go-router
  - type-safety
  - code-generation
  - advanced
```

---

## 🎯 Overview

هذا الملف يحتوي على أمثلة متقدمة وشاملة من **المصدر الرسمي** لـ `go_router_builder`.

**المصدر:** [Flutter Packages - go_router_builder Example](https://github.com/flutter/packages/tree/main/packages/go_router_builder/example)

---

## 📚 Table of Contents

1. [Setup & Configuration](#1-setup--configuration)
2. [Basic Routes](#2-basic-routes)
3. [Nested Routes](#3-nested-routes)
4. [Path Parameters](#4-path-parameters)
5. [Query Parameters](#5-query-parameters)
6. [Extra Parameters](#6-extra-parameters)
7. [Custom Page Transitions](#7-custom-page-transitions)
8. [Redirect & Guards](#8-redirect--guards)
9. [Return Values from Routes](#9-return-values-from-routes)
10. [Enum Parameters](#10-enum-parameters)
11. [Full Example](#11-full-example)

---

## 1. Setup & Configuration

### pubspec.yaml
```yaml
dependencies:
  go_router: ^16.2.5
  provider: ^6.1.5  # For state management in example

dev_dependencies:
  go_router_builder: ^4.1.1
  build_runner: ^2.10.0
```

### Generate Routes
```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild)
dart run build_runner watch --delete-conflicting-outputs
```

---

## 2. Basic Routes

### Simple Route
```dart
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

// ✅ Simple route with no parameters
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

// Usage
const HomeRoute().go(context);
const HomeRoute().push(context);
```

---

## 3. Nested Routes

### Multi-Level Nested Routes
```dart
// ✅ Parent route with nested children
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    // Child: /family/:fid
    TypedGoRoute<FamilyRoute>(
      path: 'family/:fid',
      routes: <TypedGoRoute<GoRouteData>>[
        // Grandchild: /family/:fid/person/:pid
        TypedGoRoute<PersonRoute>(
          path: 'person/:pid',
          routes: <TypedGoRoute<GoRouteData>>[
            // Great-grandchild: /family/:fid/person/:pid/details/:details
            TypedGoRoute<PersonDetailsRoute>(
              path: 'details/:details',
            ),
          ],
        ),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class FamilyRoute extends GoRouteData {
  const FamilyRoute(this.fid);
  
  final String fid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FamilyScreen(familyId: fid);
  }
}

class PersonRoute extends GoRouteData {
  const PersonRoute(this.fid, this.pid);
  
  final String fid;
  final int pid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonScreen(familyId: fid, personId: pid);
  }
}

// Usage
FamilyRoute('f1').go(context);
PersonRoute('f1', 123).go(context);
PersonDetailsRoute('f1', 123, PersonDetails.email).go(context);
```

---

## 4. Path Parameters

### String Parameters
```dart
@TypedGoRoute<FamilyRoute>(path: '/family/:fid')
class FamilyRoute extends GoRouteData {
  const FamilyRoute(this.fid);
  
  final String fid;  // ✅ String parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FamilyScreen(familyId: fid);
  }
}

// Usage
FamilyRoute('family-123').go(context);
```

### Integer Parameters
```dart
@TypedGoRoute<PersonRoute>(path: '/person/:pid')
class PersonRoute extends GoRouteData {
  const PersonRoute(this.pid);
  
  final int pid;  // ✅ Int parameter - auto-converted

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonScreen(personId: pid);
  }
}

// Usage
PersonRoute(456).go(context);
// URL: /person/456
```

### Multiple Path Parameters
```dart
@TypedGoRoute<PersonRoute>(path: '/family/:fid/person/:pid')
class PersonRoute extends GoRouteData {
  const PersonRoute(this.fid, this.pid);
  
  final String fid;  // ✅ First parameter
  final int pid;     // ✅ Second parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonScreen(familyId: fid, personId: pid);
  }
}

// Usage
PersonRoute('f1', 123).go(context);
// URL: /family/f1/person/123
```

---

## 5. Query Parameters

### Optional Query Parameters
```dart
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute({this.fromPage});
  
  final String? fromPage;  // ✅ Optional query parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(from: fromPage);
  }
}

// Usage
LoginRoute().go(context);
// URL: /login

LoginRoute(fromPage: '/profile').go(context);
// URL: /login?fromPage=%2Fprofile
```

### Multiple Query Parameters
```dart
@TypedGoRoute<SearchRoute>(path: '/search')
class SearchRoute extends GoRouteData {
  const SearchRoute({
    this.query,
    this.category,
    this.minPrice,
    this.maxPrice,
  });
  
  final String? query;      // ✅ Optional string
  final String? category;   // ✅ Optional string
  final int? minPrice;      // ✅ Optional int
  final int? maxPrice;      // ✅ Optional int

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchScreen(
      query: query,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}

// Usage
SearchRoute(
  query: 'flutter',
  category: 'books',
  minPrice: 10,
  maxPrice: 100,
).go(context);
// URL: /search?query=flutter&category=books&minPrice=10&maxPrice=100
```

---

## 6. Extra Parameters

### Passing Extra Data (Not in URL)
```dart
@TypedGoRoute<PersonDetailsRoute>(path: '/person/:pid/details/:details')
class PersonDetailsRoute extends GoRouteData {
  const PersonDetailsRoute(
    this.pid,
    this.details,
    {this.$extra},  // ✅ Extra parameter (not in URL)
  );
  
  final int pid;
  final PersonDetails details;
  final int? $extra;  // ✅ Prefix with $ for extra data

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonDetailsScreen(
      personId: pid,
      details: details,
      clickCount: $extra,
    );
  }
}

// Usage
PersonDetailsRoute(
  123,
  PersonDetails.email,
  $extra: 5,  // ✅ Extra data passed but not in URL
).go(context);
// URL: /person/123/details/email (extra not visible in URL)
```

---

## 7. Custom Page Transitions

### Using buildPage Instead of build
```dart
@TypedGoRoute<PersonDetailsRoute>(path: '/details/:id')
class PersonDetailsRoute extends GoRouteData {
  const PersonDetailsRoute(this.id, {this.$extra});
  
  final int id;
  final int? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      fullscreenDialog: true,  // ✅ Fullscreen dialog
      child: PersonDetailsScreen(
        id: id,
        extra: $extra,
      ),
    );
  }
}

// Custom transition
@override
Page<void> buildPage(BuildContext context, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: MyScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
```

---

## 8. Redirect & Guards

### Authentication Redirect
```dart
class App extends StatelessWidget {
  final LoginInfo loginInfo = LoginInfo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: $appRoutes,
        
        // ✅ Global redirect for authentication
        redirect: (BuildContext context, GoRouterState state) {
          final bool loggedIn = loginInfo.loggedIn;
          final String loginLoc = const LoginRoute().location;
          final bool goingToLogin = state.matchedLocation == loginLoc;

          // Not logged in and not going to login → redirect to login
          if (!loggedIn && !goingToLogin) {
            return LoginRoute(fromPage: state.matchedLocation).location;
          }

          // Logged in and going to login → redirect to home
          if (loggedIn && goingToLogin) {
            return const HomeRoute().location;
          }

          // No redirect needed
          return null;
        },
        
        // ✅ Refresh router when login state changes
        refreshListenable: loginInfo,
      ),
    );
  }
}

// LoginInfo class
class LoginInfo extends ChangeNotifier {
  bool _loggedIn = false;
  String? _userName;

  bool get loggedIn => _loggedIn;
  String? get userName => _userName;

  void login(String userName) {
    _loggedIn = true;
    _userName = userName;
    notifyListeners();  // ✅ Triggers router refresh
  }

  void logout() {
    _loggedIn = false;
    _userName = null;
    notifyListeners();  // ✅ Triggers router refresh
  }
}
```

---

## 9. Return Values from Routes

### Push with Return Value
```dart
@TypedGoRoute<FamilyCountRoute>(path: '/family-count/:count')
class FamilyCountRoute extends GoRouteData {
  const FamilyCountRoute(this.count);
  
  final int count;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FamilyCountScreen(count: count);
  }
}

class FamilyCountScreen extends StatelessWidget {
  final int count;
  
  const FamilyCountScreen({required this.count});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Count')),
      body: Center(
        child: ElevatedButton(
          // ✅ Pop with return value
          onPressed: () => context.pop(count),
          child: Text('Pop with value: $count'),
        ),
      ),
    );
  }
}

// Usage - Push and wait for result
void _navigateAndGetResult(BuildContext context) async {
  final int? result = await FamilyCountRoute(5).push<int>(context);
  
  if (result != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Returned value: $result')),
    );
  }
}
```

---

## 10. Enum Parameters

### Using Enums in Routes
```dart
// ✅ Define enum
enum PersonDetails {
  email,
  phone,
  address,
  bio;
  
  String get name => toString().split('.').last;
}

@TypedGoRoute<PersonDetailsRoute>(path: '/person/:pid/details/:details')
class PersonDetailsRoute extends GoRouteData {
  const PersonDetailsRoute(this.pid, this.details);
  
  final int pid;
  final PersonDetails details;  // ✅ Enum parameter

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonDetailsScreen(
      personId: pid,
      detailsType: details,
    );
  }
}

// Usage
PersonDetailsRoute(123, PersonDetails.email).go(context);
// URL: /person/123/details/email

PersonDetailsRoute(123, PersonDetails.phone).go(context);
// URL: /person/123/details/phone
```

---

## 11. Full Example

### Complete App Structure
```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

part 'main.g.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  App({super.key});

  final LoginInfo loginInfo = LoginInfo();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginInfo>.value(
      value: loginInfo,
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'GoRouter Builder Example',
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = loginInfo.loggedIn;
      final String loginLoc = const LoginRoute().location;
      final bool goingToLogin = state.matchedLocation == loginLoc;

      if (!loggedIn && !goingToLogin) {
        return LoginRoute(fromPage: state.matchedLocation).location;
      }

      if (loggedIn && goingToLogin) {
        return const HomeRoute().location;
      }

      return null;
    },
    refreshListenable: loginInfo,
  );
}

// ✅ Route Definitions
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FamilyRoute>(
      path: 'family/:fid',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<PersonRoute>(
          path: 'person/:pid',
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<PersonDetailsRoute>(path: 'details/:details'),
          ],
        ),
      ],
    ),
    TypedGoRoute<FamilyCountRoute>(path: 'family-count/:count'),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute({this.fromPage});
  
  final String? fromPage;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(from: fromPage);
  }
}

class FamilyRoute extends GoRouteData {
  const FamilyRoute(this.fid);
  
  final String fid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FamilyScreen(familyId: fid);
  }
}

class PersonRoute extends GoRouteData {
  const PersonRoute(this.fid, this.pid);
  
  final String fid;
  final int pid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PersonScreen(familyId: fid, personId: pid);
  }
}

class PersonDetailsRoute extends GoRouteData {
  const PersonDetailsRoute(this.fid, this.pid, this.details, {this.$extra});
  
  final String fid;
  final int pid;
  final PersonDetails details;
  final int? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      fullscreenDialog: true,
      key: state.pageKey,
      child: PersonDetailsScreen(
        familyId: fid,
        personId: pid,
        details: details,
        extra: $extra,
      ),
    );
  }
}

class FamilyCountRoute extends GoRouteData {
  const FamilyCountRoute(this.count);
  
  final int count;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FamilyCountScreen(count: count);
  }
}

// ✅ Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginInfo info = context.read<LoginInfo>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Push w/o return'),
                onTap: () => PersonRoute('f1', 1).push<void>(context),
              ),
              PopupMenuItem(
                child: const Text('Push w/ return'),
                onTap: () async {
                  final int? value = await FamilyCountRoute(5).push<int>(context);
                  if (value != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Value: $value')),
                    );
                  }
                },
              ),
              PopupMenuItem(
                child: Text('Logout: ${info.userName}'),
                onTap: () => info.logout(),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Family 1'),
            onTap: () => FamilyRoute('f1').go(context),
          ),
          ListTile(
            title: const Text('Family 2'),
            onTap: () => FamilyRoute('f2').go(context),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({this.from, super.key});
  
  final String? from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<LoginInfo>().login('test-user');
            if (from != null) {
              context.go(from!);
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

// ✅ Login State Management
class LoginInfo extends ChangeNotifier {
  bool _loggedIn = false;
  String? _userName;

  bool get loggedIn => _loggedIn;
  String? get userName => _userName;

  void login(String userName) {
    _loggedIn = true;
    _userName = userName;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _userName = null;
    notifyListeners();
  }
}

// ✅ Enum for details
enum PersonDetails {
  email,
  phone,
  address,
  bio;
}
```

---

## 📊 Summary Checklist

```markdown
- [ ] Setup go_router_builder with build_runner
- [ ] Define routes with @TypedGoRoute
- [ ] Use path parameters (String, int, enum)
- [ ] Add query parameters (optional)
- [ ] Pass extra data with $extra
- [ ] Implement custom page transitions
- [ ] Add authentication redirects
- [ ] Handle return values from routes
- [ ] Use enums for type-safe parameters
- [ ] Generate code with build_runner
```

---

## 🔗 Related Resources

- [GoRouter Basic Guide](./go-router.md)
- [Official Example](https://github.com/flutter/packages/tree/main/packages/go_router_builder/example)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [GoRouter Builder Documentation](https://pub.dev/packages/go_router_builder)

---

**Priority:** 🟡 HIGH  
**Level:** ADVANCED  
**Source:** Official Flutter Packages Repository  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

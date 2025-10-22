# Navigator (Traditional Routing)

## 📋 Metadata

```yaml
priority: HIGH
level: OPTIONAL
category: Navigation
applies_to:
  - simple_projects
  - legacy_apps
ai_agent_tags:
  - navigation
  - navigator
  - traditional
  - imperative
```

---

## 🎯 Overview

**Navigator** هو نظام الـ navigation الأصلي في Flutter. مناسب للتطبيقات البسيطة التي لا تحتاج deep linking أو web support.

### When to Use
- ✅ تطبيقات بسيطة (< 5 شاشات)
- ✅ لا حاجة لـ web support
- ✅ لا حاجة لـ deep linking
- ❌ استخدم GoRouter للمشاريع الكبيرة

---

## 🟡 Priority Level: HIGH

**Status:** `OPTIONAL` - استخدم GoRouter إن أمكن

---

## 📚 Core Concepts

### 1. Push/Pop Navigation

```dart
// Push new route
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);

// Pop (go back)
Navigator.pop(context);

// Pop with result
Navigator.pop(context, result);

// Get result from pushed route
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondScreen()),
);
print('Result: $result');
```

---

### 2. Named Routes

```dart
// Define routes
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

// Navigate using name
Navigator.pushNamed(context, '/profile');

// With arguments
Navigator.pushNamed(
  context,
  '/user',
  arguments: {'userId': '123'},
);

// Extract arguments
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final userId = args['userId'];
    
    return Scaffold(
      body: Text('User: $userId'),
    );
  }
}
```

---

### 3. onGenerateRoute - Dynamic Routes

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Parse route name and arguments
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
            );
            
          case '/user':
            final args = settings.arguments as Map?;
            final userId = args?['userId'] as String;
            return MaterialPageRoute(
              builder: (_) => UserScreen(userId: userId),
            );
            
          case '/product':
            final args = settings.arguments as Map?;
            final productId = args?['productId'] as String;
            return MaterialPageRoute(
              builder: (_) => ProductScreen(productId: productId),
            );
            
          default:
            return MaterialPageRoute(
              builder: (_) => NotFoundScreen(),
            );
        }
      },
    );
  }
}
```

---

### 4. Replace & Remove Routes

```dart
// Replace current route
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Push and remove until
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  (route) => false, // Remove all previous routes
);

// Push and remove specific routes
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
  ModalRoute.withName('/'), // Keep home route
);

// Pop until specific route
Navigator.popUntil(context, ModalRoute.withName('/home'));
```

---

### 5. Custom Transitions

```dart
// Custom page route
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return SecondScreen();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 300),
  ),
);

// Slide transition
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation, child) {
      return SecondScreen();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);
```

---

### 6. Dialog & Bottom Sheet

```dart
// Show dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('OK'),
      ),
    ],
  ),
);

// Get result
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => ConfirmDialog(),
);

if (confirmed == true) {
  // User confirmed
}

// Show modal bottom sheet
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share'),
          onTap: () => Navigator.pop(context, 'share'),
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () => Navigator.pop(context, 'delete'),
        ),
      ],
    ),
  ),
);
```

---

## ✅ Best Practices

### Rule 1: Extract Route Names

```dart
// routes.dart
class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const settings = '/settings';
  static const user = '/user';
}

// Usage
Navigator.pushNamed(context, AppRoutes.profile);
Navigator.pushNamed(context, AppRoutes.user, arguments: {'id': '123'});
```

---

### Rule 2: Type-Safe Arguments

```dart
// Create argument classes
class UserScreenArguments {
  final String userId;
  final String? tab;
  
  UserScreenArguments({
    required this.userId,
    this.tab,
  });
}

// Navigate with typed arguments
Navigator.pushNamed(
  context,
  AppRoutes.user,
  arguments: UserScreenArguments(userId: '123', tab: 'posts'),
);

// Extract in screen
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments 
        as UserScreenArguments;
    
    return Scaffold(
      body: Text('User: ${args.userId}, Tab: ${args.tab}'),
    );
  }
}
```

---

### Rule 3: Handle Back Button

```dart
// WillPopScope (deprecated in Flutter 3.12+)
WillPopScope(
  onWillPop: () async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  },
  child: Scaffold(body: ...),
)

// PopScope (Flutter 3.12+)
PopScope(
  canPop: false,
  onPopInvoked: (didPop) async {
    if (didPop) return;
    
    final shouldPop = await showDialog<bool>(...);
    if (shouldPop == true && context.mounted) {
      Navigator.pop(context);
    }
  },
  child: Scaffold(body: ...),
)
```

---

## 🎯 Real-World Example

```dart
// routes.dart
class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
  static const userDetails = '/user';
  static const settings = '/settings';
}

// main.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
            );
            
          case AppRoutes.login:
            return MaterialPageRoute(
              builder: (_) => LoginScreen(),
              fullscreenDialog: true,
            );
            
          case AppRoutes.profile:
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(),
            );
            
          case AppRoutes.userDetails:
            final args = settings.arguments as UserScreenArguments;
            return MaterialPageRoute(
              builder: (_) => UserScreen(userId: args.userId),
            );
            
          case AppRoutes.settings:
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SettingsScreen();
              },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
            
          default:
            return MaterialPageRoute(
              builder: (_) => NotFoundScreen(),
            );
        }
      },
    );
  }
}

// Usage in screens
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            child: Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.userDetails,
                arguments: UserScreenArguments(userId: '123'),
              );
            },
            child: Text('User Details'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Not Checking mounted

```dart
// ❌ Bad - Context might be unmounted
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.push(context, ...); // Might crash!
}

// ✅ Good - Check mounted
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  if (!mounted) return;
  Navigator.push(context, ...);
}
```

---

### Pitfall 2: Memory Leaks with Routes

```dart
// ❌ Bad - Keeps all routes in memory
Navigator.push(context, NewScreen());
Navigator.push(context, AnotherScreen());
// Previous screens still in memory!

// ✅ Good - Remove when not needed
Navigator.pushReplacement(context, NewScreen());
// or
Navigator.pushAndRemoveUntil(
  context,
  NewScreen(),
  (route) => false,
);
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - named routes defined
  - route constants
  - typed arguments
  - proper back handling
  - context.mounted checks
  - cleanup of routes

suggest:
  - use named routes
  - extract route names
  - create argument classes
  - add custom transitions
  - implement 404 page

when_to_migrate_to_gorouter:
  - > 5 screens
  - need deep linking
  - need web support
  - complex navigation
```

---

## 📊 Summary Checklist

```markdown
- [ ] Named routes defined
- [ ] Route constants extracted
- [ ] Typed argument classes
- [ ] onGenerateRoute implemented
- [ ] 404 page handling
- [ ] Back button handling
- [ ] context.mounted checks
- [ ] Clean up unused routes
```

---

## 🔗 Related Rules

- [GoRouter](./go-router.md) - Recommended alternative
- [Deep Linking](./deep-linking.md)

---

**Priority:** 🟡 HIGH  
**Level:** OPTIONAL  
**Recommendation:** Use GoRouter instead  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

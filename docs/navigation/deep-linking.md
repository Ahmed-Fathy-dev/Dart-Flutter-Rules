# Deep Linking

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Navigation
applies_to:
  - production_apps
  - web_apps
  - marketing_needs
ai_agent_tags:
  - deep-linking
  - universal-links
  - app-links
  - web-urls
  - marketing
```

---

## 🎯 Overview

**Deep Linking** يسمح بفتح التطبيق من روابط خارجية (URLs, SMS, Email, etc.). ضروري للـ marketing وتحسين تجربة المستخدم.

### Types of Deep Links
- 🌐 **Web URLs** - Universal access
- 📱 **Universal Links** (iOS)
- 🤖 **App Links** (Android)
- 📧 **Email/SMS Links**

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` للتطبيقات Production

---

## 📚 Core Concepts

### 1. URL Schemes

#### Android (AndroidManifest.xml)
```xml
<activity
    android:name=".MainActivity"
    android:exported="true">
    
    <!-- Default intent filters -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- Deep link intent filter -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        
        <!-- Custom scheme -->
        <data
            android:scheme="myapp"
            android:host="example.com"/>
    </intent-filter>
    
    <!-- Multiple paths -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        
        <data android:scheme="myapp"/>
        <data android:host="example.com"/>
        <data android:path="/product"/>
        <data android:path="/user"/>
    </intent-filter>
</activity>
```

#### iOS (Info.plist)
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.example.myapp</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myapp</string>
        </array>
    </dict>
</array>
```

---

### 2. Universal Links (iOS)

#### Associated Domains
```xml
<!-- ios/Runner/Runner.entitlements -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:example.com</string>
        <string>applinks:www.example.com</string>
    </array>
</dict>
</plist>
```

#### Apple App Site Association (AASA)
```json
// https://example.com/.well-known/apple-app-site-association
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.example.myapp",
        "paths": [
          "/product/*",
          "/user/*",
          "/promo/*"
        ]
      }
    ]
  }
}
```

---

### 3. App Links (Android)

#### Digital Asset Links
```json
// https://example.com/.well-known/assetlinks.json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.myapp",
    "sha256_cert_fingerprints": [
      "14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:44:E5"
    ]
  }
}]
```

#### Android Manifest
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    
    <data
        android:scheme="https"
        android:host="example.com"
        android:pathPrefix="/product"/>
</intent-filter>
```

---

### 4. GoRouter with Deep Links

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/user/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return UserScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/promo',
      builder: (context, state) {
        final code = state.uri.queryParameters['code'];
        return PromoScreen(code: code);
      },
    ),
  ],
);

// Links will automatically work:
// myapp://example.com/product/123
// https://example.com/product/123
// https://example.com/promo?code=SAVE20
```

---

### 5. app_links Package (Recommended)

> ⚠️ **DEPRECATED:** `uni_links` is no longer maintained. Use `app_links` instead (officially maintained by Flutter team).

```yaml
dependencies:
  app_links: ^6.3.4  # ✅ Official Flutter package
```

```dart
import 'package:app_links/app_links.dart';
import 'dart:async';

class DeepLinkService {
  late AppLinks _appLinks;
  StreamSubscription? _sub;
  
  Future<void> init() async {
    _appLinks = AppLinks();
    
    // Handle initial link (cold start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri.toString());
      }
    } catch (e) {
      print('Error getting initial link: $e');
    }
    
    // Handle links while app is running
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString());
      }
    }, onError: (err) {
      print('Error handling link: $err');
    });
  }
  
  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    
    // Parse and navigate
    if (uri.path.startsWith('/product/')) {
      final productId = uri.pathSegments.last;
      // Navigate to product
      navigatorKey.currentState?.pushNamed(
        '/product',
        arguments: {'id': productId},
      );
    } else if (uri.path.startsWith('/user/')) {
      final userId = uri.pathSegments.last;
      // Navigate to user
      navigatorKey.currentState?.pushNamed(
        '/user',
        arguments: {'id': userId},
      );
    } else if (uri.path == '/promo') {
      final code = uri.queryParameters['code'];
      // Navigate to promo
      navigatorKey.currentState?.pushNamed(
        '/promo',
        arguments: {'code': code},
      );
    }
  }
  
  void dispose() {
    _sub?.cancel();
  }
}

// In main.dart
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final deepLinkService = DeepLinkService();
  await deepLinkService.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        '/': (_) => HomeScreen(),
        '/product': (_) => ProductScreen(),
        '/user': (_) => UserScreen(),
        '/promo': (_) => PromoScreen(),
      },
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Validate Deep Link Data

```dart
void _handleDeepLink(String link) {
  try {
    final uri = Uri.parse(link);
    
    // Validate host
    if (uri.host != 'example.com') {
      print('Invalid host: ${uri.host}');
      return;
    }
    
    // Validate path
    if (!_isValidPath(uri.path)) {
      print('Invalid path: ${uri.path}');
      _navigateToHome();
      return;
    }
    
    // Extract and validate parameters
    final productId = uri.pathSegments.last;
    if (productId.isEmpty || !_isValidId(productId)) {
      print('Invalid product ID');
      _navigateToHome();
      return;
    }
    
    // Navigate
    _navigateToProduct(productId);
  } catch (e) {
    print('Error parsing deep link: $e');
    _navigateToHome();
  }
}
```

---

### Rule 2: Handle Authentication

```dart
void _handleDeepLink(String link) async {
  final uri = Uri.parse(link);
  
  // Check if route requires auth
  if (_requiresAuth(uri.path)) {
    final isLoggedIn = await _checkAuth();
    
    if (!isLoggedIn) {
      // Save deep link for later
      await _saveDeepLink(link);
      
      // Navigate to login
      _navigateToLogin();
      return;
    }
  }
  
  // Process deep link
  _processDeepLink(uri);
}

// After login
Future<void> _handlePostLogin() async {
  final savedLink = await _getSavedDeepLink();
  
  if (savedLink != null) {
    await _clearSavedDeepLink();
    _handleDeepLink(savedLink);
  } else {
    _navigateToHome();
  }
}
```

---

### Rule 3: Analytics & Tracking

```dart
void _handleDeepLink(String link) {
  // Track deep link
  analytics.logEvent(
    name: 'deep_link_opened',
    parameters: {
      'link': link,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
  
  final uri = Uri.parse(link);
  
  // Track source if present
  final source = uri.queryParameters['utm_source'];
  final campaign = uri.queryParameters['utm_campaign'];
  
  if (source != null || campaign != null) {
    analytics.logEvent(
      name: 'marketing_link',
      parameters: {
        'source': source,
        'campaign': campaign,
      },
    );
  }
  
  // Process link
  _processDeepLink(uri);
}
```

---

## 🎯 Real-World Example: E-commerce

```dart
class DeepLinkManager {
  final GoRouter router;
  final AuthService authService;
  final AnalyticsService analytics;
  
  StreamSubscription? _sub;
  
  DeepLinkManager({
    required this.router,
    required this.authService,
    required this.analytics,
  });
  
  Future<void> init() async {
    // Handle initial link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        await _handleLink(initialLink);
      }
    } catch (e) {
      print('Error with initial link: $e');
    }
    
    // Listen for links
    _sub = linkStream.listen(
      (link) => _handleLink(link!),
      onError: (err) => print('Link error: $err'),
    );
  }
  
  Future<void> _handleLink(String link) async {
    // Track
    analytics.logDeepLink(link);
    
    try {
      final uri = Uri.parse(link);
      
      // Validate
      if (!_isValidLink(uri)) {
        _showError('Invalid link');
        return;
      }
      
      // Parse route
      final route = _parseRoute(uri);
      
      // Check auth
      if (route.requiresAuth && !authService.isLoggedIn) {
        await authService.savePendingLink(link);
        router.go('/login');
        return;
      }
      
      // Navigate
      router.go(route.path, extra: route.data);
      
    } catch (e) {
      print('Error handling link: $e');
      _showError('Failed to open link');
    }
  }
  
  bool _isValidLink(Uri uri) {
    // Check host
    if (!['example.com', 'www.example.com'].contains(uri.host)) {
      return false;
    }
    
    // Check path
    final validPaths = [
      '/product',
      '/category',
      '/promo',
      '/user',
      '/order',
    ];
    
    return validPaths.any((p) => uri.path.startsWith(p));
  }
  
  _Route _parseRoute(Uri uri) {
    final path = uri.path;
    final params = uri.queryParameters;
    
    if (path.startsWith('/product/')) {
      return _Route(
        path: '/product/${uri.pathSegments.last}',
        requiresAuth: false,
        data: {'source': params['source']},
      );
    }
    
    if (path.startsWith('/order/')) {
      return _Route(
        path: '/order/${uri.pathSegments.last}',
        requiresAuth: true,
      );
    }
    
    if (path == '/promo') {
      return _Route(
        path: '/promo',
        requiresAuth: false,
        data: {'code': params['code']},
      );
    }
    
    // Default to home
    return _Route(path: '/', requiresAuth: false);
  }
  
  void _showError(String message) {
    // Show error to user
  }
  
  void dispose() {
    _sub?.cancel();
  }
}

class _Route {
  final String path;
  final bool requiresAuth;
  final Map<String, dynamic>? data;
  
  _Route({
    required this.path,
    this.requiresAuth = false,
    this.data,
  });
}
```

---

## 🧪 Testing Deep Links

```bash
# Android
adb shell am start -W -a android.intent.action.VIEW \
  -d "myapp://example.com/product/123" \
  com.example.myapp

# iOS Simulator
xcrun simctl openurl booted "myapp://example.com/product/123"

# Test Universal Links (iOS)
xcrun simctl openurl booted "https://example.com/product/123"

# Test App Links (Android)
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://example.com/product/123" \
  com.example.myapp
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - manifest/plist configuration
  - AASA/assetlinks files
  - deep link handler
  - validation logic
  - auth handling
  - analytics tracking
  - error handling

suggest:
  - add validation
  - track analytics
  - handle auth flow
  - save pending links
  - add error handling
  - test all paths

enforce:
  - validate all inputs
  - check authentication
  - track deep links
  - handle errors gracefully
```

---

## 📊 Summary Checklist

```markdown
- [ ] URL schemes configured
- [ ] Universal Links (iOS) setup
- [ ] App Links (Android) setup
- [ ] AASA/assetlinks files
- [ ] Deep link handler
- [ ] Input validation
- [ ] Auth handling
- [ ] Analytics tracking
- [ ] Error handling
- [ ] Testing done
```

---

## 🔗 Related Rules

- [GoRouter](./go-router.md) - Deep link support
- [Navigator](./navigator.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**For:** Production Apps  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

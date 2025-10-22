# Integration Testing

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Testing
applies_to:
  - all_flutter_projects
test_type: integration
ai_agent_tags:
  - testing
  - integration
  - e2e
  - user-flows
  - automation
```

---

## 🎯 Overview

**Integration Tests** تختبر التطبيق بالكامل كما يستخدمه المستخدم الحقيقي. تشمل navigation, state management, و API calls.

### Why Integration Tests?
- 👤 Test real user flows
- 🔄 Test navigation
- 📡 Test API integration
- 🎯 Catch integration bugs
- ✅ Full app confidence

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` للتطبيقات Production

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter  # ✅ SDK package (no version needed)
  flutter_test:
    sdk: flutter
```

> **Note:** `integration_test` is an SDK package, not from pub.dev

#### Test Directory
```
integration_test/
├── app_test.dart
├── login_flow_test.dart
├── shopping_flow_test.dart
└── helpers/
    └── test_helpers.dart
```

---

### 2. Basic Integration Test

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('complete app flow', (tester) async {
      // Start app
      app.main();
      await tester.pumpAndSettle();
      
      // Verify home screen
      expect(find.text('Welcome'), findsOneWidget);
      
      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Verify navigation to login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
```

---

### 3. Login Flow Test

```dart
// integration_test/login_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Login Flow', () {
    testWidgets('successful login flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Enter credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@example.com',
      );
      
      await tester.enterText(
        find.byKey(Key('password_field')),
        'password123',
      );
      
      // Submit login
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle(Duration(seconds: 3));
      
      // Verify navigation to home
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Welcome, Test User'), findsOneWidget);
    });
    
    testWidgets('login with invalid credentials shows error', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Enter invalid credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'wrong@example.com',
      );
      
      await tester.enterText(
        find.byKey(Key('password_field')),
        'wrongpassword',
      );
      
      // Submit login
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle(Duration(seconds: 2));
      
      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);
      
      // Verify still on login screen
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });
}
```

---

### 4. Shopping Flow Test

```dart
// integration_test/shopping_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Shopping Flow', () {
    testWidgets('complete purchase flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 1. Browse products
      await tester.tap(find.text('Shop'));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProductCard), findsWidgets);
      
      // 2. Select product
      await tester.tap(find.byKey(Key('product_1')));
      await tester.pumpAndSettle();
      
      // 3. Add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      
      // Verify snackbar
      expect(find.text('Added to cart'), findsOneWidget);
      
      // 4. Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      
      // Verify cart has item
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Quantity: 1'), findsOneWidget);
      
      // 5. Proceed to checkout
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
      
      // 6. Fill shipping info
      await tester.enterText(
        find.byKey(Key('address_field')),
        '123 Main St',
      );
      
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      
      // 7. Select payment method
      await tester.tap(find.text('Credit Card'));
      await tester.pumpAndSettle();
      
      // 8. Confirm order
      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle(Duration(seconds: 5));
      
      // 9. Verify success
      expect(find.text('Order Placed Successfully'), findsOneWidget);
      expect(find.textContaining('Order #'), findsOneWidget);
    });
    
    testWidgets('add multiple items to cart', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to shop
      await tester.tap(find.text('Shop'));
      await tester.pumpAndSettle();
      
      // Add first product
      await tester.tap(find.byKey(Key('add_product_1')));
      await tester.pumpAndSettle();
      
      // Add second product
      await tester.tap(find.byKey(Key('add_product_2')));
      await tester.pumpAndSettle();
      
      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      
      // Verify 2 items
      expect(find.byType(CartItem), findsNWidgets(2));
      
      // Verify total
      expect(find.textContaining('Total: \$'), findsOneWidget);
    });
  });
}
```

---

### 5. Test Helpers

```dart
// integration_test/helpers/test_helpers.dart
class TestHelpers {
  static Future<void> login(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byKey(Key('email_field')), email);
    await tester.enterText(find.byKey(Key('password_field')), password);
    
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle(Duration(seconds: 3));
  }
  
  static Future<void> logout(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
  }
  
  static Future<void> addProductToCart(
    WidgetTester tester,
    String productId,
  ) async {
    await tester.tap(find.byKey(Key('product_$productId')));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    
    await tester.pageBack();
    await tester.pumpAndSettle();
  }
  
  static Future<void> scrollToBottom(WidgetTester tester) async {
    final listFinder = find.byType(Scrollable);
    await tester.fling(listFinder, Offset(0, -500), 10000);
    await tester.pumpAndSettle();
  }
  
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);
    
    while (DateTime.now().isBefore(endTime)) {
      await tester.pumpAndSettle();
      
      if (tester.any(finder)) {
        return;
      }
      
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    throw Exception('Widget not found within timeout');
  }
}

// Usage
testWidgets('helper usage', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Login
  await TestHelpers.login(
    tester,
    email: 'test@example.com',
    password: 'password123',
  );
  
  // Add products
  await TestHelpers.addProductToCart(tester, '1');
  await TestHelpers.addProductToCart(tester, '2');
  
  // Logout
  await TestHelpers.logout(tester);
});
```

---

### 6. Mock API Responses

```dart
// integration_test/mocks/mock_api.dart
class MockApiServer {
  static void setupMocks() {
    // Mock successful login
    when(() => apiClient.post('/auth/login', data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              data: {
                'token': 'mock_token',
                'user': {
                  'id': '1',
                  'name': 'Test User',
                  'email': 'test@example.com',
                },
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/auth/login'),
            ));
    
    // Mock get products
    when(() => apiClient.get('/products')).thenAnswer((_) async => Response(
          data: [
            {
              'id': '1',
              'name': 'Product 1',
              'price': 29.99,
            },
            {
              'id': '2',
              'name': 'Product 2',
              'price': 49.99,
            },
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        ));
  }
}

// integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    MockApiServer.setupMocks();
  });
  
  // Tests...
}
```

---

### 7. Performance Testing

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Performance Tests', () {
    testWidgets('app starts in under 3 seconds', (tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(3000),
        reason: 'App should start in under 3 seconds',
      );
      
      // Report performance
      await binding.reportData?.call({
        'startup_time_ms': stopwatch.elapsedMilliseconds,
      });
    });
    
    testWidgets('smooth scrolling performance', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to list screen
      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      
      // Measure frame time
      final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      
      await binding.traceAction(() async {
        // Scroll multiple times
        for (var i = 0; i < 5; i++) {
          await tester.fling(
            find.byType(ListView),
            Offset(0, -300),
            1000,
          );
          await tester.pumpAndSettle();
        }
      }, reportKey: 'scrolling_performance');
    });
  });
}
```

---

## ✅ Best Practices

### Rule 1: Use Keys for Important Widgets

```dart
// ✅ Good - Keys for testing
TextField(
  key: Key('email_field'),
  decoration: InputDecoration(labelText: 'Email'),
)

ElevatedButton(
  key: Key('login_button'),
  onPressed: () {},
  child: Text('Login'),
)

// In test
await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
await tester.tap(find.byKey(Key('login_button')));
```

---

### Rule 2: Wait for Async Operations

```dart
// ✅ Good - Wait for async
await tester.tap(find.text('Submit'));
await tester.pumpAndSettle(Duration(seconds: 5)); // Wait for API call

// ❌ Bad - Not waiting
await tester.tap(find.text('Submit'));
await tester.pump(); // Might not be enough
```

---

### Rule 3: Test Real User Flows

```dart
// ✅ Good - Complete flow
testWidgets('user can complete purchase', (tester) async {
  // 1. Login
  await login(tester);
  
  // 2. Browse products
  await browseProducts(tester);
  
  // 3. Add to cart
  await addToCart(tester);
  
  // 4. Checkout
  await checkout(tester);
  
  // 5. Verify success
  expect(find.text('Order Placed'), findsOneWidget);
});

// ❌ Bad - Testing isolated steps
testWidgets('can tap add to cart button', (tester) async {
  await tester.tap(find.text('Add to Cart'));
  // Not testing the complete flow
});
```

---

## 🚀 Running Tests

```bash
# Run all integration tests
flutter test integration_test

# Run specific test
flutter test integration_test/login_flow_test.dart

# Run on specific device
flutter test integration_test --device-id=<device_id>

# Generate screenshots
flutter test integration_test --screenshot=on-failure
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - IntegrationTestWidgetsFlutterBinding
  - complete user flows
  - proper waiting (pumpAndSettle)
  - keys on important widgets
  - helper functions
  - error scenarios tested

suggest:
  - add keys to widgets
  - extract common flows to helpers
  - test error scenarios
  - add performance tests
  - mock API responses

enforce:
  - test complete flows
  - wait for async operations
  - verify navigation
  - test error cases
```

---

## 📊 Summary Checklist

```markdown
- [ ] Integration test setup
- [ ] Keys on important widgets
- [ ] Login flow tested
- [ ] Navigation tested
- [ ] API integration tested
- [ ] Error scenarios tested
- [ ] Helper functions created
- [ ] Performance measured
```

---

## 🔗 Related Rules

- [Unit Testing](./unit-testing.md)
- [Widget Testing](./widget-testing.md)
- [Mocking](./mocking.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Test Type:** Integration/E2E  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

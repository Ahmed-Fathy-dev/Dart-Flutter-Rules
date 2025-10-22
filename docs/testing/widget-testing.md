# Widget Testing

## 📋 Metadata

```yaml
priority: CRITICAL
level: ENFORCE
category: Testing
applies_to:
  - all_flutter_projects
min_coverage: 75
ai_agent_tags:
  - testing
  - widget-tests
  - ui-testing
  - flutter-test
  - critical
```

---

## 🎯 Overview

**Widget Testing** يختبر widgets وتفاعلها مع المستخدم. أسرع من Integration tests وأكثر شمولية من Unit tests.

### Why It Matters
- 🎨 اختبار UI logic
- 👆 اختبار user interactions
- 🐛 اكتشاف UI bugs
- ⚡ سريع (< 1 second per test)

---

## 🔴 Priority Level: CRITICAL

**Status:** `ENFORCE` - اختبار لكل screen مهم

### Why CRITICAL?

```dart
// بدون widget tests:
// UI يعمل → تغيير → UI معطل → اكتشاف في production! ❌

// مع widget tests:
// UI يعمل → تغيير → test fails → Fix قبل production ✅
```

---

## 📚 Core Concepts

### 1. Basic Widget Test

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Counter starts at zero', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: CounterScreen(),
      ),
    );
    
    // Find widget
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
```

---

### 2. Finders - Finding Widgets

```dart
testWidgets('finding widgets', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // By type
  expect(find.byType(ElevatedButton), findsOneWidget);
  expect(find.byType(TextField), findsWidgets);
  
  // By text
  expect(find.text('Submit'), findsOneWidget);
  expect(find.textContaining('Sub'), findsOneWidget);
  
  // By key
  expect(find.byKey(Key('submit-button')), findsOneWidget);
  
  // By icon
  expect(find.byIcon(Icons.add), findsOneWidget);
  
  // By widget (exact instance)
  final widget = Text('Hello');
  expect(find.byWidget(widget), findsOneWidget);
  
  // Descendant
  expect(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.text('Title'),
    ),
    findsOneWidget,
  );
  
  // Ancestor
  expect(
    find.ancestor(
      of: find.text('Title'),
      matching: find.byType(AppBar),
    ),
    findsOneWidget,
  );
}
```

---

### 3. Interactions

```dart
testWidgets('button tap increments counter', (tester) async {
  await tester.pumpWidget(MaterialApp(home: CounterScreen()));
  
  // Initial state
  expect(find.text('0'), findsOneWidget);
  
  // Tap button
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump(); // Rebuild after tap
  
  // Verify result
  expect(find.text('1'), findsOneWidget);
  
  // Tap again
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('2'), findsOneWidget);
});

testWidgets('user interactions', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Tap
  await tester.tap(find.text('Button'));
  
  // Long press
  await tester.longPress(find.byIcon(Icons.menu));
  
  // Drag
  await tester.drag(find.byType(ListView), Offset(0, -200));
  
  // Scroll
  await tester.scroll(
    find.byType(ListView),
    Offset(0, -200),
  );
  
  // Enter text
  await tester.enterText(find.byType(TextField), 'Hello');
  
  // Pump to rebuild
  await tester.pump();
});
```

---

### 4. pump Methods

```dart
testWidgets('understanding pump methods', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // pump() - Single frame
  await tester.tap(find.text('Button'));
  await tester.pump(); // Trigger one rebuild
  
  // pump(Duration) - Advance time
  await tester.pump(Duration(seconds: 1)); // Advance 1 second
  
  // pumpAndSettle() - Wait for all animations
  await tester.tap(find.text('Animate'));
  await tester.pumpAndSettle(); // Wait until animations complete
  
  // pumpFrames() - Multiple frames
  await tester.pumpFrames(
    MyWidget(),
    Duration(seconds: 2),
  ); // Pump frames for 2 seconds
});
```

---

## ✅ Best Practices

### Rule 1: Test User Flows

```dart
testWidgets('complete login flow', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  
  // Enter email
  await tester.enterText(
    find.byKey(Key('email-field')),
    'user@example.com',
  );
  
  // Enter password
  await tester.enterText(
    find.byKey(Key('password-field')),
    'password123',
  );
  
  // Tap login button
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  // Verify navigation to home screen
  expect(find.byType(HomeScreen), findsOneWidget);
  expect(find.byType(LoginScreen), findsNothing);
});
```

---

### Rule 2: Use Keys for Important Widgets

```dart
// In widget
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          key: Key('email-field'), // ✅ Key for testing
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          key: Key('password-field'), // ✅ Key for testing
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        ElevatedButton(
          key: Key('login-button'), // ✅ Key for testing
          onPressed: _login,
          child: Text('Login'),
        ),
      ],
    );
  }
}

// In test
testWidgets('login screen elements', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  
  expect(find.byKey(Key('email-field')), findsOneWidget);
  expect(find.byKey(Key('password-field')), findsOneWidget);
  expect(find.byKey(Key('login-button')), findsOneWidget);
});
```

---

### Rule 3: Test Different States

```dart
testWidgets('loading state shows progress indicator', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: DataScreen(isLoading: true)),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

testWidgets('error state shows error message', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: DataScreen(
        hasError: true,
        errorMessage: 'Failed to load',
      ),
    ),
  );
  
  expect(find.text('Failed to load'), findsOneWidget);
  expect(find.byIcon(Icons.error), findsOneWidget);
});

testWidgets('success state shows data', (tester) async {
  final data = ['Item 1', 'Item 2', 'Item 3'];
  
  await tester.pumpWidget(
    MaterialApp(home: DataScreen(data: data)),
  );
  
  expect(find.text('Item 1'), findsOneWidget);
  expect(find.text('Item 2'), findsOneWidget);
  expect(find.text('Item 3'), findsOneWidget);
});
```

---

### Rule 4: Test Async Operations

```dart
testWidgets('async data loading', (tester) async {
  await tester.pumpWidget(MaterialApp(home: UserProfileScreen()));
  
  // Initially shows loading
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // Wait for data to load
  await tester.pumpAndSettle();
  
  // Data is displayed
  expect(find.text('User Name'), findsOneWidget);
  expect(find.byType(CircularProgressIndicator), findsNothing);
});

testWidgets('handles network errors', (tester) async {
  // Inject mock that fails
  await tester.pumpWidget(
    MaterialApp(
      home: UserProfileScreen(
        api: MockApiThatFails(),
      ),
    ),
  );
  
  await tester.pumpAndSettle();
  
  expect(find.text('Network Error'), findsOneWidget);
  expect(find.text('Retry'), findsOneWidget);
});
```

---

### Rule 5: Test Scrolling

```dart
testWidgets('scrolls to bottom of list', (tester) async {
  final items = List.generate(100, (i) => 'Item $i');
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => Text(items[index]),
        ),
      ),
    ),
  );
  
  // Initially see Item 0
  expect(find.text('Item 0'), findsOneWidget);
  expect(find.text('Item 99'), findsNothing);
  
  // Scroll down
  await tester.scrollUntilVisible(
    find.text('Item 99'),
    500.0, // Scroll by 500 pixels each time
  );
  
  // Now see Item 99
  expect(find.text('Item 99'), findsOneWidget);
});
```

---

## 🚫 Common Pitfalls

### Pitfall 1: Not Wrapping in MaterialApp

```dart
// ❌ Wrong - Missing MaterialApp
testWidgets('shows text', (tester) async {
  await tester.pumpWidget(Text('Hello'));
  // Error! Many widgets need MaterialApp
});

// ✅ Correct - Wrap in MaterialApp
testWidgets('shows text', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Text('Hello'),
      ),
    ),
  );
  
  expect(find.text('Hello'), findsOneWidget);
});
```

---

### Pitfall 2: Not Pumping After Actions

```dart
// ❌ Wrong - Forgot pump
testWidgets('button changes text', (tester) async {
  await tester.pumpWidget(MyApp());
  
  await tester.tap(find.text('Change'));
  // Missing pump! Widget hasn't rebuilt yet
  
  expect(find.text('Changed'), findsNothing); // Fails!
});

// ✅ Correct - Pump after action
testWidgets('button changes text', (tester) async {
  await tester.pumpWidget(MyApp());
  
  await tester.tap(find.text('Change'));
  await tester.pump(); // ✅ Rebuild widget
  
  expect(find.text('Changed'), findsOneWidget); // Works!
});
```

---

### Pitfall 3: Testing Implementation Details

```dart
// ❌ Bad - Tests internal state
testWidgets('counter internal state', (tester) async {
  final counter = Counter();
  await tester.pumpWidget(MaterialApp(home: CounterWidget(counter)));
  
  // Accessing private state
  expect(counter._value, equals(0)); // Fragile!
});

// ✅ Good - Tests visible behavior
testWidgets('counter displays zero', (tester) async {
  await tester.pumpWidget(MaterialApp(home: CounterWidget()));
  
  // Test what user sees
  expect(find.text('0'), findsOneWidget);
});
```

---

## 💡 Advanced Patterns

### Pattern 1: Helper Functions

```dart
// Helper to pump widget with all dependencies
Future<void> pumpApp(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.light(),
      home: widget,
    ),
  );
}

// Usage
testWidgets('my test', (tester) async {
  await pumpApp(tester, MyScreen());
  
  expect(find.text('Hello'), findsOneWidget);
});

// Helper for common actions
Future<void> login(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.enterText(find.byKey(Key('email')), email);
  await tester.enterText(find.byKey(Key('password')), password);
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
}

testWidgets('user can login', (tester) async {
  await pumpApp(tester, LoginScreen());
  await login(tester, email: 'user@example.com', password: 'pass123');
  
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

---

### Pattern 2: Custom Finders

```dart
// Custom finder for widgets with specific property
Finder findByTooltip(String tooltip) {
  return find.byWidgetPredicate(
    (widget) => widget is Tooltip && widget.message == tooltip,
  );
}

testWidgets('finds widget by tooltip', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Tooltip(
        message: 'Help',
        child: Icon(Icons.help),
      ),
    ),
  );
  
  expect(findByTooltip('Help'), findsOneWidget);
});
```

---

### Pattern 3: Testing Forms

```dart
testWidgets('form validation', (tester) async {
  await tester.pumpWidget(MaterialApp(home: SignupForm()));
  
  // Submit empty form
  await tester.tap(find.text('Submit'));
  await tester.pump();
  
  // Check validation errors
  expect(find.text('Email is required'), findsOneWidget);
  expect(find.text('Password is required'), findsOneWidget);
  
  // Enter invalid email
  await tester.enterText(
    find.byKey(Key('email')),
    'invalid-email',
  );
  await tester.tap(find.text('Submit'));
  await tester.pump();
  
  expect(find.text('Invalid email format'), findsOneWidget);
  
  // Enter valid data
  await tester.enterText(
    find.byKey(Key('email')),
    'user@example.com',
  );
  await tester.enterText(
    find.byKey(Key('password')),
    'password123',
  );
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  
  // Form submitted successfully
  expect(find.byType(SuccessScreen), findsOneWidget);
});
```

---

### Pattern 4: Testing Animations

```dart
testWidgets('fade animation', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: FadeInWidget(child: Text('Hello'))),
  );
  
  // Initially invisible
  var opacity = tester.widget<Opacity>(find.byType(Opacity));
  expect(opacity.opacity, equals(0.0));
  
  // Halfway through animation
  await tester.pump(Duration(milliseconds: 250));
  opacity = tester.widget<Opacity>(find.byType(Opacity));
  expect(opacity.opacity, greaterThan(0.0));
  expect(opacity.opacity, lessThan(1.0));
  
  // Animation complete
  await tester.pumpAndSettle();
  opacity = tester.widget<Opacity>(find.byType(Opacity));
  expect(opacity.opacity, equals(1.0));
});
```

---

## 🧪 Testing with Providers

```dart
testWidgets('widget uses provider', (tester) async {
  final mockProvider = MockUserProvider();
  
  await tester.pumpWidget(
    ChangeNotifierProvider<UserProvider>.value(
      value: mockProvider,
      child: MaterialApp(home: UserScreen()),
    ),
  );
  
  // Interact and verify
  expect(find.text('Guest'), findsOneWidget);
  
  // Simulate login
  mockProvider.login(User(name: 'Ahmed'));
  await tester.pump();
  
  expect(find.text('Ahmed'), findsOneWidget);
});
```

---

## 📊 Widget Test Coverage

```bash
# Run widget tests only
flutter test test/widget_test/

# With coverage
flutter test --coverage test/widget_test/
```

### What to Test

```markdown
✅ Must test:
- Critical user flows
- Form validation
- Button interactions
- Navigation
- Error states
- Loading states

⚠️ Good to test:
- Animations
- Gestures (swipe, long press)
- Scroll behavior
- Theme changes

❌ Don't test:
- Third-party widgets (ListView, TextField, etc.)
- Framework behavior
- Styling (use Golden tests instead)
```

---

## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

```yaml
check_for:
  - widget test لكل screen
  - keys للـ important widgets
  - tests للـ user interactions
  - tests للـ different states (loading, error, success)
  - pump() بعد كل action
  - pumpAndSettle() للـ async operations
  - MaterialApp wrapper

suggest:
  - إضافة widget tests للـ screens الجديدة
  - اختبار edge cases
  - اختبار error handling
  - استخدام helper functions
  - testing forms validation
  - testing navigation

enforce:
  - MaterialApp wrapper
  - pump after interactions
  - keys for testable widgets
  - descriptive test names
  - independent tests
```

---

## 📊 Summary Checklist

```markdown
- [ ] Test لكل critical screen
- [ ] Keys للـ testable widgets
- [ ] MaterialApp wrapper
- [ ] pump() بعد interactions
- [ ] pumpAndSettle() للـ async
- [ ] Test user flows
- [ ] Test different states
- [ ] Test form validation
- [ ] Test navigation
- [ ] Helper functions للـ common actions
```

---

## 🔗 Related Rules

- [Unit Testing](./unit-testing.md) - testing logic
- [Integration Testing](./integration-testing.md) - E2E testing
- [Widget Immutability](../flutter-basics/widget-immutability.md) - widget structure

---

**Priority:** 🔴 CRITICAL  
**Level:** ENFORCE  
**Min Coverage:** 75%  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

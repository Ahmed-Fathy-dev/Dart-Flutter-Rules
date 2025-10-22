# Accessibility (A11y)

## 📋 Metadata

```yaml
priority: LOW
level: RECOMMENDED
category: Specialized
applies_to:
  - all_apps
  - inclusive_design
ai_agent_tags:
  - accessibility
  - a11y
  - inclusive
  - screen-reader
  - semantics
```

---

## 🎯 Overview

**Accessibility (A11y)** يجعل تطبيقك قابلاً للاستخدام من قبل الجميع، بما في ذلك الأشخاص ذوي الإعاقة.

### Why Accessibility?
- ♿ Inclusive design
- 👥 15% of population
- ⚖️ Legal compliance
- ✅ Better UX for all
- 📈 Wider audience

---

## 🔵 Priority Level: LOW

**Status:** `RECOMMENDED` - ضروري أخلاقياً وقانونياً

---

## 📚 Core Concepts

### 1. Semantics Widgets

```dart
// ❌ Bad - No semantics
GestureDetector(
  onTap: () => print('Tapped'),
  child: Container(
    width: 44,
    height: 44,
    color: Colors.blue,
  ),
)

// ✅ Good - With semantics
Semantics(
  label: 'Menu button',
  hint: 'Opens navigation menu',
  button: true,
  onTap: () => print('Tapped'),
  child: GestureDetector(
    onTap: () => print('Tapped'),
    child: Container(
      width: 44,
      height: 44,
      color: Colors.blue,
      child: Icon(Icons.menu),
    ),
  ),
)
```

---

### 2. Images & Icons

```dart
// ❌ Bad - No description
Image.network('https://example.com/product.jpg')

// ✅ Good - With semantic label
Semantics(
  label: 'Blue running shoes, Nike Air Max',
  child: Image.network('https://example.com/product.jpg'),
)

// ✅ For decorative images
ExcludeSemantics(
  child: Image.asset('assets/decoration.png'),
)

// ✅ Icons with labels
Icon(
  Icons.favorite,
  semanticLabel: 'Add to favorites',
)
```

---

### 3. Text & Labels

```dart
// ✅ TextField with label
TextField(
  decoration: InputDecoration(
    labelText: 'Email', // Screen reader reads this
    hintText: 'Enter your email',
  ),
)

// ✅ Custom widget with semantics
Semantics(
  label: 'Price: 99 dollars and 99 cents',
  child: Text('\$99.99'),
)

// ✅ Header semantics
Semantics(
  header: true,
  child: Text(
    'Products',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)
```

---

### 4. Touch Targets

```dart
// ❌ Bad - Too small (< 44x44)
IconButton(
  iconSize: 16,
  padding: EdgeInsets.zero,
  onPressed: () {},
  icon: Icon(Icons.close),
)

// ✅ Good - Minimum 44x44
IconButton(
  iconSize: 24,
  padding: EdgeInsets.all(12), // Total: 48x48
  onPressed: () {},
  icon: Icon(Icons.close),
)

// ✅ Ensure minimum size
ConstrainedBox(
  constraints: BoxConstraints(
    minWidth: 44,
    minHeight: 44,
  ),
  child: GestureDetector(
    onTap: () {},
    child: Icon(Icons.favorite),
  ),
)
```

---

### 5. Focus Management

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) {
            _passwordFocus.requestFocus(); // Move to next field
          },
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          focusNode: _passwordFocus,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Password'),
        ),
      ],
    );
  }
}
```

---

### 6. Color Contrast

```dart
// ❌ Bad - Low contrast
Container(
  color: Color(0xFFCCCCCC), // Light gray
  child: Text(
    'Important text',
    style: TextStyle(color: Color(0xFFDDDDDD)), // Very light gray
    // Contrast ratio: 1.2:1 (FAIL)
  ),
)

// ✅ Good - High contrast
Container(
  color: Colors.white,
  child: Text(
    'Important text',
    style: TextStyle(color: Colors.black87),
    // Contrast ratio: 15.3:1 (AAA)
  ),
)

// ✅ Check with Flutter DevTools
// Enable "Highlight Contrast Issues" in Accessibility Inspector
```

---

### 7. Screen Reader Support

```dart
// ✅ Announce changes
Semantics(
  liveRegion: true, // Announce updates
  child: Text('Loading: ${progress}%'),
)

// ✅ Group related content
MergeSemantics(
  child: Row(
    children: [
      Icon(Icons.star),
      Text('4.5'),
      Text('(120 reviews)'),
    ],
  ),
  // Screen reader: "4.5 stars, 120 reviews"
)

// ✅ Custom traversal order
Semantics(
  sortKey: OrdinalSortKey(1.0),
  child: Text('Read this first'),
)

Semantics(
  sortKey: OrdinalSortKey(2.0),
  child: Text('Then this'),
)
```

---

### 8. Accessibility Testing

```dart
// Enable semantics in tests
testWidgets('button has correct label', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {},
          child: Text('Submit'),
        ),
      ),
    ),
  );
  
  // Find by semantics
  expect(
    find.bySemanticsLabel('Submit'),
    findsOneWidget,
  );
  
  // Check semantic properties
  final semantics = tester.getSemantics(find.text('Submit'));
  expect(semantics.hasAction(SemanticsAction.tap), isTrue);
});
```

---

## ✅ Best Practices

### Rule 1: All Interactive Elements Need Labels

```dart
// ❌ Bad - No label
IconButton(
  onPressed: () {},
  icon: Icon(Icons.delete),
)

// ✅ Good - With label
IconButton(
  onPressed: () {},
  icon: Icon(Icons.delete),
  tooltip: 'Delete item', // Screen reader reads this
)
```

---

### Rule 2: Use Semantic Widgets

```dart
// ❌ Bad - Custom widget without semantics
GestureDetector(
  onTap: () {},
  child: Container(
    child: CustomIcon(),
  ),
)

// ✅ Good - With semantics
Semantics(
  button: true,
  enabled: true,
  label: 'Play video',
  onTap: () {},
  child: GestureDetector(
    onTap: () {},
    child: Container(
      child: CustomIcon(),
    ),
  ),
)
```

---

### Rule 3: Exclude Decorative Elements

```dart
// ✅ Good - Exclude decoration
ExcludeSemantics(
  child: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/background.png'),
      ),
    ),
    child: ActualContent(),
  ),
)
```

---

## 🎯 Common Issues & Solutions

### Issue 1: Images Without Alt Text

```dart
// ❌ Problem
Image.network(product.imageUrl)

// ✅ Solution
Semantics(
  label: product.name,
  image: true,
  child: Image.network(product.imageUrl),
)
```

### Issue 2: Buttons Without Labels

```dart
// ❌ Problem
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {},
)

// ✅ Solution
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {},
  tooltip: 'Settings',
)
```

### Issue 3: Form Inputs Without Labels

```dart
// ❌ Problem
TextField(
  hintText: 'Enter email',
)

// ✅ Solution
TextField(
  decoration: InputDecoration(
    labelText: 'Email', // Required!
    hintText: 'Enter your email',
  ),
)
```

---

## 🔍 Testing Accessibility

### 1. TalkBack (Android)
```
Settings > Accessibility > TalkBack > Enable
- Navigate with swipe
- Double tap to activate
```

### 2. VoiceOver (iOS)
```
Settings > Accessibility > VoiceOver > Enable
- Swipe to navigate
- Double tap to activate
```

### 3. Flutter DevTools
```
1. Run app in debug mode
2. Open DevTools
3. Go to "Widget Inspector"
4. Enable "Show Semantics Debugger"
5. Check semantic tree
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - semantic labels on images
  - tooltips on icon buttons
  - labels on text fields
  - minimum touch target size (44x44)
  - color contrast ratios
  - focus management
  - screen reader support
  - semantic widgets usage

suggest:
  - add semantic labels
  - increase touch targets
  - improve contrast
  - add tooltips
  - use Semantics widgets
  - test with TalkBack/VoiceOver

enforce:
  - all images have labels
  - all buttons have tooltips
  - touch targets ≥ 44x44
  - contrast ratio ≥ 4.5:1
  - form inputs labeled
```

---

## 📊 WCAG Guidelines

### Level A (Minimum)
```markdown
- [ ] Text alternatives for images
- [ ] Keyboard accessible
- [ ] Color not only indicator
- [ ] Error identification
```

### Level AA (Recommended)
```markdown
- [ ] Contrast ratio ≥ 4.5:1
- [ ] Text resize to 200%
- [ ] Touch target ≥ 44x44
- [ ] Multiple ways to navigate
```

### Level AAA (Enhanced)
```markdown
- [ ] Contrast ratio ≥ 7:1
- [ ] No timing
- [ ] No flashing content
```

---

## 📊 Summary Checklist

```markdown
- [ ] All images have semantic labels
- [ ] All buttons have tooltips
- [ ] Touch targets ≥ 44x44
- [ ] Color contrast ≥ 4.5:1
- [ ] Form inputs labeled
- [ ] Focus order logical
- [ ] Tested with screen reader
- [ ] Semantic widgets used
- [ ] Decorative elements excluded
- [ ] Live regions for updates
```

---

## 🔗 Related Rules

- [Internationalization](./internationalization.md)
- [Material 3 Theming](../ui-design/material3-theming.md)

---

**Priority:** 🔵 LOW  
**Level:** RECOMMENDED  
**For:** All Apps  
**WCAG:** AA Compliance  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

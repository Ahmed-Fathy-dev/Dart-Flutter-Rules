# 📱 Responsive Design - التصميم المتجاوب

## 🎯 Overview

**Category:** `UI/UX`  
**Priority:** `HIGH`  
**Difficulty:** `MEDIUM`  
**Status:** `RECOMMENDED`

التصميم المتجاوب يضمن أن تطبيقك يعمل بشكل مثالي على جميع أحجام الشاشات (mobile, tablet, desktop, web).

---

## 📚 Core Concepts

### 1. Breakpoints

#### استخدام MediaQuery

```dart
import 'package:flutter/material.dart';

class ScreenBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}

// Usage
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (ScreenBreakpoints.isMobile(context)) {
      return MobileLayout();
    } else if (ScreenBreakpoints.isTablet(context)) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  }
}
```

---

### 2. LayoutBuilder

أفضل من MediaQuery للتجاوب

```dart
// ✅ GOOD - يستجيب للحاوية الفعلية
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return MobileLayout();
    } else if (constraints.maxWidth < 900) {
      return TabletLayout();
    } else {
      return DesktopLayout();
    }
  },
)

// ❌ BAD - يعتمد على حجم الشاشة الكامل فقط
Builder(
  builder: (context) {
    final width = MediaQuery.of(context).size.width;
    // قد لا يعمل داخل containers صغيرة
    return width < 600 ? MobileLayout() : DesktopLayout();
  },
)
```

---

### 3. Responsive Helper Class

```dart
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  
  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
      
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;
      
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

// Usage
Responsive(
  mobile: MobileHomeScreen(),
  tablet: TabletHomeScreen(),
  desktop: DesktopHomeScreen(),
)
```

---

### 4. Responsive Padding & Spacing

```dart
class AppSpacing {
  // Base spacing
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  
  // Responsive spacing
  static double responsive(BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    if (Responsive.isDesktop(context)) return desktop;
    if (Responsive.isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}

// Usage
Padding(
  padding: EdgeInsets.all(
    AppSpacing.responsive(
      context,
      mobile: AppSpacing.md,
      tablet: AppSpacing.lg,
      desktop: AppSpacing.xl,
    ),
  ),
  child: child,
)
```

---

### 5. Responsive Text

```dart
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  
  const ResponsiveText(this.text, {this.style, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final baseFontSize = style?.fontSize ?? 14.0;
    
    final fontSize = Responsive.isDesktop(context)
        ? baseFontSize * 1.2
        : Responsive.isTablet(context)
            ? baseFontSize * 1.1
            : baseFontSize;
    
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
    );
  }
}

// أو باستخدام MediaQuery textScaleFactor
Text(
  'Hello',
  style: TextStyle(
    fontSize: 16 * MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3),
  ),
)
```

---

### 6. Responsive Grid

```dart
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  
  const ResponsiveGrid({required this.children, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // تحديد عدد الأعمدة حسب العرض
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 2; // Mobile
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 3; // Tablet
        } else {
          crossAxisCount = 4; // Desktop
        }
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
```

---

### 7. Orientation Support

```dart
class OrientationLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;
  
  const OrientationLayout({
    required this.portrait,
    required this.landscape,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? portrait
            : landscape;
      },
    );
  }
}

// Usage
OrientationLayout(
  portrait: Column(children: items),
  landscape: Row(children: items),
)
```

---

### 8. Responsive App Bar

```dart
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  const ResponsiveAppBar({required this.title, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return AppBar(
      title: Text(title),
      leading: isMobile ? const BackButton() : null,
      actions: [
        if (!isMobile) ...[
          TextButton(
            onPressed: () {},
            child: const Text('Home'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('About'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Contact'),
          ),
        ] else
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

---

### 9. Adaptive Widgets

```dart
// استخدام widgets تتكيف مع المنصة
import 'dart:io';

Widget buildPlatformButton({
  required VoidCallback onPressed,
  required String text,
}) {
  if (Platform.isIOS) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Text(text),
    );
  } else {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// أو باستخدام الـ package
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

PlatformButton(
  onPressed: () {},
  child: Text('Click Me'),
)
```

---

### 10. Responsive Navigation

```dart
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final List<NavigationItem> items;
  
  const ResponsiveScaffold({
    required this.body,
    required this.items,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Responsive(
      // Mobile: Bottom Navigation
      mobile: Scaffold(
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          items: items
              .map((e) => BottomNavigationBarItem(
                    icon: e.icon,
                    label: e.label,
                  ))
              .toList(),
        ),
      ),
      
      // Desktop: Side Navigation Rail
      desktop: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              destinations: items
                  .map((e) => NavigationRailDestination(
                        icon: e.icon,
                        label: Text(e.label),
                      ))
                  .toList(),
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class NavigationItem {
  final Icon icon;
  final String label;
  const NavigationItem({required this.icon, required this.label});
}
```

---

## 🎨 Material 3 Responsive Example

```dart
class ResponsiveHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveAppBar(title: 'My App'),
      drawer: Responsive.isMobile(context)
          ? Drawer(
              child: ListView(
                children: [
                  DrawerHeader(child: Text('Menu')),
                  ListTile(title: Text('Home')),
                  ListTile(title: Text('Profile')),
                ],
              ),
            )
          : null,
      body: Responsive(
        mobile: MobileBody(),
        tablet: TabletBody(),
        desktop: DesktopBody(),
      ),
    );
  }
}

class MobileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(child: ListTile(title: Text('Item 1'))),
        Card(child: ListTile(title: Text('Item 2'))),
        Card(child: ListTile(title: Text('Item 3'))),
      ],
    );
  }
}

class DesktopBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar
        SizedBox(
          width: 300,
          child: Card(
            child: ListView(
              children: [
                ListTile(title: Text('Filter 1')),
                ListTile(title: Text('Filter 2')),
              ],
            ),
          ),
        ),
        // Main content
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(24),
            children: List.generate(
              9,
              (index) => Card(
                child: Center(child: Text('Item ${index + 1}')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 📦 Recommended Packages

### **1. responsive_framework**
```yaml
dependencies:
  responsive_framework: ^1.5.1
```

```dart
MaterialApp(
  builder: (context, child) => ResponsiveBreakpoints.builder(
    child: child!,
    breakpoints: [
      const Breakpoint(start: 0, end: 450, name: MOBILE),
      const Breakpoint(start: 451, end: 800, name: TABLET),
      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
    ],
  ),
)
```

### **2. flutter_screenutil**
```yaml
dependencies:
  flutter_screenutil: ^5.9.3
```

```dart
// Init
ScreenUtil.init(context, designSize: const Size(375, 812));

// Usage
Container(
  width: 100.w,  // 100 width units
  height: 50.h,  // 50 height units
  padding: EdgeInsets.all(10.sp),  // 10 spacing units
)
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ استخدم LayoutBuilder للتجاوب
✅ استخدم MediaQuery للمعلومات العامة
✅ اختبر على أحجام شاشات مختلفة
✅ استخدم Breakpoints واضحة
✅ استخدم AspectRatio للصور
```

### **❌ تجنب:**
```dart
❌ hardcoded sizes
❌ الاعتماد فقط على MediaQuery
❌ نسيان landscape orientation
❌ نسيان اختبار على tablet
❌ تجاهل accessibility text scaling
```

---

## 🧪 Testing

```dart
testWidgets('should be responsive', (tester) async {
  // Test mobile
  await tester.binding.setSurfaceSize(const Size(400, 800));
  await tester.pumpWidget(MyApp());
  expect(find.byType(MobileLayout), findsOneWidget);
  
  // Test desktop
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MyApp());
  expect(find.byType(DesktopLayout), findsOneWidget);
});
```

---

## 🎯 AI Agent Instructions

### **Check:**
```yaml
- Are breakpoints clearly defined?
- Is LayoutBuilder used correctly?
- Are all screen sizes tested?
- Is text scaling considered?
```

### **Suggest:**
```yaml
- Use Responsive helper class
- Test on multiple devices
- Consider orientation changes
- Use responsive spacing
```

### **Enforce:**
```yaml
- No hardcoded pixel values
- Must support mobile + desktop
- Must handle orientation changes
```

---

## 📚 Related Files

- [Material 3 Theming](./material3-theming.md) - Theming
- [Layout Patterns](./layout-patterns.md) - Common layouts
- [Performance](../performance/build-optimization.md) - Optimization

---

**Last Updated:** 2025-10-22  
**Status:** `RECOMMENDED`  
**Priority:** `HIGH`

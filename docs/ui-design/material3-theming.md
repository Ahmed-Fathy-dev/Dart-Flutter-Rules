# Material 3 Theming

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: UI Design
applies_to:
  - all_flutter_projects
material_version: 3
ai_agent_tags:
  - ui
  - theming
  - material3
  - design-system
  - colors
```

---

## 🎯 Overview

**Material 3** (Material You) هو نظام التصميم الحديث من Google. يوفر theming ديناميكي ومرن.

### Why Material 3?
- ✅ Modern design
- 🎨 Dynamic colors
- 🌓 Dark/Light mode
- 📱 Adaptive components
- ♿ Better accessibility

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` لجميع المشاريع الجديدة

---

## 📚 Core Concepts

### 1. Enable Material 3

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true, // Enable Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
    ),
  ),
  home: MyHomePage(),
)
```

---

### 2. ColorScheme from Seed

```dart
// Light theme
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
);

// Dark theme
final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
);

// In MaterialApp
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system, // or .light, .dark
  home: MyHomePage(),
)
```

---

### 3. Custom ColorScheme

```dart
final lightColorScheme = ColorScheme.light(
  primary: Color(0xFF0061A4),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD1E4FF),
  onPrimaryContainer: Color(0xFF001D36),
  
  secondary: Color(0xFF535F70),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFD7E3F7),
  onSecondaryContainer: Color(0xFF101C2B),
  
  tertiary: Color(0xFF6B5778),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFF2DAFF),
  onTertiaryContainer: Color(0xFF251431),
  
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  
  background: Color(0xFFFDFCFF),
  onBackground: Color(0xFF1A1C1E),
  
  surface: Color(0xFFFDFCFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFDFE2EB),
  onSurfaceVariant: Color(0xFF43474E),
  
  outline: Color(0xFF73777F),
  outlineVariant: Color(0xFFC3C7CF),
  
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFF2F3033),
  onInverseSurface: Color(0xFFF1F0F4),
  inversePrimary: Color(0xFF9ECAFF),
);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
);
```

---

### 4. Typography

```dart
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  textTheme: TextTheme(
    // Display
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    
    // Headline
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    
    // Title
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    
    // Body
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    
    // Label
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  ),
);

// Usage
Text(
  'Display Large',
  style: Theme.of(context).textTheme.displayLarge,
)

Text(
  'Body Medium',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

---

### 5. Component Themes

```dart
final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  
  // AppBar
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
  ),
  
  // Card
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  // ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // FilledButton
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  
  // Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  
  // FloatingActionButton
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
);
```

---

### 6. ThemeExtension - Custom Colors

```dart
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color warning;
  final Color info;
  
  const AppColors({
    required this.success,
    required this.warning,
    required this.info,
  });
  
  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }
  
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
  
  // Light colors
  static const light = AppColors(
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    info: Color(0xFF2196F3),
  );
  
  // Dark colors
  static const dark = AppColors(
    success: Color(0xFF81C784),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF64B5F6),
  );
}

// Add to theme
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  extensions: [AppColors.light],
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  extensions: [AppColors.dark],
);

// Usage
final appColors = Theme.of(context).extension<AppColors>()!;

Container(
  color: appColors.success,
  child: Text('Success'),
)
```

---

## ✅ Best Practices

### Rule 1: Use Theme Colors

```dart
// ❌ Bad - Hardcoded colors
Container(
  color: Colors.blue,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.white),
  ),
)

// ✅ Good - Theme colors
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  ),
)
```

---

### Rule 2: Dynamic Theme Switching

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

// Setup
ChangeNotifierProvider(
  create: (_) => ThemeProvider(),
  child: Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeProvider.themeMode,
        home: MyHomePage(),
      );
    },
  ),
)

// Usage
context.read<ThemeProvider>().toggleTheme();
context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
```

---

### Rule 3: Responsive Typography

```dart
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  
  const ResponsiveText(this.text, {this.style});
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adjust font size based on screen
    final scale = screenWidth < 600 ? 0.9 : 1.0;
    
    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyMedium)
          ?.copyWith(fontSize: (style?.fontSize ?? 14) * scale),
    );
  }
}
```

---

## 🎯 Real-World Example: Complete Theme

```dart
// theme/app_theme.dart
class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0061A4),
      brightness: Brightness.light,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Typography
      textTheme: _textTheme,
      
      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      
      // Card
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      
      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Extensions
      extensions: [AppColors.light],
    );
  }
  
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0061A4),
      brightness: Brightness.dark,
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      // ... same component themes
      extensions: [AppColors.dark],
    );
  }
  
  static const _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  );
}

// main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'My App',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeProvider.themeMode,
          home: HomeScreen(),
        );
      },
    );
  }
}
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - useMaterial3: true
  - ColorScheme.fromSeed usage
  - theme/darkTheme defined
  - ThemeMode support
  - no hardcoded colors
  - Theme.of(context) usage
  - ThemeExtension for custom colors

suggest:
  - enable Material 3
  - use ColorScheme.fromSeed
  - add dark theme
  - use theme colors
  - extract theme to separate file
  - add ThemeExtension

enforce:
  - no hardcoded colors
  - Theme.of(context) for colors
  - proper text styles
  - component themes defined
```

---

## 📊 Summary Checklist

```markdown
- [ ] Material 3 enabled
- [ ] ColorScheme defined
- [ ] Dark theme support
- [ ] Typography configured
- [ ] Component themes
- [ ] ThemeExtension for custom colors
- [ ] Dynamic theme switching
- [ ] No hardcoded colors
```

---

## 🔗 Related Rules

- [Widget Immutability](../flutter-basics/widget-immutability.md)
- [Performance](../flutter-basics/performance-basics.md)

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Material Version:** 3  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

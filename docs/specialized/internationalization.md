# Internationalization (i18n)

## 📋 Metadata

```yaml
priority: LOW
level: OPTIONAL
category: Specialized
applies_to:
  - multi_language_apps
  - global_apps
ai_agent_tags:
  - i18n
  - localization
  - translation
  - multi-language
  - intl
```

---

## 🎯 Overview

**Internationalization (i18n)** يجعل تطبيقك يدعم لغات متعددة. ضروري للتطبيقات العالمية.

### Why i18n?
- 🌍 Global reach
- 👥 Better UX
- 📈 More users
- 💼 Business expansion
- ✅ Professional app

---

## 🔵 Priority Level: LOW

**Status:** `OPTIONAL` - ضروري للتطبيقات متعددة اللغات

---

## 📚 Core Concepts

### 1. Setup Flutter Intl

#### pubspec.yaml
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2  # ✅ Updated to latest (2025-10-22)

flutter:
  generate: true
```

#### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

---

### 2. ARB Files

#### lib/l10n/app_en.arb
```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The application title"
  },
  "welcome": "Welcome",
  "hello": "Hello {name}",
  "@hello": {
    "description": "Greeting with name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Ahmed"
      }
    }
  },
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  "price": "Price: {amount}",
  "@price": {
    "placeholders": {
      "amount": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "symbol": "$"
        }
      }
    }
  }
}
```

#### lib/l10n/app_ar.arb
```json
{
  "@@locale": "ar",
  "appTitle": "تطبيقي",
  "welcome": "مرحباً",
  "hello": "مرحباً {name}",
  "itemCount": "{count, plural, =0{لا توجد عناصر} =1{عنصر واحد} =2{عنصران} few{{count} عناصر} many{{count} عنصراً} other{{count} عنصر}}",
  "price": "السعر: {amount}"
}
```

---

### 3. MaterialApp Setup

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported locales
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('fr'), // French
      ],
      
      // Locale resolution
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        
        // Check if locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        
        // Fallback
        return supportedLocales.first;
      },
      
      home: HomeScreen(),
    );
  }
}
```

---

### 4. Using Translations

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Column(
        children: [
          // Simple text
          Text(l10n.welcome),
          
          // With placeholder
          Text(l10n.hello('Ahmed')),
          
          // Plurals
          Text(l10n.itemCount(0)), // "No items"
          Text(l10n.itemCount(1)), // "1 item"
          Text(l10n.itemCount(5)), // "5 items"
          
          // Currency
          Text(l10n.price(99.99)),
        ],
      ),
    );
  }
}
```

---

### 5. Dynamic Locale Switching

```dart
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

// In main
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('fr'),
          ],
          home: HomeScreen(),
        );
      },
    );
  }
}

// Language switcher
class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    
    return DropdownButton<Locale>(
      value: localeProvider.locale,
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
        DropdownMenuItem(
          value: Locale('fr'),
          child: Text('Français'),
        ),
      ],
      onChanged: (locale) {
        if (locale != null) {
          localeProvider.setLocale(locale);
        }
      },
    );
  }
}
```

---

### 6. RTL Support

```dart
// MaterialApp automatically handles RTL for Arabic, Hebrew, etc.
MaterialApp(
  locale: const Locale('ar'),
  localizationsDelegates: [...],
  supportedLocales: [...],
  // Automatically sets textDirection to RTL
  home: HomeScreen(),
)

// Manual control
Directionality(
  textDirection: Localizations.localeOf(context).languageCode == 'ar'
      ? TextDirection.rtl
      : TextDirection.ltr,
  child: Text('Content'),
)

// Check direction
final isRTL = Directionality.of(context) == TextDirection.rtl;
```

---

### 7. Date & Number Formatting

```dart
import 'package:intl/intl.dart';

class FormattingExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    
    return Column(
      children: [
        // Date formatting
        Text(DateFormat.yMMMd(locale).format(DateTime.now())),
        // en: Jan 15, 2024
        // ar: ١٥ يناير ٢٠٢٤
        
        // Time formatting
        Text(DateFormat.jm(locale).format(DateTime.now())),
        // en: 3:30 PM
        // ar: ٣:٣٠ م
        
        // Number formatting
        Text(NumberFormat.decimalPattern(locale).format(12345.67)),
        // en: 12,345.67
        // ar: ١٢٬٣٤٥٫٦٧
        
        // Currency
        Text(NumberFormat.currency(locale: locale, symbol: '\$').format(99.99)),
        // en: $99.99
        // ar: ٩٩٫٩٩ $
        
        // Percentage
        Text(NumberFormat.percentPattern(locale).format(0.85)),
        // en: 85%
        // ar: ٨٥٪
      ],
    );
  }
}
```

---

### 8. easy_localization Package (Alternative)

```yaml
dependencies:
  easy_localization: ^3.0.7  # ✅ Updated to latest
```

```dart
// assets/translations/en.json
{
  "title": "My App",
  "hello": "Hello {name}",
  "items": {
    "zero": "No items",
    "one": "1 item",
    "other": "{} items"
  }
}

// assets/translations/ar.json
{
  "title": "تطبيقي",
  "hello": "مرحباً {name}",
  "items": {
    "zero": "لا توجد عناصر",
    "one": "عنصر واحد",
    "other": "{} عنصر"
  }
}

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: HomeScreen(),
    );
  }
}

// Usage
Text('title'.tr())
Text('hello'.tr(namedArgs: {'name': 'Ahmed'}))
Text('items'.plural(5))

// Change locale
context.setLocale(Locale('ar'))
```

---

## ✅ Best Practices

### Rule 1: Externalize All Strings

```dart
// ❌ Bad - Hardcoded strings
Text('Welcome to My App')
Text('You have 5 items')

// ✅ Good - Localized
Text(l10n.welcome)
Text(l10n.itemCount(5))
```

---

### Rule 2: Use Placeholders

```dart
// ❌ Bad - String concatenation
Text('Hello ${userName}!') // Hard to translate

// ✅ Good - Placeholders
Text(l10n.hello(userName))
// ARB: "hello": "Hello {name}!"
```

---

### Rule 3: Handle Plurals Properly

```dart
// ❌ Bad - English-only logic
Text(count == 1 ? '$count item' : '$count items')
// Doesn't work for Arabic (has more plural forms)

// ✅ Good - Use plural rules
Text(l10n.itemCount(count))
// ARB handles all plural forms per language
```

---

## 🎯 Translation Workflow

```yaml
1. Development:
   - Add keys to app_en.arb
   - Use keys in code
   - Test in English

2. Translation:
   - Export app_en.arb
   - Send to translators
   - Receive app_ar.arb, app_fr.arb, etc.

3. Integration:
   - Add translated ARB files
   - Run: flutter gen-l10n
   - Test all languages

4. Maintenance:
   - Add new keys to all ARB files
   - Update translations
   - Version control all ARB files
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - AppLocalizations usage
  - No hardcoded strings
  - ARB files present
  - Locale switching implemented
  - RTL support for Arabic/Hebrew
  - Date/number formatting
  - Plurals used correctly

suggest:
  - externalize hardcoded strings
  - add placeholders
  - use plural rules
  - implement locale switching
  - test RTL layout
  - format dates/numbers

enforce:
  - no hardcoded user-facing strings
  - all strings in ARB files
  - proper placeholders
  - plural support
  - locale provider
```

---

## 📊 Summary Checklist

```markdown
- [ ] flutter_localizations added
- [ ] l10n.yaml configured
- [ ] ARB files created
- [ ] MaterialApp setup
- [ ] No hardcoded strings
- [ ] Locale switching works
- [ ] RTL tested (if applicable)
- [ ] Date/number formatting
- [ ] Plurals handled
- [ ] All languages tested
```

---

## 🔗 Related Rules

- [Accessibility](./accessibility.md)
- [Material 3 Theming](../ui-design/material3-theming.md)

---

**Priority:** 🔵 LOW  
**Level:** OPTIONAL  
**For:** Multi-language Apps  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

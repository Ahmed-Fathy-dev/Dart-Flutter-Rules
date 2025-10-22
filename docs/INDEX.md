# 📚 Flutter/Dart Rules Documentation Index

## 🎯 Navigation Guide

هذا الدليل منظم حسب الأولويات والفئات لسهولة الوصول.

---

## 🔴 Priority 1: CRITICAL RULES (إلزامية)

يجب تطبيقها في جميع المشاريع - لا استثناءات

### Core Rules
- [Null Safety](./core/null-safety.md) - `CRITICAL` `ENFORCE`
- [Error Handling](./core/error-handling.md) - `CRITICAL` `ENFORCE`
- [Code Style](./core/code-style.md) - `CRITICAL` `ENFORCE`
- [Async/Await](./core/async-await.md) - `CRITICAL` `ENFORCE`
- [Value Equality (Equatable)](./core/value-equality.md) - `HIGH` `RECOMMENDED` ✨ NEW!

### Flutter Basics
- [Widget Immutability](./flutter-basics/widget-immutability.md) - `CRITICAL` `ENFORCE`
- [Performance Basics](./flutter-basics/performance-basics.md) - `CRITICAL` `ENFORCE`

### Testing
- [Unit Testing Basics](./testing/unit-testing.md) - `CRITICAL` `ENFORCE`
- [Widget Testing Basics](./testing/widget-testing.md) - `CRITICAL` `ENFORCE`

**📊 Coverage:** 9 ملفات (+1) | **Priority Level:** 🔴 CRITICAL

---

## 🟡 Priority 2: HIGH (موصى بها بشدة)

مهمة لمعظم المشاريع المتوسطة والكبيرة

### State Management
- [Built-in Solutions](./state-management/built-in.md) - `HIGH` `RECOMMENDED`
- [Provider](./state-management/provider.md) - `HIGH` `OPTIONAL`
- [Bloc](./state-management/bloc.md) - `HIGH` `OPTIONAL`
- [Riverpod](./state-management/riverpod.md) - `HIGH` `OPTIONAL`
- [GetX](./state-management/getx.md) - `MEDIUM` `OPTIONAL` 🔥 NEW!
- [Flutter Hooks](./state-management/hooks.md) - `MEDIUM` `OPTIONAL`
- [Comparison Guide](./state-management/comparison.md) - `HIGH` `GUIDE`

### Navigation
- [GoRouter](./navigation/go-router.md) - `HIGH` `RECOMMENDED`
- [GoRouter Builder - Advanced](./navigation/go-router-builder-advanced.md) - `HIGH` `ADVANCED` 🔥
- [AutoRoute](./navigation/auto-route.md) - `MEDIUM` `ADVANCED` 🔥 NEW!
- [Navigator](./navigation/navigator.md) - `HIGH` `BASIC`
- [Deep Linking](./navigation/deep-linking.md) - `HIGH` `ADVANCED`

### Data & Serialization
- [JSON Serialization](./data/json-serialization.md) - `HIGH` `RECOMMENDED`
- [dart_mappable](./data/dart-mappable.md) - `MEDIUM` `ADVANCED` 🔥
- [HTTP Clients](./data/http-clients.md) - `HIGH` `RECOMMENDED`
- [Local Storage](./data/local-storage.md) - `HIGH` `RECOMMENDED`
- [ObjectBox](./data/objectbox.md) - `MEDIUM` `ADVANCED` 🔥 NEW!

### UI & Components
- [Material 3 Theming](./ui-design/material3-theming.md) - `HIGH` `RECOMMENDED`
- [Responsive Design](./ui-design/responsive-design.md) - `HIGH` `RECOMMENDED`
- [Layout Best Practices](./ui-design/layout-best-practices.md) - `HIGH` `ENFORCE`
- [Common UI Packages](./ui/common-packages.md) - `HIGH` `RECOMMENDED` ✨ NEW!
- [UI Utilities](./ui/ui-utilities.md) - `MEDIUM` `OPTIONAL` ✨ NEW!

**📊 Coverage:** 20 ملفات (+6) | **Priority Level:** 🟡 HIGH

---

## 🟢 Priority 3: MEDIUM (مفيدة)

للمشاريع المتوسطة والكبيرة

### Architecture
- [Layered Architecture](./architecture/layered.md) - `MEDIUM` `RECOMMENDED`
- [MVVM Pattern](./architecture/mvvm.md) - `MEDIUM` `OPTIONAL`
- [Clean Architecture](./architecture/clean.md) - `MEDIUM` `ADVANCED`
- [Feature-based](./architecture/feature-based.md) - `MEDIUM` `ADVANCED`
- [Comparison Guide](./architecture/comparison.md) - `MEDIUM` `GUIDE`

### Advanced Testing
- [Integration Testing](./testing/integration-testing.md) - `MEDIUM` `RECOMMENDED`
- [Golden Tests](./testing/golden-tests.md) - `MEDIUM` `OPTIONAL`
- [Mocking Strategies](./testing/mocking.md) - `MEDIUM` `GUIDE`

### Performance
- [Optimization Techniques](./performance/optimization.md) - `MEDIUM` `GUIDE`
- [Memory Management](./performance/memory.md) - `MEDIUM` `GUIDE`
- [Profiling](./performance/profiling.md) - `MEDIUM` `ADVANCED`

**📊 Coverage:** 12 ملفات (+1) | **Priority Level:** 🟢 MEDIUM

---

## 🔵 Priority 4: LOW (متخصصة)

لحالات خاصة أو مشاريع محددة

### Specialized Topics
- [Accessibility (A11Y)](./specialized/accessibility.md) - `LOW` `SPECIALIZED`
- [Internationalization](./specialized/internationalization.md) - `LOW` `SPECIALIZED`
- [Environment Configuration (Envied)](./specialized/environment-config.md) - `HIGH` `RECOMMENDED` ✨ NEW!
- [Advanced Packages](./specialized/advanced-packages.md) - `LOW` `OPTIONAL` ✨ NEW!
- [Platform Channels](./specialized/platform-channels.md) - `LOW` `ADVANCED`
- [Security](./specialized/security.md) - `HIGH` `RECOMMENDED`
- [Animations](./specialized/animations.md) - `MEDIUM` `OPTIONAL`

### Tools & Workflow
- [Build Runner](./tools/build-runner.md) - `HIGH` `RECOMMENDED`
- [Logging (Talker)](./tools/logging.md) - `CRITICAL` `RECOMMENDED` ✨ NEW!
- [Debugging](./tools/debugging.md) - `HIGH` `RECOMMENDED`
- [Analysis Options](./tools/analysis-options.md) - `HIGH` `ENFORCE`
- [Profiling](./tools/profiling.md) - `MEDIUM` `ADVANCED`

**📊 Coverage:** 10 ملفات (+1) | **Priority Level:** 🔵 LOW

---

## 🎯 Quick Access by Use Case

### للمبتدئين
```
1. Core Rules (جميع ملفات Priority 1)
2. Flutter Basics
3. Built-in State Management
4. Navigator
5. Material 3 Theming
```

### للمشاريع المتوسطة
```
1. جميع Priority 1
2. GoRouter
3. JSON Serialization
4. Layered Architecture
5. Integration Testing
```

### للمشاريع الكبيرة
```
1. جميع Priority 1 + 2
2. Feature-based Architecture
3. Bloc/Riverpod
4. Performance Optimization
5. CI/CD
```

---

## 🤖 AI Agent Integration Guide

### للعمل مع Windsurf + Claude Sonnet

#### 1. قراءة الملفات
```
- كل ملف يحتوي على metadata في الأعلى
- استخدم الـ tags للفلترة (CRITICAL, HIGH, etc.)
- الأمثلة منفصلة في sections واضحة
```

#### 2. تطبيق القواعد
```
- افحص rules-config.yaml أولاً
- اقرأ الملفات ذات Priority عالية
- طبق القواعد المفعلة فقط
```

#### 3. اقتراح التحسينات
```
- قارن الكود الحالي مع Best Practices
- اقترح ترقية من Priority منخفض لعالي
- وضح السبب والفوائد
```

---

## 📊 Statistics

```yaml
Total Files: 51 ملف (+9 جديد)
Priority Breakdown:
  CRITICAL: 9 files  (18%)
  HIGH:     20 files (39%)
  MEDIUM:   12 files (23%)
  LOW:      10 files (20%)

Coverage:
  Core & Basics:    9 files (+1)
  State & Nav:      10 files (+1)
  Data & UI:        11 files (+3)
  Architecture:     5 files
  Testing:          5 files
  Tools:            5 files (+1)
  Specialized:      6 files (+3)

New Content (2025-10-22):
  ✨ Equatable for value equality
  ✨ Talker for professional logging
  ✨ ObjectBox ultra-fast database
  ✨ Envied for secure env config
  ✨ Flutter Hooks for modern state
  ✨ 22 UI/Utility packages
  ✨ dart_mappable alternative
  ✨ pretty_dio_logger
```

---

## 🔄 Update Log

| Date | Version | Changes |
|------|---------|---------|
| 2025-10-22 | 2.0.0 | Major update: +9 files, 29 packages documented |
| 2025-10-21 | 1.0.0 | Initial release with 42 files |

---

## 📖 How to Use This Documentation
{{ ... }}
### للقراءة البشرية
1. ابدأ بالملفات ذات Priority عالية
2. اقرأ المقدمة والأمثلة
3. راجع Common Pitfalls
4. طبق في مشروعك

### للـ AI Agents
1. اقرأ rules-config.yaml
2. افتح الملفات حسب enabled rules
3. استخرج القواعد المفعلة
4. طبق مع مراعاة الـ Priority

---

**آخر تحديث:** 2025-10-22  
**الإصدار:** 2.0.0 - Major Documentation Update  
**الملفات الجديدة:** 9 files | **المكتبات الموثقة:** 29 packages

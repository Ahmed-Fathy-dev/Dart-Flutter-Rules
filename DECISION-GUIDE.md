# 🧭 دليل اتخاذ القرارات - Flutter/Dart

<div dir="rtl">

## 🎯 الهدف من هذا الدليل

مساعدتك في اتخاذ القرارات الصحيحة عند بداية مشروع Flutter جديد أو تحسين مشروع قائم.

---

## 📊 مخطط القرارات السريع

### 1. تحديد حجم المشروع

```
هل لديك أكثر من 20 شاشة؟
│
├── نعم ─────────────────────► Large Project
│   │
│   └─► استخدم: Feature-based + Bloc/Riverpod + GoRouter
│
└── لا
    │
    هل لديك 5-20 شاشة؟
    │
    ├── نعم ────────────────► Medium Project  ✅ الأكثر شيوعاً
    │   │
    │   └─► استخدم: Layered + Built-in/Provider + GoRouter
    │
    └── لا (أقل من 5) ───► Small Project
        │
        └─► استخدم: Simple structure + Built-in + Navigator
```

---

## 🔄 State Management - شجرة القرارات

### ابدأ هنا: هل حالة التطبيق معقدة؟

```
مدى تعقيد الحالة؟
│
├── بسيطة (counters, flags, simple forms)
│   │
│   └─► Built-in Solutions ✅
│       ├── ValueNotifier (قيمة واحدة)
│       ├── ChangeNotifier (كائن واحد)
│       └── StreamController (أحداث متسلسلة)
│
├── متوسطة (shared state, multiple screens)
│   │
│   حجم الفريق؟
│   │
│   ├── 1-3 مطورين ──► Built-in + Manual DI
│   └── 4+ مطورين ───► Provider ✅
│
└── معقدة (complex flows, heavy business logic)
    │
    مستوى الخبرة؟
    │
    ├── مبتدئ/متوسط ──► Riverpod ✅
    └── متقدم ─────────► Bloc ✅
```

### مقارنة تفصيلية

| المعيار | Built-in | Provider | Bloc | Riverpod |
|---------|----------|----------|------|----------|
| **Learning Curve** | ⭐⭐⭐⭐⭐ سهل | ⭐⭐⭐⭐ سهل | ⭐⭐ صعب | ⭐⭐⭐ متوسط |
| **Boilerplate** | قليل | قليل | كثير | متوسط |
| **Testability** | ⭐⭐⭐ جيد | ⭐⭐⭐⭐ ممتاز | ⭐⭐⭐⭐⭐ مثالي | ⭐⭐⭐⭐⭐ مثالي |
| **Type Safety** | ⭐⭐⭐ جيد | ⭐⭐⭐ جيد | ⭐⭐⭐⭐ ممتاز | ⭐⭐⭐⭐⭐ مثالي |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Documentation** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Community** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Best For** | Small | Small-Medium | Medium-Large | All sizes |

### أمثلة على الاستخدام

#### Built-in: ValueNotifier
```dart
class CounterScreen extends StatelessWidget {
  final counter = ValueNotifier<int>(0);
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: counter,
      builder: (context, value, child) {
        return Column(
          children: [
            Text('$value'),
            ElevatedButton(
              onPressed: () => counter.value++,
              child: Text('Increment'),
            ),
          ],
        );
      },
    );
  }
}
```

**✅ استخدمه للحالات البسيطة**

---

#### Provider
```dart
// 1. Model
class CartModel extends ChangeNotifier {
  final List<Item> _items = [];
  List<Item> get items => _items;
  
  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }
}

// 2. Provide
ChangeNotifierProvider(
  create: (context) => CartModel(),
  child: MyApp(),
)

// 3. Consume
final cart = context.watch<CartModel>();
Text('Items: ${cart.items.length}')
```

**✅ استخدمه عندما تحتاج DI**

---

#### Bloc
```dart
// 1. Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}

// 2. States
class CounterState {
  final int count;
  CounterState(this.count);
}

// 3. Bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.count + 1)));
  }
}

// 4. Use
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) => Text('${state.count}'),
)
```

**✅ استخدمه للمشاريع الكبيرة والمعقدة**

---

#### Riverpod
```dart
// 1. Provider
final counterProvider = StateProvider((ref) => 0);

// 2. Use (no BuildContext needed!)
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**✅ استخدمه كبديل حديث للـ Provider**

---

## 🧭 Navigation - متى تستخدم أي حل؟

### شجرة القرارات

```
هل تحتاج Deep Linking؟
│
├── نعم
│   │
│   └─► GoRouter ✅
│
└── لا
    │
    هل تستهدف Web؟
    │
    ├── نعم ──────────► GoRouter ✅
    │
    └── لا
        │
        عدد الشاشات؟
        │
        ├── أكثر من 5 ───► GoRouter ✅
        └── أقل من 5 ───► Navigator
```

### مقارنة تفصيلية

| Feature | Navigator | GoRouter | AutoRoute |
|---------|-----------|----------|-----------|
| **Deep Linking** | ❌ | ✅ | ✅ |
| **Web Support** | ⚠️ محدود | ✅ ممتاز | ✅ ممتاز |
| **Type Safety** | ❌ | ⚠️ يدوي | ✅ Code-gen |
| **Learning Curve** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Boilerplate** | قليل | متوسط | متوسط |
| **Auth Guards** | يدوي | ✅ مدمج | ✅ مدمج |
| **Nested Routes** | صعب | ✅ سهل | ✅ سهل |
| **Best For** | Small apps | Medium-Large | Large + Teams |

### الخلاصة

```yaml
# استخدم Navigator إذا:
navigation:
  use_navigator_if:
    - مشروع صغير (< 5 شاشات)
    - لا تحتاج deep linking
    - mobile-only
    - dialogs و bottom sheets

# استخدم GoRouter إذا:
navigation:
  use_go_router_if:
    - مشروع متوسط/كبير (5+ شاشات)
    - تحتاج deep linking
    - تستهدف web
    - authentication flow معقد
    - ✅ الخيار الموصى به للمشاريع الحديثة

# استخدم AutoRoute إذا:
navigation:
  use_auto_route_if:
    - مشروع كبير جداً
    - فريق كبير
    - تحتاج type-safety قوي
    - لا مشكلة مع code generation
```

---

## 🏗️ Architecture - أي نمط تختار؟

### شجرة القرارات

```
عدد Features/Modules؟
│
├── أقل من 3
│   │
│   └─► Simple Structure (لا architecture)
│       lib/
│       ├── main.dart
│       ├── screens/
│       └── services/
│
├── 3-8 features
│   │
│   └─► Layered Architecture ✅
│       lib/
│       ├── presentation/
│       ├── domain/
│       └── data/
│
└── أكثر من 8 features
    │
    حجم الفريق؟
    │
    ├── صغير (2-5) ──► Layered + MVVM
    │
    └── كبير (6+) ───► Feature-based + Clean Architecture
        lib/
        └── features/
            ├── feature1/
            │   ├── presentation/
            │   ├── domain/
            │   └── data/
            └── feature2/
```

### مقارنة الأنماط

| Pattern | Best For | Team Size | Complexity | Scalability |
|---------|----------|-----------|------------|-------------|
| **Simple** | MVP, Prototypes | 1-2 | ⭐ | ⭐⭐ |
| **Layered** | Most apps | 2-5 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **MVVM** | Medium apps | 3-6 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Clean** | Large apps | 5-10 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Feature-based** | Very large | 8+ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

### نصيحة ذهبية

> ⚠️ **Don't over-engineer!**  
> ابدأ بسيط، ثم أضف Complexity عند الحاجة فقط.

```dart
// ❌ خطأ: Clean Architecture لتطبيق To-Do بسيط
lib/
└── features/
    └── todo/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   └── repositories/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/

// ✅ صحيح: بنية بسيطة تكفي
lib/
├── main.dart
├── models/
│   └── todo.dart
├── screens/
│   └── todo_list_screen.dart
└── services/
    └── todo_service.dart
```

---

## 💾 Data Layer - اختيار الأدوات

### JSON Serialization

```
هل لديك أكثر من 5 models؟
│
├── نعم
│   │
│   تحتاج immutability + copyWith؟
│   │
│   ├── نعم ──────► freezed + json_serializable ✅
│   └── لا ───────► json_serializable ✅
│
└── لا (< 5 models)
    │
    └─► Manual JSON parsing (كافي)
```

### مقارنة

| Solution | Boilerplate | Features | Best For |
|----------|-------------|----------|----------|
| **Manual** | ❌ كثير | Basic | < 3 models |
| **json_serializable** | ✅ قليل | Good | Most apps |
| **freezed** | ✅ قليل | ⭐⭐⭐⭐⭐ | Complex models |
| **built_value** | متوسط | ⭐⭐⭐⭐ | Large apps |

### HTTP Client

```
احتياجاتك؟
│
├── بسيط (GET/POST فقط)
│   └─► http package
│
├── متوسط (interceptors, timeout, retry)
│   └─► dio ✅ موصى به
│
└── معقد (type-safe, code-gen)
    └─► retrofit (مبني على dio)
```

### Local Storage

| Type | Package | Best For |
|------|---------|----------|
| **Key-Value** | shared_preferences | Settings, flags |
| **Small Objects** | hive | Cache, simple data |
| **Relational** | sqflite / drift | Complex data |
| **Secure** | flutter_secure_storage | Tokens, passwords |

---

## 🎨 UI/UX - القرارات الأساسية

### Material vs Cupertino vs Custom

```
نوع التطبيق؟
│
├── Android-only ─────────► Material Design
├── iOS-only ─────────────► Cupertino Design
├── Both (adaptive) ──────► Material + Cupertino adaptive
└── Unique brand ─────────► Custom Design System
```

### مثال Adaptive

```dart
// عرض design مناسب للـ platform
Widget buildButton() {
  if (Platform.isIOS) {
    return CupertinoButton(...);
  } else {
    return ElevatedButton(...);
  }
}

// أو استخدم
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

PlatformButton() // من packages مثل flutter_platform_widgets
```

### Theming

```yaml
# Material 3 (الأحدث)
theme:
  material_version: 3
  use_color_scheme_from_seed: true
  
# Material 2 (للتوافق مع القديم)
theme:
  material_version: 2
  use_theme_data_colors: true
```

**التوصية:** استخدم Material 3 للمشاريع الجديدة

---

## ✅ Testing Strategy

### Test Coverage المناسب

```
نوع المشروع؟
│
├── MVP / Prototype
│   └─► 40-50% coverage (فقط الـ critical)
│
├── Production App
│   └─► 70-80% coverage ✅ موصى به
│
└── Mission-Critical (Banking, Health)
    └─► 90%+ coverage + Integration + E2E
```

### تخصيص Effort

```yaml
Unit Tests: 70% من الجهد
  - Business logic
  - Data layer
  - State management
  
Widget Tests: 20% من الجهد
  - Critical screens
  - Complex widgets
  
Integration Tests: 10% من الجهد
  - Critical user flows
  - Happy paths
```

### أدوات Mocking

| Package | Type | Best For |
|---------|------|----------|
| **Fakes** | Manual | Recommended ✅ |
| **mockito** | Code-gen | Complex |
| **mocktail** | No code-gen | Cleaner API |

**التوصية:** استخدم Fakes عندما يكون ممكناً

---

## 🔒 Security Decisions

### API Key Management

```
حساسية الـ API key؟
│
├── عامة (Google Maps, etc.)
│   └─► dart-define أو .env file
│
└── حساسة (Payment, Auth)
    └─► Backend proxy ✅
        (لا ترسل key للـ client أبداً)
```

### مثال

```dart
// ✅ For public APIs
const apiKey = String.fromEnvironment('MAPS_API_KEY');

// ✅ For sensitive APIs
// اجعل Backend يتعامل معهم
await http.post(
  'https://yourbackend.com/api/payment',
  body: {...}, // backend يضيف السر
);
```

### Data Storage

| Data Type | Storage | Encryption |
|-----------|---------|------------|
| **Settings** | shared_preferences | ❌ |
| **User Data** | sqflite/hive | ⚠️ optional |
| **Tokens** | flutter_secure_storage | ✅ |
| **Passwords** | Never store! | ❌ |

---

## 📱 Platform-specific Decisions

### Web Considerations

```yaml
web_specific:
  # Performance
  - Use CanvasKit for graphics
  - HTML renderer for text-heavy
  
  # SEO
  - Use flutter_seo package
  - Generate static pages if possible
  
  # Responsive
  - Breakpoints: 600, 900, 1200
  - Test on different screen sizes
```

### Desktop Considerations

```yaml
desktop_specific:
  # Layout
  - Larger screens (1280+)
  - Mouse & keyboard input
  - Menu bars
  
  # Platform
  - windows: Use windows_taskbar
  - macos: Use macos_ui
  - linux: Consider system theme
```

---

## 🚀 Performance Optimization

### متى تبدأ Optimization؟

```
هل لديك مشكلة أداء فعلية؟
│
├── لا ──────────► ✅ Don't optimize prematurely!
│                  أكمل features أولاً
│
└── نعم
    │
    أين المشكلة؟
    │
    ├── Build method ─────► Use const, extract widgets
    ├── Long lists ───────► ListView.builder
    ├── Heavy computation ► Isolates (compute)
    ├── Images ───────────► Cached network image
    └── Animations ───────► Profile with DevTools
```

### أدوات القياس

```dart
// 1. Performance Overlay
MaterialApp(
  showPerformanceOverlay: true, // يظهر FPS
)

// 2. Timeline
import 'dart:developer';
Timeline.startSync('expensive_operation');
// ... code
Timeline.finishSync();

// 3. DevTools
// افتح في browser لتحليل مفصل
```

---

## 📊 قوالب القرارات الجاهزة

### Template 1: تطبيق تجاري (E-commerce)

```yaml
project_type: e-commerce
size: medium

architecture: layered
state_management: built-in  # أو provider
navigation: go_router
  
data:
  http: dio
  json: json_serializable
  storage: hive + secure_storage
  caching: true
  
ui:
  material: 3
  theme: custom_brand_colors
  responsive: true
  
testing:
  coverage: 75%
  integration: checkout_flow
  
security:
  api_keys: backend_proxy
  secure_storage: tokens
```

---

### Template 2: تطبيق اجتماعي (Social Media)

```yaml
project_type: social_media
size: large

architecture: feature-based
state_management: bloc
navigation: go_router
  
data:
  http: dio
  json: freezed + json_serializable
  storage: drift (database)
  realtime: firebase / websockets
  caching: aggressive
  offline_first: true
  
ui:
  material: 3
  theme: dark + light
  responsive: true
  animations: heavy
  
testing:
  coverage: 85%
  integration: critical_flows
  golden: ui_regression
  
security:
  encryption: sensitive_data
  secure_storage: true
  
performance:
  profiling: enabled
  monitoring: firebase_performance
```

---

### Template 3: تطبيق إنتاجية (Productivity)

```yaml
project_type: productivity
size: small_to_medium

architecture: simple / layered
state_management: built-in
navigation: navigator / go_router
  
data:
  http: http (basic)
  json: manual / json_serializable
  storage: sqflite
  sync: cloud_backup
  
ui:
  material: 3
  theme: simple_clean
  responsive: basic
  
testing:
  coverage: 70%
  
features:
  offline: required
  widgets: custom_input_fields
```

---

## 🎯 الخلاصة: Decision Matrix

### ملخص سريع حسب حجم المشروع

| Component | Small | Medium | Large |
|-----------|-------|--------|-------|
| **Architecture** | None | Layered | Feature-based |
| **State** | Built-in | Built-in/Provider | Bloc/Riverpod |
| **Navigation** | Navigator | GoRouter | GoRouter |
| **Testing** | 60% | 75% | 85%+ |
| **JSON** | Manual | json_serializable | freezed |
| **HTTP** | http | dio | dio/retrofit |

---

## ✨ النصيحة الذهبية الأخيرة

> **Start Simple, Scale Smart**
> 
> - ✅ ابدأ بأبسط حل يعمل
> - ✅ أضف Complexity عند الحاجة فقط
> - ✅ قيس الأداء قبل التحسين
> - ✅ اختبر الـ critical paths
> - ✅ وثّق القرارات المهمة

---

## 📚 المراجع السريعة

- [QUICK-START.md](./QUICK-START.md) - دليل البداية
- [README.md](./README.md) - نظرة عامة
- [rules-config.yaml](./rules-config.yaml) - ملف التكوين
- [detailed-analysis.md](./analysis/detailed-analysis.md) - التحليل التفصيلي

---

**حظاً موفقاً في مشروعك! 🚀**

</div>

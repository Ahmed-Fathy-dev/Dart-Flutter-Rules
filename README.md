# 📘 Flutter/Dart Rules - نظام قواعد معياري ومرن

<div dir="rtl">

## 🎯 ما هذا المشروع؟

نظام شامل ومعياري لأفضل ممارسات Flutter/Dart، مصمم خصيصاً للعمل مع AI Agents و MCP (Model Context Protocol). يوفر قواعد منظمة وقابلة للتخصيص حسب احتياجات مشروعك.

### ✨ المميزات الرئيسية

- ✅ **معياري (Modular):** كل فئة من القواعد في ملف منفصل
- ✅ **قابل للتخصيص:** نظام configuration شامل
- ✅ **إعدادات جاهزة (Profiles):** حسب حجم المشروع
- ✅ **توثيق شامل:** مع أمثلة عملية
- ✅ **مصنف حسب الأولوية:** Core → Recommended → Advanced → Specialized
- ✅ **متوافق مع AI Agents:** مصمم للعمل مع MCP

---

## 📂 بنية المشروع

```
flutter-rules/
├── README.md                           # 👈 أنت هنا
├── START-HERE.md                       # 🚀 ابدأ من هنا
├── QUICK-START.md                      # 🚀 دليل المبتدئين
├── WINDSURF-USAGE-GUIDE.md             # 🎯 دليل استخدام Windsurf/Claude
├── QUICK-EXAMPLES.md                   # ⚡ أمثلة سريعة جاهزة
├── DECISION-GUIDE.md                   # 🧭 دليل اتخاذ القرارات
├── AI-AGENT-INTEGRATION.md             # 🤖 تكامل AI Agents
├── rules-config.yaml                   # ⚙️ ملف التكوين الرئيسي
│
├── archive/                            # 📦 ملفات قديمة ومرجعية
│   ├── original/                       # الملف الأصلي
│   ├── planning/                       # ملفات التخطيط (مكتملة)
│   └── version-updates/                # تقارير التحديثات
│
├── docs/                               # 📚 توثيق شامل (51 ملف - محدث 2025-10-22)
│   ├── INDEX.md                        # 📑 فهرس كامل
│   ├── core/                           # القواعد الأساسية (5 ملفات +1)
│   ├── flutter-basics/                 # أساسيات Flutter (2 ملف)
│   ├── testing/                        # الاختبارات (5 ملفات)
│   ├── state-management/               # إدارة الحالة (6 ملفات +1)
│   ├── architecture/                   # البنية المعمارية (5 ملفات)
│   ├── navigation/                     # التنقل (3 ملفات)
│   ├── data/                           # التعامل مع البيانات (3 ملفات محدثة)
│   ├── ui/                             # مكونات UI (2 ملفات جديدة)
│   ├── ui-design/                      # التصميم (4 ملفات)
│   ├── performance/                    # الأداء (3 ملفات)
│   ├── specialized/                    # مواضيع متخصصة (7 ملفات +2)
│   └── tools/                          # أدوات التطوير (5 ملفات +1)
│
└── templates/                          # 🎨 (مستقبلاً) قوالب جاهزة
    ├── small-project/
    ├── medium-project/
    └── large-project/
```

---

## 🚀 البداية السريعة

### 1️⃣ اختر Profile مناسب

افتح `rules-config.yaml` وفعّل الـ profile المناسب:

```yaml
profiles:
  small_project:      # مشروع صغير (1-3 شاشات)
    enabled: false
    
  medium_project:     # مشروع متوسط (5-15 شاشة) ✅ موصى به
    enabled: true     # 👈 فعّل هذا
    
  large_project:      # مشروع كبير (20+ شاشة)
    enabled: false
```

### 2️⃣ خصص الإعدادات

```yaml
state_management:
  primary: built-in   # أو: provider, bloc, riverpod

navigation:
  router: go_router   # أو: navigator, auto_route

testing:
  unit_tests:
    min_coverage: 80  # عدّل حسب حاجتك
```

### 3️⃣ ابدأ التطوير

اقرأ `QUICK-START.md` للحصول على دليل مفصل مع أمثلة عملية.

---

## ✨ التحديثات الأخيرة (2025-10-22)

### 🎉 المكتبات الجديدة (29 package)

#### **CRITICAL & HIGH Priority:**
- ✅ **Talker** (4.6.4) - Professional logging مع in-app viewer
- ✅ **ObjectBox** (4.3.0) - Database أسرع 10x من Hive
- ✅ **Envied** (1.1.0) - Secure environment config
- ✅ **dart_mappable** (4.4.0) - بديل أفضل لـ json_serializable
- ✅ **Equatable** (2.0.7) - Value equality بسهولة
- ✅ **Flutter Hooks** (0.21.2) - React-style hooks
- ✅ **pretty_dio_logger** (1.4.0) - Beautiful HTTP logs

#### **UI & Utilities (15 packages):**
- ✅ google_fonts, flutter_svg, form_builder_validators
- ✅ image_picker, permission_handler
- ✅ pinput, fluttertoast, toastification
- ✅ skeletonizer, uuid, smooth_page_indicator
- ✅ والمزيد...

#### **Specialized (9 packages):**
- ✅ fl_chart, media_kit, printing, pdf
- ✅ barcode_scan2, flutter_inappwebview
- ✅ window_manager, iconsax_flutter, dropdown_button2

### 📚 التوثيق المحدث:
- ✅ 9 ملفات جديدة
- ✅ 3 ملفات محدثة
- ✅ 51 ملف توثيق إجمالي
- ✅ 120+ مثال عملي جديد

**📖 راجع:** [`PACKAGES-INDEX.md`](./PACKAGES-INDEX.md) للتفاصيل الكاملة

---

## 📊 تصنيف القواعد

### 🔴 Priority 1: CRITICAL
**يجب تطبيقها في جميع المشاريع**

- Null Safety
- Error Handling
- Code Style (Naming Conventions)
- Widget Immutability
- Async/Await
- Basic Testing

### 🟡 Priority 2: HIGH
**موصى بها بشدة**

- State Management (Built-in)
- Navigation (go_router)
- Material 3 Theming
- JSON Serialization
- Performance Best Practices
- Widget Testing

### 🟢 Priority 3: MEDIUM
**مفيدة للمشاريع المتوسطة/الكبيرة**

- MVVM Architecture
- Feature-based Organization
- ThemeExtension
- Isolates for Heavy Tasks
- Integration Testing
- Code Generation

### 🔵 Priority 4: LOW
**اختيارية - لحالات خاصة**

- Custom Typography
- Advanced Accessibility
- Performance Profiling
- CI/CD Integration
- Documentation Standards

---

## 📋 الملفات الرئيسية

### 1. `GETTING-STARTED.md` 🚀 **← NEW!**
**دليل البداية الشامل - ابدأ من هنا!**
- دمج دليل المبتدئين + الأمثلة السريعة
- 10 أمثلة عملية جاهزة للنسخ
- مسارات تعلم واضحة (مبتدئ/متوسط/محترف)
- أمثلة مشاريع كاملة (To-Do, E-commerce, Social Media)
- FAQ شامل
- كل ما تحتاجه للبدء الفوري!

### 2. `WINDSURF-USAGE-GUIDE.md` 🎯
**دليل الاستخدام مع Windsurf/Claude**
- كيف يعمل النظام مع AI Agents
- الإعداد الأولي خطوة بخطوة
- طرق الاستخدام المختلفة
- أمثلة عملية واقعية
- أفضل الممارسات

### 3. `DECISION-GUIDE.md` 🧭
**دليل اتخاذ القرارات**
- أي state management تستخدم؟
- أي architecture تختار؟
- أي navigation solution؟
- Decision trees تفاعلية

### 4. `rules-config.yaml` ⚙️
**ملف التكوين الرئيسي**
- تفعيل/تعطيل القواعد
- 4 Profiles جاهزة (Small/Medium/Large/MVP)
- تخصيص كامل حسب احتياجك

### 5. `docs/INDEX.md` 📑
**فهرس كامل للتوثيق (51 ملف - محدث 2025-10-22)**
- تصنيف حسب الأولوية (CRITICAL → LOW)
- روابط مباشرة لكل ملف
- تغطية شاملة لكل جوانب Flutter
- 9 ملفات جديدة + 29 مكتبة موثقة

### 6. `CHANGELOG.md` 📝 **← NEW!**
**سجل التغييرات والتحديثات**
- Version 2.0.0: Reorganization
- Version 1.5.0: All packages updated
- Version 1.0.0: Initial release

### 7. `AI-AGENT-INTEGRATION.md` 🤖
**دليل التكامل مع AI Agents**
- كيف يقرأ Windsurf القواعد
- Best practices للتفاعل
- Metadata structure

---

## 💡 حالات استخدام شائعة

### 🟢 مشروع صغير (Small Project)

```yaml
# مثال: تطبيق To-Do بسيط
profiles:
  small_project:
    enabled: true

state_management:
  primary: built-in

navigation:
  router: navigator

architecture:
  enabled: false  # غير ضروري

testing:
  unit_tests:
    min_coverage: 60
```

**البنية:**
```
lib/
├── main.dart
├── models/
├── screens/
└── services/
```

---

### 🟡 مشروع متوسط (Medium Project)

```yaml
# مثال: تطبيق E-commerce
profiles:
  medium_project:
    enabled: true

state_management:
  primary: built-in  # أو provider

navigation:
  router: go_router

architecture:
  pattern: layered
  
testing:
  unit_tests:
    min_coverage: 75
  integration_tests:
    enabled: true
```

**البنية:**
```
lib/
├── presentation/
├── domain/
├── data/
└── core/
```

---

### 🔴 مشروع كبير (Large Project)

```yaml
# مثال: Social Media App
profiles:
  large_project:
    enabled: true

state_management:
  primary: bloc  # أو riverpod

navigation:
  router: go_router
  go_router:
    typed_routes: true

architecture:
  pattern: feature-based
  clean_architecture:
    enabled: true
    
testing:
  unit_tests:
    min_coverage: 85
  golden_tests:
    enabled: true
```

**البنية:**
```
lib/
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── feed/
│   └── chat/
└── core/
```

---

## 🔄 State Management - متى تستخدم أي حل؟

### Built-in Solutions ✅ الأفضل للبداية

```dart
// ValueNotifier - للقيم البسيطة
final counter = ValueNotifier<int>(0);

// ChangeNotifier - للحالات المعقدة قليلاً
class CartModel extends ChangeNotifier {
  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }
}
```

**استخدمه إذا:**
- ✅ مشروع صغير/متوسط
- ✅ حالة بسيطة
- ✅ لا تحتاج DI معقد

---

### Provider 📦 للمشاريع المتوسطة

```dart
// سهل الاستخدام
Provider.of<CartModel>(context)
context.watch<CartModel>()
```

**استخدمه إذا:**
- ✅ تحتاج dependency injection
- ✅ حالة مشتركة بين عدة screens
- ✅ فريق صغير (2-5)

---

### Bloc 🏗️ للمشاريع الكبيرة

```dart
// فصل واضح بين UI و Logic
BlocProvider(
  create: (context) => CounterBloc(),
  child: CounterPage(),
)
```

**استخدمه إذا:**
- ✅ مشروع كبير ومعقد
- ✅ فريق كبير (5+)
- ✅ تحتاج testability قوي
- ✅ حالة معقدة جداً

---

### Riverpod 🚀 بديل حديث

```dart
// Compile-safe, no BuildContext needed
final counterProvider = StateProvider((ref) => 0);
final count = ref.watch(counterProvider);
```

**استخدمه إذا:**
- ✅ تريد أفضل من Provider
- ✅ Compile-time safety مهم
- ✅ مشروع جديد

---

## 🧭 Navigation - go_router vs Navigator

### Navigator - للمشاريع الصغيرة

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetailsPage()),
);
```

**مميزات:**
- ✅ بسيط وسهل
- ✅ مثالي للـ dialogs

**عيوب:**
- ❌ لا يدعم deep linking
- ❌ محدود للويب

---

### GoRouter - للمشاريع المتوسطة/الكبيرة

```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'details/:id',
          builder: (context, state) => 
            DetailsPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

// الاستخدام
context.go('/details/123');
```

**مميزات:**
- ✅ Deep linking
- ✅ Web support ممتاز
- ✅ Type-safe navigation
- ✅ Authentication guards

**عيوب:**
- ⚠️ Learning curve أعلى

---

## ✅ Testing Strategy

### الأولويات

```yaml
1. Unit Tests (80% من الجهد)
   - Business logic
   - Models & Entities
   - Repositories
   - Services
   
2. Widget Tests (15% من الجهد)
   - Critical screens
   - Complex widgets
   - User interactions
   
3. Integration Tests (5% من الجهد)
   - Critical user flows
   - End-to-end scenarios
```

### لا تختبر

- ❌ Generated code (*.g.dart)
- ❌ Simple getters/setters
- ❌ UI-only widgets
- ❌ Third-party packages

### مثال

```dart
// Unit Test
test('Counter increments', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, 1);
});

// Widget Test
testWidgets('Button tap increments counter', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('0'), findsOneWidget);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('1'), findsOneWidget);
});
```

---

## 🎨 UI Best Practices

### Material 3 Theming

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
    ),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,
)
```

### Responsive Design

```dart
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
```

### تجنب Overflow

```dart
// ✅ صحيح
Row(
  children: [
    Expanded(child: Text('Long text...')),
    Icon(Icons.star),
  ],
)

// ❌ خطأ
Row(
  children: [
    Text('Very very long text...'), // Overflow!
    Icon(Icons.star),
  ],
)
```

---

## 🔒 Security Best Practices

### API Keys

```dart
// ❌ خطأ - لا تفعل هذا
const apiKey = "sk_live_12345...";

// ✅ صحيح - استخدم dart-define
flutter run --dart-define=API_KEY=sk_live_12345

// في الكود
const apiKey = String.fromEnvironment('API_KEY');
```

### Secure Storage

```dart
// للـ tokens و sensitive data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
final token = await storage.read(key: 'token');
```

---

## 📈 Performance Tips

### Const Constructors

```dart
// ✅ استخدم const عندما يكون ممكناً
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.home)

// يقلل rebuilds ويحسن الأداء
```

### ListView.builder

```dart
// ✅ للقوائم الطويلة
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ للقوائم القصيرة فقط
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### Isolates للعمليات الثقيلة

```dart
// ✅ استخدم compute للعمليات الثقيلة
final result = await compute(parseHugeJson, jsonString);

// بدلاً من
// final result = parseHugeJson(jsonString); // يعلق UI
```

---

## 🛠️ Development Tools

### Linting

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    always_use_package_imports: true
    avoid_print: true
    prefer_single_quotes: true
```

### Code Generation

```bash
# JSON serialization, freezed, etc.
dart run build_runner build --delete-conflicting-outputs

# Watch mode للتطوير
dart run build_runner watch
```

### Formatting

```bash
# Format all files
dart format .

# Check formatting
dart format --set-exit-if-changed .
```

---

## ❓ أسئلة شائعة

### متى أستخدم StatelessWidget vs StatefulWidget؟

```dart
// StatelessWidget - عندما لا تتغير الـ state
class MyWidget extends StatelessWidget {
  final String title;
  const MyWidget({required this.title});
  
  @override
  Widget build(BuildContext context) => Text(title);
}

// StatefulWidget - عندما تتغير الـ state
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  
  @override
  Widget build(BuildContext context) => Text('$count');
}
```

### كيف أتعامل مع Async في Flutter؟

```dart
// Future - عملية واحدة
Future<User> fetchUser() async {
  final response = await http.get(url);
  return User.fromJson(jsonDecode(response.body));
}

// FutureBuilder - في UI
FutureBuilder<User>(
  future: fetchUser(),
  builder: (context, snapshot) {
    if (snapshot.hasData) return UserWidget(snapshot.data!);
    if (snapshot.hasError) return ErrorWidget(snapshot.error);
    return CircularProgressIndicator();
  },
)

// Stream - سلسلة من الأحداث
Stream<int> countStream() async* {
  for (int i = 0; i < 10; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// StreamBuilder - في UI
StreamBuilder<int>(
  stream: countStream(),
  builder: (context, snapshot) => Text('${snapshot.data ?? 0}'),
)
```

---

## 🗺️ Roadmap

### ✅ المكتمل (v1.0) - 100% COMPLETE! 🎉
- [x] تحليل القواعد الأصلية
- [x] بنية معيارية (Modular Structure)
- [x] ملف configuration شامل
- [x] دليل البداية السريع
- [x] أمثلة عملية
- [x] **تقسيم القواعد إلى 49 ملف منفصل** ✅
- [x] **دليل استخدام Windsurf/Claude** ✅
- [x] **أمثلة سريعة جاهزة** ✅
- [x] **توثيق شامل لكل فئة** ✅
- [x] **AI Agent Integration كامل** ✅

### 📋 المخطط (v2.0)
- [ ] قوالب مشاريع جاهزة (templates/)
- [ ] أمثلة تطبيقات كاملة
- [ ] CLI Tool للتكوين
- [ ] VS Code Extension
- [ ] Auto-linting based on config
- [ ] Project scaffolding tool
- [ ] MCP Server integration
- [ ] Documentation website

---

## 🤝 المساهمة

نرحب بالمساهمات! يمكنك:

1. **إضافة قواعد جديدة**
   ```yaml
   custom:
     additional_rules:
       - name: "your_rule"
         description: "..."
   ```

2. **مشاركة Profiles**
   - أنشئ profile مخصص لنوع مشروعك
   - شارك التجربة والدروس المستفادة

3. **تحسين التوثيق**
   - أضف أمثلة
   - ترجمة
   - توضيح نقاط غامضة

4. **اقتراح تحسينات**
   - فتح issue
   - مناقشة في Discussions

---

## 📚 موارد إضافية

### التوثيق الرسمي
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/effective-dart)

### State Management
- [Built-in State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
- [Provider Package](https://pub.dev/packages/provider)
- [Bloc Library](https://bloclibrary.dev/)
- [Riverpod](https://riverpod.dev/)

### Architecture
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Very Good Architecture](https://verygood.ventures/blog/very-good-flutter-architecture)

### Design
- [Material 3 Guidelines](https://m3.material.io/)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

---

## 📄 الترخيص

هذا المشروع مفتوح المصدر ومتاح للاستخدام الحر.

---

## 📞 الاتصال

هل لديك أسئلة أو اقتراحات؟
- افتح issue في المشروع
- شارك تجربتك
- ساهم في التحسين

---

**آخر تحديث:** 2025-10-22  
**الإصدار:** 2.0.0 - Major Documentation Update  
**الحالة:** ✅ 100% جاهز للاستخدام  
**التوثيق:** 51 ملف (+9 جديد)  
**المكتبات:** 29 package موثقة  
**المحتوى:** ~5,000 سطر جديد + 120+ مثال

</div>

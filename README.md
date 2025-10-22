# 🚀 Flutter/Dart Rules - Remote Documentation System

<div dir="rtl">

## 🎯 ما هذا المشروع؟

**نظام توثيق شامل ومتقدم** لأفضل ممارسات Flutter/Dart، مصمم للعمل **عن بُعد** مع AI Agents بدون الحاجة لنسخ الملفات!

### ✨ الثورة الجديدة - Remote Rules!

**المشكلة القديمة:**
- ❌ نسخ 56 ملف لكل مشروع
- ❌ Updates صعبة
- ❌ ملفات كتير مش محتاجها

**الحل الجديد:**
- ✅ **ملف واحد صغير فقط!** (.cascade/rules-manifest.yaml)
- ✅ **AI يقرأ من GitHub مباشرة** 🌐
- ✅ **اختار بس اللي محتاجه** (cherry-pick)
- ✅ **Updates تلقائية**
- ✅ **Customization سهل**

### 🎁 المميزات

- ✅ **Remote-First:** لا داعي لنسخ الملفات
- ✅ **Context-Aware:** AI يقرأ بس اللي محتاجه
- ✅ **Templates جاهزة:** Minimal, Standard, Full
- ✅ **17 مكتبة موثقة** (94% coverage)
- ✅ **56 ملف توثيق شامل**
- ✅ **150+ مثال عملي**
- ✅ **Setup في 3 دقائق**

---

## 📂 بنية المشروع الجديدة

```
flutter_agent_rules/  (على GitHub)
│
├── 📄 README.md                     # 👈 أنت هنا
├── 📄 REMOTE-USAGE.md               # 🌐 دليل الاستخدام عن بُعد
├── 📄 AI-INTEGRATION.md             # 🤖 دليل AI Agents
├── 📄 SESSION-COMPLETE.md           # 📊 ملخص شامل
│
├── 📁 templates/                    # 🎨 Templates للمشاريع
│   ├── manifest-minimal.yaml        #   للمشاريع الصغيرة
│   ├── manifest-standard.yaml       #   للمشاريع المتوسطة ⭐
│   └── manifest-full.yaml           #   للمشاريع الكبيرة
│
├── 📁 tools/                        # 🛠️ Scripts للـ Setup
│   ├── setup.sh                     #   للـ Linux/Mac
│   └── setup.ps1                    #   للـ Windows
│
└── 📁 docs/                         # 📚 56 ملف توثيق
    ├── INDEX.md                     #   📑 الفهرس الرئيسي
    ├── state-management/            #   6 مكتبات
    ├── navigation/                  #   5 مكتبات
    ├── data/                        #   6 مكتبات
    ├── architecture/                #   5 ملفات
    ├── ui/                          #   6 ملفات
    └── ...                          #   والمزيد

═══════════════════════════════════════════════

your_project/  (مشروعك - ملف واحد فقط!)
│
└── 📁 .cascade/
    ├── rules-manifest.yaml          # ← ملف واحد صغير!
    ├── cache/                       #   (auto-generated)
    └── overrides/                   #   (optional)
```

---

## 🚀 البداية السريعة (3 دقائق)

### **Option 1: باستخدام Setup Script** ⭐ (الأسهل)

```bash
# Linux/Mac
curl -s https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/tools/setup.sh | bash

# Windows (PowerShell)
iwr https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/tools/setup.ps1 | iex
```

**هيعمل:**
- ✅ ينشئ `.cascade` folder
- ✅ ينزل manifest template المناسب
- ✅ يجهزك للاستخدام فوراً

---

### **Option 2: Manual Setup** (بسيطة)

```bash
# 1. Create folder
mkdir -p .cascade/cache .cascade/overrides

# 2. Download template (اختر واحد)
# Minimal (small projects)
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-minimal.yaml

# Standard (recommended) ⭐
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml

# Full (enterprise)
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-full.yaml

# 3. Customize (optional)
code .cascade/rules-manifest.yaml

# 4. Done! AI will read from GitHub automatically 🚀
```

---

### **Option 3: من داخل مشروعك**

```bash
# في مجلد المشروع
cd your_flutter_project

# نفّذ أحد الـ scripts أعلاه
# AI agents ستقرأ تلقائياً من GitHub!
```

---

## ✨ الإصدار الجديد 4.0.0 - Remote Rules System! 🚀

### 🎉 **الثورة الكبرى:** نظام Remote Documentation

**ما الجديد:**
- 🌐 **Remote-First:** AI يقرأ من GitHub مباشرة
- 📦 **Zero Installation:** ملف واحد فقط بدل 56 ملف!
- 🎨 **3 Templates:** Minimal, Standard, Full
- ⚡ **Setup في 3 دقائق**
- 🔄 **Auto-Updates:** دائماً محدث من GitHub
- 🎯 **Cherry-Pick:** اختار بس اللي محتاجه
- ✅ **Custom Overrides:** سهل جداً

### 📊 الإحصائيات:

```yaml
المكتبات الموثقة: 17 / 18 (94%)
الملفات: 56 ملف توثيق
الأمثلة: 150+ مثال عملي
السطور: ~55,000+ سطر
Setup Time: 3 دقائق ⚡
```

### 🔥 المكتبات المضافة مؤخراً:

1. **go_router_builder** - Type-safe routing
2. **GetX** - All-in-one solution
3. **AutoRoute** - Advanced routing with code gen
4. **dart_mappable** - Better than json_serializable (أسرع 2-3x)
5. **ObjectBox** - Fastest database (أسرع 10x من Hive)

### 📚 الملفات الجديدة:

- ✅ `REMOTE-USAGE.md` - دليل الاستخدام الشامل
- ✅ `AI-INTEGRATION.md` - دليل AI Agents
- ✅ `SESSION-COMPLETE.md` - ملخص كامل
- ✅ `templates/` - 3 templates جاهزة
- ✅ `tools/setup.sh` - Setup script
- ✅ `tools/setup.ps1` - Setup for Windows

**📖 التفاصيل الكاملة:** [`SESSION-COMPLETE.md`](./SESSION-COMPLETE.md)

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

### 1. `REMOTE-USAGE.md` 🌐 **← للمطورين!**
**دليل الاستخدام الشامل**
- كيف يعمل Remote Rules System
- Quick Start (3 دقائق)
- اختيار Template المناسب
- Cherry-picking features
- Custom overrides
- أمثلة واقعية (Startup, SaaS, Banking)
- FAQ كامل

### 2. `AI-INTEGRATION.md` 🤖 **← للـ AI Agents!**
**دليل AI Agents الكامل**
- كيف يقرأ AI الـ manifest
- Fetching من GitHub
- Caching strategy
- Context detection
- Decision trees
- Implementation examples
- Best practices

### 3. `SESSION-COMPLETE.md` 📊 **← الملخص الشامل!**
**تقرير المشروع الكامل**
- ما تم إنجازه (17 مكتبة، 56 ملف)
- الإحصائيات (94% coverage)
- المكتبات الجديدة (GetX, AutoRoute, dart_mappable, ObjectBox)
- الـ checklist
- النتيجة النهائية

### 4. `templates/` 🎨 **← Templates جاهزة!**
**3 Templates للمشاريع**
- `manifest-minimal.yaml` - Small projects
- `manifest-standard.yaml` - Medium projects ⭐
- `manifest-full.yaml` - Enterprise projects

### 5. `tools/` 🛠️ **← Setup Scripts!**
**Scripts للـ Setup السريع**
- `setup.sh` - للـ Linux/Mac
- `setup.ps1` - للـ Windows
- Setup في 3 دقائق!

### 6. `docs/INDEX.md` 📑
**فهرس التوثيق (56 ملف)**
- 17 مكتبة موثقة (94%)
- تصنيف حسب Category
- روابط مباشرة
- Priority levels

### 7. `ORGANIZATION-PLAN.md` 📊
**خطة التنظيم والحالة**
- حالة كل مكتبة
- إصدارات محدثة
- خطة المستقبل

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

**آخر تحديث:** 2025-10-22 22:30  
**الإصدار:** 4.0.0 - Remote Rules System Revolution! 🚀  
**الحالة:** ✅ Production Ready  
**التوثيق:** 56 ملف | 17 مكتبة (94%)  
**Setup Time:** 3 دقائق ⚡  
**الميزة الجديدة:** Remote-First - لا داعي لنسخ الملفات! 🌐

---

## 🎯 الخلاصة

```yaml
═══════════════════════════════════════════════
         ✅ Flutter/Dart Rules v4.0.0
═══════════════════════════════════════════════

النظام: Remote Documentation System
Setup: ملف واحد فقط (.cascade/rules-manifest.yaml)
AI: يقرأ من GitHub مباشرة
المكتبات: 17 موثقة (94%)
التوثيق: 56 ملف | 150+ مثال
الوقت: 3 دقائق للـ setup

════════════════════════════════════════════════
       🚀 Zero Installation - Always Updated
════════════════════════════════════════════════
```

**ابدأ الآن:**
1. 📖 اقرأ [`REMOTE-USAGE.md`](./REMOTE-USAGE.md)
2. ⚡ نفذ setup script
3. 🎨 اختر template
4. ✅ ابدأ التطوير!

**للـ AI Agents:**
📖 اقرأ [`AI-INTEGRATION.md`](./AI-INTEGRATION.md) أولاً

</div>

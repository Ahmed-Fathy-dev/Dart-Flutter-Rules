# 🚀 دليل البداية الشامل - Flutter/Dart Rules

## 📋 جدول المحتويات
1. [نظرة عامة](#overview)
2. [البداية السريعة](#quick-start)
3. [أمثلة عملية فورية](#quick-examples)
4. [اختيار الإعدادات المناسبة](#choosing-settings)
5. [أمثلة مشاريع كاملة](#project-examples)
6. [الأسئلة الشائعة](#faq)

---

## 🎯 نظرة عامة {#overview}

### ما هذا النظام؟

نظام شامل لأفضل ممارسات Flutter/Dart محسّن للعمل مع AI Agents (Windsurf + Claude).

### ماذا يوفر لك؟
- ✅ **49 ملف توثيق شامل** - كل جوانب Flutter
- ✅ **قواعد منظمة** - مصنفة حسب الأهمية (CRITICAL → LOW)
- ✅ **إعدادات جاهزة** - Profiles حسب حجم المشروع
- ✅ **محدّث دائماً** - آخر إصدارات المكتبات (2025)
- ✅ **مُحسّن للـ AI** - يعمل مباشرة مع Windsurf/Claude

### البنية الأساسية

```
flutter-rules/
├── START-HERE.md                  # نقطة الانطلاق
├── GETTING-STARTED.md             # 👈 أنت هنا
├── WINDSURF-USAGE-GUIDE.md        # دليل Windsurf/Claude
├── rules-config.yaml               # ملف التكوين الرئيسي
│
├── docs/                          # 49 ملف توثيق
│   ├── INDEX.md                   # الفهرس الكامل
│   ├── core/                      # القواعد الأساسية
│   ├── state-management/          # إدارة الحالة
│   ├── architecture/              # البنية المعمارية
│   └── ... و 7 فئات أخرى
│
└── archive/                       # ملفات مرجعية قديمة
```

---

## ⚡ البداية السريعة (3 خطوات) {#quick-start}

### **الخطوة 1: حدد نوع مشروعك**

اختر الـ Profile المناسب في `rules-config.yaml`:

```yaml
profiles:
  small_project:      # مشروع صغير (1-5 شاشات)
    enabled: false
    
  medium_project:     # مشروع متوسط (5-15 شاشة) ✅ موصى به
    enabled: true     # فعّل هذا
    
  large_project:      # مشروع كبير (20+ شاشة)
    enabled: false
    
  mvp:               # MVP سريع
    enabled: false
```

### **الخطوة 2: افتح في Windsurf**

```bash
1. File > Open Folder
2. اختر: d:\Development\agents rules\flutter
3. ✅ Windsurf سيقرأ القواعد تلقائياً
```

### **الخطوة 3: ابدأ التطوير**

افتح chat مع Claude واكتب:

```
مرحباً! أريدك أن تساعدني في تطوير Flutter باتباع نظام القواعد الموجود في هذا المشروع.
ابدأ بقراءة rules-config.yaml لفهم الإعدادات.
```

**🎉 هذا كل شيء! Claude جاهز الآن!**

---

## 🎯 أمثلة عملية فورية {#quick-examples}

### **مثال 1: البداية الأساسية**

#### **الأمر:**
```
مرحباً! لدي نظام قواعد Flutter/Dart شامل.
أريدك أن تتبع القواعد الموجودة في هذا المشروع.
ابدأ بمراجعة rules-config.yaml لفهم الإعدادات.
```

#### **ما سيحدث:**
- ✅ Claude سيقرأ `rules-config.yaml`
- ✅ سيفهم الـ profile المختار
- ✅ سيكون جاهزاً لتطبيق القواعد تلقائياً

---

### **مثال 2: إنشاء Model Class**

#### **الأمر:**
```
أنشئ Product model class مع:
- id (String)
- name (String)
- price (double)
- description (String?)
- imageUrl (String?)
- JSON serialization
- اتبع قواعد null-safety و immutability من النظام
```

#### **النتيجة المتوقعة:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) => 
      _$ProductFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  
  // copyWith for immutability
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
```

---

### **مثال 3: إضافة Repository Pattern**

#### **الأمر:**
```
أنشئ ProductRepository مع:
- Clean Architecture pattern
- Error handling صحيح
- استخدام Dio
- اتبع القواعد من docs/architecture/repository-pattern.md
```

#### **النتيجة المتوقعة:**
```dart
// Domain layer - Abstract repository
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, void>> createProduct(Product product);
}

// Data layer - Implementation
class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;
  
  ProductRepositoryImpl(this._dio);
  
  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final products = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
  
  // ... المزيد
}
```

---

### **مثال 4: State Management مع Riverpod**

#### **الأمر:**
```
أضف Riverpod state management للمنتجات
اتبع best practices من docs/state-management/riverpod.md
```

#### **النتيجة المتوقعة:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for repository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepositoryImpl(dio);
});

// State notifier
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _repository;
  
  ProductsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProducts();
  }
  
  Future<void> loadProducts() async {
    state = const AsyncValue.loading();
    final result = await _repository.getProducts();
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (products) => AsyncValue.data(products),
    );
  }
}

// Provider
final productsProvider = 
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repository);
});
```

---

### **مثال 5: إنشاء UI Screen**

#### **الأمر:**
```
أنشئ ProductListScreen مع:
- استخدام Riverpod للـ state
- Loading, Error, Empty states
- Material 3 design
- اتبع قواعد widget immutability
```

#### **النتيجة المتوقعة:**
```dart
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!)
                    : const Icon(Icons.shopping_bag),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                onTap: () => context.push('/product/${product.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### **مثال 6: إضافة Tests**

#### **الأمر:**
```
أنشئ unit tests للـ ProductRepository
اتبع قواعد docs/testing/unit-testing.md
```

#### **النتيجة المتوقعة:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRepositoryImpl repository;
  late MockDio mockDio;
  
  setUp(() {
    mockDio = MockDio();
    repository = ProductRepositoryImpl(mockDio);
  });
  
  group('ProductRepository', () {
    test('getProducts returns list on success', () async {
      // Arrange
      when(() => mockDio.get('/products')).thenAnswer(
        (_) async => Response(
          data: [
            {'id': '1', 'name': 'Product 1', 'price': 9.99},
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        ),
      );
      
      // Act
      final result = await repository.getProducts();
      
      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should be success'),
        (products) => expect(products.length, 1),
      );
    });
    
    test('getProducts returns failure on error', () async {
      // Arrange
      when(() => mockDio.get('/products')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/products'),
          message: 'Network error',
        ),
      );
      
      // Act
      final result = await repository.getProducts();
      
      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

---

### **مثال 7: Navigation مع GoRouter**

#### **الأمر:**
```
أضف GoRouter navigation
اتبع docs/navigation/go-router.md
```

---

### **مثال 8: مراجعة الكود**

#### **الأمر:**
```
راجع هذا الكود وتأكد من مطابقته للقواعد:

[الصق الكود هنا]

ركز على:
- Null safety
- Error handling  
- Widget immutability
- Best practices
```

---

### **مثال 9: تحسين الأداء**

#### **الأمر:**
```
حلل هذا الـ ListView وحسّنه للأداء
اتبع قواعد docs/performance/list-optimization.md

[الصق الكود]
```

---

### **مثال 10: إضافة Localization**

#### **الأمر:**
```
أضف i18n support للتطبيق
اتبع docs/specialized/internationalization.md
```

---

## 📋 اختيار الإعدادات المناسبة {#choosing-settings}

### **🟢 Small Project (1-5 شاشات)**

**مثال:** To-Do App, Calculator, Weather App

```yaml
profile: small_project

State Management: Provider أو Built-in (setState)
Architecture: Simple (features/ folder)
Navigation: Navigator 1.0
Testing: Unit tests فقط
```

**الملفات المهمة:**
- `docs/core/*` (CRITICAL)
- `docs/state-management/provider.md`
- `docs/testing/unit-testing.md`

---

### **🟡 Medium Project (5-15 شاشة)**

**مثال:** E-commerce, Social Media, Fitness Tracker

```yaml
profile: medium_project

State Management: Riverpod أو Bloc
Architecture: Feature-based
Navigation: GoRouter
Testing: Unit + Widget tests
```

**الملفات المهمة:**
- `docs/core/*` (CRITICAL)
- `docs/state-management/riverpod.md`
- `docs/architecture/feature-based.md`
- `docs/navigation/go-router.md`
- `docs/testing/*`

---

### **🔴 Large Project (20+ شاشة)**

**مثال:** Banking App, Enterprise App, Multi-platform

```yaml
profile: large_project

State Management: Bloc + Riverpod
Architecture: Clean Architecture
Navigation: GoRouter + Deep Linking
Testing: Unit + Widget + Integration
Performance: مهم جداً
Security: CRITICAL
```

**الملفات المهمة:**
- **كل شيء!** - اقرأ جميع الـ CRITICAL و HIGH files

---

### **⚡ MVP (Minimum Viable Product)**

**الهدف:** إطلاق سريع

```yaml
profile: mvp

State Management: Provider (الأسرع)
Architecture: Simple
Navigation: Navigator 1.0
Testing: أساسيات فقط
Focus: السرعة > الكمال
```

**نصيحة:** بعد النجاح، انتقل لـ medium_project تدريجياً

---

## 💡 أمثلة مشاريع كاملة {#project-examples}

### **مثال 1: To-Do App (Small)**

```
الأمر:
أنشئ To-Do app بسيط مع:
- Provider للـ state
- Local storage (SharedPreferences)
- Material 3 design
- اتبع small_project profile
```

### **مثال 2: E-commerce App (Medium)**

```
الأمر:
أنشئ e-commerce app مع:
- Riverpod state management
- Feature-based architecture
- GoRouter navigation
- Dio للـ API calls
- اتبع medium_project profile
```

### **مثال 3: Social Media App (Large)**

```
الأمر:
أنشئ social media app مع:
- Bloc + Riverpod
- Clean Architecture
- Deep linking
- Real-time updates
- اتبع large_project profile
```

---

## ❓ الأسئلة الشائعة {#faq}

### **Q: هل يجب أن أقرأ كل الملفات؟**
```
A: لا! ابدأ بـ CRITICAL files (8 ملفات) فقط
   ثم أضف حسب احتياجك
```

### **Q: أي state management أستخدم؟**
```
A: 
- Small project: Provider أو setState
- Medium project: Riverpod ✅ موصى به
- Large project: Bloc
راجع: docs/state-management/comparison.md
```

### **Q: كيف أعرف أي قواعد أطبق؟**
```
A: استخدم rules-config.yaml profiles
   أو راجع DECISION-GUIDE.md
```

### **Q: الملفات كثيرة! من أين أبدأ؟**
```
A: 
1. اقرأ START-HERE.md (هذا الملف)
2. فعّل profile في rules-config.yaml  
3. جرّب مثال من الأمثلة أعلاه
4. اقرأ الملفات حسب الحاجة
```

### **Q: هل يعمل مع VS Code؟**
```
A: نعم، لكن Windsurf + Claude أفضل
   لأنه مصمم خصيصاً للـ AI Agents
```

### **Q: كيف أحدّث المكتبات؟**
```
A: جميع المكتبات محدّثة لآخر إصدار (2025-10-21)
   راجع archive/version-updates/ للتفاصيل
```

---

## 🎓 مسارات التعلم

### **مسار المبتدئ (ساعة واحدة)**
```
1. ✅ اقرأ هذا الملف
2. ✅ جرّب 3 أمثلة من الأمثلة أعلاه
3. ✅ اقرأ docs/core/null-safety.md
4. ✅ ابدأ مشروع صغير
```

### **مسار المتوسط (3-4 ساعات)**
```
1. ✅ جرّب جميع الأمثلة
2. ✅ راجع CRITICAL files (8 ملفات)
3. ✅ راجع HIGH files (10 ملفات)
4. ✅ طبّق على مشروع متوسط
```

### **مسار المحترف (أسبوع)**
```
1. ✅ اقرأ جميع ملفات docs/
2. ✅ خصّص rules-config.yaml
3. ✅ طبّق على مشروع حقيقي
4. ✅ شارك التجربة
```

---

## 🚀 الخطوة التالية

**اختر واحدة:**

- 🎯 **للاستخدام الفوري:** جرّب مثال من الأمثلة أعلاه
- ⚡ **لمعرفة المزيد:** افتح `WINDSURF-USAGE-GUIDE.md`
- 📚 **للتصفح الشامل:** افتح `docs/INDEX.md`
- ⚙️ **للتخصيص:** عدّل `rules-config.yaml`

---

## 🎁 نصائح إضافية

### **✅ افعل:**
- اذكر "نظام القواعد" في طلباتك لـ Claude
- كن محدداً: "اتبع docs/core/null-safety.md"
- اطلب المراجعة: "راجع حسب القواعد"

### **❌ تجنب:**
- طلبات عامة جداً: "اكتب كود"
- نسيان ذكر القواعد في الطلبات الكبيرة

---

## ❓ أسئلة شائعة (FAQ)

### **Q: هل يجب أن أقرأ كل شيء؟**
```
A: لا! ابدأ بـ CRITICAL files فقط (8 ملفات)
   ثم أضف حسب الحاجة
```

### **Q: كيف أعرف أي قواعد أستخدم؟**
```
A: استخدم rules-config.yaml profiles
   أو اقرأ docs/INDEX.md للتصفح
```

### **Q: هل يعمل مع VS Code؟**
```
A: نعم! لكن Windsurf + Claude أفضل
   لأنه مصمم خصيصاً للـ AI Agents
```

### **Q: ما هي أفضل المكتبات؟**
```
A: راجع ORGANIZATION-PLAN.md للقائمة الكاملة
   - Riverpod للـ state management
   - GoRouter للـ navigation
   - Dio للـ networking
   - json_serializable للـ serialization
```

---

## 📚 موارد إضافية

- **INTEGRATION.md** - دليل التكامل مع AI Agents
- **docs/INDEX.md** - فهرس كامل للتوثيق (52 ملف)
- **ORGANIZATION-PLAN.md** - خطة التنظيم والمكتبات
- **rules-config.yaml** - ملف التكوين
- **archive/** - ملفات مرجعية تاريخية

---

## 🎊 مبروك!

لديك **واحد من أفضل أنظمة توثيق Flutter/Dart!**

**الآن ابدأ واستمتع! 🚀**

---

**آخر تحديث:** 2025-10-22  
**الإصدار:** 3.0.0 - Major Reorganization
**الحالة:** ✅ منظّم وجاهز  
**التحديثات:** 52 ملف | 13 مكتبة محدّثة | ملفات Root منظّمة

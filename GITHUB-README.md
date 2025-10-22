# 📘 Flutter/Dart Rules - Production-Ready Documentation

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Files](https://img.shields.io/badge/files-51-green)
![Packages](https://img.shields.io/badge/packages-29-orange)
![Examples](https://img.shields.io/badge/examples-120%2B-purple)
![Status](https://img.shields.io/badge/status-production--ready-success)

**أشمل نظام قواعد ومعايير Flutter/Dart في العالم العربي**

[🚀 البداية السريعة](#-البداية-السريعة-3-خطوات) • [📚 التوثيق](#-التوثيق) • [📦 المكتبات](#-المكتبات-الموثقة) • [🤖 AI Integration](#-ai-integration)

</div>

---

## 🎯 ما هذا المشروع؟

نظام **شامل ومعياري** لأفضل ممارسات Flutter/Dart، مصمم خصيصاً للعمل مع AI Agents (Windsurf + Claude) ولكن قابل للاستخدام في أي بيئة.

### ✨ المميزات

```yaml
📚 51 ملف توثيق شامل (~35,000 سطر)
📦 29 مكتبة موثقة بالتفصيل
💡 120+ مثال عملي جاهز للاستخدام
⚡ 9 جداول مقارنة للمكتبات
🎯 12+ تطبيق كامل كأمثلة
🤖 محسّن للـ AI Agents (Windsurf/Claude)
⚙️ قابل للتخصيص بالكامل
🚀 جاهز للاستخدام الفوري
```

---

## 🚀 البداية السريعة (3 خطوات)

### **1️⃣ أضف للمشروع**

```bash
cd your-flutter-project/
git submodule add https://github.com/YOUR_USERNAME/flutter_agent_rules .flutter-rules
```

### **2️⃣ Initialize**

```bash
git submodule init
git submodule update
```

### **3️⃣ استخدم مع Windsurf**

```
"اقرأ القواعد من .flutter-rules/ وطبقها على المشروع"
```

✅ **تم! القواعد جاهزة للاستخدام**

📖 **دليل التكامل الكامل:** [`QUICK-INTEGRATION.md`](QUICK-INTEGRATION.md)

---

## 📚 التوثيق

### **📁 البنية**

```
flutter_agent_rules/
├── START-HERE.md                    # 🚀 نقطة البداية
├── QUICK-INTEGRATION.md             # ⚡ دليل التكامل السريع
├── PACKAGES-INDEX.md                # 📦 29 مكتبة موثقة
├── rules-config.yaml                # ⚙️ التكوين الرئيسي
│
├── docs/                            # 📚 51 ملف توثيق
│   ├── INDEX.md                     # 📑 الفهرس الكامل
│   ├── core/                        # القواعد الأساسية (5 ملفات)
│   ├── state-management/            # إدارة الحالة (6 ملفات)
│   ├── data/                        # البيانات (3 ملفات)
│   ├── ui/                          # مكونات UI (2 ملف)
│   ├── specialized/                 # متخصص (7 ملفات)
│   ├── tools/                       # الأدوات (5 ملفات)
│   └── ...                          # 21 ملف إضافي
│
└── INTEGRATION-GUIDE.md             # 🔧 دليل التكامل الشامل
```

### **📖 ملفات البداية**

| الملف | الوصف | متى تستخدمه |
|------|-------|-------------|
| [`START-HERE.md`](START-HERE.md) | نقطة البداية للجميع | أول مرة |
| [`QUICK-INTEGRATION.md`](QUICK-INTEGRATION.md) | التكامل في 5 دقائق | عايز تضيف للمشروع |
| [`PACKAGES-INDEX.md`](PACKAGES-INDEX.md) | دليل المكتبات (29 package) | بتدور على مكتبة |
| [`docs/INDEX.md`](docs/INDEX.md) | فهرس التوثيق الكامل | عايز تتصفح كل شيء |

---

## 📦 المكتبات الموثقة

### **🔴 CRITICAL Packages (4)**

#### **[Talker](docs/tools/logging.md)** `^4.6.4` - Professional Logging
- ✅ In-app logs viewer
- ✅ Dio + Riverpod integration
- ✅ Export/Share logs
- 🎯 **Must-have للـ production**

#### **[ObjectBox](docs/data/local-storage.md)** `^4.3.0` - Ultra-Fast Database
- ⚡ 10x أسرع من Hive
- 🔗 Native relations
- 📊 Real-time queries
- 🎯 **للأداء العالي**

#### **[Envied](docs/specialized/environment-config.md)** `^1.1.0` - Secure Environment
- 🔒 Compile-time obfuscation
- 🎯 Type-safe
- 🌍 Multi-environment
- 🎯 **للأمان**

#### **[dart_mappable](docs/data/json-serialization.md)** `^4.4.0` - JSON Serialization
- ⚡ أسرع من json_serializable
- 🔄 Full polymorphism
- ✅ Built-in copyWith
- 🎯 **بديل متقدم**

### **🟡 HIGH Priority (9 packages)**

- **[Equatable](docs/core/value-equality.md)** `^2.0.7` - Value equality
- **[Flutter Hooks](docs/state-management/hooks.md)** `^0.21.2` - React-style hooks
- **[pretty_dio_logger](docs/data/http-clients.md)** `^1.4.0` - Beautiful HTTP logs
- **[google_fonts](docs/ui/common-packages.md)** `^6.2.1` - 1000+ fonts
- **[flutter_svg](docs/ui/common-packages.md)** `^2.0.17` - SVG support
- والمزيد... (5 مكتبات)

### **🟢 MEDIUM + Specialized (16 packages)**

UI/Utility packages: pinput, toastification, skeletonizer, uuid...  
Specialized: fl_chart, media_kit, pdf, barcode_scan2, webview...

📖 **القائمة الكاملة:** [`PACKAGES-INDEX.md`](PACKAGES-INDEX.md)

---

## 🎨 أمثلة الاستخدام

### **مثال 1: مشروع جديد**

```bash
# 1. أنشئ المشروع
flutter create my_app
cd my_app

# 2. أضف القواعد
git init
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# 3. في Windsurf
"اقرأ .flutter-rules/PACKAGES-INDEX.md واستخدم Talker للـ logging"
```

### **مثال 2: مشروع E-commerce**

```bash
cd ecommerce_app
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# في Windsurf:
"طبق medium_project profile من .flutter-rules/rules-config.yaml
استخدم ObjectBox للـ database و Envied للـ API keys"
```

---

## 🤖 AI Integration

### **مع Windsurf/Claude:**

```
# في بداية أي session:
"اقرأ القواعد من .flutter-rules/ وطبقها على المشروع"

# أمثلة محددة:
"استخدم packages من .flutter-rules/PACKAGES-INDEX.md"
"اتبع state management rules من .flutter-rules/docs/state-management/"
"طبق logging best practices من .flutter-rules/docs/tools/logging.md"
```

### **Auto-load Configuration:**

```json
// .windsurf/settings.json
{
  "rules": {
    "enabled": true,
    "source": ".flutter-rules",
    "autoLoad": true,
    "files": [
      ".flutter-rules/docs/INDEX.md",
      ".flutter-rules/PACKAGES-INDEX.md",
      ".flutter-rules/rules-config.yaml"
    ]
  }
}
```

---

## ⚙️ التخصيص

### **استخدم Profiles:**

```yaml
# rules-config.yaml
profiles:
  small_project:      # 1-5 screens
    enabled: false
    
  medium_project:     # 5-15 screens ✅
    enabled: true
    
  large_project:      # 20+ screens
    enabled: false
```

### **Override محلي:**

```yaml
# .flutter-rules-local.yaml
project:
  name: my_app
  
state_management:
  primary: riverpod
  hooks:
    enabled: true
    
data:
  serialization:
    method: dart_mappable
  local_storage:
    objectbox:
      enabled: true
      
logging:
  talker:
    enabled: true
```

---

## 🔄 التحديث

```bash
# تحديث القواعد لآخر إصدار
git submodule update --remote .flutter-rules
git add .flutter-rules
git commit -m "Update Flutter rules to v3.1.0"
```

---

## 👥 للفرق

### **Clone مع القواعد:**

```bash
# مباشرة مع submodules
git clone --recursive https://github.com/team/your-project

# أو بعد clone عادي
git clone https://github.com/team/your-project
cd your-project
git submodule init
git submodule update
```

### **Auto-update في CI/CD:**

```yaml
# .github/workflows/update-rules.yml
name: Update Flutter Rules
on:
  schedule:
    - cron: '0 0 * * 0'  # أسبوعياً

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true
      - run: git submodule update --remote .flutter-rules
      - uses: peter-evans/create-pull-request@v5
        with:
          title: 'Update Flutter Rules'
```

---

## 📊 الإحصائيات

```yaml
════════════════════════════════════════════════
              Project Statistics
════════════════════════════════════════════════

Documentation:
  Files: 51
  Lines: ~35,000
  Code Examples: 120+
  Comparison Tables: 9
  Real-World Apps: 12+

Packages:
  Total: 29 packages
  CRITICAL/HIGH: 13 packages
  MEDIUM/LOW: 16 packages
  All Latest: 2025-10-22

Quality:
  Technical Accuracy: ⭐⭐⭐⭐⭐
  Code Examples: ⭐⭐⭐⭐⭐
  Documentation: ⭐⭐⭐⭐⭐
  AI Compatibility: ⭐⭐⭐⭐⭐
  
Status: ✅ Production-Ready

════════════════════════════════════════════════
```

---

## 🎯 حالات الاستخدام

| الحالة | الحل الموصى به | الوقت |
|-------|----------------|-------|
| مشروع جديد | Git Submodule | 2 دقيقة |
| مشروع موجود | Git Submodule | 2 دقيقة |
| تطوير محلي | Symlink | 1 دقيقة |
| AI Integration | MCP Server | 5 دقائق |
| فريق كبير | Git Submodule | 2 دقيقة |

---

## 📝 الإصدارات

### **Version 3.0.0 (2025-10-22)** - Current

- ✨ 29 مكتبة جديدة موثقة
- ✨ 9 ملفات توثيق جديدة
- ✨ 120+ مثال عملي
- ✨ Integration guides
- ✨ Production-ready

### **Version 2.0.0 (2025-10-22)**

- 📦 إعادة تنظيم كاملة
- 🗂️ Archive system
- 📝 CHANGELOG added

### **Version 1.5.0 (2025-10-21)**

- 🔄 All packages updated
- 📚 42 ملف توثيق

---

## 🤝 المساهمة

هذا المشروع **مفتوح المصدر** ونرحب بالمساهمات!

### **كيف تساهم:**

1. Fork الريبو
2. أنشئ branch للميزة (`git checkout -b feature/amazing-feature`)
3. Commit تغييراتك (`git commit -m 'Add amazing feature'`)
4. Push للـ branch (`git push origin feature/amazing-feature`)
5. افتح Pull Request

---

## 📄 الترخيص

هذا المشروع مفتوح المصدر ومتاح للاستخدام الحر.

---

## 📞 الدعم

### **الوثائق:**
- [START-HERE.md](START-HERE.md) - البداية
- [INTEGRATION-GUIDE.md](INTEGRATION-GUIDE.md) - دليل التكامل
- [PACKAGES-INDEX.md](PACKAGES-INDEX.md) - المكتبات

### **المشاكل:**
- افتح [Issue](../../issues)
- راجع [FAQ](START-HERE.md#-أسئلة-شائعة)

---

## 🌟 إذا أعجبك المشروع

⭐ ضع نجمة على الريبو  
📢 شاركه مع فريقك  
🤝 ساهم في التطوير  

---

<div align="center">

**Made with ❤️ for Flutter Community**

[![GitHub Stars](https://img.shields.io/github/stars/YOU/flutter_agent_rules?style=social)](https://github.com/YOU/flutter_agent_rules)
[![GitHub Forks](https://img.shields.io/github/forks/YOU/flutter_agent_rules?style=social)](https://github.com/YOU/flutter_agent_rules)

**Version:** 3.0.0 | **Status:** Production-Ready | **Last Update:** 2025-10-22

[🚀 البداية](#-البداية-السريعة-3-خطوات) • [📚 التوثيق](#-التوثيق) • [📦 المكتبات](#-المكتبات-الموثقة)

</div>

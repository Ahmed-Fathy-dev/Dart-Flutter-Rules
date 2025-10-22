# ⚡ دليل التكامل السريع - Quick Integration

**5 دقائق للإعداد!**

---

## 🎯 الهدف

استخدم القواعد في أي مشروع **بدون نقل ملفات**.

---

## ✅ الخطوات (3 خطوات فقط!)

### **1️⃣ رفع على GitHub (مرة واحدة)**

```bash
cd "d:\Development\agents rules\flutter_agent_rules"

# Initialize git (لو مش initialized)
git init

# Add all files
git add .

# Commit
git commit -m "Flutter Rules v3.0.0 - 51 files + 29 packages"

# Create repo على GitHub ثم:
git remote add origin https://github.com/YOUR_USERNAME/flutter_agent_rules
git branch -M main
git push -u origin main
```

✅ **تم! القواعد دلوقتي على GitHub**

---

### **2️⃣ في أي مشروع Flutter**

```bash
cd your-flutter-project/

# Add as submodule (مرة واحدة فقط)
git submodule add https://github.com/YOUR_USERNAME/flutter_agent_rules .flutter-rules

# Commit
git add .gitmodules .flutter-rules
git commit -m "Add Flutter rules"
```

✅ **البنية:**
```
your-flutter-project/
├── lib/
├── .flutter-rules/          ← القواعد هنا!
│   ├── docs/
│   ├── PACKAGES-INDEX.md
│   └── rules-config.yaml
└── pubspec.yaml
```

---

### **3️⃣ استخدم مع Windsurf**

افتح المشروع في Windsurf واكتب:

```
"اقرأ القواعد من .flutter-rules/ وطبقها على المشروع"
```

أو:

```
"استخدم packages من .flutter-rules/PACKAGES-INDEX.md"
"اتبع القواعد في .flutter-rules/docs/INDEX.md"
```

✅ **تم! Windsurf هيقرأ القواعد تلقائياً**

---

## 🔄 التحديث

```bash
# لما تحدث القواعد على GitHub
git submodule update --remote .flutter-rules
git add .flutter-rules
git commit -m "Update rules"
```

---

## 👥 للفريق

```bash
# أي developer جديد بعد clone:
git submodule init
git submodule update

# أو مباشرة:
git clone --recursive https://github.com/team/your-project
```

---

## 🎨 أمثلة سريعة

### **مشروع جديد:**
```bash
flutter create my_app
cd my_app
git init
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules
```

### **مشروع موجود:**
```bash
cd existing-project
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules
git add .gitmodules .flutter-rules
git commit -m "Add rules"
```

---

## 💡 نصائح سريعة

### **1. Create .flutter-rules-local.yaml:**
للـ overrides الخاصة بالمشروع:

```yaml
project:
  name: my_app
  
state_management:
  primary: riverpod
  
data:
  serialization:
    method: dart_mappable
```

### **2. Add to .gitignore:**
```
# .gitignore
.flutter-rules-local.yaml
```

### **3. في Windsurf:**
```
"طبق medium_project profile من .flutter-rules/rules-config.yaml"
"استخدم Talker للـ logging حسب .flutter-rules/docs/tools/logging.md"
```

---

## 📚 الملفات المهمة في .flutter-rules/

```
.flutter-rules/
├── START-HERE.md               ← ابدأ من هنا
├── PACKAGES-INDEX.md          ← 29 مكتبة
├── docs/INDEX.md              ← 51 ملف توثيق
├── rules-config.yaml          ← Configuration
└── INTEGRATION-GUIDE.md       ← دليل شامل
```

---

## ❓ مشاكل شائعة

### **Windsurf مش شايف القواعد؟**
```bash
# تأكد أن الـ submodule initialized:
git submodule init
git submodule update

# ثم أخبر Windsurf:
"اقرأ .flutter-rules/docs/INDEX.md"
```

### **عايز أحدث القواعد؟**
```bash
git submodule update --remote .flutter-rules
```

### **Submodule folder فاضي؟**
```bash
git submodule update --init --recursive
```

---

## 🎊 الخلاصة

```yaml
════════════════════════════════════════════════
              Quick Setup (3 Steps)
════════════════════════════════════════════════

1️⃣ رفع على GitHub (مرة واحدة):
   git push origin main

2️⃣ في كل مشروع (مرة واحدة):
   git submodule add URL .flutter-rules

3️⃣ استخدم مع Windsurf:
   "اقرأ القواعد من .flutter-rules/"

════════════════════════════════════════════════
          ✅ Done! 5 minutes only ✅
════════════════════════════════════════════════
```

---

**للتفاصيل الكاملة:** اقرأ `INTEGRATION-GUIDE.md`

**Date:** 2025-10-22  
**Status:** ✅ Ready to Use

# 🚀 دليل الدمج في المشاريع - Integration Guide

**التاريخ:** 2025-10-22  
**الإصدار:** 1.0.0

---

## 🎯 الهدف

استخدام Flutter Rules في أي مشروع بدون نقل الملفات كل مرة، مع الحفاظ على التحديثات التلقائية.

---

## ✨ الحلول المتاحة

### **🏆 الحل 1: Git Submodule (الأفضل للمشاريع الحالية)**

#### **الإعداد الأولي:**

```bash
# 1. في أي مشروع Flutter
cd your-flutter-project/

# 2. أضف كـ submodule
git submodule add https://github.com/YOUR_USERNAME/flutter_agent_rules .flutter-rules

# 3. Commit التغييرات
git add .gitmodules .flutter-rules
git commit -m "Add Flutter rules as submodule"
```

#### **البنية:**
```
your-flutter-project/
├── lib/
├── test/
├── .flutter-rules/          ← القواعد هنا (submodule)
│   ├── docs/
│   ├── rules-config.yaml
│   ├── PACKAGES-INDEX.md
│   └── ...
├── pubspec.yaml
└── README.md
```

#### **الاستخدام مع Windsurf:**

في بداية أي session مع Windsurf:
```
أنا: "استخدم القواعد الموجودة في .flutter-rules/"

أو:
"اقرأ .flutter-rules/docs/INDEX.md وطبق القواعد"
```

#### **التحديث:**
```bash
# لما تحدث القواعد على GitHub
cd your-flutter-project/
git submodule update --remote .flutter-rules
git add .flutter-rules
git commit -m "Update Flutter rules"
```

#### **للفريق:**
```bash
# أي developer جديد:
git clone --recursive https://github.com/team/your-project
# أو
git clone https://github.com/team/your-project
git submodule init
git submodule update
```

---

### **🎨 الحل 2: Mason Template (للمشاريع الجديدة)**

إنشاء Mason template يولد المشروع مع القواعد مدمجة.

#### **الإعداد:**

```bash
# 1. Install Mason
dart pub global activate mason_cli

# 2. أنشئ template
cd flutter_agent_rules/
mason init

# 3. أنشئ brick
mason new flutter_project_with_rules
```

#### **ملف `mason.yaml`:**
```yaml
name: flutter_project_with_rules
description: Flutter project with integrated rules
version: 1.0.0
vars:
  project_name:
    type: string
    description: Project name
    prompt: What is the project name?
```

#### **الاستخدام:**
```bash
# إنشاء مشروع جديد
mason make flutter_project_with_rules --project_name my_app
```

---

### **🔗 الحل 3: Symlink (للتطوير المحلي)**

ربط رمزي للمجلد في كل مشروع.

#### **Windows (PowerShell as Admin):**
```powershell
cd your-flutter-project/
New-Item -ItemType SymbolicLink -Path ".flutter-rules" -Target "d:\Development\agents rules\flutter_agent_rules"
```

#### **Linux/Mac:**
```bash
cd your-flutter-project/
ln -s ~/Development/flutter_agent_rules .flutter-rules
```

**المميزات:**
- ✅ تحديث فوري (نفس الملفات)
- ✅ لا يحتاج git
- ✅ محلي فقط

**العيوب:**
- ❌ لا يعمل مع الفريق
- ❌ مسار مطلق (ما ينفعش للـ CI/CD)

---

### **📦 الحل 4: NPM Package Style (متقدم)**

إنشاء Dart package للقواعد.

#### **البنية:**
```
flutter_rules_package/
├── lib/
│   └── flutter_rules.dart
├── rules/
│   ├── docs/
│   ├── rules-config.yaml
│   └── ...
└── pubspec.yaml
```

#### **pubspec.yaml:**
```yaml
name: flutter_rules
description: Flutter/Dart coding rules and best practices
version: 3.0.0

environment:
  sdk: ">=3.0.0 <4.0.0"
```

#### **في المشاريع:**
```yaml
dev_dependencies:
  flutter_rules:
    git:
      url: https://github.com/YOUR_USERNAME/flutter_rules_package
      ref: main
```

---

### **🤖 الحل 5: MCP Server (للـ AI Integration)**

إنشاء MCP Server يقرأ القواعد من GitHub مباشرة.

#### **ملف `mcp_config.json`:**
```json
{
  "mcpServers": {
    "flutter-rules": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github",
        "YOUR_USERNAME/flutter_agent_rules"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_TOKEN"
      }
    }
  }
}
```

#### **الاستخدام:**
Windsurf يقرأ القواعد مباشرة من GitHub بدون تحميل.

---

### **⚙️ الحل 6: Config File Reference**

ملف config في كل مشروع يشير للقواعد.

#### **ملف `.flutter-rules-config.yaml`:**
```yaml
flutter_rules:
  version: 3.0.0
  source: https://github.com/YOUR_USERNAME/flutter_agent_rules
  
  # Local copy (if available)
  local_path: .flutter-rules/
  
  # Auto-update
  auto_update: true
  update_frequency: weekly
  
  # Enabled rules
  enabled_profiles:
    - medium_project
  
  # Custom overrides
  overrides:
    state_management:
      primary: riverpod
    testing:
      min_coverage: 80
```

---

## 🎯 الحل الموصى به لكل حالة

### **✅ للمشاريع الحالية:**
```
استخدم: Git Submodule
السبب:
  - سهل الإعداد
  - يعمل مع الفريق
  - تحديثات متزامنة
  - Windsurf يقدر يقرا منه

الأوامر:
  git submodule add URL .flutter-rules
```

### **✅ للمشاريع الجديدة:**
```
استخدم: Mason Template
السبب:
  - one-command setup
  - القواعد مدمجة من البداية
  - customizable

الأوامر:
  mason make flutter_project_with_rules
```

### **✅ للتطوير المحلي:**
```
استخدم: Symlink
السبب:
  - تحديث فوري
  - بدون git overhead
  - سريع

الأوامر:
  New-Item -ItemType SymbolicLink ...
```

### **✅ للـ AI Integration:**
```
استخدم: MCP Server
السبب:
  - قراءة مباشرة من GitHub
  - بدون ملفات محلية
  - always up-to-date

Setup:
  Configure في Windsurf settings
```

---

## 📝 خطوات التنفيذ (خطوة بخطوة)

### **الطريقة الموصى بها (Git Submodule):**

#### **1. رفع على GitHub:**
```bash
cd "d:\Development\agents rules\flutter_agent_rules"
git init
git add .
git commit -m "Initial commit - Flutter Rules v3.0.0"
git remote add origin https://github.com/YOUR_USERNAME/flutter_agent_rules
git push -u origin main
```

#### **2. في أي مشروع Flutter:**
```bash
cd your-flutter-project/
git submodule add https://github.com/YOUR_USERNAME/flutter_agent_rules .flutter-rules
```

#### **3. Configure Windsurf:**

أنشئ ملف `.windsurf/settings.json` في المشروع:
```json
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

#### **4. استخدم في Windsurf:**
```
"اقرأ القواعد من .flutter-rules/docs/INDEX.md وطبقها"
"استخدم packages من .flutter-rules/PACKAGES-INDEX.md"
"اتبع rules-config من .flutter-rules/rules-config.yaml"
```

---

## 🔄 سيناريوهات الاستخدام

### **Scenario 1: مشروع جديد**
```bash
# 1. أنشئ المشروع
flutter create my_app
cd my_app/

# 2. أضف القواعد
git init
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# 3. Configure
cp .flutter-rules/rules-config.yaml .flutter-rules-local.yaml
# عدّل حسب احتياجك

# 4. ابدأ التطوير مع Windsurf
```

### **Scenario 2: مشروع موجود**
```bash
# 1. في المشروع الحالي
cd existing-project/

# 2. أضف كـ submodule
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# 3. اخبر الفريق
git add .gitmodules .flutter-rules
git commit -m "Add Flutter rules"
git push
```

### **Scenario 3: Clone مشروع فيه القواعد**
```bash
# Clone مع الـ submodules
git clone --recursive https://github.com/team/project

# أو بعد Clone عادي
git submodule init
git submodule update
```

### **Scenario 4: تحديث القواعد**
```bash
# لما تحدث القواعد على GitHub
cd your-project/
git submodule update --remote .flutter-rules
git add .flutter-rules
git commit -m "Update Flutter rules to v3.1.0"
```

---

## 🎨 أمثلة عملية

### **مثال 1: مشروع E-commerce**

```bash
# Setup
flutter create ecommerce_app
cd ecommerce_app/
git init
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# Configure for e-commerce
cat > .flutter-rules-local.yaml << EOF
project:
  name: ecommerce_app
  type: mobile
  
state_management:
  primary: riverpod
  
data:
  serialization:
    method: dart_mappable
  local_storage:
    database: objectbox
    
logging:
  package: talker
  
security:
  api_keys:
    envied:
      enabled: true
EOF

# في Windsurf:
# "استخدم القواعد من .flutter-rules/ مع config من .flutter-rules-local.yaml"
```

### **مثال 2: مشروع MVP سريع**

```bash
flutter create mvp_app
cd mvp_app/
git init
git submodule add https://github.com/YOU/flutter_agent_rules .flutter-rules

# Use MVP profile
# في rules-config.yaml فعّل:
profiles:
  mvp:
    enabled: true

# في Windsurf:
# "طبق MVP profile من .flutter-rules/rules-config.yaml"
```

---

## 📚 Documentation في كل مشروع

أنشئ ملف `RULES.md` في كل مشروع:

```markdown
# Project Rules

هذا المشروع يستخدم Flutter/Dart Rules من:
https://github.com/YOUR_USERNAME/flutter_agent_rules

## الموقع المحلي
القواعد موجودة في: `.flutter-rules/`

## التحديث
\```bash
git submodule update --remote .flutter-rules
\```

## للفريق الجديد
\```bash
git submodule init
git submodule update
\```

## الاستخدام مع Windsurf
"اقرأ القواعد من .flutter-rules/ وطبقها على المشروع"

## Profile المستخدم
- medium_project (من rules-config.yaml)
- Custom overrides في: .flutter-rules-local.yaml
```

---

## 🔧 نصائح متقدمة

### **1. Auto-update في CI/CD:**
```yaml
# .github/workflows/update-rules.yml
name: Update Flutter Rules
on:
  schedule:
    - cron: '0 0 * * 0'  # أسبوعياً
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true
      
      - name: Update submodule
        run: |
          git submodule update --remote .flutter-rules
          
      - name: Create PR
        uses: peter-evans/create-pull-request@v5
        with:
          title: 'Update Flutter Rules'
          body: 'Auto-update Flutter rules to latest version'
```

### **2. Pre-commit Hook:**
```bash
# .git/hooks/pre-commit
#!/bin/bash
# تأكد أن القواعد محدثة
cd .flutter-rules
git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [ $LOCAL != $REMOTE ]; then
    echo "⚠️  Flutter rules are outdated. Run: git submodule update --remote"
fi
```

### **3. VS Code Tasks:**
```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Update Flutter Rules",
      "type": "shell",
      "command": "git submodule update --remote .flutter-rules",
      "problemMatcher": []
    }
  ]
}
```

---

## ❓ FAQ

### **Q: الـ submodule بياخد مساحة؟**
```
A: لأ، بياخد reference فقط (~1KB)
   الملفات الأصلية على GitHub
```

### **Q: لو حدثت القواعد على GitHub؟**
```
A: في كل مشروع:
   git submodule update --remote .flutter-rules
```

### **Q: الفريق محتاج يعمل إيه؟**
```
A: بعد clone:
   git submodule init
   git submodule update
```

### **Q: ينفع أعدل القواعد محلياً؟**
```
A: أيوه، لكن أحسن:
   - اعمل .flutter-rules-local.yaml للـ overrides
   - أو fork الريبو وعدل فيه
```

### **Q: Windsurf مش شايف القواعد؟**
```
A: اخبره صراحة:
   "اقرأ القواعد من .flutter-rules/"
   أو configure في .windsurf/settings.json
```

---

## 🎊 الخلاصة

```yaml
════════════════════════════════════════════════
         أفضل Setup للاستخدام اليومي
════════════════════════════════════════════════

1. رفع على GitHub ✅
2. في كل مشروع: git submodule add ✅
3. Configure Windsurf ✅
4. تحديث: git submodule update --remote ✅

════════════════════════════════════════════════
         الفوائد:
════════════════════════════════════════════════

✅ مرة واحدة فقط لكل مشروع
✅ تحديثات تلقائية
✅ يعمل مع الفريق
✅ Windsurf يقرا منه مباشرة
✅ لا يأخذ مساحة
✅ Professional workflow

════════════════════════════════════════════════
```

---

**Status:** ✅ Production-Ready  
**Date:** 2025-10-22  
**Version:** 1.0.0

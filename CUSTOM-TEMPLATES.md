# 🎨 Custom Templates Guide

**Create your own Flutter Agent Rules template!**

---

## 🎯 لماذا Custom Templates؟

### **Use Cases:**

1. **مشاريع متخصصة:**
   - Gaming apps
   - IOT apps
   - Desktop apps
   - وغيرها...

2. **متطلبات فريق محددة:**
   - Coding standards خاصة
   - Architecture patterns مختلفة
   - مكتبات داخلية

3. **Industry-specific:**
   - Healthcare
   - Finance/Banking
   - Education
   - E-commerce

4. **Learning/Teaching:**
   - Templates للطلاب
   - Workshops
   - Training programs

---

## 🚀 3 طرق لإنشاء Custom Template

### **Option 1: من داخل Setup Script** ⭐ (الأسهل)

```bash
# عند تشغيل setup
./setup.sh

# اختار Option 4: Custom
Choose a template:
  1) Minimal
  2) Standard
  3) Full
  4) Custom      ← اختار هذا
  5) URL

# هينزل manifest-custom-example.yaml
# عدّله بعد كده!
```

**مميزات:**
- ✅ Guided setup
- ✅ Template جاهز للتعديل
- ✅ كل الخيارات موضحة

---

### **Option 2: من URL مباشر** (مرن جداً)

```bash
# عند تشغيل setup
./setup.sh

# اختار Option 5: URL
Choose a template:
  1) Minimal
  2) Standard
  3) Full
  4) Custom
  5) URL         ← اختار هذا

# أدخل URL
Enter manifest URL: https://your-domain.com/my-template.yaml
```

**مميزات:**
- ✅ استخدام templates من أي مكان
- ✅ مشاركة templates مع الفريق
- ✅ Version control للـ templates

**أمثلة:**
```bash
# من GitHub Gist
https://gist.githubusercontent.com/user/abc123/raw/manifest.yaml

# من repo خاص
https://raw.githubusercontent.com/company/templates/main/flutter-template.yaml

# من server خاص
https://company.com/templates/banking-app.yaml
```

---

### **Option 3: Manual Creation** (التحكم الكامل)

```bash
# 1. Copy example
cp templates/manifest-custom-example.yaml .cascade/rules-manifest.yaml

# 2. Edit it
code .cascade/rules-manifest.yaml

# 3. Customize everything!
```

---

## 📝 كيف تنشئ Custom Template

### **Step 1: ابدأ من Example**

```bash
# نسخ الـ example
curl -o my-template.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-custom-example.yaml
```

### **Step 2: حدد احتياجاتك**

**اسأل نفسك:**
- ما نوع المشروع؟ (Mobile/Web/Desktop)
- أي state management؟
- أي architecture pattern؟
- هل تحتاج database محلي؟
- هل تحتاج offline support؟
- ما المكتبات المهمة؟

### **Step 3: Cherry-Pick Features**

```yaml
# مثال: Gaming App Template
includes:
  state_management:
    - riverpod          # ✅ For game state
    - hooks             # ✅ For animations
  
  navigation:
    - go_router         # ✅ For menus
  
  data:
    - local-storage     # ✅ For save games
  
  # لا تحتاج:
  # - json-serialization (no API calls)
  # - http-clients (offline game)
  # - objectbox (simple storage enough)
```

### **Step 4: اكتب AI Instructions**

```yaml
ai_instructions: |
  Gaming App Template
  
  Project: 2D mobile game with local saves
  
  Architecture:
  - Game state managed by Riverpod
  - Scene-based structure
  - Asset management best practices
  
  State Management:
  - Use Riverpod for game state
  - Use hooks for animations and timers
  - Keep state immutable
  
  Performance:
  - Optimize for 60 FPS
  - Use const widgets
  - Profile regularly
  
  Data:
  - Save games in local storage
  - No network calls (offline game)
```

---

## 🎯 أمثلة واقعية

### **Example 1: E-commerce App**

```yaml
version: 4.0.0
template: ecommerce

includes:
  state_management: [riverpod, hooks]
  navigation: [go_router, go_router_builder_advanced, deep-linking]
  data: [json-serialization, http-clients, local-storage, objectbox]
  architecture: [feature-based]
  ui: [material3-theming, responsive-design, common-packages]
  specialized: [environment-config, logging]

priority:
  - architecture/feature-based
  - state-management/riverpod
  - data/objectbox  # For offline cart
  - navigation/deep-linking  # For marketing

ai_instructions: |
  E-commerce Mobile App
  
  Features:
  - Product catalog (ObjectBox for offline)
  - Shopping cart (Riverpod + local storage)
  - Checkout (GoRouter flows)
  - Deep links for products
  - Push notifications
  
  Architecture:
  - Feature-based (auth, catalog, cart, checkout)
  - Clean separation
  - Offline-first approach
  
  State:
  - Riverpod for cart state
  - AsyncNotifierProvider for API calls
  - Local caching with ObjectBox
```

---

### **Example 2: Banking App**

```yaml
version: 4.0.0
template: banking

includes:
  state_management: [riverpod, bloc]  # Riverpod + Bloc for complex flows
  navigation: [go_router, go_router_builder_advanced]
  data: [json-serialization, http-clients, objectbox]
  architecture: [clean-architecture, feature-based]
  specialized: [environment-config, logging, testing]

priority:
  - architecture/clean-architecture
  - specialized/logging  # Audit trail
  - specialized/testing  # Critical!
  - data/objectbox  # Encrypted storage

ai_instructions: |
  Banking Mobile App - High Security
  
  Security Requirements:
  - No hardcoded secrets (use envied)
  - All API calls logged
  - Encrypted local storage (ObjectBox)
  - Biometric authentication
  
  Architecture:
  - Clean architecture (strict layers)
  - Domain-driven design
  - Feature-based organization
  
  State:
  - Bloc for transaction flows (testability)
  - Riverpod for user session
  
  Testing:
  - 90%+ code coverage required
  - Integration tests for flows
  - Golden tests for UI
```

---

### **Example 3: IOT Dashboard**

```yaml
version: 4.0.0
template: iot_dashboard

includes:
  state_management: [riverpod]
  navigation: [go_router]
  data: [http-clients, local-storage]  # Real-time updates
  ui: [material3-theming, responsive-design, common-packages]
  specialized: [logging]

priority:
  - state-management/riverpod
  - ui/responsive-design  # Desktop + Mobile
  - data/http-clients  # WebSocket support

ai_instructions: |
  IOT Dashboard - Multi-platform
  
  Platforms: Desktop (Windows/Mac/Linux) + Mobile
  
  Features:
  - Real-time device monitoring
  - WebSocket for live updates
  - Charts and graphs
  - Device control
  
  Architecture:
  - Responsive design (desktop-first)
  - Stream-based updates
  
  State:
  - Riverpod with StreamProvider
  - Real-time device state
  
  UI:
  - Desktop-optimized layouts
  - Keyboard shortcuts
  - Mouse interactions
```

---

## 📦 مشاركة Templates مع الفريق

### **Option 1: GitHub Gist**

```bash
# 1. Create gist على GitHub
# 2. Upload your template

# 3. Share URL مع الفريق
https://gist.githubusercontent.com/username/abc123/raw/team-template.yaml

# 4. الفريق يستخدمه:
./setup.sh
# Option 5: URL
# Paste the gist URL
```

---

### **Option 2: Company Repository**

```bash
# 1. أنشئ repo للـ templates
company-templates/
├── flutter-mobile.yaml
├── flutter-web.yaml
└── flutter-desktop.yaml

# 2. الفريق ينزل منه:
./setup.sh
# Option 5: URL
https://raw.githubusercontent.com/company/templates/main/flutter-mobile.yaml
```

---

### **Option 3: Internal Server**

```bash
# Host على server داخلي
https://internal.company.com/templates/flutter.yaml

# Setup
./setup.sh
# Option 5: URL
https://internal.company.com/templates/flutter.yaml
```

---

## ✅ Template Best Practices

### **1. Start Small**
```yaml
# ابدأ بالأساسيات فقط
includes:
  state_management: [riverpod]
  navigation: [go_router]
  architecture: [feature-based]

# أضف بعدين حسب الحاجة
```

### **2. Document Everything**
```yaml
metadata:
  name: "My Template"
  description: "For mobile e-commerce apps"
  author: "Team Name"
  use_case: "Use for customer-facing shopping apps"
  
ai_instructions: |
  Clear instructions here...
  - When to use X
  - How to handle Y
  - Special considerations for Z
```

### **3. Version Control**
```yaml
# في الـ template
version: 4.0.0
template: mytemplate-v1.0  # ← version your templates!
```

### **4. Test Before Sharing**
```bash
# Test في مشروع تجريبي أولاً
flutter create test_app
cd test_app
curl -o .cascade/rules-manifest.yaml YOUR_TEMPLATE_URL
# Test with AI agent
```

---

## 🔧 Template Structure Reference

```yaml
# Required fields
version: 4.0.0
template: custom

remote:
  url: https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules
  branch: main
  repo: https://github.com/Ahmed-Fathy-dev/Dart-Flutter-Rules

# Main configuration
includes:
  state_management: [...]
  navigation: [...]
  data: [...]
  architecture: [...]
  ui: [...]
  core: [...]
  tools: [...]
  specialized: [...]

priority:
  - category/file
  - ...

ai_instructions: |
  ...

# Optional fields
excludes: [...]
cache: {...}
overrides: {...}
advanced: {...}
metadata: {...}
```

---

## 📚 Resources

### **Template Examples:**
- `templates/manifest-minimal.yaml`
- `templates/manifest-standard.yaml`
- `templates/manifest-full.yaml`
- `templates/manifest-custom-example.yaml` ⭐

### **Documentation:**
- `REMOTE-USAGE.md` - كيف يعمل Remote System
- `AI-INTEGRATION.md` - كيف AI يقرأ الـ manifest
- `docs/INDEX.md` - كل الـ docs المتاحة

---

## ❓ FAQ

### **Q: هل أقدر أستخدم أكتر من template؟**
A: لأ، template واحد بس. لكن تقدر تعمل custom template يجمع features من أكتر من template.

### **Q: هل أقدر أغير الـ template بعد ما أبدأ؟**
A: آه، بس edit `.cascade/rules-manifest.yaml` في مشروعك.

### **Q: Custom template فين يتحفظ؟**
A: في 3 أماكن:
- في الـ repo (templates/)
- على server/GitHub
- في مشروعك (.cascade/rules-manifest.yaml)

### **Q: إزاي أشارك template مع الفريق؟**
A: Options:
1. GitHub Gist (public/private)
2. Company repo
3. Internal server
4. Commit في الـ project repo

---

## 🎉 الخلاصة

**Custom Templates = Maximum Flexibility!**

```yaml
═══════════════════════════════════════════════
        🎨 Custom Templates System
═══════════════════════════════════════════════

✅ Create templates لأي use case
✅ Share مع الفريق
✅ Version control
✅ Cherry-pick features
✅ Team-specific standards
✅ Industry requirements

Setup Methods:
  - Script: Option 4 (Custom)
  - Script: Option 5 (URL)
  - Manual: Copy & edit

═══════════════════════════════════════════════
           Your Template, Your Way!
═══════════════════════════════════════════════
```

---

**Happy Templating! 🚀**

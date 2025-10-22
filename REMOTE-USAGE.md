# 🌐 Remote Usage Guide - Flutter Agent Rules

**للمطورين:** دليل شامل لاستخدام Flutter Agent Rules من GitHub مباشرة بدون نسخ الملفات!

---

## 🎯 لماذا Remote Rules؟

### **المشكلة القديمة:**
```
❌ نسخ 56 ملف لكل مشروع
❌ Updates صعبة (لازم تنسخ تاني)
❌ ملفات كتير مش محتاجها
❌ مساحة ضائعة
```

### **الحل الجديد:**
```
✅ ملف واحد صغير فقط! (.cascade/rules-manifest.yaml)
✅ Updates تلقائية من GitHub
✅ اختار بس اللي محتاجه
✅ AI يقرأ من الإنترنت مباشرة
```

---

## 🚀 Quick Start (3 دقائق)

### **Option 1: Using curl (Recommended)**

```bash
# 1. Create .cascade folder
mkdir -p .cascade/cache .cascade/overrides

# 2. Download manifest template
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml

# 3. Edit to customize (optional)
code .cascade/rules-manifest.yaml

# 4. Done! AI will read from GitHub automatically
```

### **Option 2: Manual Setup**

1. Create `.cascade` folder in your project root
2. Copy one of these templates to `.cascade/rules-manifest.yaml`:
   - **minimal**: For small projects
   - **standard**: For medium projects (recommended)
   - **full**: For large enterprise projects
3. Edit the manifest to choose what you need
4. That's it!

---

## 📁 Project Structure

### **Before (Old Way):**
```
your_project/
├── .cascade/
│   └── rules/          # ❌ 56 files copied!
│       ├── docs/
│       ├── core/
│       └── ... (many files)
└── lib/
```

### **After (New Way):**
```
your_project/
├── .cascade/
│   ├── rules-manifest.yaml   # ✅ 1 file only!
│   ├── cache/                # Auto-generated
│   └── overrides/            # Your custom rules (optional)
└── lib/
```

---

## 🎨 Choosing a Template

### **1. Minimal (Small Projects)**

**Use When:**
- Simple app with basic needs
- Learning Flutter
- Prototype or MVP
- No complex features

**Includes:**
- setState for state management
- Basic Navigator
- Basic project structure

**Download:**
```bash
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-minimal.yaml
```

---

### **2. Standard (Medium Projects)** ⭐ RECOMMENDED

**Use When:**
- Production app
- Modern architecture needed
- Team of 2-5 developers
- Typical business app

**Includes:**
- Riverpod (state management)
- GoRouter (navigation)
- JSON serialization
- Feature-based architecture
- Material 3 theming

**Download:**
```bash
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml
```

---

### **3. Full (Enterprise Projects)**

**Use When:**
- Large-scale app
- Multiple teams
- Complex requirements
- High performance needed

**Includes:**
- All state management options
- All navigation options
- Advanced serialization (dart_mappable)
- ObjectBox database
- Clean architecture
- Comprehensive logging

**Download:**
```bash
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-full.yaml
```

---

## ⚙️ Customizing Your Manifest

### **Example: E-commerce App**

```yaml
# .cascade/rules-manifest.yaml

version: 4.0.0
template: custom

remote:
  url: https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules
  branch: main

includes:
  # State Management
  state_management:
    - riverpod          # ✅ For app state
    - hooks             # ✅ For UI optimization
  
  # Navigation
  navigation:
    - go_router                  # ✅ Main routing
    - go_router_builder_advanced # ✅ Type-safe
    - deep-linking               # ✅ For marketing links
  
  # Data
  data:
    - json-serialization # ✅ API responses
    - http-clients       # ✅ Dio for API
    - local-storage      # ✅ Cart caching
    - objectbox          # ✅ Products DB
  
  # Architecture
  architecture:
    - feature-based      # ✅ Feature-first
  
  # UI
  ui:
    - material3-theming      # ✅ Branding
    - responsive-design      # ✅ Mobile + Tablet
    - common-packages        # ✅ Cached images, etc.

priority:
  - architecture/feature-based
  - state-management/riverpod
  - navigation/go_router
  - data/objectbox

ai_instructions: |
  E-commerce app with:
  - Product catalog with caching (ObjectBox)
  - Shopping cart (Riverpod + local storage)
  - Checkout flow (GoRouter)
  - Deep linking for products
  - Offline support
```

---

## 🎯 Cherry-Picking Features

### **Only Need State + Navigation?**

```yaml
includes:
  state_management: [riverpod]
  navigation: [go_router]
  # Skip everything else!

priority:
  - state-management/riverpod
  - navigation/go_router
```

### **Need Multiple State Management Options?**

```yaml
includes:
  state_management:
    - riverpod    # Primary
    - bloc        # For complex flows
    - comparison  # To understand differences
```

### **Skip What You Don't Need:**

```yaml
includes:
  state_management: [riverpod]
  # NO navigation (using basic Navigator)
  # NO database (using API only)
  architecture: [project-structure]
```

---

## 🔧 Custom Overrides

Sometimes you need project-specific rules that override the defaults.

### **1. Enable Overrides:**

```yaml
# In rules-manifest.yaml
overrides:
  enabled: true
  path: .cascade/overrides/
```

### **2. Create Custom Rules:**

```yaml
# .cascade/overrides/custom-rules.yaml

custom_instructions: |
  Project-specific rules:
  
  State Management:
  - Always use AsyncNotifierProvider (never FutureProvider)
  - Use code generation for all providers
  
  Navigation:
  - All routes must have analytics tracking
  - Deep links must validate user auth first
  
  Data:
  - All API calls must include retry logic
  - Cache all GET requests for 5 minutes
  
  Architecture:
  - Each feature must have its own repository
  - No direct API calls from UI layer
```

### **3. Override Specific Recommendations:**

```yaml
# .cascade/overrides/state-overrides.yaml

riverpod_rules:
  code_generation: required     # Override: always use
  providers:
    - type: AsyncNotifierProvider
      when: "dealing with async data"
      avoid: FutureProvider
    - type: NotifierProvider  
      when: "mutable state"
```

---

## 📦 Caching

The system automatically caches docs from GitHub for faster access.

### **How It Works:**

```yaml
cache:
  enabled: true           # Enable caching
  ttl: 86400             # Cache for 24 hours
  path: .cascade/cache/  # Where to store
```

### **Cache Behavior:**

1. **First Request:**
   - Fetches from GitHub
   - Saves to `.cascade/cache/`

2. **Subsequent Requests (within 24h):**
   - Reads from cache (instant!)
   - No network needed

3. **After 24h:**
   - Fetches fresh content from GitHub
   - Updates cache

4. **Offline Mode:**
   - Uses cache even if expired
   - Works offline!

### **Cache Management:**

```bash
# Clear cache (force fresh fetch)
rm -rf .cascade/cache/*

# Disable cache (always fetch fresh)
# Edit .cascade/rules-manifest.yaml:
cache:
  enabled: false
```

---

## 🤖 How AI Agents Use This

### **1. AI Reads Manifest:**
```typescript
const manifest = readYaml('.cascade/rules-manifest.yaml')
```

### **2. AI Fetches Relevant Docs:**
```typescript
// User asks about state management
const riverpodUrl = `${manifest.remote.url}/main/docs/state-management/riverpod.md`
const content = await fetch(riverpodUrl)
```

### **3. AI Uses as Context:**
```typescript
// Apply rules from fetched docs
answerUserQuestion(content)
```

**Result:** AI has fresh, up-to-date knowledge without you copying files!

---

## 📋 Real-World Examples

### **Example 1: Startup MVP**

```yaml
# Fast setup for validation
template: minimal

includes:
  state_management: [built-in]  # setState
  navigation: [navigator]        # Basic
  architecture: [project-structure]

ai_instructions: |
  Keep it simple, ship fast.
  Use basic Flutter features.
  Optimize later.
```

### **Example 2: SaaS Product**

```yaml
# Production-ready modern stack
template: standard

includes:
  state_management: [riverpod, hooks]
  navigation: [go_router, go_router_builder_advanced]
  data: [json-serialization, http-clients, local-storage]
  architecture: [feature-based]
  ui: [material3-theming, responsive-design]
  specialized: [environment-config, logging]

priority:
  - specialized/logging        # Important!
  - state-management/riverpod
  - navigation/go_router
```

### **Example 3: Banking App**

```yaml
# High security & performance
template: full

includes:
  state_management: [riverpod, bloc]  # Riverpod + Bloc
  navigation: [go_router, go_router_builder_advanced]
  data:
    - json-serialization
    - http-clients
    - objectbox              # Offline transactions
  architecture:
    - clean-architecture     # Strict layers
    - feature-based
  specialized:
    - environment-config     # Dev/Prod separation
    - logging                # Audit trail
    - testing                # Comprehensive tests

ai_instructions: |
  Security & compliance first:
  - No hardcoded secrets
  - All API calls must be logged
  - Sensitive data must be encrypted
  - Offline mode for transactions
  - Clean architecture strictly enforced
```

---

## 🔄 Updating Rules

### **Auto-Update (Recommended):**

```yaml
advanced:
  auto_update: true
  update_interval: 86400  # Check daily
```

### **Manual Update:**

Just delete cache and AI will fetch fresh content:
```bash
rm -rf .cascade/cache/*
```

### **Pin to Specific Version:**

```yaml
remote:
  url: https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules
  branch: v4.0.0  # Pin to tag instead of 'main'
```

---

## 🎓 Best Practices

### **✅ DO:**

1. **Start with standard template**
   ```bash
   curl -o .cascade/rules-manifest.yaml \
     .../manifest-standard.yaml
   ```

2. **Cherry-pick what you need**
   ```yaml
   includes:
     state_management: [riverpod]  # Only what you use
   ```

3. **Use custom overrides for project-specific rules**
   ```yaml
   overrides:
     enabled: true
   ```

4. **Set clear priorities**
   ```yaml
   priority:
     - state-management/riverpod
     - navigation/go_router
   ```

5. **Enable caching**
   ```yaml
   cache:
     enabled: true
     ttl: 86400
   ```

### **❌ DON'T:**

1. **Don't include everything**
   ```yaml
   # ❌ Don't do this unless you really need all
   includes:
     state_management: [riverpod, bloc, provider, getx]
   ```

2. **Don't disable caching without reason**
   ```yaml
   # ❌ Slow and wastes bandwidth
   cache:
     enabled: false
   ```

3. **Don't forget to commit manifest**
   ```bash
   git add .cascade/rules-manifest.yaml
   git commit -m "Add Flutter agent rules"
   ```

4. **Don't commit cache**
   ```gitignore
   # .gitignore
   .cascade/cache/
   ```

---

## 🆘 Troubleshooting

### **Problem: AI can't fetch docs**

**Solution:**
```bash
# Check internet connection
ping github.com

# Try fetching manually
curl https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/docs/state-management/riverpod.md

# If works, clear AI cache and retry
rm -rf .cascade/cache/*
```

### **Problem: Outdated content**

**Solution:**
```bash
# Clear cache to force fresh fetch
rm -rf .cascade/cache/*
```

### **Problem: Manifest not found**

**Solution:**
```bash
# Re-download template
curl -o .cascade/rules-manifest.yaml \
  https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml
```

---

## 📚 Reference

### **GitHub Repository:**
https://github.com/Ahmed-Fathy-dev/Dart-Flutter-Rules

### **Templates:**
- https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-minimal.yaml
- https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml
- https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-full.yaml

### **AI Integration Guide:**
https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/AI-INTEGRATION.md

---

## 🎉 Success!

You're now using Flutter Agent Rules remotely! 

**Benefits:**
- ✅ Zero files to copy
- ✅ Always up-to-date
- ✅ Choose only what you need
- ✅ Custom overrides
- ✅ Works offline (with cache)

**Happy coding!** 🚀

---

**Version:** 4.0.0  
**Last Updated:** 2025-10-22  
**Repository:** https://github.com/Ahmed-Fathy-dev/Dart-Flutter-Rules

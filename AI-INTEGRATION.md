# 🤖 AI Agent Integration Guide

**For AI Agents:** Read this file FIRST to understand how to use this documentation system.

---

## 🎯 Quick Start for AI Agents

### **Step 1: Read the Manifest**
```typescript
// 1. Check if manifest exists
const manifestPath = '.cascade/rules-manifest.yaml'
if (exists(manifestPath)) {
  const manifest = readYaml(manifestPath)
} else {
  // No manifest = user hasn't set up yet
  suggestSetup()
}
```

### **Step 2: Fetch Docs from GitHub**
```typescript
// 2. Build URLs from manifest
const baseUrl = manifest.remote.url
const branch = manifest.remote.branch

// Example: Fetch Riverpod docs
const riverpodUrl = `${baseUrl}/${branch}/docs/state-management/riverpod.md`
const content = await fetchWithCache(riverpodUrl, manifest.cache)
```

### **Step 3: Apply Priority**
```typescript
// 3. Read priority docs FIRST
for (const doc of manifest.priority) {
  const url = buildUrl(baseUrl, branch, doc)
  const content = await fetchWithCache(url)
  applyToContext(content)
}
```

---

## 📋 How It Works

### **System Architecture:**

```
User's Project
├── .cascade/
│   ├── rules-manifest.yaml    ← YOU READ THIS FIRST
│   ├── cache/                 ← Cached docs (offline mode)
│   └── overrides/             ← User's custom rules
│
Remote (GitHub)
└── Ahmed-Fathy-dev/Dart-Flutter-Rules
    ├── docs/                  ← YOU FETCH FROM HERE
    │   ├── state-management/
    │   ├── navigation/
    │   └── ...
    └── templates/             ← Templates for setup
```

---

## 🔧 Implementation Details

### **URL Pattern:**
```
https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/docs/{category}/{file}.md
```

### **Example URLs:**
```typescript
const urls = {
  riverpod: 'https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/docs/state-management/riverpod.md',
  goRouter: 'https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/docs/navigation/go-router.md',
  featureBased: 'https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/docs/architecture/feature-based.md',
}
```

### **Caching Logic:**
```typescript
async function fetchWithCache(url: string, cacheConfig: CacheConfig) {
  const cachePath = `${cacheConfig.path}/${hashUrl(url)}.md`
  
  // Check cache
  if (cacheConfig.enabled && exists(cachePath)) {
    const cacheAge = Date.now() - getFileModTime(cachePath)
    if (cacheAge < cacheConfig.ttl * 1000) {
      return readFile(cachePath)  // Use cache
    }
  }
  
  // Fetch from remote
  try {
    const content = await fetch(url)
    if (cacheConfig.enabled) {
      writeFile(cachePath, content)  // Save to cache
    }
    return content
  } catch (error) {
    // Fallback to cache even if expired
    if (exists(cachePath)) {
      return readFile(cachePath)
    }
    throw error
  }
}
```

---

## 📖 Reading Strategy

### **1. Context Detection:**
```typescript
function detectContext(userMessage: string): string[] {
  const contexts = []
  
  // State management keywords
  if (matches(userMessage, ['state', 'riverpod', 'bloc', 'provider'])) {
    contexts.push('state_management')
  }
  
  // Navigation keywords
  if (matches(userMessage, ['navigation', 'routing', 'go_router'])) {
    contexts.push('navigation')
  }
  
  // Data keywords
  if (matches(userMessage, ['json', 'api', 'serialization'])) {
    contexts.push('data')
  }
  
  return contexts
}
```

### **2. Smart Loading:**
```typescript
async function loadRelevantDocs(contexts: string[], manifest: Manifest) {
  const docsToRead = []
  
  for (const context of contexts) {
    // Get docs for this context
    const contextDocs = manifest.includes[context] || []
    
    for (const doc of contextDocs) {
      const url = buildUrl(manifest.remote.url, manifest.remote.branch, context, doc)
      docsToRead.push(url)
    }
  }
  
  // Fetch in parallel
  const contents = await Promise.all(docsToRead.map(fetchWithCache))
  return contents
}
```

### **3. Priority Reading:**
```typescript
async function readWithPriority(manifest: Manifest) {
  // Always read priority docs first
  const priorityDocs = []
  
  for (const docPath of manifest.priority) {
    const [category, file] = docPath.split('/')
    const url = buildUrl(manifest.remote.url, manifest.remote.branch, category, file)
    priorityDocs.push(fetchWithCache(url, manifest.cache))
  }
  
  return await Promise.all(priorityDocs)
}
```

---

## 🎨 Custom Overrides

### **Checking for Overrides:**
```typescript
async function applyOverrides(manifest: Manifest, baseRules: string) {
  if (!manifest.overrides?.enabled) {
    return baseRules  // No overrides
  }
  
  const overridesPath = manifest.overrides.path
  const customRulesPath = `${overridesPath}/custom-rules.yaml`
  
  if (exists(customRulesPath)) {
    const customRules = readYaml(customRulesPath)
    return merge(baseRules, customRules)  // Merge with priority to custom
  }
  
  return baseRules
}
```

---

## 🔍 Decision Tree

```
User asks a question
    ↓
1. Read .cascade/rules-manifest.yaml
    ↓
2. Detect context from question
   - State management?
   - Navigation?
   - Data/API?
   - UI/Design?
    ↓
3. Load relevant docs from GitHub
   - Use URLs from manifest.includes
   - Respect manifest.priority
   - Check cache first
    ↓
4. Check for custom overrides
   - Read .cascade/overrides/ if enabled
    ↓
5. Apply rules to answer
   - Use fetched docs as context
   - Follow custom instructions
    ↓
6. Generate answer
```

---

## 📊 Manifest Structure

```yaml
# Manifest file structure
version: 4.0.0
template: minimal|standard|full

remote:
  url: <github-raw-url>
  branch: main
  repo: <github-repo-url>

includes:
  state_management: [riverpod, bloc, ...]
  navigation: [go_router, ...]
  data: [json-serialization, ...]
  # ... more categories

priority:
  - state-management/riverpod
  - navigation/go_router

ai_instructions: |
  Custom instructions...

cache:
  enabled: true
  ttl: 86400
  path: .cascade/cache/

overrides:
  enabled: true
  path: .cascade/overrides/
```

---

## 🚦 Setup Detection

### **If No Manifest Exists:**
```typescript
if (!exists('.cascade/rules-manifest.yaml')) {
  const suggestion = `
    No Flutter Agent Rules found.
    
    To set up:
    1. Run: curl -o .cascade/rules-manifest.yaml \\
              https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/manifest-standard.yaml
    
    2. Edit .cascade/rules-manifest.yaml to customize
    
    3. I'll automatically read from GitHub!
    
    Templates available:
    - manifest-minimal.yaml (small projects)
    - manifest-standard.yaml (recommended)
    - manifest-full.yaml (enterprise)
  `
  
  return suggestion
}
```

---

## ⚡ Performance Tips

### **1. Parallel Fetching:**
```typescript
// ✅ DO: Fetch in parallel
const docs = await Promise.all([
  fetch(riverpodUrl),
  fetch(goRouterUrl),
  fetch(featureBasedUrl),
])

// ❌ DON'T: Fetch sequentially
const doc1 = await fetch(riverpodUrl)
const doc2 = await fetch(goRouterUrl)
const doc3 = await fetch(featureBasedUrl)
```

### **2. Lazy Loading:**
```typescript
// Only fetch what you need
if (needsStateManagement) {
  fetchDocs(manifest.includes.state_management)
}

if (needsNavigation) {
  fetchDocs(manifest.includes.navigation)
}
```

### **3. Cache Aggressively:**
```typescript
// Cache docs for 24 hours
const ttl = 86400  // seconds

// Only re-fetch if cache expired
if (cacheAge > ttl) {
  refetch()
}
```

---

## 🎯 Best Practices for AI Agents

### **✅ DO:**
1. **Read manifest first** - Always check `.cascade/rules-manifest.yaml`
2. **Use cache** - Respect `cache.enabled` and `cache.ttl`
3. **Follow priority** - Read `manifest.priority` docs first
4. **Apply overrides** - Check `.cascade/overrides/` for custom rules
5. **Context-aware** - Only load relevant docs based on user's question
6. **Offline mode** - Fall back to cache if GitHub is unreachable

### **❌ DON'T:**
1. **Don't fetch all docs** - Only fetch what's needed
2. **Don't ignore cache** - Always check cache first
3. **Don't skip overrides** - User's custom rules are important
4. **Don't hardcode URLs** - Use manifest.remote.url
5. **Don't fail on network errors** - Use cached content as fallback

---

## 🔗 Example Implementation

```typescript
// Full example for Windsurf/Claude
class FlutterAgentRules {
  private manifest: Manifest
  private cache: Map<string, string> = new Map()
  
  async initialize() {
    // 1. Read manifest
    this.manifest = await this.readManifest()
    
    // 2. Read priority docs
    await this.loadPriorityDocs()
  }
  
  async readManifest(): Promise<Manifest> {
    const path = '.cascade/rules-manifest.yaml'
    if (!exists(path)) {
      throw new Error('No manifest found. Run setup first.')
    }
    return readYaml(path)
  }
  
  async loadPriorityDocs() {
    for (const docPath of this.manifest.priority) {
      const url = this.buildUrl(docPath)
      const content = await this.fetchWithCache(url)
      this.cache.set(docPath, content)
    }
  }
  
  async getDocs(context: string): Promise<string[]> {
    const docs = this.manifest.includes[context] || []
    const contents = []
    
    for (const doc of docs) {
      const docPath = `${context}/${doc}`
      
      // Check cache first
      if (this.cache.has(docPath)) {
        contents.push(this.cache.get(docPath))
      } else {
        // Fetch from remote
        const url = this.buildUrl(docPath)
        const content = await this.fetchWithCache(url)
        this.cache.set(docPath, content)
        contents.push(content)
      }
    }
    
    return contents
  }
  
  buildUrl(docPath: string): string {
    const [category, file] = docPath.split('/')
    return `${this.manifest.remote.url}/${this.manifest.remote.branch}/docs/${category}/${file}.md`
  }
  
  async fetchWithCache(url: string): Promise<string> {
    const cacheKey = hashUrl(url)
    const cachePath = `${this.manifest.cache.path}/${cacheKey}.md`
    
    // Check cache
    if (this.manifest.cache.enabled && exists(cachePath)) {
      const cacheAge = Date.now() - getFileModTime(cachePath)
      if (cacheAge < this.manifest.cache.ttl * 1000) {
        return readFile(cachePath)
      }
    }
    
    // Fetch from remote
    try {
      const content = await fetch(url)
      if (this.manifest.cache.enabled) {
        await writeFile(cachePath, content)
      }
      return content
    } catch (error) {
      // Fallback to cache
      if (exists(cachePath)) {
        return readFile(cachePath)
      }
      throw error
    }
  }
}

// Usage
const rules = new FlutterAgentRules()
await rules.initialize()

// When user asks about state management
const stateDocs = await rules.getDocs('state_management')
// Use stateDocs as context for answer
```

---

## 📚 Reference

### **Repository Structure:**
```
Ahmed-Fathy-dev/Dart-Flutter-Rules/
├── docs/
│   ├── state-management/
│   │   ├── riverpod.md
│   │   ├── bloc.md
│   │   └── ...
│   ├── navigation/
│   │   ├── go-router.md
│   │   └── ...
│   ├── data/
│   └── ...
├── templates/
│   ├── manifest-minimal.yaml
│   ├── manifest-standard.yaml
│   └── manifest-full.yaml
└── AI-INTEGRATION.md  ← THIS FILE
```

### **URLs:**
- **Repository:** https://github.com/Ahmed-Fathy-dev/Dart-Flutter-Rules
- **Raw Content:** https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/
- **Templates:** https://raw.githubusercontent.com/Ahmed-Fathy-dev/Dart-Flutter-Rules/main/templates/

---

**Version:** 4.0.0  
**Last Updated:** 2025-10-22  
**For:** Windsurf, Claude, and any AI coding assistant

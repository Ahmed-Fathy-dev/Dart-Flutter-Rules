# 🤖 AI Agent Integration Guide

## For Windsurf + Claude Sonnet 4.5 Thinking

---

## 🎯 Overview

هذا الدليل مخصص لتحسين التواصل بين AI Agents (مثل Windsurf مع Claude Sonnet) وقواعد Flutter/Dart.

---

## 📁 File Structure for AI Agents

### البنية المحسّنة للقراءة الآلية

```
flutter-rules/
├── rules-config.yaml              # ✅ ابدأ هنا - ملف التكوين
├── docs/
│   ├── INDEX.md                   # ✅ خريطة الملفات مع Priority
│   ├── core/                      # 🔴 CRITICAL
│   │   ├── null-safety.md
│   │   ├── error-handling.md
│   │   ├── code-style.md
│   │   └── async-await.md
│   ├── state-management/          # 🟡 HIGH
│   │   ├── comparison.md          # ✅ اقرأ أولاً للمقارنة
│   │   ├── built-in.md
│   │   ├── provider.md
│   │   ├── bloc.md
│   │   └── riverpod.md
│   └── ... (باقي الفئات)
└── templates/                     # قوالب جاهزة
```

---

## 🔄 Workflow للـ AI Agents

### Phase 1: Initial Project Analysis

```yaml
step_1_read_config:
  file: rules-config.yaml
  extract:
    - project.type (mobile/web/desktop)
    - project.team_size
    - enabled profiles
    - state_management.primary
    - navigation.router
    - testing requirements
  
  output:
    - project_context: {type, size, complexity}
    - enabled_rules: [list of enabled features]
    - priority_focus: [CRITICAL, HIGH, MEDIUM, LOW]

step_2_read_index:
  file: docs/INDEX.md
  extract:
    - files by priority
    - tags for each file
    - relationships between rules
  
  output:
    - files_to_read: [ordered by priority]
    - dependencies: {rule: [dependent_rules]}

step_3_read_rules:
  for_each: enabled_rule
  read: docs/{category}/{rule}.md
  extract:
    - metadata (priority, level, tags)
    - best practices
    - code examples
    - common pitfalls
    - ai_agent_guidance sections
  
  output:
    - rules_database: {rule: {practices, examples, checks}}
```

---

### Phase 2: Code Analysis

```yaml
when_analyzing_code:
  step_1_identify_context:
    check:
      - Is this a new file or existing?
      - What's the file type? (widget, model, service, etc.)
      - Which rules apply to this file type?
    
  step_2_apply_rules:
    for_each: applicable_rule
    check:
      - Is rule enabled in config?
      - What's the priority level?
      - Are there violations?
    
    priority_order:
      - CRITICAL first (must fix)
      - HIGH second (should fix)
      - MEDIUM third (nice to fix)
      - LOW last (optional)
  
  step_3_generate_suggestions:
    for_each: violation
    suggest:
      - what: description of issue
      - why: explanation from rules
      - how: code example from docs
      - priority: from metadata
```

---

### Phase 3: Code Generation

```yaml
when_writing_new_code:
  step_1_determine_approach:
    read:
      - rules-config.yaml (what's enabled?)
      - docs/INDEX.md (which patterns to use?)
      - relevant rule files (how to implement?)
    
  step_2_select_patterns:
    state_management:
      if: config.state_management.primary == "built-in"
      use: docs/state-management/built-in.md examples
      
      if: config.state_management.primary == "provider"
      use: docs/state-management/provider.md examples
      
      if: config.state_management.primary == "bloc"
      use: docs/state-management/bloc.md examples
    
    architecture:
      if: config.architecture.pattern == "layered"
      structure: presentation/ domain/ data/
      
      if: config.architecture.pattern == "feature-based"
      structure: features/{feature}/
  
  step_3_generate_code:
    follow:
      - CRITICAL rules (always)
      - HIGH rules (if applicable)
      - patterns from config
      - examples from docs
    
    include:
      - null safety
      - error handling
      - proper naming
      - documentation
```

---

## 📋 Metadata Format in Docs

كل ملف documentation يحتوي على:

```yaml
# في بداية الملف
priority: CRITICAL | HIGH | MEDIUM | LOW
level: ENFORCE | RECOMMENDED | OPTIONAL | GUIDE
category: Core | State Management | Navigation | etc.
applies_to:
  - all_projects
  - mobile_only
  - web_only
  - etc.
ai_agent_tags:
  - tag1
  - tag2
  - tag3
```

### كيف يستخدم AI Agent هذا؟

```python
# Pseudo-code
def should_apply_rule(rule_file, project_config):
    metadata = extract_metadata(rule_file)
    
    # Check priority
    if metadata.priority == "CRITICAL":
        return True  # Always apply
    
    # Check if enabled in config
    if not is_enabled_in_config(rule_file, project_config):
        return False
    
    # Check applicability
    if project_config.type not in metadata.applies_to:
        return False
    
    return True

def get_enforcement_level(rule_file):
    metadata = extract_metadata(rule_file)
    
    if metadata.level == "ENFORCE":
        return "error"  # Must fix
    elif metadata.level == "RECOMMENDED":
        return "warning"  # Should fix
    elif metadata.level == "OPTIONAL":
        return "info"  # Nice to fix
    else:  # GUIDE
        return "suggestion"  # For reference
```

---

## 🎯 AI Agent Sections في الملفات

كل ملف documentation يحتوي على قسم خاص بـ AI Agents:

### Example من null-safety.md

```markdown
## 🤖 AI Agent Integration

### For Windsurf + Claude Sonnet

#### عند قراءة Null Safety Rules:

```yaml
check_for:
  - تأكد أن جميع classes تستخدم non-nullable بشكل افتراضي
  - ابحث عن استخدامات ! غير ضرورية
  - تحقق من late variables بدون initialization
  - افحص nullable collections

suggest:
  - تحويل nullable إلى non-nullable مع default values
  - استخدام ?? بدلاً من !
  - early returns للـ null checks

enforce:
  - لا null في production code بدون سبب واضح
  - توثيق كل nullable field
```

#### Prompt Template:

```markdown
عند مراجعة كود:
1. افحص كل `?` في التعريفات
2. ابحث عن `!` 
3. تحقق من `late`
4. اقترح improvements
```
```

---

## 💬 Communication Patterns

### 1. Pattern: Rule Violation Detection

```markdown
# User asks: "راجع هذا الكود"

AI Agent Process:
1. Read rules-config.yaml
2. Identify enabled rules
3. Read relevant doc files
4. Check code against rules
5. Generate report

Response Format:
```markdown
## 🔍 Code Review Results

### 🔴 Critical Issues (must fix)
- **Null Safety Violation** (line 15)
  - Issue: Using `!` without null check
  - Why: Can cause runtime crash
  - Fix: Use `??` or null check
  - Reference: docs/core/null-safety.md#rule-2

### 🟡 Warnings (should fix)
- **Missing Error Handling** (line 30)
  - Issue: async call without try-catch
  - Why: Unhandled errors will crash
  - Fix: Wrap in try-catch
  - Reference: docs/core/error-handling.md#best-practices

### 💡 Suggestions (nice to have)
- **Consider using const** (line 5)
  - Benefit: Better performance
  - Reference: docs/flutter-basics/performance-basics.md
```

---

### 2. Pattern: Architecture Recommendation

```markdown
# User asks: "أي state management أستخدم؟"

AI Agent Process:
1. Read project info from rules-config.yaml
2. Read docs/state-management/comparison.md
3. Use decision tree
4. Provide recommendation

Response Format:
```markdown
## 🎯 State Management Recommendation

### Project Analysis
- Screens: 12
- Team: 3 developers
- Complexity: Medium

### Decision Tree Result
```
عدد الشاشات: 12 (5-15 range)
حجم الفريق: 3 (small)
→ Recommendation: Built-in or Provider ✅
```

### Detailed Comparison
[Table from comparison.md]

### My Recommendation
**Provider** for the following reasons:
1. Good for 12 screens
2. Team of 3 can learn easily
3. Provides DI when needed
4. Easy to test

### Implementation Guide
[Link to docs/state-management/provider.md]
```

---

### 3. Pattern: Code Generation

```markdown
# User asks: "اعمل counter screen مع bloc"

AI Agent Process:
1. Check rules-config.yaml - is Bloc enabled?
2. Read docs/state-management/bloc.md
3. Extract code examples
4. Generate following best practices
5. Include all required parts

Generated Code:
- events.dart
- state.dart
- bloc.dart
- screen.dart
- tests.dart

All following CRITICAL rules:
- Null safety ✅
- Error handling ✅
- Proper naming ✅
- Documentation ✅
```

---

## 🔍 Advanced Prompts for AI Agents

### Prompt 1: Comprehensive Review

```markdown
## System Prompt for Windsurf/Claude

You are reviewing Flutter/Dart code following these rules:

1. ALWAYS read rules-config.yaml first
2. Identify enabled rules and their priority
3. Read relevant documentation from docs/
4. Check code against:
   - 🔴 CRITICAL rules (must pass)
   - 🟡 HIGH rules (should pass)
   - 🟢 MEDIUM rules (nice to pass)
   - 🔵 LOW rules (optional)

5. For each violation:
   - State the issue clearly
   - Explain why it matters
   - Show example fix from docs
   - Link to relevant documentation

6. Prioritize fixes by:
   - CRITICAL first (blocking)
   - HIGH second (important)
   - MEDIUM third (improvements)
   - LOW last (nice-to-have)

7. Format output as:
   - Section per priority level
   - Clear action items
   - Code examples
   - References to docs
```

---

### Prompt 2: Context-Aware Code Generation

```markdown
## System Prompt for Code Generation

When generating Flutter code:

1. Context Gathering:
   - Read rules-config.yaml
   - Extract: project type, enabled features, patterns
   - Read docs/INDEX.md for relevant files

2. Pattern Selection:
   - State Management: config.state_management.primary
   - Architecture: config.architecture.pattern
   - Navigation: config.navigation.router

3. Code Generation:
   - Follow CRITICAL rules (non-negotiable)
   - Apply HIGH rules (when applicable)
   - Include proper:
     * Null safety
     * Error handling
     * Documentation
     * Tests (if testing.required)

4. Example Sources:
   - Read examples from:
     * docs/core/*.md
     * docs/state-management/{selected}.md
     * docs/architecture/{selected}.md

5. Output Format:
   - Show file structure
   - Generate all necessary files
   - Include imports
   - Add inline comments explaining key decisions
   - Reference rules followed
```

---

### Prompt 3: Migration Assistant

```markdown
## System Prompt for Migration

When helping migrate code:

1. Identify Current State:
   - What pattern is currently used?
   - Which rules are being followed?
   - What's the project size/complexity?

2. Determine Target:
   - Read rules-config.yaml for desired state
   - Read docs/state-management/comparison.md
   - Check migration difficulty

3. Create Migration Plan:
   - Step-by-step approach
   - File-by-file or feature-by-feature
   - Testing strategy

4. For Each Migration Step:
   - Show before code
   - Show after code
   - Explain changes
   - Reference docs

5. Warn About:
   - Breaking changes
   - Required updates
   - Testing requirements
```

---

## 📊 Performance Optimization

### للـ AI Agents

```yaml
optimization_tips:
  caching:
    - Cache rules-config.yaml in memory
    - Cache parsed documentation
    - Cache extracted examples
  
  lazy_loading:
    - Don't read all files upfront
    - Load only relevant categories
    - Load by priority (CRITICAL first)
  
  indexing:
    - Build index from docs/INDEX.md
    - Map tags to files
    - Map categories to rules
  
  parallel_processing:
    - Read multiple doc files in parallel
    - Check multiple rules simultaneously
    - Generate reports concurrently
```

---

## 🎯 Example Integration

### Windsurf Configuration

```json
// .windsurf/rules.json
{
  "flutter_rules": {
    "config_file": "rules-config.yaml",
    "docs_folder": "docs/",
    "index_file": "docs/INDEX.md",
    "priority_order": ["CRITICAL", "HIGH", "MEDIUM", "LOW"],
    "auto_fix": {
      "CRITICAL": true,
      "HIGH": false,
      "MEDIUM": false,
      "LOW": false
    },
    "notification_level": {
      "CRITICAL": "error",
      "HIGH": "warning",
      "MEDIUM": "info",
      "LOW": "hint"
    }
  }
}
```

### Usage in Windsurf

```typescript
// Pseudo-code for Windsurf integration

async function analyzeFlutterCode(file: string) {
  // 1. Load configuration
  const config = await loadYaml('rules-config.yaml');
  const index = await loadMarkdown('docs/INDEX.md');
  
  // 2. Identify applicable rules
  const rules = identifyRules(file, config, index);
  
  // 3. Check each rule
  const violations = [];
  for (const rule of rules) {
    const ruleDoc = await loadMarkdown(`docs/${rule.path}`);
    const checks = extractChecks(ruleDoc);
    
    for (const check of checks) {
      if (!passesCheck(file, check)) {
        violations.push({
          rule: rule.name,
          priority: rule.priority,
          line: check.line,
          message: check.message,
          fix: check.suggestedFix
        });
      }
    }
  }
  
  // 4. Sort by priority
  violations.sort((a, b) => 
    priorityOrder.indexOf(a.priority) - priorityOrder.indexOf(b.priority)
  );
  
  // 5. Return formatted report
  return formatReport(violations);
}
```

---

## ✅ Checklist للـ AI Agent Implementation

```markdown
- [ ] قراءة rules-config.yaml
- [ ] تحديد القواعد المفعلة
- [ ] قراءة docs/INDEX.md
- [ ] تحميل الملفات ذات الأولوية العالية
- [ ] استخراج metadata من كل ملف
- [ ] بناء قاعدة بيانات القواعد
- [ ] تطبيق القواعد حسب الأولوية
- [ ] توليد تقارير واضحة
- [ ] توفير أمثلة من الـ docs
- [ ] ربط كل اقتراح بالمرجع
```

---

## 🚀 Quick Start للـ AI Agents

```markdown
1. First Time Setup:
   ```
   READ: rules-config.yaml
   READ: docs/INDEX.md
   CACHE: file structure and priorities
   ```

2. For Each Request:
   ```
   IDENTIFY: request type (review/generate/migrate)
   LOAD: relevant rule files
   APPLY: rules by priority
   GENERATE: response with references
   ```

3. Response Format:
   ```
   PRIORITY_LEVEL: issue count
   ISSUE: description
   WHY: explanation
   FIX: code example
   REF: docs/path/to/file.md#section
   ```
```

---

## 📚 Resources

- [rules-config.yaml](../rules-config.yaml) - التكوين الرئيسي
- [docs/INDEX.md](./docs/INDEX.md) - فهرس الملفات
- [DECISION-GUIDE.md](./DECISION-GUIDE.md) - دليل القرارات
- [QUICK-START.md](./QUICK-START.md) - البداية السريعة

---

**Last Updated:** 2025-10-21  
**Version:** 1.0.0  
**For:** Windsurf + Claude Sonnet 4.5 Thinking

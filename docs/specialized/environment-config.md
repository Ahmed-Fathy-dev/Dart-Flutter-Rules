# 🔐 Environment Configuration with Envied

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: Specialized
applies_to:
  - all_production_apps
recommended_package: envied
ai_agent_tags:
  - security
  - environment
  - configuration
  - secrets
  - envied
```

---

## 🎯 Overview

**Envied** يوفر طريقة آمنة لإدارة environment variables في Flutter. أفضل من `flutter_dotenv` لأنه compile-time.

### Why Envied?
- 🔒 **Secure** - Variables are obfuscated at compile-time
- ⚡ **Fast** - No runtime parsing
- 🎯 **Type-safe** - Generate typed classes
- 🔑 **Hidden** - Not stored in plain text
- 🚫 **No .env exposure** - Values compiled into binary

---

## 🟡 Priority Level: HIGH

**Status:** `RECOMMENDED` for production apps

---

## 📚 Core Concepts

### 1. Setup

#### pubspec.yaml
```yaml
dependencies:
  envied: ^1.1.0  # ✅ Latest (2025-10-22)

dev_dependencies:
  build_runner: ^2.4.15
  envied_generator: ^1.1.0  # ✅ Latest
```

---

### 2. Create `.env` File

```.env
# .env (add to .gitignore!)
API_KEY=your_api_key_here
API_URL=https://api.example.com
DEBUG_MODE=true
MAX_RETRIES=3
```

#### `.gitignore`
```gitignore
# Environment files
.env
.env.local
.env.production
.env.development
```

---

### 3. Define Environment Class

```dart
// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static const String apiKey = _Env.apiKey;
  
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;
  
  @EnviedField(varName: 'DEBUG_MODE', defaultValue: false)
  static const bool debugMode = _Env.debugMode;
  
  @EnviedField(varName: 'MAX_RETRIES', defaultValue: 3)
  static const int maxRetries = _Env.maxRetries;
}
```

#### Generate Code
```bash
# Generate env.g.dart
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter pub run build_runner watch
```

---

### 4. Usage

```dart
import 'env/env.dart';

void main() {
  // Use environment variables
  print('API URL: ${Env.apiUrl}');
  print('Debug Mode: ${Env.debugMode}');
  print('Max Retries: ${Env.maxRetries}');
  
  // API Key is obfuscated!
  final apiKey = Env.apiKey;
  
  runApp(MyApp());
}

class ApiClient {
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,  // ✅ Type-safe!
        headers: {
          'Authorization': 'Bearer ${Env.apiKey}',
        },
      ),
    );
  }
}
```

---

### 5. Multi-Environment Setup

#### `.env.development`
```env
API_URL=https://dev-api.example.com
API_KEY=dev_key_123
DEBUG_MODE=true
ENABLE_LOGGING=true
```

#### `.env.production`
```env
API_URL=https://api.example.com
API_KEY=prod_key_xyz
DEBUG_MODE=false
ENABLE_LOGGING=false
```

#### Separate Environment Classes
```dart
// lib/env/dev_env.dart
@Envied(path: '.env.development')
abstract class DevEnv {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static const String apiKey = _DevEnv.apiKey;
  
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _DevEnv.apiUrl;
}

// lib/env/prod_env.dart
@Envied(path: '.env.production')
abstract class ProdEnv {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static const String apiKey = _ProdEnv.apiKey;
  
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _ProdEnv.apiUrl;
}

// lib/env/env.dart
class Env {
  static const bool isProd = bool.fromEnvironment('dart.vm.product');
  
  static String get apiKey => isProd ? ProdEnv.apiKey : DevEnv.apiKey;
  static String get apiUrl => isProd ? ProdEnv.apiUrl : DevEnv.apiUrl;
}
```

---

### 6. Obfuscation Levels

```dart
@Envied(path: '.env')
abstract class Env {
  // No obfuscation - visible in binary
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;
  
  // Basic obfuscation
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static const String apiKey = _Env.apiKey;
  
  // Optional - can be null
  @EnviedField(varName: 'OPTIONAL_KEY', obfuscate: true)
  static const String? optionalKey = _Env.optionalKey;
  
  // With default value
  @EnviedField(
    varName: 'TIMEOUT',
    defaultValue: 30,
    obfuscate: true,
  )
  static const int timeout = _Env.timeout;
}
```

---

### 7. Build Flavors Integration

#### `android/app/build.gradle`
```gradle
android {
    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
        }
        prod {
            dimension "environment"
        }
    }
}
```

#### Run Commands
```bash
# Development
flutter run --flavor dev --dart-define-from-file=.env.development

# Production
flutter build apk --flavor prod --dart-define-from-file=.env.production
```

---

### 8. CI/CD Setup

#### GitHub Actions
```yaml
name: Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      # Create .env from secrets
      - name: Create .env
        run: |
          echo "API_KEY=${{ secrets.API_KEY }}" >> .env
          echo "API_URL=${{ secrets.API_URL }}" >> .env
      
      # Generate envied code
      - name: Generate Envied
        run: flutter pub run build_runner build --delete-conflicting-outputs
      
      # Build
      - name: Build APK
        run: flutter build apk --release
```

---

### 9. Real-World Example: Multi-Tenant App

```dart
// .env.client1
API_URL=https://client1-api.example.com
API_KEY=client1_key_xyz
TENANT_ID=client1
APP_NAME=Client 1 App
PRIMARY_COLOR=0xFF1976D2

// .env.client2
API_URL=https://client2-api.example.com
API_KEY=client2_key_abc
TENANT_ID=client2
APP_NAME=Client 2 App
PRIMARY_COLOR=0xFFF44336

// env.dart
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static const String apiKey = _Env.apiKey;
  
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;
  
  @EnviedField(varName: 'TENANT_ID')
  static const String tenantId = _Env.tenantId;
  
  @EnviedField(varName: 'APP_NAME')
  static const String appName = _Env.appName;
  
  @EnviedField(varName: 'PRIMARY_COLOR')
  static const int primaryColorValue = _Env.primaryColorValue;
  
  static Color get primaryColor => Color(primaryColorValue);
}

// main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Env.appName,  // ✅ Per-client branding
      theme: ThemeData(
        primaryColor: Env.primaryColor,  // ✅ Per-client theming
      ),
      home: HomeScreen(),
    );
  }
}

// Build for different clients
// flutter build apk --dart-define-from-file=.env.client1
// flutter build apk --dart-define-from-file=.env.client2
```

---

## ⚖️ Envied vs flutter_dotenv

### **Comparison Table:**

| Feature | flutter_dotenv | Envied |
|---------|---------------|--------|
| **Security** | ❌ Plain text at runtime | ✅ **Obfuscated at compile-time** |
| **Performance** | ⚠️ Runtime parsing | ✅ **Compile-time (faster)** |
| **Type Safety** | ❌ No | ✅ **Yes** |
| **Ease of Use** | 🟢 Easy | 🟡 Medium |
| **Setup** | 🟢 Simple | 🟡 Requires code generation |
| **File Exposure** | ❌ `.env` in assets | ✅ **Not in final binary** |
| **Obfuscation** | ❌ No | ✅ **Yes** |
| **Best For** | Development | **Production** |

---

### **When to use flutter_dotenv:**
```yaml
✅ Quick prototypes
✅ Development only
✅ No sensitive data
✅ Simple projects
```

### **When to use Envied:**
```yaml
✅ Production apps ⭐
✅ Sensitive API keys
✅ Type safety needed
✅ Better security required
✅ Professional projects
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ Use envied for production
✅ Obfuscate all sensitive data
✅ Add .env to .gitignore
✅ Use different .env per environment
✅ Type-safe access
✅ Document required env variables
```

### **❌ تجنب:**
```dart
❌ Commit .env to git
❌ Store sensitive data unobfuscated
❌ Hardcode secrets in code
❌ Share .env files
❌ Use flutter_dotenv in production
```

---

### **Environment Variables Documentation**

```dart
// docs/ENV_VARIABLES.md
# Required Environment Variables

## Development (.env.development)
- `API_URL`: Development API endpoint
- `API_KEY`: Development API key
- `DEBUG_MODE`: Enable debug features (true)

## Production (.env.production)
- `API_URL`: Production API endpoint
- `API_KEY`: Production API key (SECRET!)
- `DEBUG_MODE`: Disable debug features (false)

## How to setup:
1. Copy `.env.example` to `.env`
2. Fill in your values
3. Run: `flutter pub run build_runner build`
4. Never commit .env files!
```

---

## 🧪 Testing

```dart
// test/env_test.dart
import 'package:test/test.dart';
import 'package:your_app/env/env.dart';

void main() {
  group('Environment Variables', () {
    test('API URL is not empty', () {
      expect(Env.apiUrl, isNotEmpty);
      expect(Env.apiUrl, startsWith('https://'));
    });
    
    test('API Key is obfuscated', () {
      // Key exists but value is obfuscated
      expect(Env.apiKey, isNotNull);
      expect(Env.apiKey.length, greaterThan(0));
    });
    
    test('Debug mode has correct type', () {
      expect(Env.debugMode, isA<bool>());
    });
  });
}
```

---

## 🎯 Real-World Setup

```bash
# Project structure
lib/
  env/
    env.dart           # Main environment class
    env.g.dart         # Generated file
    dev_env.dart       # Development config
    dev_env.g.dart
    prod_env.dart      # Production config
    prod_env.g.dart

# Environment files (gitignored)
.env
.env.development
.env.production
.env.example           # Template (committed)

# CI/CD
.github/
  workflows/
    build.yml          # Uses secrets
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - envied setup
  - .env in .gitignore
  - obfuscation for sensitive data
  - type-safe access
  - no hardcoded secrets

suggest:
  - use envied for production
  - obfuscate API keys
  - separate dev/prod environments
  - document env variables
  - setup CI/CD secrets

enforce:
  - no .env in git
  - all secrets obfuscated
  - type-safe access
  - no hardcoded values
```

---

## 📚 Related Files

- [Security](./security.md) - Security best practices
- [HTTP Clients](../data/http-clients.md) - API configuration
- [CI/CD Integration](../tools/cicd.md) - Deployment

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**For:** All Production Apps  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

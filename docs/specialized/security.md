# Security Best Practices

## 📋 Metadata

```yaml
priority: LOW
level: CRITICAL
category: Specialized
applies_to:
  - all_production_apps
security_level: essential
ai_agent_tags:
  - security
  - encryption
  - authentication
  - sensitive-data
  - best-practices
```

---

## 🎯 Overview

**Security** أساسي لحماية بيانات المستخدمين وسمعة التطبيق. خرق أمني واحد يمكن أن يدمر الثقة.

### Why Security?
- 🔒 Protect user data
- 🛡️ Prevent breaches
- ⚖️ Legal compliance
- 💼 Business reputation
- ✅ User trust

---

## 🔵 Priority Level: LOW (but CRITICAL importance)

**Status:** `CRITICAL` للإنتاج

---

## 📚 Core Concepts

### 1. Secure Storage

```dart
// ❌ NEVER - Storing sensitive data in SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token); // ❌ INSECURE!
await prefs.setString('password', password); // ❌ NEVER!

// ✅ ALWAYS - Use flutter_secure_storage
// pubspec.yaml: flutter_secure_storage: ^9.2.4
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Store
await storage.write(key: 'auth_token', value: token);

// Read
final token = await storage.read(key: 'auth_token');

// Delete
await storage.delete(key: 'auth_token');
```

---

### 2. API Keys & Secrets

```dart
// ❌ NEVER - Hardcode API keys
class ApiClient {
  static const apiKey = 'sk_live_abc123xyz789'; // ❌ EXPOSED!
  static const baseUrl = 'https://api.example.com';
}

// ✅ Use environment variables
// .env file (add to .gitignore)
API_KEY=sk_live_abc123xyz789
API_URL=https://api.example.com

// Load with flutter_dotenv
// pubspec.yaml: flutter_dotenv: ^5.2.1
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class ApiClient {
  static String get apiKey => dotenv.env['API_KEY']!;
  static String get baseUrl => dotenv.env['API_URL']!;
}

// ✅ Even better - Backend proxy
// Client → Your Backend → Third-party API
// API key stays on backend, never exposed
```

---

### 3. HTTPS Only

```dart
// ❌ NEVER - Use HTTP
final response = await http.get(
  Uri.parse('http://api.example.com/data'), // ❌ INSECURE!
);

// ✅ ALWAYS - Use HTTPS
final response = await http.get(
  Uri.parse('https://api.example.com/data'), // ✅ SECURE
);

// ✅ Enforce HTTPS in AndroidManifest.xml
<application
    android:usesCleartextTraffic="false"> // Blocks HTTP
    ...
</application>

// ✅ iOS automatically blocks HTTP (App Transport Security)
```

---

### 4. Certificate Pinning

```dart
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class SecureApiClient {
  static Dio createDio() {
    final dio = Dio();
    
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        // Pin certificate
        return cert.sha1.toString() == 'YOUR_CERT_SHA1';
      };
      return client;
    };
    
    return dio;
  }
}
```

---

### 5. Input Validation

```dart
// ❌ Bad - No validation
void updateUser(String email, String age) {
  api.update(email: email, age: age); // SQL injection risk!
}

// ✅ Good - Validate & sanitize
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidAge(String age) {
    final parsed = int.tryParse(age);
    return parsed != null && parsed >= 0 && parsed <= 150;
  }
  
  static String sanitizeInput(String input) {
    // Remove dangerous characters
    return input
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }
}

void updateUser(String email, String age) {
  // Validate
  if (!Validators.isValidEmail(email)) {
    throw ValidationException('Invalid email');
  }
  
  if (!Validators.isValidAge(age)) {
    throw ValidationException('Invalid age');
  }
  
  // Sanitize
  final sanitizedEmail = Validators.sanitizeInput(email);
  
  api.update(email: sanitizedEmail, age: age);
}
```

---

### 6. Authentication Tokens

```dart
// ✅ Store tokens securely
class AuthService {
  final FlutterSecureStorage _storage;
  
  AuthService(this._storage);
  
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}

// ✅ Add token to requests
class ApiClient {
  final Dio _dio;
  final AuthService _auth;
  
  ApiClient(this._dio, this._auth) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _auth.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
```

---

### 7. Biometric Authentication

```yaml
dependencies:
  local_auth: ^2.3.0  # ✅ Latest version
```

```dart
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();
  
  Future<bool> canAuthenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck && isDeviceSupported;
  }
  
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

// Usage
class SecureScreen extends StatefulWidget {
  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  bool _isAuthenticated = false;
  
  @override
  void initState() {
    super.initState();
    _authenticate();
  }
  
  Future<void> _authenticate() async {
    final biometric = BiometricAuth();
    
    if (await biometric.canAuthenticate()) {
      final authenticated = await biometric.authenticate();
      setState(() => _isAuthenticated = authenticated);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Text('Authentication required'),
        ),
      );
    }
    
    return Scaffold(
      body: SensitiveContent(),
    );
  }
}
```

---

### 8. Code Obfuscation

```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug-info

flutter build ios --obfuscate --split-debug-info=build/debug-info

# This makes reverse engineering harder
```

---

### 9. Prevent Screenshots (Sensitive Screens)

```yaml
dependencies:
  flutter_windowmanager: ^0.2.0  # ✅ Latest version
```

```dart
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SecureScreen extends StatefulWidget {
  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  @override
  void initState() {
    super.initState();
    _disableScreenshots();
  }
  
  Future<void> _disableScreenshots() async {
    await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
  }
  
  @override
  void dispose() {
    FlutterWindowManager.clearFlags(
      FlutterWindowManager.FLAG_SECURE,
    );
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Screen')),
      body: Center(
        child: Text('Screenshots disabled'),
      ),
    );
  }
}
```

---

### 10. SQL Injection Prevention

```dart
// ❌ NEVER - String concatenation
final query = "SELECT * FROM users WHERE email = '$email'";
// If email = "'; DROP TABLE users; --" → Database destroyed!

// ✅ ALWAYS - Parameterized queries
final db = await database;
final result = await db.query(
  'users',
  where: 'email = ?',
  whereArgs: [email], // Automatically escaped
);

// ✅ Or use ORM (Drift)
final users = await (select(users)
  ..where((u) => u.email.equals(email)))
  .get();
```

---

## ✅ Best Practices

### Rule 1: Never Store Passwords

```dart
// ❌ NEVER
await storage.write(key: 'password', value: userPassword);

// ✅ Store only auth tokens
await storage.write(key: 'auth_token', value: token);

// ✅ Use OAuth/Social Login
// Let Google/Apple/Facebook handle authentication
```

---

### Rule 2: Validate All User Input

```dart
// ✅ Always validate
String validateInput(String input) {
  // Remove whitespace
  input = input.trim();
  
  // Check length
  if (input.length < 3 || input.length > 100) {
    throw ValidationException('Invalid length');
  }
  
  // Check format
  if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(input)) {
    throw ValidationException('Invalid characters');
  }
  
  return input;
}
```

---

### Rule 3: Use HTTPS Everywhere

```dart
// ✅ Enforce HTTPS
class ApiClient {
  static final baseUrl = Uri.parse('https://api.example.com');
  
  Future<Response> get(String path) async {
    final url = baseUrl.resolve(path);
    
    // Verify HTTPS
    if (url.scheme != 'https') {
      throw SecurityException('HTTPS required');
    }
    
    return await http.get(url);
  }
}
```

---

## 🔒 Security Checklist

```markdown
**Data Storage:**
- [ ] Sensitive data in secure storage
- [ ] No passwords stored
- [ ] Tokens encrypted
- [ ] No API keys in code

**Network:**
- [ ] HTTPS only
- [ ] Certificate pinning (if needed)
- [ ] Token-based auth
- [ ] Request validation

**Code:**
- [ ] Input validation
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Code obfuscation (production)

**Authentication:**
- [ ] Secure token storage
- [ ] Biometric auth (optional)
- [ ] Session timeout
- [ ] Logout functionality

**App Protection:**
- [ ] Screenshot prevention (sensitive screens)
- [ ] Root/jailbreak detection
- [ ] App signing
- [ ] ProGuard/R8 (Android)
```

---

## 🚨 Common Vulnerabilities

### 1. Exposed API Keys
```dart
// ❌ Vulnerable
const apiKey = 'sk_live_abc123'; // Visible in source code

// ✅ Secure
const apiKey = String.fromEnvironment('API_KEY');
```

### 2. Insecure Storage
```dart
// ❌ Vulnerable
SharedPreferences.setString('token', token);

// ✅ Secure
FlutterSecureStorage().write(key: 'token', value: token);
```

### 3. Man-in-the-Middle
```dart
// ❌ Vulnerable
http.get(Uri.parse('http://api.com/data'));

// ✅ Secure
http.get(Uri.parse('https://api.com/data'));
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - flutter_secure_storage for tokens
  - no hardcoded API keys
  - HTTPS only
  - input validation
  - parameterized queries
  - code obfuscation in builds
  - no passwords stored

suggest:
  - use secure storage
  - move API keys to .env
  - validate all inputs
  - implement biometric auth
  - add certificate pinning
  - enable obfuscation

enforce:
  - no passwords in storage
  - HTTPS required
  - tokens in secure storage
  - API keys not hardcoded
  - input validation
```

---

## 📊 Summary

| Security Aspect | Implementation | Priority |
|----------------|----------------|----------|
| **Secure Storage** | flutter_secure_storage | CRITICAL |
| **HTTPS** | All network calls | CRITICAL |
| **Input Validation** | All user inputs | CRITICAL |
| **API Keys** | Environment variables | CRITICAL |
| **Code Obfuscation** | Production builds | HIGH |
| **Biometric Auth** | Sensitive operations | MEDIUM |
| **Screenshot Block** | Banking/medical apps | MEDIUM |

---

## 🔗 Related Rules

- [Error Handling](../core/error-handling.md)
- [HTTP Clients](../data/http-clients.md)
- [Local Storage](../data/local-storage.md)

---

**Priority:** 🔵 LOW (but CRITICAL importance)  
**Level:** CRITICAL  
**For:** All Production Apps  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

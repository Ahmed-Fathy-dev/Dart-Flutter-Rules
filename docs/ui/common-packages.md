# 📦 Common UI & Utility Packages

## 📋 Metadata

```yaml
priority: HIGH
level: RECOMMENDED
category: UI & Utilities
applies_to:
  - most_projects
ai_agent_tags:
  - ui
  - fonts
  - svg
  - forms
  - validation
  - media
  - permissions
```

---

## 🎯 Overview

مجموعة من المكتبات الشائعة والمهمة للـ UI والـ Utilities.

---

## 1. 🎨 Google Fonts

### Overview
**google_fonts** يوفر وصول سهل لأكثر من 1000 خط من Google Fonts.

### Setup
```yaml
dependencies:
  google_fonts: ^6.2.1  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
import 'package:google_fonts/google_fonts.dart';

// Use directly
Text(
  'Hello World',
  style: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

// With text style
Text(
  'Hello World',
  style: GoogleFonts.lato(
    textStyle: Theme.of(context).textTheme.headlineLarge,
  ),
)

// Different weights
Text(
  'Light',
  style: GoogleFonts.openSans(fontWeight: FontWeight.w300),
)

Text(
  'Regular',
  style: GoogleFonts.openSans(fontWeight: FontWeight.w400),
)

Text(
  'Bold',
  style: GoogleFonts.openSans(fontWeight: FontWeight.w700),
)
```

### Theme Integration
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Set default font family
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        // Or specific font
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: HomeScreen(),
    );
  }
}
```

### Arabic Fonts
```dart
// Arabic fonts
Text(
  'مرحبا بالعالم',
  style: GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)

Text(
  'مرحبا',
  style: GoogleFonts.tajawal(fontSize: 20),
)

Text(
  'مرحبا',
  style: GoogleFonts.amiri(fontSize: 20),
)

// Common Arabic fonts:
// - Cairo
// - Tajawal
// - Almarai
// - Amiri
// - Harmattan
// - Lalezar
```

### Performance Optimization
```dart
// Pre-cache fonts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // License fonts (required!)
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  
  runApp(MyApp());
}
```

### Popular Fonts
```dart
// Sans-Serif
GoogleFonts.roboto()
GoogleFonts.openSans()
GoogleFonts.lato()
GoogleFonts.montserrat()
GoogleFonts.poppins()
GoogleFonts.inter()

// Serif
GoogleFonts.playfairDisplay()
GoogleFonts.merriweather()
GoogleFonts.loraFont()

// Monospace
GoogleFonts.robotoMono()
GoogleFonts.sourceCodePro()
GoogleFonts.jetBrainsMono()

// Arabic
GoogleFonts.cairo()
GoogleFonts.tajawal()
GoogleFonts.almarai()
```

---

## 2. 🖼️ Flutter SVG

### Overview
**flutter_svg** لعرض ملفات SVG بجودة عالية وأداء ممتاز.

### Setup
```yaml
dependencies:
  flutter_svg: ^2.0.17  # ✅ Latest (2025-10-22)
```

### Basic Usage
```dart
import 'package:flutter_svg/flutter_svg.dart';

// From asset
SvgPicture.asset(
  'assets/icons/logo.svg',
  width: 100,
  height: 100,
)

// From network
SvgPicture.network(
  'https://example.com/image.svg',
  placeholderBuilder: (context) => CircularProgressIndicator(),
)

// From string
SvgPicture.string(
  '''<svg viewBox="0 0 100 100">
    <circle cx="50" cy="50" r="40" fill="blue"/>
  </svg>''',
)
```

### Color & Size
```dart
SvgPicture.asset(
  'assets/icons/heart.svg',
  width: 24,
  height: 24,
  colorFilter: ColorFilter.mode(
    Colors.red,
    BlendMode.srcIn,
  ),
)

// Theme color
SvgPicture.asset(
  'assets/icons/icon.svg',
  colorFilter: ColorFilter.mode(
    Theme.of(context).primaryColor,
    BlendMode.srcIn,
  ),
)
```

### Caching
```dart
// Pre-cache SVG
Future<void> precacheSvg() async {
  final loader = SvgAssetLoader('assets/icons/logo.svg');
  await svg.cache.putIfAbsent(
    loader.cacheKey(null),
    () => loader.loadBytes(null),
  );
}
```

### Icon Button with SVG
```dart
IconButton(
  icon: SvgPicture.asset(
    'assets/icons/settings.svg',
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(
      Colors.white,
      BlendMode.srcIn,
    ),
  ),
  onPressed: () {},
)
```

### Real-World Example
```dart
class CustomIcon extends StatelessWidget {
  final String asset;
  final double size;
  final Color? color;
  
  const CustomIcon({
    required this.asset,
    this.size = 24,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$asset.svg',
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

// Usage
CustomIcon(
  asset: 'home',
  size: 32,
  color: Colors.blue,
)
```

---

## 3. ✅ Form Builder Validators

### Overview
**form_builder_validators** يوفر validators جاهزة لجميع حالات الـ validation.

### Setup
```yaml
dependencies:
  form_builder_validators: ^11.1.2  # ✅ Latest (2025-10-22)
```

### Basic Validators
```dart
import 'package:form_builder_validators/form_builder_validators.dart';

TextFormField(
  decoration: const InputDecoration(labelText: 'Email'),
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.email(),
  ]),
)

TextFormField(
  decoration: const InputDecoration(labelText: 'Password'),
  obscureText: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.minLength(8),
    FormBuilderValidators.maxLength(50),
  ]),
)

TextFormField(
  decoration: const InputDecoration(labelText: 'Age'),
  keyboardType: TextInputType.number,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.numeric(),
    FormBuilderValidators.min(18),
    FormBuilderValidators.max(100),
  ]),
)
```

### Common Validators
```dart
// Required
FormBuilderValidators.required()

// Email
FormBuilderValidators.email()

// URL
FormBuilderValidators.url()

// Numeric
FormBuilderValidators.numeric()

// Integer
FormBuilderValidators.integer()

// Min/Max Length
FormBuilderValidators.minLength(5)
FormBuilderValidators.maxLength(50)

// Min/Max Value
FormBuilderValidators.min(0)
FormBuilderValidators.max(100)

// Pattern (Regex)
FormBuilderValidators.match(r'^[a-zA-Z]+$')

// Equal
FormBuilderValidators.equal('value')

// Date Range
FormBuilderValidators.dateString()
FormBuilderValidators.dateTime()

// Credit Card
FormBuilderValidators.creditCard()

// IP Address
FormBuilderValidators.ip()

// Phone
FormBuilderValidators.phoneNumber()
```

### Custom Error Messages
```dart
TextFormField(
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(
      errorText: 'هذا الحقل مطلوب',
    ),
    FormBuilderValidators.email(
      errorText: 'البريد الإلكتروني غير صحيح',
    ),
  ]),
)
```

### Password Confirmation
```dart
final passwordController = TextEditingController();

TextFormField(
  controller: passwordController,
  decoration: const InputDecoration(labelText: 'Password'),
  obscureText: true,
  validator: FormBuilderValidators.required(),
)

TextFormField(
  decoration: const InputDecoration(labelText: 'Confirm Password'),
  obscureText: true,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    (value) {
      if (value != passwordController.text) {
        return 'Passwords do not match';
      }
      return null;
    },
  ]),
)
```

### Real-World Registration Form
```dart
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(3),
              FormBuilderValidators.maxLength(50),
            ]),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ]),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(8),
              FormBuilderValidators.match(
                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)',
                errorText: 'Password must contain uppercase, lowercase, and number',
              ),
            ]),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.equal(
                _passwordController.text,
                errorText: 'Passwords do not match',
              ),
            ]),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.phoneNumber(),
            ]),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit form
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

---

## 4. 📸 Image Picker

### Overview
**image_picker** لاختيار الصور والفيديوهات من الكاميرا أو المعرض.

### Setup
```yaml
dependencies:
  image_picker: ^1.1.2  # ✅ Latest (2025-10-22)
```

### iOS Configuration (Info.plist)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to upload images</string>

<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to record videos</string>
```

### Android Configuration (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Pick from Gallery
```dart
import 'package:image_picker/image_picker.dart';

Future<void> pickImageFromGallery() async {
  final picker = ImagePicker();
  
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
    imageQuality: 85,
  );
  
  if (image != null) {
    print('Image path: ${image.path}');
    // Use image
  }
}
```

### Take Photo from Camera
```dart
Future<void> takePhoto() async {
  final picker = ImagePicker();
  
  final XFile? photo = await picker.pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear,
    maxWidth: 1800,
    maxHeight: 1800,
    imageQuality: 85,
  );
  
  if (photo != null) {
    // Use photo
  }
}
```

### Pick Multiple Images
```dart
Future<void> pickMultipleImages() async {
  final picker = ImagePicker();
  
  final List<XFile> images = await picker.pickMultipleImages(
    maxWidth: 1800,
    maxHeight: 1800,
    imageQuality: 85,
  );
  
  print('Selected ${images.length} images');
}
```

### Pick Video
```dart
Future<void> pickVideo() async {
  final picker = ImagePicker();
  
  final XFile? video = await picker.pickVideo(
    source: ImageSource.gallery,
    maxDuration: const Duration(seconds: 30),
  );
  
  if (video != null) {
    // Use video
  }
}
```

### Real-World Example: Profile Picture
```dart
class ProfilePictureSelector extends StatefulWidget {
  @override
  _ProfilePictureSelectorState createState() => _ProfilePictureSelectorState();
}

class _ProfilePictureSelectorState extends State<ProfilePictureSelector> {
  XFile? _image;
  final _picker = ImagePicker();
  
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 90,
    );
    
    if (image != null) {
      setState(() => _image = image);
      // Upload to server
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
        child: _image == null
            ? const Icon(Icons.add_a_photo, size: 40)
            : null,
      ),
    );
  }
}
```

---

## 5. 🔐 Permission Handler

### Overview
**permission_handler** لطلب وإدارة الأذونات في Flutter.

### Setup
```yaml
dependencies:
  permission_handler: ^12.0.0+1  # ✅ Latest (2025-10-22)
```

### iOS Configuration (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need location access</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access</string>

<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access</string>
```

### Android Configuration (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Check Permission
```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkCameraPermission() async {
  final status = await Permission.camera.status;
  
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    // Request permission
    final result = await Permission.camera.request();
    return result.isGranted;
  } else if (status.isPermanentlyDenied) {
    // Open settings
    await openAppSettings();
    return false;
  }
  
  return false;
}
```

### Request Permission
```dart
Future<void> requestPermission() async {
  final status = await Permission.camera.request();
  
  if (status.isGranted) {
    print('Permission granted');
  } else if (status.isDenied) {
    print('Permission denied');
  } else if (status.isPermanentlyDenied) {
    print('Permission permanently denied');
    await openAppSettings();
  }
}
```

### Request Multiple Permissions
```dart
Future<void> requestMultiplePermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.location,
  ].request();
  
  print('Camera: ${statuses[Permission.camera]}');
  print('Microphone: ${statuses[Permission.microphone]}');
  print('Location: ${statuses[Permission.location]}');
}
```

### Common Permissions
```dart
// Camera
Permission.camera

// Location
Permission.location
Permission.locationWhenInUse
Permission.locationAlways

// Storage
Permission.storage
Permission.photos
Permission.videos

// Microphone
Permission.microphone

// Contacts
Permission.contacts

// Calendar
Permission.calendar

// Notifications
Permission.notification

// Bluetooth
Permission.bluetooth
Permission.bluetoothScan
Permission.bluetoothConnect
```

### Real-World Example: Camera Access
```dart
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _hasPermission = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }
  
  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    
    setState(() {
      _hasPermission = status.isGranted;
    });
    
    if (!_hasPermission) {
      _requestPermission();
    }
  }
  
  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Camera permission is required. Please enable it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Camera permission is required'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _requestPermission,
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Center(
        child: const Text('Camera Ready!'),
      ),
    );
  }
}
```

---

## ✅ Best Practices

### Google Fonts
```dart
✅ Pre-cache commonly used fonts
✅ Use font families consistently
✅ Test Arabic/RTL fonts
✅ Set font in theme for consistency
```

### Flutter SVG
```dart
✅ Use SVG for icons and logos
✅ Pre-cache important SVGs
✅ Use colorFilter for theming
✅ Optimize SVG files before use
```

### Form Validators
```dart
✅ Compose multiple validators
✅ Provide clear error messages
✅ Use appropriate keyboard types
✅ Validate on submit and onChange
```

### Image Picker
```dart
✅ Compress images before upload
✅ Set max dimensions
✅ Handle permission denials
✅ Show loading during upload
```

### Permission Handler
```dart
✅ Check permissions before use
✅ Handle all permission states
✅ Provide clear explanations
✅ Guide users to settings when needed
```

---

**Priority:** 🟡 HIGH  
**Level:** RECOMMENDED  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

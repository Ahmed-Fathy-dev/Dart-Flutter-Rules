# Image Optimization

## 📋 Metadata

```yaml
priority: MEDIUM
level: RECOMMENDED
category: Performance
applies_to:
  - all_flutter_projects
performance_impact: high
ai_agent_tags:
  - performance
  - images
  - optimization
  - caching
  - memory
```

---

## 🎯 Overview

**Image Optimization** يقلل memory usage ويحسّن load times. الصور غير المُحسّنة تسبب crashes و jank.

### Why Optimize Images?
- 🧠 Lower memory usage
- ⚡ Faster loading
- 📱 Smoother scrolling
- 🔋 Better battery
- 💾 Less storage

---

## 🟠 Priority Level: MEDIUM

**Status:** `RECOMMENDED` - Critical للتطبيقات مع صور كثيرة

---

## 📚 Core Concepts

### 1. CachedNetworkImage

#### Setup
```yaml
dependencies:
  cached_network_image: ^3.4.1  # ✅ Updated to latest
```

#### Basic Usage
```dart
import 'package:cached_network_image/cached_network_image.dart';

// ❌ Bad - No caching
Image.network(
  'https://example.com/image.jpg',
)

// ✅ Good - Cached
CachedNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

### 2. Resize Images in Memory

```dart
// ❌ Bad - Full resolution (4K = 3840×2160)
CachedNetworkImage(
  imageUrl: imageUrl,
  // Loads full 4K image! ❌
  // Memory: ~33MB per image
)

// ✅ Good - Resize for display
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: 400, // Resize to 400px width
  memCacheHeight: 300, // Resize to 300px height
  // Memory: ~0.5MB per image ✅
)

// ✅ Calculate based on device
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: (MediaQuery.of(context).size.width * 
      MediaQuery.of(context).devicePixelRatio).toInt(),
)
```

---

### 3. Image Caching

```dart
// ✅ Control cache behavior
CachedNetworkImage(
  imageUrl: imageUrl,
  
  // Cache control
  cacheKey: 'custom_key_${product.id}',
  
  // Cache duration
  maxHeightDiskCache: 1000,
  maxWidthDiskCache: 1000,
  
  // Error handling
  errorWidget: (context, url, error) {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image),
    );
  },
  
  // Loading
  placeholder: (context, url) {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  },
)
```

---

### 4. Precache Images

```dart
// ✅ Precache for instant display
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Precache network images
    precacheImage(
      CachedNetworkImageProvider(imageUrl),
      context,
    );
    
    // Precache asset images
    precacheImage(
      const AssetImage('assets/splash.png'),
      context,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(imageUrl),
      // Instant display (already cached) ✅
    );
  }
}
```

---

### 5. Asset Image Optimization

```dart
// ✅ Provide multiple resolutions
// assets/
//   images/
//     logo.png          (1x - 100x100)
//     2.0x/logo.png     (2x - 200x200)
//     3.0x/logo.png     (3x - 300x300)

// pubspec.yaml
flutter:
  assets:
    - assets/images/

// Usage - Auto selects resolution
Image.asset(
  'assets/images/logo.png',
  // Automatically loads 2x or 3x based on device
)

// ✅ Resize asset images
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  cacheWidth: 200, // ✅ Resize in memory
  cacheHeight: 200,
)
```

---

### 6. Fade-In Placeholders

```dart
// ✅ Smooth loading
CachedNetworkImage(
  imageUrl: imageUrl,
  fadeInDuration: const Duration(milliseconds: 500),
  fadeOutDuration: const Duration(milliseconds: 300),
  placeholder: (context, url) => Container(
    color: Colors.grey[200],
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  ),
)

// ✅ Custom transition
CachedNetworkImage(
  imageUrl: imageUrl,
  imageBuilder: (context, imageProvider) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  },
)
```

---

### 7. GridView with Images

```dart
// ✅ Optimized grid
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    final product = products[index];
    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      
      // ✅ Resize for grid cell
      memCacheWidth: 200,
      memCacheHeight: 200,
      
      // ✅ Simple placeholder
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
      ),
      
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      ),
    );
  },
)
```

---

### 8. Clear Cache

```dart
import 'package:cached_network_image/cached_network_image.dart';

// Clear specific image
await CachedNetworkImage.evictFromCache(imageUrl);

// Clear all cache
await CachedNetworkImage.clearCachedImages();

// Get cache manager
final cacheManager = DefaultCacheManager();
await cacheManager.emptyCache();

// Check cache size
final files = await cacheManager.store.getAllObjects();
final totalSize = files.fold<int>(
  0,
  (sum, file) => sum + file.length,
);
print('Cache size: ${totalSize / 1024 / 1024} MB');
```

---

### 9. Image Compression

```dart
// ✅ Use compressed formats
// - WebP (best compression, modern)
// - JPEG (good for photos)
// - PNG (for transparency)

// ❌ Avoid
// - BMP (huge files)
// - Uncompressed formats

// Backend should serve:
'https://api.example.com/images/product_1.webp'  // ✅
'https://api.example.com/images/product_1.jpg'   // ✅
'https://api.example.com/images/product_1.png'   // ⚠️ If transparency needed
```

---

### 10. Lazy Loading Images

```dart
class LazyImageList extends StatelessWidget {
  final List<String> imageUrls;
  
  const LazyImageList(this.imageUrls);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: CachedNetworkImage(
            imageUrl: imageUrls[index],
            
            // ✅ Only loads when visible
            memCacheWidth: 600,
            
            placeholder: (context, url) {
              return Container(
                height: 200,
                color: Colors.grey[200],
              );
            },
          ),
        );
      },
    );
  }
}
```

---

## ✅ Best Practices

### Rule 1: Always Resize

```dart
// ❌ Bad - Full resolution
CachedNetworkImage(imageUrl: url)

// ✅ Good - Resized
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 400,
  memCacheHeight: 300,
)
```

---

### Rule 2: Use Appropriate Format

```dart
// ✅ Photo/Product Images
'image.jpg' or 'image.webp'

// ✅ Icons/Logos with transparency
'logo.png'

// ✅ Animated
'animation.gif' or 'animation.webp'

// ❌ Avoid
'huge_image.bmp'  // Too large
```

---

### Rule 3: Precache Critical Images

```dart
// ✅ Good - Precache splash/logo
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  
  precacheImage(
    const AssetImage('assets/logo.png'),
    context,
  );
}
```

---

## 🎯 Performance Impact

```yaml
Example: Product Grid (100 images)

Without Optimization:
  - Memory: 3.3GB (33MB per 4K image)
  - Load time: 45s
  - Crashes: Frequent
  - FPS: 15-20

With Optimization (memCacheWidth: 400):
  - Memory: 50MB (0.5MB per image)
  - Load time: 3s
  - Crashes: None
  - FPS: 60
```

---

## 🔧 Advanced: Custom Cache Manager

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = 'customCacheKey';
  
  static CustomCacheManager? _instance;
  
  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();
    return _instance!;
  }
  
  CustomCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Cache for 7 days
      maxNrOfCacheObjects: 200, // Max 200 images
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

// Usage
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: CustomCacheManager(),
)
```

---

## 🤖 AI Agent Integration

```yaml
check_for:
  - CachedNetworkImage usage
  - memCacheWidth/Height specified
  - placeholder & errorWidget
  - asset image variants (2x, 3x)
  - cacheWidth/Height for assets
  - precaching critical images

suggest:
  - use CachedNetworkImage
  - add memCache dimensions
  - provide 2x, 3x assets
  - precache splash images
  - compress images
  - use WebP format

enforce:
  - no Image.network without cache
  - memCache for images in lists
  - placeholder & error handling
  - dispose controllers
```

---

## 📊 Image Size Guidelines

| Use Case | Max Dimensions | Format | Quality |
|----------|---------------|--------|---------|
| **Thumbnails** | 200x200 | WebP/JPEG | 70% |
| **Product Cards** | 400x400 | WebP/JPEG | 80% |
| **Full Screen** | 1080x1920 | WebP/JPEG | 85% |
| **Logos** | 512x512 | PNG | 100% |
| **Icons** | 48x48 | PNG/SVG | 100% |

---

## 📊 Summary Checklist

```markdown
- [ ] CachedNetworkImage installed
- [ ] memCacheWidth/Height specified
- [ ] Placeholder & error widgets
- [ ] Multiple asset resolutions (2x, 3x)
- [ ] Critical images precached
- [ ] Cache cleared when needed
- [ ] WebP format used
- [ ] Images compressed
- [ ] Tested with 100+ images
```

---

## 🔗 Related Rules

- [List Optimization](./list-optimization.md)
- [Build Optimization](./build-optimization.md)
- [Performance Basics](../flutter-basics/performance-basics.md)

---

**Priority:** 🟠 MEDIUM  
**Level:** RECOMMENDED  
**Impact:** High  
**Last Updated:** 2025-10-21  
**Version:** 1.0.0

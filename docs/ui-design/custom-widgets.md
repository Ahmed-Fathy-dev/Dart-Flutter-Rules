# 🧩 Custom Widgets - الويدجت المخصصة

## 🎯 Overview

**Category:** `UI/UX`  
**Priority:** `MEDIUM`  
**Difficulty:** `MEDIUM`  
**Status:** `RECOMMENDED`

إنشاء widgets مخصصة قابلة لإعادة الاستخدام لتحسين الإنتاجية وجودة الكود.

---

## 📚 Core Concepts

### 1. Basic Custom Widget

```dart
// ✅ GOOD - Reusable widget
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  
  const AppButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon),
                  const SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
    );
  }
}

// Usage
AppButton(
  text: 'Save',
  icon: Icons.save,
  isLoading: _isSaving,
  onPressed: _handleSave,
)
```

---

### 2. Composition Over Inheritance

```dart
// ✅ GOOD - Composition
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  
  const PrimaryButton({
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
      child: Text(text),
    );
  }
}

// ❌ BAD - Inheritance
class PrimaryButton extends ElevatedButton {
  PrimaryButton({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          onPressed: onPressed,
          child: Text(text),
        );
}
```

---

### 3. Avatar Widget

```dart
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;
  
  const AppAvatar({
    this.imageUrl,
    this.name,
    this.size = 40,
    this.onTap,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: imageUrl != null
            ? NetworkImage(imageUrl!)
            : null,
        child: imageUrl == null
            ? Text(
                _getInitials(),
                style: TextStyle(
                  fontSize: size / 2.5,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
  
  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    
    final parts = name!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }
}

// Usage
AppAvatar(
  imageUrl: user.avatarUrl,
  name: user.name,
  size: 48,
  onTap: () => Navigator.push(...),
)
```

---

### 4. Loading Overlay Widget

```dart
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(message!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Usage
LoadingOverlay(
  isLoading: _isLoading,
  message: 'Saving...',
  child: YourContent(),
)
```

---

### 5. Animated Toggle Button

```dart
class AnimatedToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  
  const AnimatedToggle({
    required this.value,
    required this.onChanged,
    this.label,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!),
          const SizedBox(width: 8),
        ],
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: value ? Colors.green : Colors.grey,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

### 6. Custom Card Widget

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.elevation,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final card = Card(
      color: color,
      elevation: elevation,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }
    
    return card;
  }
}
```

---

### 7. Badge Widget

```dart
class Badge extends StatelessWidget {
  final Widget child;
  final String? label;
  final int? count;
  final Color? color;
  final bool showBadge;
  
  const Badge({
    required this.child,
    this.label,
    this.count,
    this.color,
    this.showBadge = true,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge && (label != null || count != null))
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  label ?? (count! > 99 ? '99+' : '$count'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Usage
Badge(
  count: 5,
  child: IconButton(
    icon: const Icon(Icons.notifications),
    onPressed: () {},
  ),
)
```

---

### 8. Shimmer Loading Widget

```dart
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  
  const ShimmerLoading({
    required this.child,
    required this.isLoading,
    Key? key,
  }) : super(key: key);
  
  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Colors.grey,
                Colors.white,
                Colors.grey,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
```

---

### 9. Expandable Card

```dart
class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;
  
  const ExpandableCard({
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    Key? key,
  }) : super(key: key);
  
  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;
  
  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            trailing: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.expand_more),
            ),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.content,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
```

---

### 10. Rating Widget

```dart
class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final ValueChanged<double>? onRatingChanged;
  
  const RatingWidget({
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.onRatingChanged,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1.0;
        IconData icon;
        
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        
        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(starValue)
              : null,
          child: Icon(
            icon,
            size: size,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}

// Usage
RatingWidget(
  rating: 4.5,
  size: 32,
  onRatingChanged: (rating) {
    setState(() => _rating = rating);
  },
)
```

---

## 🎨 Advanced Custom Widgets

### Custom Paint Example

```dart
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  CircularProgressPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Background circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );
    
    // Progress arc
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }
  
  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final double size;
  
  const CircularProgressWidget({
    required this.progress,
    this.size = 100,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: progress.clamp(0.0, 1.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Text(
            '${(progress * 100).toInt()}%',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
```

---

## ✅ Best Practices

### **✅ افعل:**
```dart
✅ استخدم const constructors
✅ اجعل الـ widgets composable
✅ استخدم final للـ properties
✅ أضف documentation
✅ اجعلها reusable
✅ استخدم Key عند الحاجة
```

### **❌ تجنب:**
```dart
❌ Inheritance من الـ Flutter widgets
❌ Mutable state في StatelessWidget
❌ Too many required parameters
❌ نسيان const constructors
❌ Hardcoded values
❌ عدم استخدام Theme
```

---

## 🧪 Testing Custom Widgets

```dart
testWidgets('AppButton shows loading state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppButton(
          text: 'Submit',
          isLoading: true,
          onPressed: () {},
        ),
      ),
    ),
  );
  
  // Should show progress indicator
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  
  // Should not show text when loading
  expect(find.text('Submit'), findsNothing);
});

testWidgets('RatingWidget is interactive', (tester) async {
  double selectedRating = 0;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RatingWidget(
          rating: 0,
          onRatingChanged: (rating) => selectedRating = rating,
        ),
      ),
    ),
  );
  
  // Tap on third star
  await tester.tap(find.byIcon(Icons.star_border).at(2));
  
  expect(selectedRating, equals(3.0));
});
```

---

## 🎯 AI Agent Instructions

### **Check:**
```yaml
- Are widgets reusable?
- Are const constructors used?
- Is composition preferred over inheritance?
- Are all properties final?
- Is documentation provided?
```

### **Suggest:**
```yaml
- Extract repeated UI into widgets
- Use Theme for styling
- Add loading/error states
- Make it configurable
- Add documentation comments
```

### **Enforce:**
```yaml
- Must use const constructors
- Must use final for properties
- Must not inherit from Flutter widgets
- Must be stateless when possible
```

---

## 📚 Related Files

- [Widget Immutability](../flutter-basics/widget-immutability.md) - Immutability
- [Material 3 Theming](./material3-theming.md) - Theming
- [Layout Patterns](./layout-patterns.md) - Layout patterns

---

**Last Updated:** 2025-10-22  
**Status:** `RECOMMENDED`  
**Priority:** `MEDIUM`

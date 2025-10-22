# 🚀 Advanced & Specialized Packages

## 📋 Metadata

```yaml
priority: LOW
level: OPTIONAL
category: Specialized
ai_agent_tags:
  - charts
  - media
  - pdf
  - printing
  - barcode
  - webview
  - desktop
  - icons
  - ui-components
```

---

## 1. 📊 FL Chart - Beautiful Charts

### Setup
```yaml
dependencies:
  fl_chart: ^0.69.2  # ✅ Latest (2025-10-22)
```

### Line Chart
```dart
import 'package:fl_chart/fl_chart.dart';

LineChart(
  LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(1, 4),
          FlSpot(2, 3.5),
          FlSpot(3, 5),
        ],
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: true),
      ),
    ],
  ),
)
```

### Bar Chart
```dart
BarChart(
  BarChartData(
    barGroups: [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14)]),
    ],
  ),
)
```

### Pie Chart
```dart
PieChart(
  PieChartData(
    sections: [
      PieChartSectionData(value: 40, title: '40%', color: Colors.blue),
      PieChartSectionData(value: 30, title: '30%', color: Colors.red),
      PieChartSectionData(value: 30, title: '30%', color: Colors.green),
    ],
  ),
)
```

---

## 2. 🎬 Media Kit - Video Player

### Setup
```yaml
dependencies:
  media_kit: ^1.1.11  # ✅ Latest (2025-10-22)
  media_kit_video: ^1.2.5
  media_kit_libs_video: ^1.0.5
```

### Basic Usage
```dart
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final player = Player();
  late final controller = VideoController(player);
  
  @override
  void initState() {
    super.initState();
    player.open(Media('https://example.com/video.mp4'));
  }
  
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Video(controller: controller),
    );
  }
}
```

---

## 3. 🖨️ Printing & PDF

### Setup
```yaml
dependencies:
  printing: ^5.13.4  # ✅ Latest (2025-10-22)
  pdf: ^3.11.1  # ✅ Latest
```

### Generate PDF
```dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdf() async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Text('Hello PDF!'),
      ),
    ),
  );
  
  await Printing.layoutPdf(
    onLayout: (format) => pdf.save(),
  );
}
```

### Print Invoice
```dart
Future<void> printInvoice(Invoice invoice) async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        children: [
          pw.Text('Invoice #${invoice.id}'),
          pw.Divider(),
          pw.Text('Total: \$${invoice.total}'),
        ],
      ),
    ),
  );
  
  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}
```

---

## 4. 📷 Barcode Scan

### Setup
```yaml
dependencies:
  barcode_scan2: ^4.3.3  # ✅ Latest (2025-10-22)
```

### Scan Barcode
```dart
import 'package:barcode_scan2/barcode_scan2.dart';

Future<void> scanBarcode() async {
  try {
    final result = await BarcodeScanner.scan();
    print('Barcode: ${result.rawContent}');
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## 5. 🌐 Flutter InAppWebView

### Setup
```yaml
dependencies:
  flutter_inappwebview: ^6.1.5  # ✅ Latest (2025-10-22)
```

### Basic WebView
```dart
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppWebView(
  initialUrlRequest: URLRequest(
    url: WebUri('https://flutter.dev'),
  ),
  onLoadStop: (controller, url) {
    print('Page loaded: $url');
  },
)
```

---

## 6. 🖥️ Window Manager (Desktop)

### Setup
```yaml
dependencies:
  window_manager: ^0.4.3  # ✅ Latest (2025-10-22)
```

### Configure Window
```dart
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  
  await windowManager.setTitle('My App');
  await windowManager.setSize(const Size(800, 600));
  await windowManager.center();
  
  runApp(MyApp());
}
```

---

## 7. 🎨 Iconsax Flutter

### Setup
```yaml
dependencies:
  iconsax_flutter: ^1.0.0  # ✅ Latest (2025-10-22)
```

### Usage
```dart
import 'package:iconsax_flutter/iconsax_flutter.dart';

Icon(Iconsax.home)
Icon(Iconsax.user)
Icon(Iconsax.heart)
Icon(Iconsax.notification)
```

---

## 8. 📋 Dropdown Button 2

### Setup
```yaml
dependencies:
  dropdown_button2: ^3.0.3  # ✅ Latest (2025-10-22)
```

### Enhanced Dropdown
```dart
import 'package:dropdown_button2/dropdown_button2.dart';

DropdownButton2<String>(
  items: ['Option 1', 'Option 2', 'Option 3']
      .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
      .toList(),
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  buttonStyleData: ButtonStyleData(
    height: 50,
    width: 200,
  ),
  dropdownStyleData: DropdownStyleData(
    maxHeight: 200,
  ),
)
```

---

**Priority:** 🟢 LOW  
**Level:** OPTIONAL  
**Last Updated:** 2025-10-22  
**Version:** 1.0.0

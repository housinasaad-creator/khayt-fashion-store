import 'package:flutter/material.dart';

/// Non-web fallback. On Android/iOS this can be swapped for a WebView that
/// loads assets/viewer/viewer.html (same postMessage API).
class Viewer3D extends StatelessWidget {
  final String style;
  final Color color;
  const Viewer3D({super.key, required this.style, required this.color});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.checkroom_rounded, size: 120, color: color),
          const SizedBox(height: 8),
          const Text('3D preview is available on the web build'),
        ]),
      );
}

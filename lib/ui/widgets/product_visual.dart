import 'package:flutter/material.dart';
import '../../data/products.dart';

/// Product photo, with a soft tinted placeholder while it loads or if it is missing.
/// The photo is decoded at the size it is shown (times the device pixel ratio and [zoom]),
/// not at full resolution, so dozens of photos stay light on memory.
class ProductImage extends StatelessWidget {
  final Product product;
  final int colorIndex;
  final BoxFit fit;
  final Alignment alignment;
  final double zoom;
  const ProductImage(this.product, {super.key, this.colorIndex = 0, this.fit = BoxFit.cover, this.alignment = Alignment.center, this.zoom = 1});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: product.accent.withValues(alpha: 0.3));
    final path = product.image;
    if (path == null) return placeholder;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(builder: (context, c) {
      final w = c.hasBoundedWidth ? c.maxWidth : 600.0;
      // buckets of 160 px keep the decoded copies reusable while the size animates
      final px = ((w * dpr * zoom * 1.1) / 160).ceil() * 160;
      return Image.asset(path, fit: fit, alignment: alignment, cacheWidth: px.clamp(160, 1280), gaplessPlayback: true, errorBuilder: (_, _, _) => placeholder);
    });
  }
}

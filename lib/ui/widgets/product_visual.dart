import 'package:flutter/material.dart';
import '../../data/products.dart';

/// Product photo, with a soft tinted placeholder while it loads or if it is missing.
class ProductImage extends StatelessWidget {
  final Product product;
  final int colorIndex;
  final BoxFit fit;
  final Alignment alignment;
  const ProductImage(this.product, {super.key, this.colorIndex = 0, this.fit = BoxFit.cover, this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(color: product.accent.withValues(alpha: 0.3));
    final path = product.image;
    if (path == null) return placeholder;
    return Image.asset(path, fit: fit, alignment: alignment, errorBuilder: (_, _, _) => placeholder);
  }
}

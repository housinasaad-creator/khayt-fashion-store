import 'package:flutter/material.dart';
import '../../data/products.dart';
import 'common.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final int? maxCols;
  const ProductGrid(this.products, {super.key, this.maxCols});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      var cols = w > 1000 ? 4 : (w > 700 ? 3 : 2);
      if (maxCols != null && cols > maxCols!) cols = maxCols!;
      final spacing = w < 700 ? 14.0 : 24.0;
      final cell = (w - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing + 8,
        children: [for (final p in products) SizedBox(width: cell, child: LazyMount(child: ProductCard(p)))],
      );
    });
  }
}

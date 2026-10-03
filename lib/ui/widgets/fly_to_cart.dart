import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../data/products.dart';
import 'product_visual.dart';

/// Launches a little thumbnail of [product] from [from] into the bag icon.
void flyToCart(AppState app, Product product, int colorIndex, Rect from) {
  final overlay = navKey.currentState?.overlay;
  final box = app.cartIconKey.currentContext?.findRenderObject();
  if (overlay == null || box is! RenderBox || !box.attached) return;
  final target = box.localToGlobal(Offset.zero) & box.size;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _Flyer(product: product, colorIndex: colorIndex, from: from, to: target, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _Flyer extends StatefulWidget {
  final Product product;
  final int colorIndex;
  final Rect from, to;
  final VoidCallback onDone;
  const _Flyer({required this.product, required this.colorIndex, required this.from, required this.to, required this.onDone});
  @override
  State<_Flyer> createState() => _FlyerState();
}

class _FlyerState extends State<_Flyer> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(milliseconds: 850))
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    })
    ..forward();

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.from.center, b = widget.to.center;
    final ctrl = Offset((a.dx + b.dx) / 2, math.min(a.dy, b.dy) - 140);
    final startSize = math.min(widget.from.width, widget.from.height).clamp(60.0, 190.0);
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(c.value);
        final x = math.pow(1 - t, 2) * a.dx + 2 * (1 - t) * t * ctrl.dx + t * t * b.dx;
        final y = math.pow(1 - t, 2) * a.dy + 2 * (1 - t) * t * ctrl.dy + t * t * b.dy;
        final size = startSize + (30 - startSize) * t;
        // Positioned must stay the direct child of the Overlay's Stack.
        return Positioned(
          left: x - size / 2,
          top: y - size / 2,
          width: size,
          height: size,
          child: IgnorePointer(
            child: Opacity(
              opacity: (1 - math.pow(t, 6)).toDouble().clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: t * 0.9,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14 + 20 * t),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 8))],
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(14 + 20 * t), child: ProductImage(widget.product, colorIndex: widget.colorIndex)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/products.dart';

/// Flat knit sweater illustration, tinted by [color]. Used wherever a small
/// stand-in for the 3D garment is needed (cards, cart, receipts).
class SweaterIllustration extends StatelessWidget {
  final Color color;
  final bool oversize;
  const SweaterIllustration({super.key, required this.color, this.oversize = false});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _SweaterPainter(color, oversize), child: const SizedBox.expand());
}

class _SweaterPainter extends CustomPainter {
  final Color color;
  final bool oversize;
  _SweaterPainter(this.color, this.oversize);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final dx = (size.width - s) / 2, dy = (size.height - s) / 2;
    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(s / 100);

    final bw = oversize ? 22.0 : 28.0;
    final path = Path()
      ..moveTo(39, 16)
      ..quadraticBezierTo(50, 26, 61, 16)
      ..lineTo(oversize ? 80 : 76, 22)
      ..lineTo(oversize ? 97 : 94, oversize ? 80 : 70)
      ..lineTo(oversize ? 84 : 82, oversize ? 85 : 76)
      ..lineTo(100 - bw, 50)
      ..lineTo(100 - bw, 88)
      ..lineTo(bw, 88)
      ..lineTo(bw, 50)
      ..lineTo(oversize ? 16 : 18, oversize ? 85 : 76)
      ..lineTo(oversize ? 3 : 6, oversize ? 80 : 70)
      ..lineTo(oversize ? 20 : 24, 22)
      ..close();

    canvas.drawShadow(path.shift(const Offset(0, 2)), Colors.black.withValues(alpha: 0.35), 3, false);
    canvas.drawPath(path, Paint()..color = color);

    canvas.save();
    canvas.clipPath(path);
    final dark = Paint()
      ..color = Colors.black.withValues(alpha: 0.13)
      ..strokeWidth = 0.55
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final light = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 0.55
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (oversize) {
      for (double x = 0; x < 100; x += 1.8) {
        canvas.drawLine(Offset(x, 10), Offset(x, 95), x % 3.6 < 1.8 ? dark : light);
      }
    } else {
      for (double y = 14; y < 92; y += 2.2) {
        for (double x = 2; x < 100; x += 2.2) {
          final ox = ((y / 2.2).round() & 1) == 1 ? 1.1 : 0.0;
          canvas.drawLine(Offset(x + ox, y), Offset(x + ox + 1.1, y + 1.6), dark);
          canvas.drawLine(Offset(x + ox + 2.2, y), Offset(x + ox + 1.1, y + 1.6), light);
        }
      }
    }
    // hem + cuffs
    final band = Paint()..color = Colors.black.withValues(alpha: 0.16);
    canvas.drawRect(Rect.fromLTWH(bw, 82, 100 - 2 * bw, 6), band);
    final c1 = Path()
      ..moveTo(oversize ? 84 : 82, oversize ? 85 : 76)
      ..lineTo(oversize ? 97 : 94, oversize ? 80 : 70)
      ..lineTo(oversize ? 94 : 91, oversize ? 74 : 64)
      ..lineTo(oversize ? 81 : 79, oversize ? 79 : 70)
      ..close();
    canvas.drawPath(c1, band);
    final c2 = Path()
      ..moveTo(oversize ? 16 : 18, oversize ? 85 : 76)
      ..lineTo(oversize ? 3 : 6, oversize ? 80 : 70)
      ..lineTo(oversize ? 6 : 9, oversize ? 74 : 64)
      ..lineTo(oversize ? 19 : 21, oversize ? 79 : 70)
      ..close();
    canvas.drawPath(c2, band);
    canvas.restore();

    // collar
    final collar = Path()
      ..moveTo(39, 16)
      ..quadraticBezierTo(50, 26, 61, 16)
      ..quadraticBezierTo(50, 11, 39, 16);
    canvas.drawPath(collar, Paint()..color = Colors.black.withValues(alpha: 0.22));
    canvas.drawPath(collar, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.6..color = Color.lerp(color, Colors.black, 0.2)!);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SweaterPainter old) => old.color != color || old.oversize != oversize;
}

/// Photo for real-photo products, tinted illustration for the 3D knits.
class ProductImage extends StatelessWidget {
  final Product product;
  final int colorIndex;
  final BoxFit fit;
  final Alignment alignment;
  const ProductImage(this.product, {super.key, this.colorIndex = 0, this.fit = BoxFit.cover, this.alignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    if (product.image != null) {
      return Image.asset(product.image!, fit: fit, alignment: alignment, errorBuilder: (_, _, _) => Container(color: product.accent.withValues(alpha: 0.3)));
    }
    final col = product.colors.isEmpty ? product.accent : product.colors[colorIndex.clamp(0, product.colors.length - 1)].color;
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(center: const Alignment(0, -0.2), radius: 1.0, colors: [Color.lerp(Colors.white, col, 0.18)!, Color.lerp(const Color(0xFFEFE7DA), col, 0.28)!]),
      ),
      padding: const EdgeInsets.all(18),
      child: SweaterIllustration(color: col, oversize: product.style == 'oversize'),
    );
  }
}

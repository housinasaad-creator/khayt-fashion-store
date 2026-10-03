import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../theme.dart';

class KhaytMark extends StatelessWidget {
  final double size;
  final Color color;
  final Color thread;
  const KhaytMark({super.key, this.size = 36, this.color = KColors.ink, this.thread = const Color(0xFFC4572F)});

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _MarkPainter(color, thread)));
}

class _MarkPainter extends CustomPainter {
  final Color color, thread;
  _MarkPainter(this.color, this.thread);

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final p = Path()
      ..moveTo(w * 0.26, w * 0.16)
      ..lineTo(w * 0.26, w * 0.84)
      ..moveTo(w * 0.26, w * 0.54)
      ..lineTo(w * 0.70, w * 0.16)
      ..moveTo(w * 0.40, w * 0.46)
      ..lineTo(w * 0.72, w * 0.84);
    canvas.drawPath(p, stroke);

    final th = Paint()
      ..color = thread
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeCap = StrokeCap.round;
    final t = Path()
      ..moveTo(w * 0.72, w * 0.84)
      ..cubicTo(w * 0.86, w * 0.98, w * 1.02, w * 0.80, w * 0.92, w * 0.66)
      ..cubicTo(w * 0.84, w * 0.55, w * 0.74, w * 0.66, w * 0.82, w * 0.74);
    canvas.drawPath(t, th);
    canvas.drawCircle(Offset(w * 0.70, w * 0.16), w * 0.045, Paint()..color = thread);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter old) => old.color != color || old.thread != thread;
}

class KhaytLogo extends StatelessWidget {
  final double size;
  final Color color;
  final Color thread;
  final bool compact;
  const KhaytLogo({super.key, this.size = 34, this.color = KColors.ink, this.thread = const Color(0xFFC4572F), this.compact = false});

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      KhaytMark(size: size, color: color, thread: thread),
      if (!compact) ...[
        SizedBox(width: size * 0.28),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(ar ? 'خيط' : 'KHAYT', style: KText.display(ar, ar ? size * 0.78 : size * 0.58, w: FontWeight.w800, color: color, h: 1.0, ls: ar ? 0 : size * 0.11)),
          Text(context.t('brandTag').toUpperCase(), style: KText.label(ar, color: color.withValues(alpha: 0.6), size: size * 0.24).copyWith(letterSpacing: ar ? 0 : 2.2)),
        ]),
      ],
    ]);
  }
}

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../../data/products.dart';
import '../theme.dart';
import 'product_visual.dart';

/// A clothes rail: garments hang from hangers and swing like a pendulum when
/// you drag, scroll or tap the arrows. The garment closest to the centre of
/// the rail reports itself through [onFocus] so the whole site can take its colour.
class HangerRail extends StatefulWidget {
  final List<Product> items;
  final ValueChanged<Product>? onFocus;
  const HangerRail({super.key, required this.items, this.onFocus});
  @override
  State<HangerRail> createState() => _HangerRailState();
}

class _HangerRailState extends State<HangerRail> with SingleTickerProviderStateMixin {
  final ScrollController sc = ScrollController();
  late final Ticker ticker;
  final ValueNotifier<double> swing = ValueNotifier<double>(0);
  double angle = 0, vel = 0, impulse = 0, lastPix = 0;
  Duration last = Duration.zero;
  int focusIdx = -1;
  double get itemW => Bp.mobile(context) ? 210 : 264;
  static const gap = 26.0;

  @override
  void initState() {
    super.initState();
    sc.addListener(_onScroll);
    ticker = createTicker(_tick);
  }

  @override
  void dispose() {
    ticker.dispose();
    sc.dispose();
    swing.dispose();
    super.dispose();
  }

  void _onScroll() {
    final px = sc.offset;
    impulse += px - lastPix;
    lastPix = px;
    if (!sc.hasClients) return;
    // the swing simulation only runs while the rail is moving
    if (!ticker.isActive) {
      last = Duration.zero;
      ticker.start();
    }
    final vw = sc.position.viewportDimension;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    var idx = ((px + vw / 2 - 20) / (itemW + gap)).floor().clamp(0, widget.items.length - 1);
    if (rtl) idx = idx; // list is already mirrored by the scrollable
    if (idx != focusIdx) {
      focusIdx = idx;
      widget.onFocus?.call(widget.items[idx]);
    }
  }

  void _tick(Duration t) {
    final dt = ((t - last).inMicroseconds / 1e6).clamp(0.0, 0.05);
    last = t;
    if (dt == 0) return;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final dir = rtl ? 1.0 : -1.0;
    vel += dir * impulse * 0.0042;
    impulse = 0;
    vel += (-angle * 52 - vel * 3.1) * dt;
    angle += vel * dt;
    angle = angle.clamp(-0.5, 0.5);
    if (angle.abs() < 0.0003 && vel.abs() < 0.0006) {
      if (swing.value != 0) swing.value = 0;
      angle = 0;
      vel = 0;
      ticker.stop();
      return;
    }
    swing.value = angle;
  }

  void _nudge(int dir) {
    if (!sc.hasClients) return;
    final target = (sc.offset + dir * (itemW + gap) * 2).clamp(0.0, sc.position.maxScrollExtent);
    sc.animateTo(target, duration: const Duration(milliseconds: 750), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Bp.mobile(context);
    final height = (itemW * 4 / 3) + 150;
    return Column(children: [
      SizedBox(
        height: height,
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            top: 16,
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF9A927F),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 6, offset: const Offset(0, 4))],
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad, PointerDeviceKind.stylus}, scrollbars: false),
            child: ListView.separated(
              controller: sc,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Bp.pad(context)),
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => const SizedBox(width: gap),
              itemBuilder: (context, i) => _Hanging(product: widget.items[i], index: i, width: itemW, swing: swing),
            ),
          ),
        ]),
      ),
      if (!mobile)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Bp.pad(context)),
          child: Row(children: [
            Text(context.t('dragRail'), style: KText.body(context.isAr, 13, color: KColors.muted)),
            const Spacer(),
            _Arrow(Icons.arrow_back_rounded, () => _nudge(context.isAr ? 1 : -1)),
            const SizedBox(width: 10),
            _Arrow(Icons.arrow_forward_rounded, () => _nudge(context.isAr ? -1 : 1)),
          ]),
        ),
    ]);
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Arrow(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => Material(
        color: KColors.ink,
        shape: const CircleBorder(),
        child: InkWell(customBorder: const CircleBorder(), onTap: onTap, child: Padding(padding: const EdgeInsets.all(12), child: Icon(icon, color: Colors.white, size: 20))),
      );
}

class _Hanging extends StatefulWidget {
  final Product product;
  final int index;
  final double width;
  final ValueNotifier<double> swing;
  const _Hanging({required this.product, required this.index, required this.width, required this.swing});
  @override
  State<_Hanging> createState() => _HangingState();
}

class _HangingState extends State<_Hanging> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final p = widget.product;
    final imgH = widget.width * 4 / 3;
    final stagger = 1 + 0.07 * (widget.index % 4);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () => Go.product(p.id),
        child: ValueListenableBuilder<double>(
          valueListenable: widget.swing,
          builder: (context, a, child) => Transform.rotate(angle: a * stagger + (hover ? 0.02 : 0), alignment: Alignment.topCenter, child: child),
          child: SizedBox(
            width: widget.width,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 6),
              Center(child: SizedBox(width: 96, height: 50, child: CustomPaint(painter: _HangerPainter()))),
              Container(
                height: imgH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: p.accent.withValues(alpha: hover ? 0.5 : 0.28), blurRadius: hover ? 34 : 20, offset: const Offset(0, 16))],
                ),
                child: ClipRRect(borderRadius: BorderRadius.circular(14), child: ProductImage(p)),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: p.accent, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(p.name(ar), maxLines: 1, overflow: TextOverflow.ellipsis, style: KText.body(ar, 15, w: FontWeight.w700))),
              ]),
              const SizedBox(height: 2),
              Text(money0(p.price), style: KText.body(ar, 14, color: KColors.muted, w: FontWeight.w600)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _HangerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0xFF9C7A52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final cx = s.width / 2;
    // hook
    final hook = Path()
      ..moveTo(cx, 18)
      ..lineTo(cx, 11)
      ..cubicTo(cx, 3, cx + 9, 1, cx + 9, -5 + 9)
      ..cubicTo(cx + 9, 14, cx + 2, 15, cx, 11);
    canvas.drawPath(Path()..moveTo(cx, 20)..lineTo(cx, 12)..arcToPoint(Offset(cx + 7, 4), radius: const Radius.circular(8), clockwise: false), p);
    // shoulders
    final sh = Path()
      ..moveTo(cx, 20)
      ..lineTo(5, s.height - 4)
      ..lineTo(s.width - 5, s.height - 4)
      ..close();
    canvas.drawPath(sh, p);
    canvas.drawPath(hook, Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

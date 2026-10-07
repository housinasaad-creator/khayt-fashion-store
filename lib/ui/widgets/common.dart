import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import '../../core/app_state.dart';
import '../../core/strings.dart';
import '../theme.dart';

class KButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool outline;
  final bool dark;
  final IconData? icon;
  final bool expand;
  final double height;
  const KButton({super.key, required this.label, this.onTap, this.outline = false, this.dark = false, this.icon, this.expand = false, this.height = 52});

  @override
  State<KButton> createState() => _KButtonState();
}

class _KButtonState extends State<KButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final accent = context.app.accent;
    final disabled = widget.onTap == null;
    final Color bg = widget.outline
        ? (_hover ? KColors.ink : Colors.transparent)
        : (_hover ? Color.lerp(KColors.ink, accent, 0.85)! : (widget.dark ? Colors.white : KColors.ink));
    final Color fg = widget.outline
        ? (_hover ? Colors.white : (widget.dark ? Colors.white : KColors.ink))
        : (widget.dark && !_hover ? KColors.ink : Colors.white);
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      transform: Matrix4.identity()..scaleByDouble(_down ? 0.97 : 1.0, _down ? 0.97 : 1.0, 1.0, 1.0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: disabled ? KColors.line : bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: widget.outline ? (widget.dark ? Colors.white : KColors.ink) : Colors.transparent, width: 1.4),
      ),
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[Icon(widget.icon, size: 18, color: fg), const SizedBox(width: 10)],
          Flexible(child: Text(widget.label, overflow: TextOverflow.ellipsis, style: KText.body(ar, 15, w: FontWeight.w700, color: disabled ? KColors.muted : fg, ls: ar ? 0 : 0.3))),
        ],
      ),
    );
    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onTap,
        child: child,
      ),
    );
  }
}

class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delayMs;
  final Offset from;
  const FadeSlideIn({super.key, required this.child, this.delayMs = 0, this.from = const Offset(0, 24)});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 650 + delayMs),
      curve: Interval(delayMs / (650 + delayMs), 1, curve: Curves.easeOutCubic),
      builder: (_, v, c) => Opacity(opacity: v, child: Transform.translate(offset: Offset(from.dx * (1 - v), from.dy * (1 - v)), child: c)),
      child: child,
    );
  }
}

class Stars extends StatelessWidget {
  final double rating;
  final double size;
  const Stars(this.rating, {super.key, this.size = 14});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) {
      final v = rating - i;
      return Icon(v >= 1 ? Icons.star_rounded : (v >= 0.5 ? Icons.star_half_rounded : Icons.star_outline_rounded), size: size, color: const Color(0xFFE0A526));
    }));
  }
}

class Badge3 extends StatelessWidget {
  final String text;
  final Color color;
  final Color fg;
  const Badge3(this.text, {super.key, this.color = KColors.ink, this.fg = Colors.white});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: KText.label(ar, color: fg, size: 10.5).copyWith(letterSpacing: ar ? 0 : 1.1)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? sub;
  final Widget? trailing;
  const SectionTitle({super.key, required this.eyebrow, required this.title, this.sub, this.trailing});

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ar ? eyebrow : eyebrow.toUpperCase(), style: KText.label(ar, color: context.app.accent, size: 12)),
          const SizedBox(height: 8),
          Text(title, style: KText.display(ar, mobile ? 30 : 44)),
          if (sub != null) ...[
            const SizedBox(height: 10),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: Text(sub!, style: KText.body(ar, 15.5, color: KColors.muted))),
          ],
        ]),
      ),
      ?trailing,
    ]);
  }
}

/// Floating toast that stays compact on wide screens and fits phones.
void showToast(BuildContext context, String text, {SnackBarAction? action}) {
  final w = MediaQuery.sizeOf(context).width;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(text),
      action: action,
      width: w > 520 ? 440 : w - 32,
      duration: const Duration(milliseconds: 3200),
      persist: false,
    ));
}

/// Keeps a page section in memory only while it is near the screen.
/// Farther than [margin] viewport heights above or below, the section is replaced by an empty box
/// of exactly the same height (so the scroll position never jumps) and its photos are released;
/// it is rebuilt when the visitor scrolls back toward it.
class LazyMount extends StatefulWidget {
  final Widget child;
  final double margin;
  const LazyMount({super.key, required this.child, this.margin = 1.0});

  @override
  State<LazyMount> createState() => _LazyMountState();
}

class _LazyMountState extends State<LazyMount> {
  ScrollPosition? _pos;
  double _h = 0;
  bool _alive = true;
  String _sig = '';
  static Timer? _purge;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    final sig = '${size.width.round()}|${Localizations.localeOf(context)}|${Directionality.of(context)}';
    if (sig != _sig) {
      // the layout may have changed while this section was away: measure it again from scratch
      final first = _sig.isEmpty;
      _sig = sig;
      if (!first && !_alive) _alive = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    }
    final p = Scrollable.maybeOf(context)?.position;
    if (p != _pos) {
      _pos?.removeListener(_check);
      _pos = p;
      _pos?.addListener(_check);
      WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    }
  }

  @override
  void dispose() {
    _pos?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted) return;
    final pos = _pos;
    final ro = context.findRenderObject();
    if (pos == null || ro is! RenderBox || !ro.attached || !ro.hasSize) return;
    final viewport = RenderAbstractViewport.maybeOf(ro);
    if (viewport == null) return;
    final vh = pos.viewportDimension;
    double top, bottom;
    try {
      top = viewport.getOffsetToReveal(ro, 0.0).offset - pos.pixels;
      bottom = top + ro.size.height;
    } catch (_) {
      return; // a neighbouring section is mid-rebuild and not laid out yet; the next scroll tick measures again
    }
    final near = bottom > -vh * widget.margin && top < vh * (1 + widget.margin);
    if (_alive) _h = ro.size.height;
    if (near == _alive) return;
    void apply() {
      if (!mounted) return;
      setState(() => _alive = near);
      if (!near) {
        // let the decoded copies of the photos that just left go right away
        _purge?.cancel();
        _purge = Timer(const Duration(milliseconds: 500), () => PaintingBinding.instance.imageCache.clear());
      }
    }
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  @override
  Widget build(BuildContext context) => _alive ? widget.child : SizedBox(height: _h);
}

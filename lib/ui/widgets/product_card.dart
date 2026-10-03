import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../../data/products.dart';
import '../theme.dart';
import 'common.dart';
import 'fly_to_cart.dart';
import 'product_visual.dart';

/// Product card with pointer-follow tilt, a hanging-tag flip to the back
/// (details + size picker + quick add) and a fly-to-bag animation.
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard(this.product, {super.key});
  static double heightFor(double width) => width * 4 / 3 + 100;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hover = false;
  bool flipped = false;
  Offset tilt = Offset.zero; // -0.5 .. 0.5
  String? size;

  Product get p => widget.product;

  void _quickAdd(BuildContext ctx) {
    final app = ctx.appRead;
    if (p.sizes.length > 1 && size == null) {
      setState(() => flipped = true);
      return;
    }
    final s = size ?? p.sizes.first;
    final box = ctx.findRenderObject() as RenderBox;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    app.addToCart(p, size: s);
    flyToCart(app, p, 0, rect);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final h = c.hasBoundedHeight ? c.maxHeight : ProductCard.heightFor(c.maxWidth);
        return SizedBox(height: h, child: _interactive(context));
      },
    );
  }

  Widget _interactive(BuildContext context) {
    final ar = context.isAr;
    final angle = flipped ? math.pi : 0.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() {
        hover = false;
        tilt = Offset.zero;
      }),
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null || flipped) return;
        setState(() => tilt = Offset((e.localPosition.dx / box.size.width) - 0.5, (e.localPosition.dy / box.size.height) - 0.5));
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: angle),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
        builder: (context, a, _) {
          final showBack = a > math.pi / 2;
          final tx = flipped ? 0.0 : tilt.dy * -0.18;
          final ty = flipped ? 0.0 : tilt.dx * 0.22;
          final m = Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(tx)
            ..rotateY(a + ty);
          return AnimatedScale(
            scale: hover && !flipped ? 1.025 : 1,
            duration: const Duration(milliseconds: 220),
            child: Transform(
              alignment: Alignment.center,
              transform: m,
              child: showBack ? Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: _back(context, ar)) : _front(context, ar),
            ),
          );
        },
      ),
    );
  }

  Widget _front(BuildContext context, bool ar) {
    return GestureDetector(
      onTap: () => Go.product(p.id),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(fit: StackFit.expand, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: KColors.card,
                boxShadow: [BoxShadow(color: p.accent.withValues(alpha: hover ? 0.38 : 0.16), blurRadius: hover ? 30 : 14, offset: Offset(0, hover ? 16 : 7))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AnimatedScale(scale: hover ? 1.06 : 1.0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut, child: ProductImage(p)),
              ),
            ),
            PositionedDirectional(
              top: 12,
              start: 12,
              child: Wrap(spacing: 6, children: [
                if (p.isNew) Badge3(context.t('newBadge'), color: Colors.white, fg: KColors.ink),
                if (p.onSale) Badge3(context.t('sale'), color: KColors.danger),
              ]),
            ),
            PositionedDirectional(
              top: 8,
              end: 8,
              child: Tooltip(
                message: context.t('flip'),
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: InkWell(customBorder: const CircleBorder(), onTap: () => setState(() => flipped = true), child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.flip_rounded, size: 18))),
                ),
              ),
            ),
            PositionedDirectional(
              start: 12,
              end: 12,
              bottom: 12,
              child: AnimatedSlide(
                offset: Offset(0, hover || Bp.mobile(context) ? 0 : 1.4),
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: hover || Bp.mobile(context) ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Bp.mobile(context)
                      ? Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Tooltip(
                            message: context.t('quickAdd'),
                            child: Material(
                              color: KColors.ink,
                              elevation: 3,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => _quickAdd(context),
                                child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 20)),
                              ),
                            ),
                          ),
                        )
                      : KButton(label: context.t('quickAdd'), icon: Icons.add_shopping_cart_rounded, expand: true, height: 44, onTap: () => _quickAdd(context)),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        Expanded(child: ClipRect(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Text(p.name(ar), maxLines: 2, overflow: TextOverflow.ellipsis, style: KText.body(ar, 15.5, w: FontWeight.w700))),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(money0(p.price), style: KText.body(ar, 15.5, w: FontWeight.w800)),
            if (p.oldPrice != null) Text(money0(p.oldPrice!), style: KText.body(ar, 12.5, color: KColors.muted).copyWith(decoration: TextDecoration.lineThrough)),
          ]),
        ]),
        const SizedBox(height: 4),
        Row(children: [Stars(p.rating, size: 13), const SizedBox(width: 6), Text('(${p.reviews})', style: KText.body(ar, 12, color: KColors.muted))]),
        ]))),
      ]),
    );
  }

  Widget _back(BuildContext context, bool ar) {
    final accent = context.app.accent;
    return Container(
      decoration: BoxDecoration(color: KColors.ink, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: p.accent.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 14))]),
      padding: const EdgeInsets.all(18),
      child: LayoutBuilder(builder: (context, c) {
        final tiny = c.maxHeight < 340;
        final compact = c.maxHeight < 420;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p.name(ar), style: KText.display(ar, 18, color: Colors.white, h: 1.15), maxLines: 2, overflow: TextOverflow.ellipsis)),
            InkWell(onTap: () => setState(() => flipped = false), borderRadius: BorderRadius.circular(99), child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close_rounded, color: Colors.white, size: 20))),
          ]),
          if (!tiny) ...[
            const SizedBox(height: 8),
            Flexible(child: Text(p.desc(ar), maxLines: compact ? 3 : 5, overflow: TextOverflow.ellipsis, style: KText.body(ar, 12.8, color: Colors.white.withValues(alpha: 0.75)))),
            if (!compact) ...[
              const SizedBox(height: 10),
              Text(p.fabric(ar), maxLines: 2, overflow: TextOverflow.ellipsis, style: KText.body(ar, 11.5, color: Colors.white.withValues(alpha: 0.5))),
            ],
          ],
          const Spacer(),
          Text(ar ? context.t('size') : context.t('size').toUpperCase(), style: KText.label(ar, color: Colors.white.withValues(alpha: 0.55), size: 11)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final s in p.sizes)
              InkWell(
                onTap: () => setState(() => size = s),
                borderRadius: BorderRadius.circular(99),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: size == s ? accent : Colors.transparent,
                    border: Border.all(color: size == s ? accent : Colors.white.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(s, style: KText.body(ar, 12.5, w: FontWeight.w700, color: Colors.white)),
                ),
              ),
          ]),
          const SizedBox(height: 14),
          KButton(label: '${context.t('addToBag')} · ${money0(p.price)}', dark: true, expand: true, height: 44, onTap: () => _quickAdd(context)),
          if (!tiny) ...[
            const SizedBox(height: 6),
            Center(child: TextButton(onPressed: () => Go.product(p.id), child: Text(context.t('viewDetails'), style: KText.body(ar, 13, color: Colors.white.withValues(alpha: 0.8), w: FontWeight.w600)))),
          ],
        ]);
      }),
    );
  }
}

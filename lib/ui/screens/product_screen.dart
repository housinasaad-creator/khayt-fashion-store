import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../../data/products.dart';
import '../theme.dart';
import '../widgets/cart_panel.dart';
import '../widgets/common.dart';
import '../widgets/fly_to_cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_visual.dart';
import '../widgets/shell.dart';
import '../widgets/viewer3d.dart';

class ProductScreen extends StatefulWidget {
  final String id;
  const ProductScreen({super.key, required this.id});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final Product? p = productById(widget.id);
  int colorIdx = 0;
  String? size;
  int qty = 1;
  int gallery = 0;
  Offset zoomPos = const Offset(0.5, 0.5);
  bool zooming = false;
  final galleryKey = GlobalKey();

  static const crops = [
    (1.0, Alignment.center),
    (1.8, Alignment.topCenter),
    (1.8, Alignment.bottomCenter),
  ];

  @override
  void initState() {
    super.initState();
    final pr = p;
    if (pr != null) {
      if (pr.sizes.length == 1) size = pr.sizes.first;
      if (pr.is3d) colorIdx = pr.id == 'heritage-crew' ? 1 : 3;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.appRead.setAccent(pr.is3d ? pr.colors[colorIdx].color : pr.accent);
      });
    }
  }

  void _add({bool buyNow = false}) {
    final pr = p!;
    final ar = context.isAr;
    if (size == null) {
      showToast(context, context.t('selectSize'));
      return;
    }
    final app = context.appRead;
    app.addToCart(pr, size: size!, colorIndex: colorIdx, qty: qty);
    final box = galleryKey.currentContext?.findRenderObject();
    if (box is RenderBox && box.attached) {
      flyToCart(app, pr, colorIdx, box.localToGlobal(Offset.zero) & box.size);
    }
    if (buyNow) {
      Go.push('/checkout');
    } else {
      showToast(context, '${context.t('addedToBag')}: ${pr.name(ar)}', action: SnackBarAction(label: context.t('bag'), textColor: Colors.white, onPressed: Go.openCart));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pr = p;
    final ar = context.isAr;
    if (pr == null) {
      return PageBody(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Center(child: Column(children: [
            Text(context.t('productNotFound'), style: KText.display(ar, 30)),
            const SizedBox(height: 20),
            KButton(label: context.t('backToShop'), onTap: () => Go.top('/shop')),
          ])),
        ),
      ]);
    }
    final mobile = Bp.mobile(context);
    final accent = context.app.accent;
    final colorName = pr.colors.isEmpty ? null : (ar ? pr.colors[colorIdx].ar : pr.colors[colorIdx].en);
    final related = kProducts.where((x) => x.id != pr.id && x.cats.any(pr.cats.contains)).take(4).toList();

    final galleryW = pr.is3d ? _viewer(context, pr, accent) : _photo(context, pr);
    final info = _info(context, pr, ar, mobile, accent, colorName);

    return PageBody(children: [
      Constrained(
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 18 : 30, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            InkWell(onTap: () => Go.top('/shop'), child: Text(context.t('shop'), style: KText.body(ar, 13.5, color: KColors.muted, w: FontWeight.w600))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(ar ? Icons.chevron_left_rounded : Icons.chevron_right_rounded, size: 18, color: KColors.muted)),
            Flexible(child: Text(pr.name(ar), overflow: TextOverflow.ellipsis, style: KText.body(ar, 13.5, w: FontWeight.w700))),
          ]),
          SizedBox(height: mobile ? 18 : 30),
          mobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [galleryW, const SizedBox(height: 26), info])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 11, child: galleryW), const SizedBox(width: 56), Expanded(flex: 10, child: info)]),
        ]),
      ),
      const SizedBox(height: 90),
      Constrained(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(eyebrow: context.t('shop'), title: context.t('youMayLike')),
          const SizedBox(height: 26),
          ProductGrid(related, maxCols: 4),
        ]),
      ),
    ]);
  }

  // ----------------------------------------------------------- 3D viewer
  Widget _viewer(BuildContext context, Product pr, Color accent) {
    final ar = context.isAr;
    final col = pr.colors[colorIdx];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AspectRatio(
        aspectRatio: 1,
        child: Container(
          key: galleryKey,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: RadialGradient(center: const Alignment(0, -0.1), radius: 0.95, colors: [Color.lerp(Colors.white, col.color, 0.30)!, Color.lerp(KColors.bg, col.color, 0.30)!]),
            boxShadow: [BoxShadow(color: col.color.withValues(alpha: 0.30), blurRadius: 50, offset: const Offset(0, 24))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(fit: StackFit.expand, children: [
              Viewer3D(key: ValueKey('pv-${pr.id}'), style: pr.style, color: col.color),
              PositionedDirectional(top: 18, start: 18, child: Badge3('3D', color: accent)),
              PositionedDirectional(
                bottom: 16,
                start: 0,
                end: 0,
                child: Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(99)), child: Text(context.t('dragHint'), style: KText.body(ar, 12.5, w: FontWeight.w600)))),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }

  // -------------------------------------------------------- photo gallery
  Widget _photo(BuildContext context, Product pr) {
    final ar = context.isAr;
    final crop = crops[gallery];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AspectRatio(
        aspectRatio: 4 / 5,
        child: MouseRegion(
          onEnter: (_) => setState(() => zooming = true),
          onExit: (_) => setState(() => zooming = false),
          onHover: (e) {
            final box = galleryKey.currentContext?.findRenderObject() as RenderBox?;
            if (box == null) return;
            setState(() => zoomPos = Offset((e.localPosition.dx / box.size.width).clamp(0, 1), (e.localPosition.dy / box.size.height).clamp(0, 1)));
          },
          child: Container(
            key: galleryKey,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: pr.accent.withValues(alpha: 0.32), blurRadius: 50, offset: const Offset(0, 24))]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(fit: StackFit.expand, children: [
                AnimatedScale(
                  scale: zooming ? crop.$1 * 1.7 : crop.$1,
                  alignment: zooming ? Alignment(zoomPos.dx * 2 - 1, zoomPos.dy * 2 - 1) : crop.$2,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                  child: ProductImage(pr),
                ),
                PositionedDirectional(top: 18, start: 18, child: Wrap(spacing: 6, children: [if (pr.isNew) Badge3(context.t('newBadge'), color: Colors.white, fg: KColors.ink), if (pr.onSale) Badge3(context.t('sale'), color: KColors.danger)])),
                if (!Bp.mobile(context)) PositionedDirectional(bottom: 14, start: 18, child: Badge3(context.t('zoomHint'), color: Colors.black.withValues(alpha: 0.5))),
              ]),
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Row(children: [
        for (var i = 0; i < crops.length; i++)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: GestureDetector(
              onTap: () => setState(() => gallery = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 78,
                height: 96,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: gallery == i ? KColors.ink : Colors.transparent, width: 2)),
                padding: const EdgeInsets.all(2),
                child: ClipRRect(borderRadius: BorderRadius.circular(11), child: ClipRect(child: Transform.scale(scale: crops[i].$1, alignment: crops[i].$2, child: SizedBox.expand(child: ProductImage(pr))))),
              ),
            ),
          ),
        const SizedBox(width: 4),
        Text(i18nDetail(ar), style: KText.body(ar, 12.5, color: KColors.muted)),
      ]),
    ]);
  }

  String i18nDetail(bool ar) => ar ? 'عدة زوايا' : 'Detail crops';

  // ---------------------------------------------------------------- info
  Widget _info(BuildContext context, Product pr, bool ar, bool mobile, Color accent, String? colorName) {
    Widget label(String t, {String? trailing}) => Row(children: [
          Text(ar ? t : t.toUpperCase(), style: KText.label(ar, color: KColors.muted, size: 11.5)),
          if (trailing != null) ...[const SizedBox(width: 10), Text(trailing, style: KText.body(ar, 13.5, w: FontWeight.w700))],
        ]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Stars(pr.rating, size: 17),
        const SizedBox(width: 8),
        Text('${pr.rating}  ·  ${pr.reviews} ${context.t('reviews')}', style: KText.body(ar, 13.5, color: KColors.muted, w: FontWeight.w600)),
      ]),
      const SizedBox(height: 12),
      Text(pr.name(ar), style: KText.display(ar, mobile ? 34 : 50, h: 1.05)),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(money(pr.price), style: KText.display(ar, 34, w: FontWeight.w700)),
        if (pr.oldPrice != null) ...[
          const SizedBox(width: 12),
          Text(money(pr.oldPrice!), style: KText.body(ar, 18, color: KColors.muted).copyWith(decoration: TextDecoration.lineThrough)),
          const SizedBox(width: 12),
          Badge3('-${(100 - pr.price / pr.oldPrice! * 100).round()}%', color: KColors.danger),
        ],
      ]),
      const SizedBox(height: 18),
      Text(pr.desc(ar), style: KText.body(ar, 16, color: KColors.muted)),
      const SizedBox(height: 26),
      if (pr.colors.isNotEmpty) ...[
        label(context.t('color'), trailing: colorName),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 12, children: [
          for (var i = 0; i < pr.colors.length; i++)
            Tooltip(
              message: ar ? pr.colors[i].ar : pr.colors[i].en,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => colorIdx = i);
                    context.appRead.setAccent(pr.colors[i].color);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(3),
                    transform: Matrix4.identity()..scaleByDouble(colorIdx == i ? 1.12 : 1.0, colorIdx == i ? 1.12 : 1.0, 1.0, 1.0),
                    transformAlignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colorIdx == i ? KColors.ink : Colors.transparent, width: 2)),
                    child: Container(decoration: BoxDecoration(color: pr.colors[i].color, shape: BoxShape.circle, border: Border.all(color: Colors.black.withValues(alpha: 0.12)))),
                  ),
                ),
              ),
            ),
        ]),
        const SizedBox(height: 26),
      ],
      label(context.t('size'), trailing: size),
      const SizedBox(height: 12),
      Wrap(spacing: 10, runSpacing: 10, children: [
        for (final s in pr.sizes)
          GestureDetector(
            onTap: () => setState(() => size = s),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: const BoxConstraints(minWidth: 54),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(color: size == s ? KColors.ink : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: size == s ? KColors.ink : KColors.line)),
                child: Text(s, textAlign: TextAlign.center, style: KText.body(ar, 14.5, w: FontWeight.w700, color: size == s ? Colors.white : KColors.ink)),
              ),
            ),
          ),
      ]),
      const SizedBox(height: 26),
      if (mobile) ...[
        Row(children: [
          Stepper2(qty: qty, onChanged: (v) => setState(() => qty = v.clamp(1, 10)), size: 44),
          const Spacer(),
          Text(money(pr.price * qty), style: KText.display(ar, 28)),
        ]),
        const SizedBox(height: 14),
        KButton(label: context.t('addToBag'), icon: Icons.shopping_bag_outlined, expand: true, onTap: () => _add()),
      ] else
        Row(children: [
          Stepper2(qty: qty, onChanged: (v) => setState(() => qty = v.clamp(1, 10)), size: 44),
          const SizedBox(width: 14),
          Expanded(child: KButton(label: '${context.t('addToBag')}  ·  ${money(pr.price * qty)}', icon: Icons.shopping_bag_outlined, expand: true, onTap: () => _add())),
        ]),
      const SizedBox(height: 12),
      KButton(label: context.t('buyNow'), outline: true, expand: true, onTap: () => _add(buyNow: true)),
      const SizedBox(height: 16),
      Row(children: [
        const Icon(Icons.verified_outlined, size: 18, color: KColors.ok),
        const SizedBox(width: 8),
        Text('${context.t('inStock')}  ·  ${context.t('freeShipOver')}', style: KText.body(ar, 13, color: KColors.muted, w: FontWeight.w600)),
      ]),
      const SizedBox(height: 28),
      _Acc(title: context.t('details'), body: pr.desc(ar)),
      _Acc(title: context.t('fabricCare'), body: pr.fabric(ar)),
      _Acc(title: context.t('shippingReturns'), body: context.t('shipReturnText')),
    ]);
  }
}

class _Acc extends StatelessWidget {
  final String title;
  final String body;
  const _Acc({required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: KColors.line))),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(title, style: KText.body(ar, 15.5, w: FontWeight.w700)),
          children: [Align(alignment: AlignmentDirectional.centerStart, child: Text(body, style: KText.body(ar, 14.5, color: KColors.muted)))],
        ),
      ),
    );
  }
}

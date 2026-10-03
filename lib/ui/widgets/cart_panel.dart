import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../theme.dart';
import 'common.dart';
import 'product_visual.dart';

class CartPanel extends StatefulWidget {
  final bool inDrawer;
  const CartPanel({super.key, this.inDrawer = false});
  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  final promoCtl = TextEditingController();
  String? promoMsg;
  bool promoOk = false;

  @override
  void dispose() {
    promoCtl.dispose();
    super.dispose();
  }

  void _apply() {
    final ok = context.appRead.applyPromo(promoCtl.text);
    setState(() {
      promoOk = ok;
      promoMsg = ok ? context.t('promoApplied') : context.t('promoInvalid');
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final ar = app.isAr;
    final accent = app.accent;
    final pad = widget.inDrawer ? 20.0 : 0.0;

    if (app.cart.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(pad == 0 ? 8 : 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (widget.inDrawer) Align(alignment: AlignmentDirectional.topEnd, child: IconButton(onPressed: Go.closeDrawers, icon: const Icon(Icons.close_rounded))),
          const Spacer(),
          Icon(Icons.shopping_bag_outlined, size: 72, color: accent.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(context.t('emptyBag'), style: KText.display(ar, 26)),
          const SizedBox(height: 8),
          Text(context.t('emptyBagSub'), textAlign: TextAlign.center, style: KText.body(ar, 15, color: KColors.muted)),
          const SizedBox(height: 24),
          KButton(
            label: context.t('continueShopping'),
            onTap: () {
              Go.closeDrawers();
              Go.top('/shop');
            },
          ),
          const Spacer(),
          const Spacer(),
        ]),
      );
    }

    final toFree = 120 - (app.subtotal - app.discount);
    final progress = ((app.subtotal - app.discount) / 120).clamp(0.0, 1.0);

    final lines = [
      for (final l in app.cart) _LineTile(line: l),
    ];

    final summary = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: TextField(
              controller: promoCtl,
              textCapitalization: TextCapitalization.characters,
              onSubmitted: (_) => _apply(),
              style: KText.body(ar, 14.5),
              decoration: InputDecoration(
                hintText: context.t('promoCode'),
                hintStyle: KText.body(ar, 14, color: KColors.muted),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KColors.line)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KColors.line)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(height: 46, child: KButton(label: context.t('apply'), onTap: _apply, outline: true, height: 46)),
      ]),
      if (promoMsg != null || app.promo != null) ...[
        const SizedBox(height: 8),
        Text(app.promo != null ? context.t('promoApplied') : promoMsg!, style: KText.body(ar, 13, color: (app.promo != null || promoOk) ? KColors.ok : KColors.danger, w: FontWeight.w600)),
      ],
      const SizedBox(height: 18),
      _row(context, context.t('subtotal'), money(app.subtotal)),
      if (app.discount > 0) _row(context, context.t('discount'), '-${money(app.discount)}', color: KColors.ok),
      _row(context, context.t('shippingLabel'), app.shipping == 0 ? context.t('free') : money(app.shipping)),
      _row(context, context.t('tax'), money(app.tax)),
      const Divider(height: 26, color: KColors.line),
      _row(context, context.t('total'), money(app.total), big: true),
      const SizedBox(height: 18),
      KButton(
        label: context.t('checkout'),
        icon: Icons.lock_outline_rounded,
        expand: true,
        onTap: () {
          Go.closeDrawers();
          Go.push('/checkout');
        },
      ),
      if (widget.inDrawer) ...[
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Go.closeDrawers();
            Go.push('/cart');
          },
          child: Text(context.t('viewFullBag'), style: KText.body(ar, 14, w: FontWeight.w700, color: KColors.muted)),
        ),
      ],
    ]);

    final freeShip = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(toFree <= 0 ? context.t('freeShipDone') : context.t('freeShipLeft').replaceAll('X', toFree.toStringAsFixed(0)), style: KText.body(ar, 13.5, w: FontWeight.w700)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (_, v, _) => LinearProgressIndicator(value: v, minHeight: 6, backgroundColor: Colors.white, color: accent),
          ),
        ),
      ]),
    );

    if (widget.inDrawer) {
      return Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(pad, 12, 8, 8),
          child: Row(children: [
            Expanded(child: Text('${context.t('yourBag')} (${app.count})', style: KText.display(ar, 24))),
            IconButton(onPressed: Go.closeDrawers, icon: const Icon(Icons.close_rounded)),
          ]),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: pad), child: freeShip),
        Expanded(child: ListView(padding: EdgeInsets.symmetric(horizontal: pad, vertical: 8), children: lines)),
        Container(
          padding: EdgeInsets.fromLTRB(pad, 14, pad, 18),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: KColors.line)), color: KColors.card),
          child: summary,
        ),
      ]);
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      freeShip,
      const SizedBox(height: 12),
      ...lines,
      const SizedBox(height: 20),
      summary,
    ]);
  }

  Widget _row(BuildContext context, String a, String b, {bool big = false, Color? color}) {
    final ar = context.isAr;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(a, style: KText.body(ar, big ? 17 : 14.5, w: big ? FontWeight.w700 : FontWeight.w500, color: big ? KColors.ink : KColors.muted))),
        Text(b, style: KText.body(ar, big ? 20 : 14.5, w: big ? FontWeight.w800 : FontWeight.w600, color: color ?? KColors.ink)),
      ]),
    );
  }
}

class _LineTile extends StatelessWidget {
  final CartLine line;
  const _LineTile({required this.line});

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final p = line.product;
    final colorName = line.colorName(ar);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Go.closeDrawers();
              Go.product(p.id);
            },
            child: ClipRRect(borderRadius: BorderRadius.circular(12), child: SizedBox(width: 78, height: 98, child: ProductImage(p, colorIndex: line.colorIndex))),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name(ar), style: KText.body(ar, 15, w: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text([line.size, if (colorName.isNotEmpty) colorName].join('  ·  '), style: KText.body(ar, 12.5, color: KColors.muted)),
            const SizedBox(height: 10),
            Row(children: [
              _Stepper(qty: line.qty, onChanged: (q) => context.appRead.setQty(line, q)),
              const Spacer(),
              Text(money(line.total), style: KText.body(ar, 15.5, w: FontWeight.w800)),
            ]),
          ]),
        ),
        const SizedBox(width: 4),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => context.appRead.remove(line),
          icon: const Icon(Icons.close_rounded, size: 18, color: KColors.muted),
        ),
      ]),
    );
  }
}

class Stepper2 extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  final double size;
  const Stepper2({super.key, required this.qty, required this.onChanged, this.size = 34});
  @override
  Widget build(BuildContext context) => _Stepper(qty: qty, onChanged: onChanged, size: size);
}

class _Stepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChanged;
  final double size;
  const _Stepper({required this.qty, required this.onChanged, this.size = 32});
  @override
  Widget build(BuildContext context) {
    Widget b(IconData i, VoidCallback f) => InkWell(
          onTap: f,
          borderRadius: BorderRadius.circular(99),
          child: SizedBox(width: size, height: size, child: Icon(i, size: 17)),
        );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: KColors.line), borderRadius: BorderRadius.circular(99), color: Colors.white),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        b(Icons.remove_rounded, () => onChanged(qty - 1)),
        SizedBox(width: 26, child: Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
        b(Icons.add_rounded, () => onChanged(qty + 1)),
      ]),
    );
  }
}

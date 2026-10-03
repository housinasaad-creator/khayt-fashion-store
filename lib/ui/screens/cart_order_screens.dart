import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../theme.dart';
import '../widgets/card_marks.dart';
import '../widgets/cart_panel.dart';
import '../widgets/common.dart';
import '../widgets/product_visual.dart';
import '../widgets/shell.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    return PageBody(children: [
      Constrained(
        max: 860,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 24 : 44, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(context.t('yourBag'), style: KText.display(ar, mobile ? 34 : 52)),
          const SizedBox(height: 26),
          const CartPanel(),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => Go.top('/shop'),
              icon: Icon(ar ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded, size: 18),
              label: Text(context.t('continueShopping'), style: KText.body(ar, 14.5, w: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    ]);
  }
}

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({super.key});
  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.appRead.setAccent(KColors.ok);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final ar = app.isAr;
    final o = app.lastOrder;
    final mobile = Bp.mobile(context);
    if (o == null) {
      return PageBody(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Center(child: Column(children: [
            Text(context.t('noOrder'), style: KText.display(ar, 26)),
            const SizedBox(height: 20),
            KButton(label: context.t('backHome'), onTap: () => Go.top('/')),
          ])),
        ),
      ]);
    }
    return PageBody(children: [
      Constrained(
        max: 820,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (_, v, _) => Transform.scale(
                scale: v.clamp(0.0, 1.2),
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(color: KColors.ok, shape: BoxShape.circle, boxShadow: [BoxShadow(color: KColors.ok.withValues(alpha: 0.35), blurRadius: 36, offset: const Offset(0, 14))]),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text(context.t('thankYou'), textAlign: TextAlign.center, style: KText.display(ar, mobile ? 34 : 50)),
          const SizedBox(height: 10),
          Text('${context.t('orderNumber')}: ${o.number}', textAlign: TextAlign.center, style: KText.body(ar, 17, w: FontWeight.w800, color: KColors.ok)),
          const SizedBox(height: 14),
          Text(context.t('orderConfirmedSub'), textAlign: TextAlign.center, style: KText.body(ar, 15, color: KColors.muted)),
          const SizedBox(height: 34),
          Container(
            padding: EdgeInsets.all(mobile ? 18 : 28),
            decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(26), border: Border.all(color: KColors.line)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (final l in o.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 54, height: 68, child: ProductImage(l.product, colorIndex: l.colorIndex))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.product.name(ar), style: KText.body(ar, 14.5, w: FontWeight.w700)),
                      Text('${l.qty} × ${[l.size, l.colorName(ar)].where((e) => e.isNotEmpty).join(' · ')}', style: KText.body(ar, 12.5, color: KColors.muted)),
                    ])),
                    Text(money(l.total), style: KText.body(ar, 14.5, w: FontWeight.w700)),
                  ]),
                ),
              const Divider(color: KColors.line),
              _row(context, context.t('subtotal'), money(o.subtotal)),
              if (o.discount > 0) _row(context, context.t('discount'), '-${money(o.discount)}'),
              _row(context, context.t('shippingLabel'), o.shipping == 0 ? context.t('free') : money(o.shipping)),
              _row(context, context.t('tax'), money(o.tax)),
              const Divider(height: 24, color: KColors.line),
              _row(context, context.t('total'), money(o.total), big: true),
              const SizedBox(height: 22),
              mobile
                  ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_ship(context, o), const SizedBox(height: 18), _pay(context, o)])
                  : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _ship(context, o)), const SizedBox(width: 24), Expanded(child: _pay(context, o))]),
            ]),
          ),
          const SizedBox(height: 30),
          Wrap(alignment: WrapAlignment.center, spacing: 14, runSpacing: 14, children: [
            KButton(label: context.t('backHome'), onTap: () => Go.top('/')),
            KButton(label: context.t('continueShopping'), outline: true, onTap: () => Go.top('/shop')),
          ]),
        ]),
      ),
    ]);
  }

  Widget _ship(BuildContext context, OrderSummary o) {
    final ar = context.isAr;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(ar ? context.t('shippedTo') : context.t('shippedTo').toUpperCase(), style: KText.label(ar)),
      const SizedBox(height: 8),
      Text('${o.name}\n${o.address}\n${o.city}, ${o.country}', style: KText.body(ar, 14.5)),
    ]);
  }

  Widget _pay(BuildContext context, OrderSummary o) {
    final ar = context.isAr;
    final brand = o.cardBrand == 'Visa' ? CardBrand.visa : (o.cardBrand == 'Mastercard' ? CardBrand.mastercard : CardBrand.unknown);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(ar ? context.t('paidWith') : context.t('paidWith').toUpperCase(), style: KText.label(ar)),
      const SizedBox(height: 8),
      Row(children: [CardMark(brand, height: 24), const SizedBox(width: 10), Text('•••• ${o.cardLast4}', style: KText.body(ar, 14.5, w: FontWeight.w700))]),
      const SizedBox(height: 6),
      Text(o.email, style: KText.body(ar, 13, color: KColors.muted)),
    ]);
  }

  Widget _row(BuildContext context, String a, String b, {bool big = false}) {
    final ar = context.isAr;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(a, style: KText.body(ar, big ? 17 : 14.5, w: big ? FontWeight.w700 : FontWeight.w500, color: big ? KColors.ink : KColors.muted))),
        Text(b, style: KText.body(ar, big ? 21 : 14.5, w: big ? FontWeight.w800 : FontWeight.w600)),
      ]),
    );
  }
}

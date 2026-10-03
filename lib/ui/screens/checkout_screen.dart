import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../theme.dart';
import '../widgets/card_marks.dart';
import '../widgets/common.dart';
import '../widgets/product_visual.dart';
import '../widgets/shell.dart';

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue v) {
    final d = v.text.replaceAll(RegExp(r'\D'), '');
    final cut = d.length > 16 ? d.substring(0, 16) : d;
    final b = StringBuffer();
    for (var i = 0; i < cut.length; i++) {
      if (i > 0 && i % 4 == 0) b.write(' ');
      b.write(cut[i]);
    }
    return TextEditingValue(text: b.toString(), selection: TextSelection.collapsed(offset: b.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue v) {
    var d = v.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 4) d = d.substring(0, 4);
    final t = d.length > 2 ? '${d.substring(0, 2)}/${d.substring(2)}' : d;
    return TextEditingValue(text: t, selection: TextSelection.collapsed(offset: t.length));
  }
}

bool _luhn(String digits) {
  if (digits.length < 13) return false;
  var sum = 0;
  var alt = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var n = int.parse(digits[i]);
    if (alt) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alt = !alt;
  }
  return sum % 10 == 0;
}

const _countries = ['Germany', 'Austria', 'Switzerland', 'France', 'Netherlands', 'Belgium', 'Italy', 'Spain', 'Sweden', 'Poland', 'Ireland', 'United Kingdom'];

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final phone = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final postal = TextEditingController();
  final cardName = TextEditingController();
  final cardNo = TextEditingController();
  final expiry = TextEditingController();
  final cvc = TextEditingController();
  String country = _countries.first;
  bool express = false;
  bool busy = false;

  @override
  void dispose() {
    for (final c in [email, phone, name, address, city, postal, cardName, cardNo, expiry, cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  double _shipping(AppState a) => express ? 14 : a.shipping;
  double _total(AppState a) => a.subtotal - a.discount + _shipping(a);

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? context.t('required') : null;

  Future<void> _pay() async {
    final app = context.appRead;
    if (app.cart.isEmpty) return;
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    // 1) "processing"
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProcessingDialog(text: context.t('processing')),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    // 2) fake 3-D Secure
    final ok = await showDialog<bool>(context: context, barrierDismissible: false, builder: (_) => const _VerifyDialog());
    if (!mounted) return;
    if (ok != true) {
      setState(() => busy = false);
      return;
    }
    showDialog(context: context, barrierDismissible: false, builder: (_) => _ProcessingDialog(text: context.t('processing')));
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    final digits = cardNo.text.replaceAll(' ', '');
    final brand = brandName(detectBrand(digits));
    final shippingCost = _shipping(app);
    final order = app.placeOrder(
      email: email.text.trim(),
      name: name.text.trim(),
      city: city.text.trim(),
      country: country,
      address: address.text.trim(),
      cardBrand: brand,
      cardLast4: digits.substring(digits.length - 4),
    );
    // keep the chosen delivery price on the receipt
    final fixed = OrderSummary(
      number: order.number,
      lines: order.lines,
      subtotal: order.subtotal,
      discount: order.discount,
      shipping: shippingCost,
      tax: order.tax,
      total: order.subtotal - order.discount + shippingCost,
      email: order.email,
      name: order.name,
      city: order.city,
      country: order.country,
      address: order.address,
      cardBrand: order.cardBrand,
      cardLast4: order.cardLast4,
      placedAt: order.placedAt,
    );
    app.lastOrder = fixed;
    for (final c in [cardName, cardNo, expiry, cvc]) {
      c.clear();
    }
    if (mounted) navKey.currentState?.pushNamedAndRemoveUntil('/order-confirmed', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final ar = app.isAr;
    final mobile = Bp.mobile(context);
    final accent = app.accent;

    if (app.cart.isEmpty) {
      return PageBody(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
          child: Center(
            child: Column(children: [
              Icon(Icons.shopping_bag_outlined, size: 70, color: accent),
              const SizedBox(height: 14),
              Text(context.t('bagEmptyCheckout'), textAlign: TextAlign.center, style: KText.display(ar, 26)),
              const SizedBox(height: 22),
              KButton(label: context.t('continueShopping'), onTap: () => Go.top('/shop')),
            ]),
          ),
        ),
      ]);
    }

    InputDecoration deco(String key, {Widget? suffix, String? hint}) => InputDecoration(
          labelText: context.t(key),
          hintText: hint,
          labelStyle: KText.body(ar, 14, color: KColors.muted),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: accent, width: 1.8)),
        );

    Widget card(String title, IconData icon, List<Widget> kids) => Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: EdgeInsets.all(mobile ? 18 : 26),
          decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: KColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [Icon(icon, color: accent), const SizedBox(width: 10), Text(title, style: KText.display(ar, 22))]),
            const SizedBox(height: 18),
            ...kids,
          ]),
        );

    Widget gap() => const SizedBox(height: 14);
    Widget two(Widget a, Widget b) => mobile ? Column(children: [a, gap(), b]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: a), const SizedBox(width: 14), Expanded(child: b)]);

    final digits = cardNo.text.replaceAll(' ', '');
    final brand = detectBrand(digits);

    final left = Form(
      key: form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9C46A))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF8A5A00)),
            const SizedBox(width: 12),
            Expanded(child: Text(context.t('demoNote'), style: KText.body(ar, 13.5, color: const Color(0xFF5E3D00), w: FontWeight.w600))),
          ]),
        ),
        card(context.t('contactInfo'), Icons.alternate_email_rounded, [
          two(
            TextFormField(controller: email, keyboardType: TextInputType.emailAddress, decoration: deco('email'), validator: (v) => (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) ? context.t('invalidEmail') : null),
            TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: deco('phone')),
          ),
        ]),
        card(context.t('shipTo'), Icons.local_shipping_outlined, [
          TextFormField(controller: name, decoration: deco('fullName'), validator: _req),
          gap(),
          TextFormField(controller: address, decoration: deco('address'), validator: _req),
          gap(),
          two(TextFormField(controller: city, decoration: deco('city'), validator: _req), TextFormField(controller: postal, decoration: deco('postal'), validator: _req)),
          gap(),
          DropdownButtonFormField<String>(
            initialValue: country,
            decoration: deco('country'),
            items: [for (final c in _countries) DropdownMenuItem(value: c, child: Text(c))],
            onChanged: (v) => setState(() => country = v!),
          ),
          const SizedBox(height: 20),
          Text(ar ? context.t('shipMethod') : context.t('shipMethod').toUpperCase(), style: KText.label(ar)),
          const SizedBox(height: 8),
          RadioGroup<bool>(
            groupValue: express,
            onChanged: (v) => setState(() => express = v ?? false),
            child: Column(children: [
              _RadioTile<bool>(value: false, title: context.t('standardShip'), price: app.shipping == 0 ? context.t('free') : money(app.shipping)),
              const SizedBox(height: 8),
              _RadioTile<bool>(value: true, title: context.t('expressShip'), price: money(14)),
            ]),
          ),
        ]),
        card(context.t('payment'), Icons.credit_card_rounded, [
          Row(children: [
            Text(context.t('acceptedCards'), style: KText.body(ar, 13, color: KColors.muted, w: FontWeight.w600)),
            const Spacer(),
            CardMark(CardBrand.visa, dim: brand == CardBrand.mastercard),
            const SizedBox(width: 8),
            CardMark(CardBrand.mastercard, dim: brand == CardBrand.visa),
          ]),
          gap(),
          TextFormField(controller: cardName, decoration: deco('nameOnCard'), validator: _req, textCapitalization: TextCapitalization.words),
          gap(),
          TextFormField(
            controller: cardNo,
            keyboardType: TextInputType.number,
            inputFormatters: [_CardNumberFormatter()],
            onChanged: (_) => setState(() {}),
            decoration: deco('cardNumber', hint: '4242 4242 4242 4242', suffix: Padding(padding: const EdgeInsets.all(10), child: CardMark(brand, height: 24))),
            validator: (v) {
              final d = (v ?? '').replaceAll(' ', '');
              if (detectBrand(d) == CardBrand.unknown || d.length != 16 || !_luhn(d)) return context.t('invalidCard');
              return null;
            },
          ),
          gap(),
          two(
            TextFormField(
              controller: expiry,
              keyboardType: TextInputType.number,
              inputFormatters: [_ExpiryFormatter()],
              decoration: deco('expiry', hint: 'MM/YY'),
              validator: (v) {
                final m = RegExp(r'^(\d{2})/(\d{2})$').firstMatch(v ?? '');
                if (m == null) return context.t('invalidExpiry');
                final mm = int.parse(m.group(1)!), yy = 2000 + int.parse(m.group(2)!);
                final now = DateTime.now();
                if (mm < 1 || mm > 12 || yy < now.year || (yy == now.year && mm < now.month)) return context.t('invalidExpiry');
                return null;
              },
            ),
            TextFormField(
              controller: cvc,
              keyboardType: TextInputType.number,
              obscureText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              decoration: deco('cvc'),
              validator: (v) => (v == null || v.length < 3) ? context.t('invalidCvc') : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.lock_outline_rounded, size: 16, color: KColors.ok),
            const SizedBox(width: 6),
            Expanded(child: Text(context.t('secureNote'), style: KText.body(ar, 12.5, color: KColors.muted))),
          ]),
          const SizedBox(height: 6),
          Text(context.t('testCardHint'), style: KText.body(ar, 12.5, color: accent, w: FontWeight.w700)),
        ]),
        KButton(label: '${context.t('payNow')} ${money(_total(app))}', icon: Icons.lock_rounded, expand: true, height: 58, onTap: busy ? null : _pay),
        const SizedBox(height: 10),
      ]),
    );

    final summary = Container(
      padding: EdgeInsets.all(mobile ? 18 : 26),
      decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: KColors.line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(context.t('orderSummary'), style: KText.display(ar, 22)),
        const SizedBox(height: 16),
        for (final l in app.cart)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              Stack(clipBehavior: Clip.none, children: [
                ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 56, height: 70, child: ProductImage(l.product, colorIndex: l.colorIndex))),
                PositionedDirectional(top: -6, end: -6, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: KColors.ink, shape: BoxShape.circle), child: Text('${l.qty}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)))),
              ]),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.product.name(ar), maxLines: 2, overflow: TextOverflow.ellipsis, style: KText.body(ar, 14, w: FontWeight.w700)),
                  Text([l.size, l.colorName(ar)].where((e) => e.isNotEmpty).join(' · '), style: KText.body(ar, 12, color: KColors.muted)),
                ]),
              ),
              Text(money(l.total), style: KText.body(ar, 14, w: FontWeight.w700)),
            ]),
          ),
        const Divider(color: KColors.line),
        _sumRow(context, context.t('subtotal'), money(app.subtotal)),
        if (app.discount > 0) _sumRow(context, context.t('discount'), '-${money(app.discount)}', color: KColors.ok),
        _sumRow(context, context.t('shippingLabel'), _shipping(app) == 0 ? context.t('free') : money(_shipping(app))),
        _sumRow(context, context.t('tax'), money(app.tax)),
        const Divider(height: 24, color: KColors.line),
        _sumRow(context, context.t('total'), money(_total(app)), big: true),
      ]),
    );

    return PageBody(children: [
      Constrained(
        max: 1180,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 24 : 44, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.t('checkoutTitle'), style: KText.display(ar, mobile ? 34 : 52)),
          const SizedBox(height: 26),
          mobile
              ? Column(children: [summary, const SizedBox(height: 18), left])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 6, child: left), const SizedBox(width: 32), Expanded(flex: 4, child: summary)]),
        ]),
      ),
    ]);
  }

  Widget _sumRow(BuildContext context, String a, String b, {bool big = false, Color? color}) {
    final ar = context.isAr;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(a, style: KText.body(ar, big ? 17 : 14.5, w: big ? FontWeight.w700 : FontWeight.w500, color: big ? KColors.ink : KColors.muted))),
        Text(b, style: KText.body(ar, big ? 21 : 14.5, w: big ? FontWeight.w800 : FontWeight.w600, color: color ?? KColors.ink)),
      ]),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  final T value;
  final String title;
  final String price;
  const _RadioTile({required this.value, required this.title, required this.price});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final group = RadioGroup.maybeOf<T>(context);
    final selected = group?.groupValue == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => group?.onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? context.app.accent : KColors.line, width: selected ? 2 : 1)),
        child: Row(children: [
          Radio<T>(value: value),
          Expanded(child: Text(title, style: KText.body(ar, 14, w: FontWeight.w600))),
          Text(price, style: KText.body(ar, 14, w: FontWeight.w800)),
        ]),
      ),
    );
  }
}

class _ProcessingDialog extends StatelessWidget {
  final String text;
  const _ProcessingDialog({required this.text});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: KColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(width: 44, height: 44, child: CircularProgressIndicator(strokeWidth: 3.5, color: context.app.accent)),
            const SizedBox(height: 20),
            Text(text, style: KText.body(ar, 16, w: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}

class _VerifyDialog extends StatefulWidget {
  const _VerifyDialog();
  @override
  State<_VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends State<_VerifyDialog> {
  final ctl = TextEditingController();
  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final accent = context.app.accent;
    return Dialog(
      backgroundColor: KColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.verified_user_outlined, color: accent, size: 28),
              const SizedBox(width: 10),
              Expanded(child: Text(context.t('verifyTitle'), style: KText.display(ar, 22))),
            ]),
            const SizedBox(height: 12),
            Text(context.t('verifySub'), style: KText.body(ar, 14, color: KColors.muted)),
            const SizedBox(height: 18),
            TextField(
              controller: ctl,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 26, letterSpacing: 10, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: accent, width: 2)),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: KButton(label: context.t('cancel'), outline: true, onTap: () => Navigator.of(context).pop(false))),
              const SizedBox(width: 12),
              Expanded(child: KButton(label: context.t('verify'), onTap: ctl.text.length == 6 ? () => Navigator.of(context).pop(true) : null)),
            ]),
          ]),
        ),
      ),
    );
  }
}

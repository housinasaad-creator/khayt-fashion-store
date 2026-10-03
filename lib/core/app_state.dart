import 'package:flutter/material.dart';
import '../data/products.dart';

class CartLine {
  final Product product;
  final String size;
  final int colorIndex;
  int qty;
  CartLine(this.product, this.size, this.colorIndex, this.qty);

  String get key => '${product.id}|$size|$colorIndex';
  double get total => product.price * qty;
  String colorName(bool ar) {
    if (product.colors.isEmpty) return '';
    final c = product.colors[colorIndex.clamp(0, product.colors.length - 1)];
    return ar ? c.ar : c.en;
  }
}

class OrderSummary {
  final String number;
  final List<CartLine> lines;
  final double subtotal, discount, shipping, tax, total;
  final String email, name, city, country, address, cardBrand, cardLast4;
  final DateTime placedAt;
  OrderSummary({
    required this.number,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.email,
    required this.name,
    required this.city,
    required this.country,
    required this.address,
    required this.cardBrand,
    required this.cardLast4,
    required this.placedAt,
  });
}

class AppState extends ChangeNotifier {
  String lang = 'en';
  bool get isAr => lang == 'ar';
  Locale get locale => Locale(lang);

  final List<CartLine> cart = [];
  String? promo;
  Color accent = const Color(0xFFC4572F);
  int cartBump = 0;
  OrderSummary? lastOrder;
  final GlobalKey cartIconKey = GlobalKey();

  void toggleLang() {
    lang = isAr ? 'en' : 'ar';
    notifyListeners();
  }

  void setAccent(Color c) {
    if (c == accent) return;
    accent = c;
    notifyListeners();
  }

  int get count => cart.fold(0, (a, l) => a + l.qty);
  double get subtotal => cart.fold(0.0, (a, l) => a + l.total);
  double get discount => promo == 'KHAYT10' ? subtotal * 0.10 : 0;
  double get shipping => subtotal == 0 ? 0 : ((subtotal - discount) >= 120 ? 0 : 9);
  /// VAT (19 %) is already included in the shown prices, as in EU shops.
  double get tax => (subtotal - discount) * 19 / 119;
  double get total => subtotal - discount + shipping;

  void addToCart(Product p, {required String size, int colorIndex = 0, int qty = 1}) {
    final existing = cart.where((l) => l.product.id == p.id && l.size == size && l.colorIndex == colorIndex);
    if (existing.isNotEmpty) {
      existing.first.qty += qty;
    } else {
      cart.add(CartLine(p, size, colorIndex, qty));
    }
    cartBump++;
    notifyListeners();
  }

  void setQty(CartLine l, int q) {
    if (q <= 0) {
      cart.remove(l);
    } else {
      l.qty = q.clamp(1, 20);
    }
    notifyListeners();
  }

  void remove(CartLine l) {
    cart.remove(l);
    notifyListeners();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'KHAYT10') {
      promo = 'KHAYT10';
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearPromo() {
    promo = null;
    notifyListeners();
  }

  OrderSummary placeOrder({
    required String email,
    required String name,
    required String city,
    required String country,
    required String address,
    required String cardBrand,
    required String cardLast4,
  }) {
    final n = 'KH-${(100000 + DateTime.now().millisecondsSinceEpoch % 900000)}';
    final order = OrderSummary(
      number: n,
      lines: cart.map((l) => CartLine(l.product, l.size, l.colorIndex, l.qty)).toList(),
      subtotal: subtotal,
      discount: discount,
      shipping: shipping,
      tax: tax,
      total: total,
      email: email,
      name: name,
      city: city,
      country: country,
      address: address,
      cardBrand: cardBrand,
      cardLast4: cardLast4,
      placedAt: DateTime.now(),
    );
    lastOrder = order;
    cart.clear();
    promo = null;
    notifyListeners();
    return order;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);
  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
  static AppState read(BuildContext context) => (context.getElementForInheritedWidgetOfExactType<AppScope>()!.widget as AppScope).notifier!;
}

extension AppCtx on BuildContext {
  AppState get app => AppScope.of(this);
  AppState get appRead => AppScope.read(this);
}

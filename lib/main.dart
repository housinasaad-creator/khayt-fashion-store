import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_state.dart';
import 'core/nav.dart';
import 'data/legal_content.dart';
import 'ui/screens/cart_order_screens.dart';
import 'ui/screens/checkout_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/info_screens.dart';
import 'ui/screens/product_screen.dart';
import 'ui/screens/shop_screen.dart';
import 'ui/theme.dart';
import 'ui/widgets/shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // keep decoded photos within a small budget; pictures of sections that left the screen are dropped
  PaintingBinding.instance.imageCache
    ..maximumSize = 90
    ..maximumSizeBytes = 64 << 20;
  runApp(const KhaytApp());
}

class KhaytApp extends StatefulWidget {
  const KhaytApp({super.key});
  @override
  State<KhaytApp> createState() => _KhaytAppState();
}

class _KhaytAppState extends State<KhaytApp> {
  final AppState state = AppState();

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  Route<dynamic> _route(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;
    Widget page;
    if (path == '/' || path.isEmpty) {
      page = const HomeScreen();
    } else if (path == '/shop') {
      page = ShopScreen(key: ValueKey('shop-${uri.queryParameters['cat']}'), cat: uri.queryParameters['cat'] ?? 'all');
    } else if (path.startsWith('/product/')) {
      page = ProductScreen(key: ValueKey(path), id: path.substring('/product/'.length));
    } else if (path == '/cart') {
      page = const CartScreen();
    } else if (path == '/checkout') {
      page = const CheckoutScreen();
    } else if (path == '/order-confirmed') {
      page = const OrderConfirmedScreen();
    } else if (path == '/about') {
      page = const AboutScreen();
    } else if (path == '/contact') {
      page = const ContactScreen();
    } else if (path == '/faq') {
      page = const FaqScreen();
    } else if (path == '/shipping') {
      page = const LegalScreen(titleKey: 'shippingReturns', en: shippingEn, ar: shippingAr, showUpdated: false);
    } else if (path == '/privacy') {
      page = const LegalScreen(titleKey: 'privacy', en: privacyEn, ar: privacyAr);
    } else if (path == '/terms') {
      page = const LegalScreen(titleKey: 'terms', en: termsEn, ar: termsAr);
    } else {
      page = const NotFoundScreen();
    }
    return PageRouteBuilder<void>(
      settings: settings,
      maintainState: false,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, anim, _, child) {
        final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: c, child: SlideTransition(position: Tween(begin: const Offset(0, 0.015), end: Offset.zero).animate(c), child: child));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: Builder(builder: (context) {
        final app = AppScope.of(context);
        return MaterialApp(
          title: 'Khayt — خيط',
          debugShowCheckedModeBanner: false,
          navigatorKey: navKey,
          navigatorObservers: [PathObserver()],
          theme: buildTheme(app.isAr),
          locale: app.locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad, PointerDeviceKind.stylus}),
          initialRoute: '/',
          onGenerateRoute: _route,
          builder: (context, child) => Directionality(
            textDirection: app.isAr ? TextDirection.rtl : TextDirection.ltr,
            child: ShellLayout(child: child ?? const SizedBox.shrink()),
          ),
        );
      }),
    );
  }
}

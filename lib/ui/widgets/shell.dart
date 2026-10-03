import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/scroll.dart';
import '../../core/strings.dart';
import '../theme.dart';
import 'card_marks.dart';
import 'cart_panel.dart';
import 'logo.dart';

/// Persistent frame around the Navigator: announcement bar, header, drawers.
class ShellLayout extends StatelessWidget {
  final Widget child;
  const ShellLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final tint = Color.lerp(KColors.bg, app.accent, 0.16)!;
    final w = MediaQuery.sizeOf(context).width;
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: tint),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, bg, _) => Scaffold(
        key: shellKey,
        backgroundColor: bg,
        drawer: const MobileMenu(),
        endDrawer: Drawer(
          width: w < 480 ? w : 440,
          backgroundColor: KColors.card,
          shape: const RoundedRectangleBorder(),
          child: const SafeArea(child: CartPanel(inDrawer: true)),
        ),
        body: Column(children: [
          const AnnouncementBar(),
          const SiteHeader(),
          Expanded(child: child),
        ]),
      ),
    );
  }
}

class AnnouncementBar extends StatelessWidget {
  const AnnouncementBar({super.key});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return Container(
      width: double.infinity,
      color: KColors.ink,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Text(context.t('announce'), textAlign: TextAlign.center, style: KText.body(ar, 12, color: Colors.white.withValues(alpha: 0.9), w: FontWeight.w500, ls: ar ? 0 : 0.3)),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String path;
  final String label;
  final bool active;
  const _NavLink(this.path, this.label, this.active);
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final accent = context.app.accent;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () => Go.top(widget.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label, style: KText.body(ar, 14.5, w: widget.active ? FontWeight.w700 : FontWeight.w500, color: hover || widget.active ? KColors.ink : KColors.muted)),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: widget.active || hover ? 22 : 0,
              decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
            ),
          ]),
        ),
      ),
    );
  }
}

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.app;
    final wide = MediaQuery.sizeOf(context).width >= 920;
    final mobile = Bp.mobile(context);
    final accent = app.accent;
    return Container(
      height: mobile ? 62 : 72,
      padding: EdgeInsets.symmetric(horizontal: Bp.pad(context) - (mobile ? 6 : 0)),
      decoration: BoxDecoration(
        color: Color.lerp(KColors.bg, accent, 0.06),
        border: const Border(bottom: BorderSide(color: KColors.line)),
      ),
      child: ValueListenableBuilder<String>(
        valueListenable: currentPath,
        builder: (context, path, _) {
          bool on(String p) => p == '/' ? path == '/' : path.startsWith(p);
          return Row(children: [
            if (!wide)
              IconButton(
                tooltip: context.t('menu'),
                onPressed: () => shellKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: KColors.ink),
              ),
            MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(onTap: () => Go.top('/'), child: KhaytLogo(size: mobile ? 28 : 34, thread: accent))),
            if (wide) ...[
              const Spacer(),
              _NavLink('/', context.t('home'), on('/')),
              _NavLink('/shop', context.t('shop'), on('/shop') || on('/product')),
              _NavLink('/about', context.t('about'), on('/about')),
              _NavLink('/contact', context.t('contact'), on('/contact')),
              const Spacer(),
            ] else
              const Spacer(),
            TextButton(
              onPressed: app.toggleLang,
              style: TextButton.styleFrom(foregroundColor: KColors.ink, padding: const EdgeInsets.symmetric(horizontal: 12)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.language_rounded, size: 18),
                const SizedBox(width: 6),
                Text(context.t('langName'), style: KText.body(app.isAr, 13.5, w: FontWeight.w700)),
              ]),
            ),
            const SizedBox(width: 4),
            _CartButton(count: app.count, bump: app.cartBump, iconKey: app.cartIconKey),
          ]);
        },
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final int bump;
  final GlobalKey iconKey;
  const _CartButton({required this.count, required this.bump, required this.iconKey});

  @override
  Widget build(BuildContext context) {
    final accent = context.app.accent;
    return TweenAnimationBuilder<double>(
      key: ValueKey(bump),
      tween: Tween(begin: bump == 0 ? 1 : 1.35, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.elasticOut,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: Tooltip(
        message: context.t('bag'),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: Go.openCart,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(clipBehavior: Clip.none, children: [
              Icon(Icons.shopping_bag_outlined, key: iconKey, size: 26, color: KColors.ink),
              if (count > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 19, minHeight: 19),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(999)),
                    child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    Widget item(String path, String key, IconData icon) => ListTile(
          leading: Icon(icon, color: KColors.ink),
          title: Text(context.t(key), style: KText.body(ar, 17, w: FontWeight.w600)),
          onTap: () {
            Go.closeDrawers();
            Go.top(path);
          },
        );
    return Drawer(
      backgroundColor: KColors.card,
      child: SafeArea(
        child: ListView(padding: const EdgeInsets.all(12), children: [
          const Padding(padding: EdgeInsets.fromLTRB(12, 12, 12, 24), child: KhaytLogo(size: 34)),
          item('/', 'home', Icons.home_outlined),
          item('/shop', 'shop', Icons.storefront_outlined),
          item('/about', 'about', Icons.favorite_border_rounded),
          item('/contact', 'contact', Icons.mail_outline_rounded),
          const Divider(height: 32),
          item('/faq', 'faq', Icons.help_outline_rounded),
          item('/shipping', 'shippingReturns', Icons.local_shipping_outlined),
          item('/privacy', 'privacy', Icons.lock_outline_rounded),
          item('/terms', 'terms', Icons.description_outlined),
        ]),
      ),
    );
  }
}

/// Scrolling page content + footer. Registers its controller so the 3D
/// viewer can forward mouse-wheel scrolling.
class PageBody extends StatefulWidget {
  final List<Widget> children;
  final bool footer;
  const PageBody({super.key, required this.children, this.footer = true});
  @override
  State<PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  final ScrollController sc = ScrollController();

  @override
  void dispose() {
    if (identical(activePageScroll, sc)) activePageScroll = null;
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent ?? true) activePageScroll = sc;
    return Scrollbar(
      controller: sc,
      child: SingleChildScrollView(
        controller: sc,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ...widget.children,
          if (widget.footer) const SiteFooter(),
        ]),
      ),
    );
  }
}

class Constrained extends StatelessWidget {
  final Widget child;
  final double max;
  final EdgeInsets? padding;
  const Constrained({super.key, required this.child, this.max = 1280, this.padding});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: Padding(padding: padding ?? EdgeInsets.symmetric(horizontal: Bp.pad(context)), child: child),
      ),
    );
  }
}

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final accent = context.app.accent;

    Widget link(String key, String path) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Go.top(path),
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(context.t(key), style: KText.body(ar, 14, color: Colors.white.withValues(alpha: 0.72)))),
          ),
        );
    Widget col(String titleKey, List<Widget> kids) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ar ? context.t(titleKey) : context.t(titleKey).toUpperCase(), style: KText.label(ar, color: Colors.white.withValues(alpha: 0.5), size: 11.5)),
          const SizedBox(height: 12),
          ...kids,
        ]);

    final about = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      KhaytLogo(size: 36, color: Colors.white, thread: accent),
      const SizedBox(height: 16),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 340), child: Text(context.t('footerAbout'), style: KText.body(ar, 14, color: Colors.white.withValues(alpha: 0.7)))),
      const SizedBox(height: 18),
      const PaymentMarks(light: true),
    ]);
    final cols = [
      col('shopCol', [link('women', '/shop?cat=women'), link('men', '/shop?cat=men'), link('knitwear', '/shop?cat=knitwear'), link('accessories', '/shop?cat=accessories')]),
      col('helpCol', [link('faq', '/faq'), link('shippingReturns', '/shipping'), link('contact', '/contact')]),
      col('companyCol', [link('about', '/about'), link('shop', '/shop')]),
      col('legalCol', [link('privacy', '/privacy'), link('terms', '/terms')]),
    ];

    return Container(
      margin: const EdgeInsets.only(top: 72),
      color: KColors.ink,
      child: Constrained(
        padding: EdgeInsets.symmetric(horizontal: Bp.pad(context), vertical: 52),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (mobile) ...[
            about,
            const SizedBox(height: 32),
            Wrap(spacing: 40, runSpacing: 28, children: cols.map((c) => SizedBox(width: 140, child: c)).toList()),
          ] else
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 4, child: about),
              for (final c in cols) Expanded(flex: 2, child: c),
            ]),
          const SizedBox(height: 40),
          Divider(color: Colors.white.withValues(alpha: 0.14)),
          const SizedBox(height: 16),
          Text(context.t('fictionalNotice'), style: KText.body(ar, 12.5, color: Colors.white.withValues(alpha: 0.55))),
          const SizedBox(height: 8),
          Text('${context.t('rights')}   ·   ${context.t('photoCredit')}', style: KText.body(ar, 12.5, color: Colors.white.withValues(alpha: 0.55))),
        ]),
      ),
    );
  }
}

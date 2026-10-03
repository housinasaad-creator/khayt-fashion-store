import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../../data/products.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/hanger_rail.dart';
import '../widgets/product_grid.dart';
import '../widgets/shell.dart';
import '../widgets/viewer3d.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final heroProduct = productById('heritage-crew')!;
  final featProduct = productById('oversized-rib')!;
  int heroColor = 1;
  int featColor = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.appRead.setAccent(heroProduct.colors[heroColor].color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Bp.mobile(context);
    final ar = context.isAr;
    final railItems = [for (final p in kProducts) if (p.isNew || p.is3d || p.onSale) p].take(10).toList();
    final arrivals = kProducts.where((p) => !p.is3d).take(8).toList();

    return PageBody(children: [
      _hero(context, mobile, ar),
      const SizedBox(height: 28),
      const _Marquee(),
      const SizedBox(height: 72),
      Constrained(child: SectionTitle(eyebrow: context.t('newArrivals'), title: context.t('railTitle'), sub: context.t('railSub'))),
      const SizedBox(height: 18),
      HangerRail(
        items: railItems,
        onFocus: (p) => context.appRead.setAccent(p.is3d ? p.colors[heroColor].color : p.accent),
      ),
      const SizedBox(height: 80),
      _categories(context, mobile),
      const SizedBox(height: 90),
      _featured3d(context, mobile, ar),
      const SizedBox(height: 90),
      Constrained(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionTitle(
            eyebrow: context.t('shop'),
            title: context.t('newArrivals'),
            trailing: TextButton(onPressed: () => Go.top('/shop'), child: Text('${context.t('viewAll')}  →', style: KText.body(ar, 15, w: FontWeight.w700, color: context.app.accent))),
          ),
          const SizedBox(height: 28),
          ProductGrid(arrivals),
        ]),
      ),
      const SizedBox(height: 90),
      _values(context, mobile),
      const SizedBox(height: 90),
      _testimonials(context, mobile),
      const SizedBox(height: 90),
      const _Newsletter(),
    ]);
  }

  // ---------------------------------------------------------------- hero
  Widget _hero(BuildContext context, bool mobile, bool ar) {
    final app = context.app;
    final accent = app.accent;
    final colors = heroProduct.colors;
    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FadeSlideIn(child: Text(ar ? context.t('heroEyebrow') : context.t('heroEyebrow'), style: KText.label(ar, color: accent, size: 12.5))),
      const SizedBox(height: 18),
      FadeSlideIn(delayMs: 120, child: Text(context.t('heroTitle1'), style: KText.display(ar, mobile ? 46 : 84, w: FontWeight.w700, h: 1.0))),
      FadeSlideIn(
        delayMs: 240,
        child: Text(context.t('heroTitle2'), style: KText.display(ar, mobile ? 46 : 84, w: FontWeight.w700, color: accent, h: 1.05).copyWith(fontStyle: ar ? FontStyle.normal : FontStyle.italic)),
      ),
      const SizedBox(height: 22),
      FadeSlideIn(delayMs: 380, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Text(context.t('heroSub'), style: KText.body(ar, mobile ? 16 : 18, color: KColors.muted)))),
      const SizedBox(height: 30),
      FadeSlideIn(
        delayMs: 520,
        child: Wrap(spacing: 14, runSpacing: 14, children: [
          KButton(label: context.t('shopNow'), icon: Icons.arrow_forward_rounded, onTap: () => Go.top('/shop')),
          KButton(label: context.t('tryIn3d'), outline: true, icon: Icons.threed_rotation_rounded, onTap: () => Go.product(heroProduct.id)),
        ]),
      ),
      const SizedBox(height: 34),
      FadeSlideIn(
        delayMs: 640,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.star_rounded, color: Color(0xFFE0A526), size: 20),
          const SizedBox(width: 6),
          Text('4.8', style: KText.body(ar, 15, w: FontWeight.w800)),
          const SizedBox(width: 8),
          Text('· 2,400+ ${context.t('reviews')}', style: KText.body(ar, 14, color: KColors.muted)),
        ]),
      ),
    ]);

    final viewer = Column(children: [
      AspectRatio(
        aspectRatio: mobile ? 1 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: RadialGradient(center: const Alignment(0, -0.1), radius: 0.95, colors: [Color.lerp(Colors.white, accent, 0.32)!, Color.lerp(KColors.bg, accent, 0.28)!]),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.30), blurRadius: 60, offset: const Offset(0, 30))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(fit: StackFit.expand, children: [
              Viewer3D(key: const ValueKey('hero-viewer'), style: heroProduct.style, color: colors[heroColor].color),
              PositionedDirectional(
                top: 18,
                start: 20,
                child: Badge3('3D · ${context.t('drag3d')}', color: Colors.white.withValues(alpha: 0.85), fg: KColors.ink),
              ),
              PositionedDirectional(
                bottom: 16,
                start: 16,
                end: 16,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Go.product(heroProduct.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(18)),
                      child: Row(children: [
                        Expanded(child: Text(heroProduct.name(ar), style: KText.body(ar, 14.5, w: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Text(money0(heroProduct.price), style: KText.body(ar, 14.5, w: FontWeight.w800)),
                        const SizedBox(width: 10),
                        Icon(ar ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 18),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      const SizedBox(height: 22),
      Text('${context.t('liveColor')}: ${colors[heroColor].en == '' ? '' : (ar ? colors[heroColor].ar : colors[heroColor].en)}', style: KText.body(ar, 14, w: FontWeight.w700)),
      const SizedBox(height: 4),
      Text(context.t('heroColor'), style: KText.body(ar, 12.5, color: KColors.muted)),
      const SizedBox(height: 14),
      _Swatches(
        colors: colors,
        selected: heroColor,
        onSelect: (i) {
          setState(() => heroColor = i);
          context.appRead.setAccent(colors[i].color);
        },
      ),
    ]);

    return Constrained(
      padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
      child: mobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [text, const SizedBox(height: 36), viewer])
          : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 11, child: text),
              const SizedBox(width: 56),
              Expanded(flex: 10, child: viewer),
            ]),
    );
  }

  // ---------------------------------------------------------- categories
  Widget _categories(BuildContext context, bool mobile) {
    int count(String c) => kProducts.where((p) => p.cats.contains(c)).length;
    final tiles = [
      ('women', 'assets/images/products/reddress.jpg', Alignment.topCenter),
      ('men', 'assets/images/products/leather.jpg', Alignment.center),
      ('knitwear', 'assets/images/products/orange.jpg', Alignment.topCenter),
      ('accessories', 'assets/images/products/handbag.jpg', Alignment.center),
    ];
    Widget tile((String, String, Alignment) t) => _CatTile(catKey: t.$1, image: t.$2, align: t.$3, count: count(t.$1));
    return Constrained(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(eyebrow: context.t('shop'), title: context.t('shopByCat')),
        const SizedBox(height: 28),
        LayoutBuilder(builder: (context, c) {
          final cols = mobile ? 2 : 4;
          final gap = mobile ? 12.0 : 20.0;
          final w = (c.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(spacing: gap, runSpacing: gap, children: [for (final t in tiles) SizedBox(width: w, height: w * 1.28, child: tile(t))]);
        }),
      ]),
    );
  }

  // ------------------------------------------------------- 3D feature
  Widget _featured3d(BuildContext context, bool mobile, bool ar) {
    final p = featProduct;
    final col = p.colors[featColor];
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(ar ? 'تجربة ثلاثية الأبعاد' : 'IN THE ROUND', style: KText.label(ar, color: Colors.white.withValues(alpha: 0.6), size: 12.5)),
      const SizedBox(height: 14),
      Text(p.name(ar), style: KText.display(ar, mobile ? 34 : 54, color: Colors.white, h: 1.05)),
      const SizedBox(height: 16),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Text(p.desc(ar), style: KText.body(ar, 16, color: Colors.white.withValues(alpha: 0.75)))),
      const SizedBox(height: 26),
      Text('${context.t('liveColor')}: ${ar ? col.ar : col.en}', style: KText.body(ar, 14, w: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 14),
      _Swatches(
        colors: p.colors,
        selected: featColor,
        onDark: true,
        onSelect: (i) {
          setState(() => featColor = i);
          context.appRead.setAccent(p.colors[i].color);
        },
      ),
      const SizedBox(height: 28),
      KButton(label: '${context.t('viewDetails')}  ·  ${money0(p.price)}', dark: true, onTap: () => Go.product(p.id)),
    ]);
    final right = AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: RadialGradient(radius: 0.9, colors: [Color.lerp(const Color(0xFF2A2825), col.color, 0.45)!, const Color(0xFF1B1A17)]),
        ),
        child: ClipRRect(borderRadius: BorderRadius.circular(32), child: Viewer3D(key: const ValueKey('feat-viewer'), style: p.style, color: col.color)),
      ),
    );
    return Constrained(
      child: Container(
        padding: EdgeInsets.all(mobile ? 24 : 56),
        decoration: BoxDecoration(color: KColors.ink, borderRadius: BorderRadius.circular(44)),
        child: mobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 28), right])
            : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(child: left), const SizedBox(width: 48), Expanded(child: right)]),
      ),
    );
  }

  // --------------------------------------------------------------- values
  Widget _values(BuildContext context, bool mobile) {
    final ar = context.isAr;
    final items = [
      (Icons.spa_outlined, 'value1t', 'value1d'),
      (Icons.handshake_outlined, 'value2t', 'value2d'),
      (Icons.replay_circle_filled_outlined, 'value3t', 'value3d'),
    ];
    Widget card((IconData, String, String) it) => Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(26), border: Border.all(color: KColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: context.app.accent.withValues(alpha: 0.14), shape: BoxShape.circle),
              child: Icon(it.$1, color: context.app.accent, size: 26),
            ),
            const SizedBox(height: 20),
            Text(context.t(it.$2), style: KText.display(ar, 24)),
            const SizedBox(height: 10),
            Text(context.t(it.$3), style: KText.body(ar, 15, color: KColors.muted)),
          ]),
        );
    return Constrained(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(eyebrow: context.t('about'), title: context.t('valuesTitle')),
        const SizedBox(height: 28),
        mobile
            ? Column(children: [for (final it in items) Padding(padding: const EdgeInsets.only(bottom: 14), child: card(it))])
            : Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (var i = 0; i < items.length; i++) ...[if (i > 0) const SizedBox(width: 20), Expanded(child: card(items[i]))]]),
      ]),
    );
  }

  // --------------------------------------------------------- testimonials
  Widget _testimonials(BuildContext context, bool mobile) {
    final ar = context.isAr;
    final q = ar
        ? [
            ('ليلى م.', 'السويتر الأرضي صار قطعتي الأولى بالشتا. والعارض الثلاثي الأبعاد خلاني أعرف اللون بالضبط قبل الشراء.'),
            ('عمر ك.', 'التيشيرت الأسود قماشه ثقيل ومظبوط. والإرجاع كان سهل بدون أي أسئلة.'),
            ('صوفيا ر.', 'التغليف جميل والمقاس طلع مظبوط. أحب إنو الموقع كله يتغيّر مع كل لون!'),
          ]
        : [
            ('Layla M.', 'The terracotta sweater is my go-to this winter. Seeing it in 3D told me the exact colour before I bought.'),
            ('Omar K.', 'The black tee is properly heavyweight and fits right. Returns were painless, no questions asked.'),
            ('Sofia R.', 'Lovely packaging, true to size. I adore that the whole site changes colour with every swatch!'),
          ];
    Widget card((String, String) t) => Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: KColors.line)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Stars(5, size: 18),
            const SizedBox(height: 14),
            Text('"${t.$2}"', style: KText.display(ar, 18, w: FontWeight.w500, h: 1.45)),
            const SizedBox(height: 18),
            Row(children: [
              CircleAvatar(radius: 16, backgroundColor: context.app.accent.withValues(alpha: 0.2), child: Text(t.$1.characters.first, style: KText.body(ar, 14, w: FontWeight.w800))),
              const SizedBox(width: 10),
              Text(t.$1, style: KText.body(ar, 14, w: FontWeight.w700)),
              const SizedBox(width: 8),
              Text(ar ? '· زبون خيالي' : '· imaginary customer', style: KText.body(ar, 12.5, color: KColors.muted)),
            ]),
          ]),
        );
    return Constrained(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(eyebrow: ar ? 'آراء' : 'Reviews', title: context.t('loveTitle')),
        const SizedBox(height: 28),
        mobile
            ? Column(children: [for (final t in q) Padding(padding: const EdgeInsets.only(bottom: 14), child: card(t))])
            : Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (var i = 0; i < q.length; i++) ...[if (i > 0) const SizedBox(width: 20), Expanded(child: card(q[i]))]]),
      ]),
    );
  }
}

// ------------------------------------------------------------------ pieces
class _Swatches extends StatelessWidget {
  final List<ColorOpt> colors;
  final int selected;
  final ValueChanged<int> onSelect;
  final bool onDark;
  const _Swatches({required this.colors, required this.selected, required this.onSelect, this.onDark = false});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return Wrap(spacing: 12, runSpacing: 12, children: [
      for (var i = 0; i < colors.length; i++)
        Tooltip(
          message: ar ? colors[i].ar : colors[i].en,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutBack,
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: selected == i ? (onDark ? Colors.white : KColors.ink) : Colors.transparent, width: 2)),
                transform: Matrix4.identity()..scaleByDouble(selected == i ? 1.12 : 1.0, selected == i ? 1.12 : 1.0, 1.0, 1.0),
                transformAlignment: Alignment.center,
                child: Container(decoration: BoxDecoration(color: colors[i].color, shape: BoxShape.circle, border: Border.all(color: Colors.black.withValues(alpha: 0.12)))),
              ),
            ),
          ),
        ),
    ]);
  }
}

class _CatTile extends StatefulWidget {
  final String catKey;
  final String image;
  final Alignment align;
  final int count;
  const _CatTile({required this.catKey, required this.image, required this.align, required this.count});
  @override
  State<_CatTile> createState() => _CatTileState();
}

class _CatTileState extends State<_CatTile> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () => Go.top('/shop?cat=${widget.catKey}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(fit: StackFit.expand, children: [
            AnimatedScale(scale: hover ? 1.08 : 1.0, duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic, child: Image.asset(widget.image, fit: BoxFit.cover, alignment: widget.align)),
            DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: hover ? 0.72 : 0.55)]))),
            Padding(
              padding: EdgeInsets.all(Bp.mobile(context) ? 14 : 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerStart, child: Text(context.t(widget.catKey), maxLines: 1, style: KText.display(ar, 28, color: Colors.white))),
                const SizedBox(height: 4),
                Row(children: [
                  Text('${widget.count} ${context.t('pieces')}', style: KText.body(ar, 13, color: Colors.white.withValues(alpha: 0.8))),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: hover ? Colors.white : Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Icon(ar ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded, size: 18, color: hover ? KColors.ink : Colors.white),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Marquee extends StatefulWidget {
  const _Marquee();
  @override
  State<_Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<_Marquee> with SingleTickerProviderStateMixin {
  final ScrollController sc = ScrollController();
  late final Ticker t;
  @override
  void initState() {
    super.initState();
    t = createTicker((elapsed) {
      if (sc.hasClients && sc.position.hasContentDimensions) {
        sc.jumpTo(elapsed.inMicroseconds / 1e6 * 42);
      }
    })..start();
  }

  @override
  void dispose() {
    t.dispose();
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final words = ar
        ? ['شحن مجاني فوق ١٢٠\$', 'إرجاع خلال ٣٠ يوماً', 'قطن عضوي وصوف ميرينو', 'عارض ثلاثي الأبعاد', 'دفع آمن بفيزا وماستركارد']
        : ['FREE SHIPPING OVER \$120', '30-DAY RETURNS', 'ORGANIC COTTON & MERINO', 'TRY IT IN 3D', 'SECURE VISA & MASTERCARD CHECKOUT'];
    return Container(
      height: 54,
      color: KColors.ink,
      child: ListView.builder(
        controller: sc,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(children: [
              Text(words[i % words.length], style: KText.label(ar, color: Colors.white, size: 13)),
              const SizedBox(width: 52),
              Icon(Icons.auto_awesome_rounded, size: 14, color: context.app.accent),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Newsletter extends StatefulWidget {
  const _Newsletter();
  @override
  State<_Newsletter> createState() => _NewsletterState();
}

class _NewsletterState extends State<_Newsletter> {
  final ctl = TextEditingController();
  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final accent = context.app.accent;
    final field = Row(children: [
      Expanded(
        child: TextField(
          controller: ctl,
          style: KText.body(ar, 15, color: Colors.white),
          decoration: InputDecoration(
            hintText: context.t('emailPlaceholder'),
            hintStyle: KText.body(ar, 15, color: Colors.white.withValues(alpha: 0.5)),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
          ),
        ),
      ),
      const SizedBox(width: 10),
      KButton(
        label: context.t('subscribe'),
        dark: true,
        onTap: () {
          ctl.clear();
          showToast(context, context.t('subscribed'));
        },
      ),
    ]);
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(context.t('newsletterTitle'), style: KText.display(ar, mobile ? 28 : 40, color: Colors.white)),
      const SizedBox(height: 8),
      Text(context.t('newsletterSub'), style: KText.body(ar, 15, color: Colors.white.withValues(alpha: 0.7))),
    ]);
    return Constrained(
      child: Container(
        padding: EdgeInsets.all(mobile ? 26 : 52),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(colors: [Color.lerp(KColors.ink, accent, 0.35)!, KColors.ink], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: mobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 22), field])
            : Row(children: [Expanded(child: left), const SizedBox(width: 40), Expanded(child: field)]),
      ),
    );
  }
}

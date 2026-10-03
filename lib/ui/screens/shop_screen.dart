import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/strings.dart';
import '../../data/products.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/product_grid.dart';
import '../widgets/shell.dart';

class ShopScreen extends StatefulWidget {
  final String cat;
  const ShopScreen({super.key, this.cat = 'all'});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late String cat = widget.cat;
  String sort = 'featured';
  String q = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.appRead.setAccent(const Color(0xFFC4572F));
    });
  }

  List<Product> get list {
    var l = kProducts.where((p) => cat == 'all' || p.cats.contains(cat)).toList();
    if (q.trim().isNotEmpty) {
      final s = q.trim().toLowerCase();
      l = l.where((p) => p.nameEn.toLowerCase().contains(s) || p.nameAr.contains(s)).toList();
    }
    switch (sort) {
      case 'newest':
        l.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
      case 'low':
        l.sort((a, b) => a.price.compareTo(b.price));
      case 'high':
        l.sort((a, b) => b.price.compareTo(a.price));
      case 'rating':
        l.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final accent = context.app.accent;
    final items = list;
    final cats = ['all', 'women', 'men', 'knitwear', 'accessories'];

    final chips = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (final c in cats)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => cat = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: cat == c ? KColors.ink : Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: cat == c ? KColors.ink : KColors.line),
                  ),
                  child: Text(context.t(c), style: KText.body(ar, 14, w: FontWeight.w700, color: cat == c ? Colors.white : KColors.ink)),
                ),
              ),
            ),
          ),
      ]),
    );

    final sortBox = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KColors.line)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: sort,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: KText.body(ar, 14, w: FontWeight.w600),
          items: [
            DropdownMenuItem(value: 'featured', child: Text(context.t('sortFeatured'))),
            DropdownMenuItem(value: 'newest', child: Text(context.t('sortNewest'))),
            DropdownMenuItem(value: 'low', child: Text(context.t('sortPriceLow'))),
            DropdownMenuItem(value: 'high', child: Text(context.t('sortPriceHigh'))),
            DropdownMenuItem(value: 'rating', child: Text(context.t('sortRating'))),
          ],
          onChanged: (v) => setState(() => sort = v!),
        ),
      ),
    );

    final search = SizedBox(
      width: mobile ? double.infinity : 280,
      child: TextField(
        onChanged: (v) => setState(() => q = v),
        style: KText.body(ar, 14.5),
        decoration: InputDecoration(
          hintText: context.t('search'),
          hintStyle: KText.body(ar, 14, color: KColors.muted),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
        ),
      ),
    );

    return PageBody(children: [
      Constrained(
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 52, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FadeSlideIn(child: Text(ar ? context.t('shop') : context.t('shop').toUpperCase(), style: KText.label(ar, color: accent, size: 12.5))),
          const SizedBox(height: 10),
          FadeSlideIn(delayMs: 100, child: Text(context.t('shopTitle'), style: KText.display(ar, mobile ? 38 : 64))),
          const SizedBox(height: 8),
          Text(context.t('shopSub'), style: KText.body(ar, 16.5, color: KColors.muted)),
          const SizedBox(height: 30),
          chips,
          const SizedBox(height: 18),
          mobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [search, const SizedBox(height: 12), Row(children: [Expanded(child: sortBox)])])
              : Row(children: [search, const Spacer(), Text('${items.length} ${context.t('results')}', style: KText.body(ar, 14, color: KColors.muted)), const SizedBox(width: 18), sortBox]),
          const SizedBox(height: 30),
          if (items.isEmpty)
            Padding(padding: const EdgeInsets.symmetric(vertical: 80), child: Center(child: Text(context.t('noResults'), style: KText.display(ar, 24))))
          else
            ProductGrid(items),
        ]),
      ),
    ]);
  }
}

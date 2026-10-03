import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/nav.dart';
import '../../core/strings.dart';
import '../../data/legal_content.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/logo.dart';
import '../widgets/shell.dart';

void _tint(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) context.appRead.setAccent(const Color(0xFFC4572F));
  });
}

/// Long-form legal pages (privacy, terms, shipping & returns).
class LegalScreen extends StatefulWidget {
  final String titleKey;
  final List<Section> en;
  final List<Section> ar;
  final bool showUpdated;
  const LegalScreen({super.key, required this.titleKey, required this.en, required this.ar, this.showUpdated = true});
  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  @override
  void initState() {
    super.initState();
    _tint(context);
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final secs = ar ? widget.ar : widget.en;
    return PageBody(children: [
      Constrained(
        max: 860,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FadeSlideIn(child: Text(context.t(widget.titleKey), style: KText.display(ar, mobile ? 36 : 58))),
          const SizedBox(height: 10),
          if (widget.showUpdated) Text(context.t('lastUpdated'), style: KText.body(ar, 14, color: KColors.muted)),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9C46A))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFF8A5A00)),
              const SizedBox(width: 12),
              Expanded(child: Text(context.t('fictionalNotice'), style: KText.body(ar, 13.5, color: const Color(0xFF5E3D00), w: FontWeight.w600))),
            ]),
          ),
          const SizedBox(height: 34),
          for (final s in secs) ...[
            Text(s.h, style: KText.display(ar, 24)),
            const SizedBox(height: 10),
            for (final p in s.p) Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(p, style: KText.body(ar, 16, color: const Color(0xFF3F3A33), h: 1.7))),
            const SizedBox(height: 18),
          ],
        ]),
      ),
    ]);
  }
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    _tint(context);
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final list = ar ? faqAr : faqEn;
    return PageBody(children: [
      Constrained(
        max: 860,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FadeSlideIn(child: Text(context.t('faq'), style: KText.display(ar, mobile ? 36 : 58))),
          const SizedBox(height: 28),
          for (final q in list)
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: KColors.line)),
                child: ExpansionTile(
                  shape: const RoundedRectangleBorder(),
                  collapsedShape: const RoundedRectangleBorder(),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Text(q.q, style: KText.body(ar, 16.5, w: FontWeight.w700)),
                  children: [Text(q.a, style: KText.body(ar, 15.5, color: KColors.muted, h: 1.65))],
                ),
              ),
            ),
        ]),
      ),
    ]);
  }
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    _tint(context);
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final story = ar ? aboutStoryAr : aboutStoryEn;
    final accent = context.app.accent;
    final stats = [
      ('2,400+', ar ? 'تقييم خيالي' : 'imaginary reviews'),
      ('30', ar ? 'يوم إرجاع' : 'day returns'),
      ('9', ar ? 'ألوان تريكو' : 'knit colours'),
      ('0', ar ? 'طلبات حقيقية' : 'real orders'),
    ];
    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(ar ? context.t('about') : context.t('about').toUpperCase(), style: KText.label(ar, color: accent, size: 12.5)),
      const SizedBox(height: 12),
      Text(ar ? 'خيط واحد، بعناية.' : 'One thread, done carefully.', style: KText.display(ar, mobile ? 38 : 64)),
      const SizedBox(height: 22),
      for (final p in story) Padding(padding: const EdgeInsets.only(bottom: 14), child: Text(p, style: KText.body(ar, 17, color: const Color(0xFF3F3A33), h: 1.7))),
      const SizedBox(height: 18),
      Row(children: [
        KhaytMark(size: 54, thread: accent),
        const SizedBox(width: 14),
        Expanded(child: Text(ar ? 'تصميم وبرمجة: Muhammed Elhuseyin' : 'Designed and built by Muhammed Elhuseyin', style: KText.body(ar, 14, color: KColors.muted, w: FontWeight.w600))),
      ]),
    ]);
    final photo = ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: AspectRatio(aspectRatio: 4 / 5, child: Image.asset('assets/images/products/hero1.jpg', fit: BoxFit.cover)),
    );
    return PageBody(children: [
      Constrained(
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
        child: mobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [text, const SizedBox(height: 30), photo])
            : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(flex: 6, child: text), const SizedBox(width: 56), Expanded(flex: 5, child: photo)]),
      ),
      const SizedBox(height: 70),
      Constrained(
        child: Wrap(spacing: 18, runSpacing: 18, children: [
          for (final s in stats)
            Container(
              width: mobile ? (MediaQuery.sizeOf(context).width - Bp.pad(context) * 2 - 18) / 2 : 270,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: KColors.line)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.$1, style: KText.display(ar, 42, color: accent)),
                const SizedBox(height: 4),
                Text(s.$2, style: KText.body(ar, 14, color: KColors.muted, w: FontWeight.w600)),
              ]),
            ),
        ]),
      ),
    ]);
  }
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final msg = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tint(context);
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    final mobile = Bp.mobile(context);
    final accent = context.app.accent;
    InputDecoration deco(String key) => InputDecoration(
          labelText: context.t(key),
          labelStyle: KText.body(ar, 14, color: KColors.muted),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: KColors.line)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: accent, width: 1.8)),
        );
    String? req(String? v) => (v == null || v.trim().isEmpty) ? context.t('required') : null;

    Widget info(IconData i, String t, String v) => Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: accent.withValues(alpha: 0.14), shape: BoxShape.circle), child: Icon(i, color: accent, size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ar ? t : t.toUpperCase(), style: KText.label(ar)),
              const SizedBox(height: 4),
              Text(v, style: KText.body(ar, 15.5, w: FontWeight.w600)),
            ])),
          ]),
        );

    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(context.t('contactTitle'), style: KText.display(ar, mobile ? 36 : 56)),
      const SizedBox(height: 14),
      Text(context.t('contactSub'), style: KText.body(ar, 17, color: KColors.muted)),
      const SizedBox(height: 34),
      info(Icons.mail_outline_rounded, context.t('writeUs'), kEmail),
      info(Icons.phone_outlined, context.t('callUs'), kPhone),
      info(Icons.location_on_outlined, context.t('visitUs'), ar ? kAddressAr : kAddressEn),
      info(Icons.schedule_rounded, ar ? 'ساعات العمل' : 'Hours', context.t('hours')),
    ]);

    final right = Container(
      padding: EdgeInsets.all(mobile ? 20 : 30),
      decoration: BoxDecoration(color: KColors.card, borderRadius: BorderRadius.circular(28), border: Border.all(color: KColors.line)),
      child: Form(
        key: form,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextFormField(controller: name, decoration: deco('yourName'), validator: req),
          const SizedBox(height: 14),
          TextFormField(controller: email, decoration: deco('email'), keyboardType: TextInputType.emailAddress, validator: (v) => (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) ? context.t('invalidEmail') : null),
          const SizedBox(height: 14),
          TextFormField(controller: msg, decoration: deco('yourMessage'), minLines: 5, maxLines: 8, validator: req),
          const SizedBox(height: 18),
          KButton(
            label: context.t('send'),
            icon: Icons.send_rounded,
            expand: true,
            onTap: () {
              if (!form.currentState!.validate()) return;
              name.clear();
              email.clear();
              msg.clear();
              showToast(context, context.t('messageSent'));
            },
          ),
        ]),
      ),
    );

    return PageBody(children: [
      Constrained(
        max: 1180,
        padding: EdgeInsets.fromLTRB(Bp.pad(context), mobile ? 28 : 56, Bp.pad(context), 0),
        child: mobile
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, const SizedBox(height: 20), right])
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 5, child: left), const SizedBox(width: 56), Expanded(flex: 5, child: right)]),
      ),
    ]);
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ar = context.isAr;
    return PageBody(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Center(child: Column(children: [
          Text('404', style: KText.display(ar, 90)),
          Text(context.t('notFound'), style: KText.body(ar, 17, color: KColors.muted)),
          const SizedBox(height: 22),
          KButton(label: context.t('backHome'), onTap: () => Go.top('/')),
        ])),
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CardBrand { visa, mastercard, unknown }

CardBrand detectBrand(String digits) {
  if (digits.startsWith('4')) return CardBrand.visa;
  if (digits.length >= 2) {
    final two = int.tryParse(digits.substring(0, 2)) ?? 0;
    if (two >= 51 && two <= 55) return CardBrand.mastercard;
  }
  if (digits.length >= 4) {
    final four = int.tryParse(digits.substring(0, 4)) ?? 0;
    if (four >= 2221 && four <= 2720) return CardBrand.mastercard;
  }
  return CardBrand.unknown;
}

String brandName(CardBrand b) => switch (b) { CardBrand.visa => 'Visa', CardBrand.mastercard => 'Mastercard', CardBrand.unknown => 'Card' };

class CardMark extends StatelessWidget {
  final CardBrand brand;
  final double height;
  final bool dim;
  const CardMark(this.brand, {super.key, this.height = 26, this.dim = false});

  @override
  Widget build(BuildContext context) {
    final w = height * 1.6;
    Widget inner;
    switch (brand) {
      case CardBrand.visa:
        inner = Center(child: Text('VISA', style: GoogleFonts.inter(fontSize: height * 0.52, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: const Color(0xFF1A1F71), letterSpacing: -0.5)));
        break;
      case CardBrand.mastercard:
        inner = Stack(alignment: Alignment.center, children: [
          Positioned(left: w * 0.20, child: Container(width: height * 0.62, height: height * 0.62, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle))),
          Positioned(right: w * 0.20, child: Container(width: height * 0.62, height: height * 0.62, decoration: BoxDecoration(color: const Color(0xFFF79E1B).withValues(alpha: 0.92), shape: BoxShape.circle))),
        ]);
        break;
      case CardBrand.unknown:
        inner = const Icon(Icons.credit_card_rounded, size: 20, color: Color(0xFF6E675C));
        break;
    }
    return Opacity(
      opacity: dim ? 0.35 : 1,
      child: Container(
        width: w,
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFFDDD3C4))),
        child: inner,
      ),
    );
  }
}

class PaymentMarks extends StatelessWidget {
  final bool light;
  const PaymentMarks({super.key, this.light = false});
  @override
  Widget build(BuildContext context) {
    return const Row(mainAxisSize: MainAxisSize.min, children: [
      CardMark(CardBrand.visa, height: 26),
      SizedBox(width: 8),
      CardMark(CardBrand.mastercard, height: 26),
    ]);
  }
}

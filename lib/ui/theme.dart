import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KColors {
  static const bg = Color(0xFFF6F1EA);
  static const card = Color(0xFFFFFBF5);
  static const ink = Color(0xFF1B1A17);
  static const muted = Color(0xFF6E675C);
  static const line = Color(0xFFDDD3C4);
  static const ok = Color(0xFF2F7D5B);
  static const danger = Color(0xFFB3382C);
}

class Bp {
  static bool mobile(BuildContext c) => MediaQuery.sizeOf(c).width < 720;
  static bool tablet(BuildContext c) => MediaQuery.sizeOf(c).width < 1100;
  static double pad(BuildContext c) => mobile(c) ? 18 : (tablet(c) ? 32 : 56);
}

class KText {
  static TextStyle display(bool ar, double size, {FontWeight w = FontWeight.w600, Color color = KColors.ink, double? h, double? ls}) {
    if (ar) return GoogleFonts.cairo(fontSize: size, fontWeight: w, color: color, height: h ?? 1.2, letterSpacing: 0);
    return GoogleFonts.playfairDisplay(fontSize: size, fontWeight: w, color: color, height: h ?? 1.08, letterSpacing: ls);
  }

  static TextStyle body(bool ar, double size, {FontWeight w = FontWeight.w400, Color color = KColors.ink, double? h, double? ls}) {
    if (ar) return GoogleFonts.cairo(fontSize: size, fontWeight: w, color: color, height: h ?? 1.55, letterSpacing: 0);
    return GoogleFonts.inter(fontSize: size, fontWeight: w, color: color, height: h ?? 1.5, letterSpacing: ls);
  }

  static TextStyle label(bool ar, {Color color = KColors.muted, double size = 12}) {
    if (ar) return GoogleFonts.cairo(fontSize: size, fontWeight: FontWeight.w700, color: color, letterSpacing: 0);
    return GoogleFonts.inter(fontSize: size, fontWeight: FontWeight.w600, color: color, letterSpacing: 1.6);
  }
}

String money(double v) => '\$${v.toStringAsFixed(2)}';
String money0(double v) => '\$${v.toStringAsFixed(v == v.roundToDouble() ? 0 : 2)}';

ThemeData buildTheme(bool ar) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: KColors.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC4572F), brightness: Brightness.light, surface: KColors.bg),
    splashFactory: InkRipple.splashFactory,
  );
  return base.copyWith(
    textTheme: (ar ? GoogleFonts.cairoTextTheme(base.textTheme) : GoogleFonts.interTextTheme(base.textTheme)).apply(bodyColor: KColors.ink, displayColor: KColors.ink),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: KColors.ink,
      contentTextStyle: KText.body(ar, 14, color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

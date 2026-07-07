import 'package:flutter/material.dart';

/// Design tokens for the whole site.
///
/// Direction: deep-space navy with an electric blue -> cyan gradient accent,
/// glowing cards, centered hero. Type: Chillax (display), Supreme (text),
/// Fragment Mono (labels/kickers).
abstract class Palette {
  /// Page background: near-black with a blue undertone.
  static const bg = Color(0xFF060B1A);

  /// Slightly lifted surface for cards and panels.
  static const surface = Color(0xFF0C142C);

  /// A second, lighter surface for hover states and inner chips.
  static const surfaceHi = Color(0xFF121C3A);

  /// Primary electric blue.
  static const blue = Color(0xFF3D7BFD);

  /// Cyan partner for gradients and highlights.
  static const cyan = Color(0xFF3FD8FF);

  /// Main reading color: soft blue-white.
  static const text = Color(0xFFE9EFFC);

  /// Secondary text.
  static const dim = Color(0xFF8B98BC);

  /// Hairline borders on cards.
  static const line = Color(0x2233518F);

  /// The signature gradient, used for CTAs, the name, and glow accents.
  static const gradient = LinearGradient(
    colors: [blue, cyan],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

/// Layout breakpoints. Mobile-first: single column is the base layout.
abstract class Breaks {
  static const mobile = 700.0;
  static const desktop = 1080.0;
}

/// Fluid type scale: interpolates a size between a 360px and a 1440px
/// viewport so text resizes continuously instead of jumping.
double fluid(BuildContext context, double min, double max) {
  final w = MediaQuery.sizeOf(context).width;
  final t = ((w - 360) / (1440 - 360)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}

/// True when the layout should collapse to a single column.
bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < Breaks.mobile;

/// Text styles. Three voices:
///  - Chillax for display: headlines, numbers, the name.
///  - Supreme for reading: paragraphs and UI.
///  - Fragment Mono for machine voice: kickers, labels, tags.
abstract class Type {
  /// Hero-scale display.
  static TextStyle display(BuildContext c,
      {double min = 40, double max = 84, Color color = Palette.text}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'Chillax',
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.04,
      letterSpacing: size * -0.015,
      color: color,
    );
  }

  /// Section-level headings.
  static TextStyle heading(BuildContext c,
      {double min = 26, double max = 44, Color color = Palette.text}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'Chillax',
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.1,
      letterSpacing: size * -0.01,
      color: color,
    );
  }

  /// Card titles and sub-headings.
  static TextStyle title(BuildContext c,
      {double min = 18, double max = 24, Color color = Palette.text}) {
    return TextStyle(
      fontFamily: 'Chillax',
      fontWeight: FontWeight.w500,
      fontSize: fluid(c, min, max),
      height: 1.2,
      color: color,
    );
  }

  /// Body copy.
  static TextStyle body(BuildContext c, {Color color = Palette.dim}) {
    return TextStyle(
      fontFamily: 'Supreme',
      fontWeight: FontWeight.w400,
      fontSize: fluid(c, 15.5, 18),
      height: 1.65,
      color: color,
    );
  }

  /// Larger intro paragraph (hero statement).
  static TextStyle lede(BuildContext c, {Color color = Palette.dim}) {
    return TextStyle(
      fontFamily: 'Supreme',
      fontWeight: FontWeight.w400,
      fontSize: fluid(c, 17, 21),
      height: 1.55,
      color: color,
    );
  }

  /// Mono labels/kickers. ALL CAPS gets wide tracking.
  static TextStyle label(BuildContext c,
      {Color color = Palette.dim, double min = 11, double max = 13}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'FragmentMono',
      fontSize: size,
      height: 1.4,
      letterSpacing: size * 0.18,
      color: color,
    );
  }

  /// Mono at reading size (tags, small code-ish text).
  static TextStyle mono(BuildContext c, {Color color = Palette.dim}) {
    return TextStyle(
      fontFamily: 'FragmentMono',
      fontSize: fluid(c, 12, 14),
      height: 1.5,
      color: color,
    );
  }

  /// Giant stat numbers.
  static TextStyle stat(BuildContext c, {Color color = Palette.text}) {
    return TextStyle(
      fontFamily: 'Chillax',
      fontWeight: FontWeight.w700,
      fontSize: fluid(c, 34, 52),
      height: 1,
      color: color,
    );
  }
}

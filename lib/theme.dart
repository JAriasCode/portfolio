import 'package:flutter/material.dart';

/// Design tokens for the whole site.
///
/// Direction: typographic-first dev brand. Warm ink background, paper text,
/// a single amber accent (Von Restorff: one accent, used only where it earns
/// attention). No gradients, no purple, no glassmorphism.
abstract class Palette {
  /// Warm near-black. Deliberately NOT #000: keeps the page from reading as
  /// "default dark mode" and lets the grain overlay show.
  static const ink = Color(0xFF141210);

  /// Slightly raised surface for panels (project motifs, terminal window).
  static const inkRaised = Color(0xFF1B1815);

  /// Warm off-white for body text. Paper, not pure white.
  static const paper = Color(0xFFEDE6D8);

  /// Muted paper for secondary text and labels.
  static const paperDim = Color(0xFF9A9182);

  /// The one accent. Terminal-amber lineage, not indigo.
  static const amber = Color(0xFFF5A623);

  /// Hairline borders. Low-alpha paper so lines feel printed, not drawn.
  static const line = Color(0x26EDE6D8);
}

/// Layout breakpoints. Mobile-first: the single-column layout is the base
/// and desktop is the enhancement.
abstract class Breaks {
  static const mobile = 700.0;
  static const desktop = 1080.0;
}

/// Fluid type scale: interpolates a size between a 360px and a 1440px
/// viewport so headlines resize continuously instead of jumping.
double fluid(BuildContext context, double min, double max) {
  final w = MediaQuery.sizeOf(context).width;
  final t = ((w - 360) / (1440 - 360)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}

/// True when the layout should collapse to a single column.
bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < Breaks.mobile;

/// Text styles. Three voices:
///  - Erode (serif) for display: headlines and project names.
///  - Author (sans) for reading: paragraphs and UI.
///  - Fragment Mono for machine voice: labels, indexes, the pubspec block.
abstract class Type {
  /// Display headlines. Negative tracking on large sizes: LLM output leaves
  /// letter-spacing at default everywhere, humans tighten display type.
  static TextStyle display(BuildContext c,
      {double min = 44, double max = 120, Color color = Palette.paper}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'Erode',
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 0.98,
      letterSpacing: size * -0.02,
      color: color,
    );
  }

  /// Section-level serif headings.
  static TextStyle heading(BuildContext c,
      {double min = 28, double max = 56, Color color = Palette.paper}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'Erode',
      fontWeight: FontWeight.w500,
      fontSize: size,
      height: 1.05,
      letterSpacing: size * -0.015,
      color: color,
    );
  }

  /// Body copy. 16 to 19px, relaxed leading for reading.
  static TextStyle body(BuildContext c, {Color color = Palette.paper}) {
    return TextStyle(
      fontFamily: 'Author',
      fontWeight: FontWeight.w400,
      fontSize: fluid(c, 16, 19),
      height: 1.6,
      color: color,
    );
  }

  /// Larger intro paragraph (hero statement).
  static TextStyle lede(BuildContext c, {Color color = Palette.paper}) {
    return TextStyle(
      fontFamily: 'Author',
      fontWeight: FontWeight.w400,
      fontSize: fluid(c, 19, 26),
      height: 1.45,
      color: color,
    );
  }

  /// Mono labels. ALL CAPS always gets extra tracking (+8%), the classic
  /// human typesetting move.
  static TextStyle label(BuildContext c,
      {Color color = Palette.paperDim, double min = 11, double max = 13}) {
    final size = fluid(c, min, max);
    return TextStyle(
      fontFamily: 'FragmentMono',
      fontSize: size,
      height: 1.4,
      letterSpacing: size * 0.08,
      color: color,
    );
  }

  /// Mono at reading size, for the pubspec terminal block.
  static TextStyle code(BuildContext c, {Color color = Palette.paper}) {
    return TextStyle(
      fontFamily: 'FragmentMono',
      fontSize: fluid(c, 12.5, 15),
      height: 1.7,
      color: color,
    );
  }
}

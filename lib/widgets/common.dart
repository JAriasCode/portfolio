import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'motion.dart';

/// Max content width. Wide enough for editorial two-column layouts,
/// narrow enough that lines stay readable.
const kMaxContentWidth = 1200.0;

/// Standard horizontal gutter, fluid between phone and desktop.
EdgeInsets pageGutter(BuildContext c) =>
    EdgeInsets.symmetric(horizontal: fluid(c, 20, 64));

/// Centers content and applies the gutter. Every section sits in one.
class SectionShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const SectionShell({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? pageGutter(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
          child: child,
        ),
      ),
    );
  }
}

/// Mono kicker + serif heading, the repeating editorial section opener.
class SectionHeader extends StatelessWidget {
  final String index;
  final String label;
  final String title;

  const SectionHeader({
    super.key,
    required this.index,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(index, style: Type.label(context, color: Palette.amber)),
              const SizedBox(width: 12),
              Text(label.toUpperCase(), style: Type.label(context)),
              const SizedBox(width: 16),
              // Rule line that finishes the row, a print habit.
              Expanded(child: Container(height: 1, color: Palette.line)),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: Type.heading(context)),
        ],
      ),
    );
  }
}

/// Text link with an animated amber underline and arrow nudge on hover.
class HoverLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool showArrow;
  final TextStyle? style;

  const HoverLink({
    super.key,
    required this.text,
    required this.onTap,
    this.showArrow = false,
    this.style,
  });

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? Type.body(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.text,
                  style: style.copyWith(
                      color: _hover ? Palette.amber : style.color),
                ),
                if (widget.showArrow)
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text('->',
                          style: Type.code(context,
                              color:
                                  _hover ? Palette.amber : Palette.paperDim)),
                    ),
                  ),
              ],
            ),
            // Underline grows from the left on hover.
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              height: 1.5,
              width: _hover ? _textWidth(widget.text, style) : 0,
              color: Palette.amber,
            ),
          ],
        ),
      ),
    );
  }

  double _textWidth(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}

/// Small mono tag chip used in project rows.
class TagChip extends StatelessWidget {
  final String text;

  const TagChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: Palette.line)),
      child: Text(text, style: Type.label(context, min: 10.5, max: 12)),
    );
  }
}

/// TapGestureRecognizer helper for inline links inside rich text.
TapGestureRecognizer tapTo(VoidCallback fn) =>
    TapGestureRecognizer()..onTap = fn;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'motion.dart';

/// Max content width.
const kMaxContentWidth = 1160.0;

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

/// Centered section opener: mono kicker in cyan, big heading, optional
/// one-line subtitle. Matches the reference structure.
class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Column(
        children: [
          Text(label.toUpperCase(),
              style: Type.label(context, color: Palette.cyan)),
          const SizedBox(height: 14),
          Text(title,
              textAlign: TextAlign.center, style: Type.heading(context)),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(subtitle!,
                  textAlign: TextAlign.center, style: Type.body(context)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Card with the site's glow language: raised navy surface, hairline
/// border that lights up blue on hover, soft cyan shadow, slight lift.
class GlowCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;

  const GlowCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(26),
  });

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -5 : 0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hover ? Palette.surfaceHi : Palette.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hover
                ? Palette.blue.withValues(alpha: 0.65)
                : Palette.line,
          ),
          boxShadow: [
            if (_hover)
              BoxShadow(
                color: Palette.blue.withValues(alpha: 0.22),
                blurRadius: 34,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Primary CTA: gradient pill with a cyan glow that intensifies on hover.
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform:
              Matrix4.diagonal3Values(_hover ? 1.04 : 1, _hover ? 1.04 : 1, 1),
          transformAlignment: Alignment.center,
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            gradient: Palette.gradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Palette.blue.withValues(alpha: _hover ? 0.55 : 0.3),
                blurRadius: _hover ? 34 : 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.text,
                  style: TextStyle(
                    fontFamily: 'Supreme',
                    fontWeight: FontWeight.w700,
                    fontSize: fluid(context, 14, 16),
                    color: const Color(0xFF04101F),
                  )),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.icon,
                    size: 18, color: const Color(0xFF04101F)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Secondary CTA: outlined pill that fills subtly on hover.
class OutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const OutlineButton({super.key, required this.text, required this.onTap});

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            color: _hover
                ? Palette.cyan.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hover
                  ? Palette.cyan
                  : Palette.dim.withValues(alpha: 0.5),
            ),
          ),
          child: Text(widget.text,
              style: TextStyle(
                fontFamily: 'Supreme',
                fontWeight: FontWeight.w600,
                fontSize: fluid(context, 14, 16),
                color: _hover ? Palette.cyan : Palette.text,
              )),
        ),
      ),
    );
  }
}

/// Small mono tag chip.
class TagChip extends StatelessWidget {
  final String text;
  final bool accent;

  const TagChip(this.text, {super.key, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? Palette.cyan.withValues(alpha: 0.1)
            : Palette.surfaceHi,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accent
              ? Palette.cyan.withValues(alpha: 0.5)
              : Palette.line,
        ),
      ),
      child: Text(
        text,
        style: Type.mono(context,
            color: accent ? Palette.cyan : Palette.dim),
      ),
    );
  }
}

/// Nav / footer text link with cyan hover.
class HoverLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const HoverLink({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? Type.body(context, color: Palette.text);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 160),
          style: style.copyWith(color: _hover ? Palette.cyan : style.color),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

/// Name-style gradient text via ShaderMask.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  const GradientText(this.text,
      {super.key, required this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => Palette.gradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(text, textAlign: textAlign, style: style),
    );
  }
}

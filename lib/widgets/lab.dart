import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../theme.dart';
import 'motion.dart';

/// The Widget Lab: three small interactive Flutter toys running live on the
/// page. The point is not decoration; it is proof of motion craft, each demo
/// built with a different animation technique:
///  1. SpringOrbDemo    - physics-based (SpringSimulation)
///  2. StaggerBarsDemo  - staggered Intervals on one controller
///  3. MorphDemo        - implicit animations only

// ---------------------------------------------------------------------------
// 1. SPRING PHYSICS
// ---------------------------------------------------------------------------

/// Drag the orb anywhere inside the card and release: a 2D spring pulls it
/// back to center with natural overshoot. Classic physics-based pattern:
/// AnimationController driven by SpringSimulation per axis via animateWith.
class SpringOrbDemo extends StatefulWidget {
  const SpringOrbDemo({super.key});

  @override
  State<SpringOrbDemo> createState() => _SpringOrbDemoState();
}

class _SpringOrbDemoState extends State<SpringOrbDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController.unbounded(vsync: this);
  Animation<Offset>? _spring;

  /// Orb offset from the center of the card, in px.
  Offset _offset = Offset.zero;

  static const _spec = SpringDescription(mass: 1, stiffness: 340, damping: 16);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_spring != null) setState(() => _offset = _spring!.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _release(DragEndDetails details) {
    // Animate 0 -> 1 with spring timing; the Offset tween maps that onto
    // the release position -> center path, keeping the flick velocity.
    _spring = Tween<Offset>(begin: _offset, end: Offset.zero)
        .animate(_controller);
    final v = details.velocity.pixelsPerSecond;
    final speed = v.distance / max(_offset.distance, 1);
    _controller.value = 0;
    _controller.animateWith(SpringSimulation(_spec, 0, 1, -speed / 1000));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bounds = constraints.biggest;
      return GestureDetector(
        onPanStart: (_) => _controller.stop(),
        onPanUpdate: (d) => setState(() {
          final next = _offset + d.delta;
          // Keep the orb inside the card with a small margin.
          _offset = Offset(
            next.dx.clamp(-bounds.width / 2 + 34, bounds.width / 2 - 34),
            next.dy.clamp(-bounds.height / 2 + 34, bounds.height / 2 - 34),
          );
        }),
        onPanEnd: _release,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Anchor mark at the spring's rest point.
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Palette.line, width: 2),
              ),
            ),
            Transform.translate(
              offset: _offset,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Palette.gradient,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.cyan.withValues(alpha: 0.45),
                      blurRadius: 26,
                    ),
                  ],
                ),
                child: const Icon(Icons.open_with_rounded,
                    size: 22, color: Color(0xFF04101F)),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// 2. STAGGERED INTERVALS
// ---------------------------------------------------------------------------

/// Five bars animated by ONE controller, each bar bound to a different
/// Interval window: the canonical staggered-animation pattern. Tap replays.
class StaggerBarsDemo extends StatefulWidget {
  const StaggerBarsDemo({super.key});

  @override
  State<StaggerBarsDemo> createState() => _StaggerBarsDemoState();
}

class _StaggerBarsDemoState extends State<StaggerBarsDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final List<Animation<double>> _bars;

  static const _heights = [0.55, 0.85, 0.4, 1.0, 0.68];

  @override
  void initState() {
    super.initState();
    // Each bar owns a 0.5-wide window, offset by 12.5% per index, so the
    // rises overlap like a wave instead of firing all at once.
    _bars = List.generate(_heights.length, (i) {
      final start = i * 0.125;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, start + 0.5, curve: Curves.easeOutBack),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !reducedMotion(context)) _controller.forward();
      if (mounted && reducedMotion(context)) _controller.value = 1;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay() {
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _replay,
      child: LayoutBuilder(builder: (context, constraints) {
        final maxH = constraints.maxHeight * 0.7;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < _heights.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: AnimatedBuilder(
                  animation: _bars[i],
                  builder: (context, _) {
                    final v = _bars[i].value.clamp(0.0, 1.2);
                    return Container(
                      width: 22,
                      height: maxH * _heights[i] * v + 6,
                      margin: EdgeInsets.only(
                          bottom: constraints.maxHeight * 0.15),
                      decoration: BoxDecoration(
                        gradient: Palette.gradient,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Palette.blue.withValues(alpha: 0.3 * v),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. IMPLICIT MORPH
// ---------------------------------------------------------------------------

/// Tap to morph between a circle and a rounded square, swapping color and
/// icon at the same time. Zero controllers: AnimatedContainer plus
/// AnimatedSwitcher carry the whole effect.
class MorphDemo extends StatefulWidget {
  const MorphDemo({super.key});

  @override
  State<MorphDemo> createState() => _MorphDemoState();
}

class _MorphDemoState extends State<MorphDemo> {
  bool _alt = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _alt = !_alt),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutBack,
          width: _alt ? 120 : 84,
          height: _alt ? 72 : 84,
          decoration: BoxDecoration(
            color: _alt ? Palette.cyan : Palette.blue,
            // 60 already renders as a full circle on an 84px box, and 22
            // keeps a cushion above zero: easeInOutBack overshoots past the
            // tween ends, and a lerped radius below 0 clamps to square
            // corners for a frame. This range never reaches that point.
            borderRadius: BorderRadius.circular(_alt ? 22 : 60),
            boxShadow: [
              BoxShadow(
                color: (_alt ? Palette.cyan : Palette.blue)
                    .withValues(alpha: 0.4),
                blurRadius: 30,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              _alt ? Icons.smartphone_rounded : Icons.touch_app_rounded,
              key: ValueKey(_alt),
              color: const Color(0xFF04101F),
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Static film-grain overlay at ~3% opacity across the whole page.
/// Grain is the cheapest anti-flat texture there is: it reads as print,
/// costs nothing at runtime (painted once, cached by RepaintBoundary),
/// and separates the site from the perfectly-flat template look.
class GrainOverlay extends StatelessWidget {
  const GrainOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  const _GrainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Fixed seed: the grain pattern is stable across repaints, so it never
    // shimmers or distracts. Density scales with area.
    final rng = Random(1984);
    final light = Paint()..color = Palette.paper.withValues(alpha: 0.030);
    final dark = Paint()..color = Colors.black.withValues(alpha: 0.05);
    final count = (size.width * size.height / 600).clamp(800, 12000).toInt();
    for (var i = 0; i < count; i++) {
      final offset = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, 1, 1),
        rng.nextBool() ? light : dark,
      );
    }
  }

  @override
  bool shouldRepaint(_GrainPainter oldDelegate) => false;
}

/// Hand-drawn-looking underline: a slightly wobbly amber stroke drawn with
/// seeded jitter, animated left to right on reveal. This is the deliberate
/// human mark of the page; used exactly once, in the hero.
class WobblyUnderline extends StatelessWidget {
  final double progress; // 0..1 draw-on
  final double thickness;

  const WobblyUnderline({
    super.key,
    required this.progress,
    this.thickness = 3,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WobblyPainter(progress: progress, thickness: thickness),
      size: const Size(double.infinity, 10),
    );
  }
}

class _WobblyPainter extends CustomPainter {
  final double progress;
  final double thickness;

  const _WobblyPainter({required this.progress, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || size.width <= 0) return;
    final rng = Random(7); // fixed seed: same wobble every frame
    final path = Path()..moveTo(0, size.height * 0.5);
    const step = 26.0;
    var x = 0.0;
    while (x < size.width) {
      final nextX = min(x + step, size.width);
      // Small vertical jitter makes the line read as drawn, not rendered.
      final controlY = size.height * 0.5 + (rng.nextDouble() - 0.5) * 6;
      path.quadraticBezierTo((x + nextX) / 2, controlY, nextX,
          size.height * 0.5 + (rng.nextDouble() - 0.5) * 2.5);
      x = nextX;
    }

    // Draw only the first `progress` fraction of the stroke.
    final metric = path.computeMetrics().first;
    final partial = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(
      partial,
      Paint()
        ..color = Palette.amber
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_WobblyPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// 2px amber reading-progress line pinned to the top of the viewport.
class ScrollProgressBar extends StatelessWidget {
  final ScrollController controller;

  const ScrollProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double t = 0;
        // hasContentDimensions: extents are null until the first layout
        // pass, so hasClients alone is not a safe guard here.
        if (controller.hasClients &&
            controller.position.hasContentDimensions &&
            controller.position.maxScrollExtent > 0) {
          t = (controller.offset / controller.position.maxScrollExtent)
              .clamp(0.0, 1.0);
        }
        return Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: t,
            child: Container(height: 2, color: Palette.amber),
          ),
        );
      },
    );
  }
}

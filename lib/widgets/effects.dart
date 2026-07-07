import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme.dart';
import 'motion.dart';

/// Animated constellation background: drifting particles that connect with
/// thin lines when close. Painted on the compositor every frame, but with a
/// small particle budget so it stays cheap even on modest laptops.
class ParticleField extends StatefulWidget {
  /// Particle count per 100k px² of surface, clamped to a hard budget.
  const ParticleField({super.key});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  Offset pos;
  Offset vel;
  double radius;
  _Particle(this.pos, this.vel, this.radius);
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  final _particles = <_Particle>[];
  final _rng = Random(42);
  Ticker? _ticker;
  Duration _last = Duration.zero;
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  /// First layout only: populate the field.
  void _seed(Size size) {
    _size = size;
    _particles.clear();
    // ~1 particle per 18k px², capped: enough for constellation lines
    // without turning the hero into a starfield screensaver.
    final count = (size.width * size.height / 18000).clamp(24, 90).toInt();
    for (var i = 0; i < count; i++) {
      _particles.add(_Particle(
        Offset(_rng.nextDouble() * size.width,
            _rng.nextDouble() * size.height),
        Offset((_rng.nextDouble() - 0.5) * 18,
            (_rng.nextDouble() - 0.5) * 18),
        _rng.nextDouble() * 1.6 + 0.8,
      ));
    }
  }

  void _tick(Duration elapsed) {
    final dt = ((elapsed - _last).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _last = elapsed;
    if (!mounted || _size == Size.zero) return;
    if (reducedMotion(context)) return; // freeze field, keep it visible
    for (final p in _particles) {
      p.pos += p.vel * dt;
      // Wrap around edges so the field never empties out.
      if (p.pos.dx < 0) p.pos = Offset(_size.width, p.pos.dy);
      if (p.pos.dx > _size.width) p.pos = Offset(0, p.pos.dy);
      if (p.pos.dy < 0) p.pos = Offset(p.pos.dx, _size.height);
      if (p.pos.dy > _size.height) p.pos = Offset(p.pos.dx, 0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  /// Later size changes (e.g. the hero grows a line when the typing text
  /// wraps) must NOT reshuffle the sky: keep every particle where it is and
  /// let the wrap-around logic absorb the new bounds. Reseeding here caused
  /// a visible constellation "jump" every few seconds.
  void _resize(Size size) {
    _size = size;
    for (final p in _particles) {
      p.pos = Offset(
        p.pos.dx.clamp(0.0, size.width),
        p.pos.dy.clamp(0.0, size.height),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          if (_particles.isEmpty) {
            _seed(size);
          } else if (size != _size) {
            _resize(size);
          }
          return CustomPaint(
            size: size,
            painter: _ParticlePainter(particles: _particles),
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = Palette.cyan.withValues(alpha: 0.55);
    final line = Paint()..strokeWidth = 1;
    const linkDist = 130.0;
    for (var i = 0; i < particles.length; i++) {
      final a = particles[i];
      canvas.drawCircle(a.pos, a.radius, dot);
      // Connect close neighbours; alpha fades with distance.
      for (var j = i + 1; j < particles.length; j++) {
        final b = particles[j];
        final d = (a.pos - b.pos).distance;
        if (d < linkDist) {
          line.color =
              Palette.blue.withValues(alpha: 0.18 * (1 - d / linkDist));
          canvas.drawLine(a.pos, b.pos, line);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}

/// Soft radial glow spot, used behind the hero and section headings to give
/// the page its blue depth. Pure decoration, ignores pointers.
class GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const GlowBlob({
    super.key,
    required this.size,
    this.color = Palette.blue,
    this.opacity = 0.16,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2px gradient reading-progress line pinned to the top of the viewport.
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
            child: Container(
              height: 2,
              decoration: const BoxDecoration(gradient: Palette.gradient),
            ),
          ),
        );
      },
    );
  }
}

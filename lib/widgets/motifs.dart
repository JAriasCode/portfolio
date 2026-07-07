import 'dart:math';

import 'package:flutter/material.dart';

import '../content.dart';
import '../theme.dart';

/// Each project gets a custom-painted line illustration inside a phone
/// outline: no stock images, no AI renders, no screenshots to date badly.
/// Strokes are paper-toned; the amber accent lights up on hover.
class ProjectMotifView extends StatelessWidget {
  final ProjectMotif motif;
  final bool hovered;

  const ProjectMotifView({super.key, required this.motif, this.hovered = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Palette.inkRaised,
        border: Border.all(
          color: hovered ? Palette.amber : Palette.line,
        ),
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: CustomPaint(
          painter: _MotifPainter(motif: motif, hovered: hovered),
        ),
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  final ProjectMotif motif;
  final bool hovered;

  const _MotifPainter({required this.motif, required this.hovered});

  Paint get _stroke => Paint()
    ..color = Palette.paperDim
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4;

  Paint get _accent => Paint()
    ..color = hovered ? Palette.amber : Palette.paperDim
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Paint get _accentFill => Paint()
    ..color = hovered ? Palette.amber : Palette.paperDim
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Phone outline shared by every motif: this is a mobile portfolio and
    // the frame keeps repeating that quietly.
    final phone = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.height * 0.52,
      height: size.height * 0.86,
    );
    final rrect = RRect.fromRectAndRadius(phone, const Radius.circular(18));
    canvas.drawRRect(rrect, _stroke);
    // Speaker slot.
    canvas.drawLine(
      Offset(phone.center.dx - 14, phone.top + 14),
      Offset(phone.center.dx + 14, phone.top + 14),
      _stroke,
    );

    // Screen area where each project draws its own signature shape.
    final screen = Rect.fromLTRB(
        phone.left + 10, phone.top + 26, phone.right - 10, phone.bottom - 14);
    canvas.save();
    canvas.clipRect(screen);
    switch (motif) {
      case ProjectMotif.diamond:
        _paintDiamond(canvas, screen);
      case ProjectMotif.rings:
        _paintRings(canvas, screen);
      case ProjectMotif.card:
        _paintCard(canvas, screen);
      case ProjectMotif.grid:
        _paintGrid(canvas, screen);
    }
    canvas.restore();
  }

  /// Prep Baseball: infield diamond with base dots and a fly-ball arc.
  void _paintDiamond(Canvas canvas, Rect r) {
    final c = Offset(r.center.dx, r.center.dy + r.height * 0.12);
    final d = r.width * 0.36;
    final diamond = Path()
      ..moveTo(c.dx, c.dy + d) // home
      ..lineTo(c.dx + d, c.dy) // first
      ..lineTo(c.dx, c.dy - d) // second
      ..lineTo(c.dx - d, c.dy) // third
      ..close();
    canvas.drawPath(diamond, _stroke);
    for (final base in [
      Offset(c.dx, c.dy + d),
      Offset(c.dx + d, c.dy),
      Offset(c.dx, c.dy - d),
      Offset(c.dx - d, c.dy),
    ]) {
      canvas.drawCircle(base, 3, _accentFill);
    }
    // Fly ball leaving the park.
    final arc = Path()
      ..moveTo(c.dx, c.dy + d)
      ..quadraticBezierTo(
          c.dx + d * 1.1, c.dy - d * 1.6, c.dx + d * 0.2, c.dy - d * 2.4);
    canvas.drawPath(arc, _accent..strokeWidth = 1.4);
  }

  /// NuMbi: concentric macro rings with tick marks, one ring accented.
  void _paintRings(Canvas canvas, Rect r) {
    final c = r.center;
    final maxR = r.width * 0.34;
    for (var i = 0; i < 3; i++) {
      final radius = maxR - i * 12.0;
      // Each ring is an open arc, like a tracker mid-day, not a full circle.
      final sweep = pi * (1.1 + i * 0.25);
      canvas.drawArc(Rect.fromCircle(center: c, radius: radius), -pi / 2,
          sweep, false, i == 0 ? _accent : _stroke);
    }
    // Tick marks around the outside.
    for (var a = 0; a < 12; a++) {
      final angle = a * pi / 6;
      final from = c + Offset(cos(angle), sin(angle)) * (maxR + 7);
      final to = c + Offset(cos(angle), sin(angle)) * (maxR + 11);
      canvas.drawLine(from, to, _stroke);
    }
  }

  /// MutualMovil: bank card with a chip plus a fingerprint whorl.
  void _paintCard(Canvas canvas, Rect r) {
    final card = Rect.fromCenter(
        center: Offset(r.center.dx, r.center.dy - r.height * 0.12),
        width: r.width * 0.62,
        height: r.width * 0.40);
    canvas.drawRRect(
        RRect.fromRectAndRadius(card, const Radius.circular(8)), _stroke);
    // Chip.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(card.left + 10, card.top + 12, 16, 12),
          const Radius.circular(2)),
      _accent..strokeWidth = 1.4,
    );
    canvas.drawLine(Offset(card.left + 10, card.bottom - 12),
        Offset(card.left + card.width * 0.55, card.bottom - 12), _stroke);
    // Fingerprint arcs below the card: the biometric login.
    final fc = Offset(r.center.dx, card.bottom + r.height * 0.22);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(Rect.fromCircle(center: fc, radius: i * 7.0), pi * 1.15,
          pi * 0.7, false, i == 2 ? _accent : _stroke);
    }
  }

  /// Vivco: a block of condo units plus a QR finder pattern in the corner.
  void _paintGrid(Canvas canvas, Rect r) {
    const cols = 4, rows = 5;
    final w = r.width * 0.13, h = r.height * 0.10;
    final startX = r.center.dx - (cols * w + (cols - 1) * 5) / 2;
    final startY = r.center.dy - (rows * h + (rows - 1) * 5) / 2;
    final rng = Random(3); // fixed seed: same lit windows every paint
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cell = Rect.fromLTWH(
            startX + col * (w + 5), startY + row * (h + 5), w, h);
        // A few units are "home": filled instead of outlined.
        if (rng.nextDouble() < 0.22) {
          canvas.drawRect(cell, _accentFill);
        } else {
          canvas.drawRect(cell, _stroke);
        }
      }
    }
    // QR finder square, bottom-right: the gate access story.
    final q = Rect.fromLTWH(r.right - 30, r.bottom - 30, 20, 20);
    canvas.drawRect(q, _accent..strokeWidth = 1.6);
    canvas.drawRect(q.deflate(6), _accentFill);
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) =>
      oldDelegate.hovered != hovered || oldDelegate.motif != motif;
}

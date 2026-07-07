import 'dart:math';

import 'package:flutter/material.dart';

import '../content.dart';
import '../theme.dart';

/// Each project card gets a hand-painted line illustration inside a phone
/// outline: no stock images, no screenshots to date badly. Strokes light up
/// cyan when the card is hovered.
class ProjectMotifView extends StatelessWidget {
  final ProjectMotif motif;
  final bool hovered;

  const ProjectMotifView(
      {super.key, required this.motif, this.hovered = false});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CustomPaint(
        painter: _MotifPainter(motif: motif, hovered: hovered),
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  final ProjectMotif motif;
  final bool hovered;

  const _MotifPainter({required this.motif, required this.hovered});

  Paint get _stroke => Paint()
    ..color = Palette.dim.withValues(alpha: 0.75)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4;

  Paint get _accent => Paint()
    ..color = hovered ? Palette.cyan : Palette.blue.withValues(alpha: 0.8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  Paint get _accentFill => Paint()
    ..color = hovered ? Palette.cyan : Palette.blue.withValues(alpha: 0.8)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Phone outline shared by every motif: this is a mobile portfolio and
    // the frame keeps repeating that quietly.
    final phone = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.height * 0.52,
      height: size.height * 0.88,
    );
    final rrect = RRect.fromRectAndRadius(phone, const Radius.circular(16));
    canvas.drawRRect(rrect, _stroke);
    canvas.drawLine(
      Offset(phone.center.dx - 12, phone.top + 12),
      Offset(phone.center.dx + 12, phone.top + 12),
      _stroke,
    );

    final screen = Rect.fromLTRB(
        phone.left + 9, phone.top + 22, phone.right - 9, phone.bottom - 12);
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
      case ProjectMotif.plug:
        _paintPlug(canvas, screen);
      case ProjectMotif.cart:
        _paintCart(canvas, screen);
    }
    canvas.restore();
  }

  /// Prep Baseball: infield diamond with base dots and a fly-ball arc.
  void _paintDiamond(Canvas canvas, Rect r) {
    final c = Offset(r.center.dx, r.center.dy + r.height * 0.1);
    final d = r.width * 0.36;
    final diamond = Path()
      ..moveTo(c.dx, c.dy + d)
      ..lineTo(c.dx + d, c.dy)
      ..lineTo(c.dx, c.dy - d)
      ..lineTo(c.dx - d, c.dy)
      ..close();
    canvas.drawPath(diamond, _stroke);
    for (final base in [
      Offset(c.dx, c.dy + d),
      Offset(c.dx + d, c.dy),
      Offset(c.dx, c.dy - d),
      Offset(c.dx - d, c.dy),
    ]) {
      canvas.drawCircle(base, 2.6, _accentFill);
    }
    final arc = Path()
      ..moveTo(c.dx, c.dy + d)
      ..quadraticBezierTo(
          c.dx + d * 1.1, c.dy - d * 1.6, c.dx + d * 0.2, c.dy - d * 2.4);
    canvas.drawPath(arc, _accent..strokeWidth = 1.4);
  }

  /// NuMbi: concentric macro rings with tick marks.
  void _paintRings(Canvas canvas, Rect r) {
    final c = r.center;
    final maxR = r.width * 0.32;
    for (var i = 0; i < 3; i++) {
      final radius = maxR - i * 10.0;
      final sweep = pi * (1.1 + i * 0.25);
      canvas.drawArc(Rect.fromCircle(center: c, radius: radius), -pi / 2,
          sweep, false, i == 0 ? _accent : _stroke);
    }
    for (var a = 0; a < 12; a++) {
      final angle = a * pi / 6;
      final from = c + Offset(cos(angle), sin(angle)) * (maxR + 6);
      final to = c + Offset(cos(angle), sin(angle)) * (maxR + 10);
      canvas.drawLine(from, to, _stroke);
    }
  }

  /// MutualMovil: bank card with chip plus fingerprint arcs.
  void _paintCard(Canvas canvas, Rect r) {
    final card = Rect.fromCenter(
        center: Offset(r.center.dx, r.center.dy - r.height * 0.12),
        width: r.width * 0.6,
        height: r.width * 0.38);
    canvas.drawRRect(
        RRect.fromRectAndRadius(card, const Radius.circular(7)), _stroke);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(card.left + 9, card.top + 10, 14, 11),
          const Radius.circular(2)),
      _accent..strokeWidth = 1.4,
    );
    canvas.drawLine(Offset(card.left + 9, card.bottom - 10),
        Offset(card.left + card.width * 0.55, card.bottom - 10), _stroke);
    final fc = Offset(r.center.dx, card.bottom + r.height * 0.2);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(Rect.fromCircle(center: fc, radius: i * 6.0), pi * 1.15,
          pi * 0.7, false, i == 2 ? _accent : _stroke);
    }
  }

  /// Vivco: block of condo units plus a QR finder square.
  void _paintGrid(Canvas canvas, Rect r) {
    const cols = 4, rows = 4;
    final w = r.width * 0.12, h = r.height * 0.11;
    final startX = r.center.dx - (cols * w + (cols - 1) * 5) / 2;
    final startY = r.center.dy - (rows * h + (rows - 1) * 5) / 2;
    final rng = Random(3);
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cell = Rect.fromLTWH(
            startX + col * (w + 5), startY + row * (h + 5), w, h);
        if (rng.nextDouble() < 0.22) {
          canvas.drawRect(cell, _accentFill);
        } else {
          canvas.drawRect(cell, _stroke);
        }
      }
    }
    final q = Rect.fromLTWH(r.right - 26, r.bottom - 26, 17, 17);
    canvas.drawRect(q, _accent..strokeWidth = 1.5);
    canvas.drawRect(q.deflate(5), _accentFill);
  }

  /// numbi-admin: plug connecting two systems (WordPress <-> Firestore).
  void _paintPlug(Canvas canvas, Rect r) {
    final leftBox = Rect.fromCenter(
        center: Offset(r.center.dx, r.center.dy - r.height * 0.24),
        width: r.width * 0.42,
        height: r.height * 0.2);
    final rightBox = Rect.fromCenter(
        center: Offset(r.center.dx, r.center.dy + r.height * 0.24),
        width: r.width * 0.42,
        height: r.height * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(leftBox, const Radius.circular(5)), _stroke);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rightBox, const Radius.circular(5)),
        _stroke);
    // Connecting cable with a plug node in the middle.
    canvas.drawLine(Offset(r.center.dx, leftBox.bottom),
        Offset(r.center.dx, rightBox.top), _accent);
    canvas.drawCircle(r.center, 4, _accentFill);
    // Small "data" ticks flowing along the cable.
    for (var i = -1; i <= 1; i += 2) {
      canvas.drawCircle(
          Offset(r.center.dx, r.center.dy + i * r.height * 0.12),
          1.8,
          _accentFill);
    }
  }

  /// Pinky Singles: shopping cart made of simple strokes.
  void _paintCart(Canvas canvas, Rect r) {
    final c = r.center;
    final w = r.width * 0.4;
    final body = Path()
      ..moveTo(c.dx - w / 2 - 8, c.dy - w * 0.32)
      ..lineTo(c.dx - w / 2, c.dy - w * 0.32)
      ..lineTo(c.dx - w / 2 + w * 0.14, c.dy + w * 0.22)
      ..lineTo(c.dx + w / 2, c.dy + w * 0.22)
      ..lineTo(c.dx + w / 2 + w * 0.12, c.dy - w * 0.18)
      ..lineTo(c.dx - w / 2 + w * 0.06, c.dy - w * 0.18);
    canvas.drawPath(body, _stroke);
    canvas.drawCircle(
        Offset(c.dx - w * 0.18, c.dy + w * 0.38), 3.2, _accentFill);
    canvas.drawCircle(
        Offset(c.dx + w * 0.34, c.dy + w * 0.38), 3.2, _accentFill);
    // A card (the product) dropping into the cart.
    final cardRect = Rect.fromCenter(
        center: Offset(c.dx + w * 0.05, c.dy - w * 0.42),
        width: w * 0.2,
        height: w * 0.28);
    canvas.drawRRect(
        RRect.fromRectAndRadius(cardRect, const Radius.circular(2)),
        _accent..strokeWidth = 1.6);
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) =>
      oldDelegate.hovered != hovered || oldDelegate.motif != motif;
}

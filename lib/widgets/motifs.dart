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

  const ProjectMotifView({
    super.key,
    required this.motif,
    this.hovered = false,
  });

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
      phone.left + 9,
      phone.top + 22,
      phone.right - 9,
      phone.bottom - 12,
    );
    canvas.save();
    canvas.clipRect(screen);
    switch (motif) {
      case ProjectMotif.chat:
        _paintChat(canvas, screen);
      case ProjectMotif.hourglass:
        _paintHourglass(canvas, screen);
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
      case ProjectMotif.boxes:
        _paintBoxes(canvas, screen);
    }
    canvas.restore();
  }

  /// Keen: two chat bubbles (consumer and advisor) plus a call wave.
  void _paintChat(Canvas canvas, Rect r) {
    final bw = r.width * 0.5, bh = r.height * 0.14;
    // Incoming bubble on the left, outgoing (accent) on the right.
    final incoming = Rect.fromLTWH(
      r.left + r.width * 0.1,
      r.top + r.height * 0.18,
      bw,
      bh,
    );
    final outgoing = Rect.fromLTWH(
      r.right - r.width * 0.1 - bw,
      incoming.bottom + 10,
      bw,
      bh,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(incoming, const Radius.circular(8)),
      _stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(outgoing, const Radius.circular(8)),
      _accent..strokeWidth = 1.6,
    );
    // Typing dots inside the incoming bubble.
    for (var i = -1; i <= 1; i++) {
      canvas.drawCircle(incoming.center + Offset(i * 7.0, 0), 1.8, _stroke);
    }
    // Live call: a dot with sound arcs radiating out under the chat.
    final callC = Offset(
      r.center.dx - r.width * 0.12,
      r.bottom - r.height * 0.24,
    );
    canvas.drawCircle(callC, 3.2, _accentFill);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: callC, radius: 6.0 + i * 5),
        -pi / 4,
        pi / 2,
        false,
        i == 1 ? _accent : _stroke,
      );
    }
  }

  /// Tempo: hourglass with a heartbeat in the sand, the app's own mark.
  void _paintHourglass(Canvas canvas, Rect r) {
    final c = r.center;
    final w = r.width * 0.28, h = r.height * 0.3;
    // Top and bottom caps.
    canvas.drawLine(
      Offset(c.dx - w, c.dy - h),
      Offset(c.dx + w, c.dy - h),
      _stroke,
    );
    canvas.drawLine(
      Offset(c.dx - w, c.dy + h),
      Offset(c.dx + w, c.dy + h),
      _stroke,
    );
    // Glass: two triangles meeting at the waist.
    final glass = Path()
      ..moveTo(c.dx - w * 0.8, c.dy - h)
      ..lineTo(c.dx, c.dy)
      ..lineTo(c.dx + w * 0.8, c.dy - h)
      ..moveTo(c.dx - w * 0.8, c.dy + h)
      ..lineTo(c.dx, c.dy)
      ..lineTo(c.dx + w * 0.8, c.dy + h);
    canvas.drawPath(glass, _stroke);
    // Sand pile at the bottom drawn as a pulse line.
    final pulseY = c.dy + h * 0.72;
    final pulse = Path()
      ..moveTo(c.dx - w * 0.55, pulseY)
      ..lineTo(c.dx - w * 0.15, pulseY)
      ..lineTo(c.dx - w * 0.05, pulseY - h * 0.3)
      ..lineTo(c.dx + w * 0.08, pulseY + h * 0.12)
      ..lineTo(c.dx + w * 0.18, pulseY)
      ..lineTo(c.dx + w * 0.55, pulseY);
    canvas.drawPath(pulse, _accent..strokeWidth = 1.6);
    // Falling grain through the waist.
    canvas.drawCircle(Offset(c.dx, c.dy + h * 0.22), 1.8, _accentFill);
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
        c.dx + d * 1.1,
        c.dy - d * 1.6,
        c.dx + d * 0.2,
        c.dy - d * 2.4,
      );
    canvas.drawPath(arc, _accent..strokeWidth = 1.4);
  }

  /// NuMbi: concentric macro rings with tick marks.
  void _paintRings(Canvas canvas, Rect r) {
    final c = r.center;
    final maxR = r.width * 0.32;
    for (var i = 0; i < 3; i++) {
      final radius = maxR - i * 10.0;
      final sweep = pi * (1.1 + i * 0.25);
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: radius),
        -pi / 2,
        sweep,
        false,
        i == 0 ? _accent : _stroke,
      );
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
      height: r.width * 0.38,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(card, const Radius.circular(7)),
      _stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(card.left + 9, card.top + 10, 14, 11),
        const Radius.circular(2),
      ),
      _accent..strokeWidth = 1.4,
    );
    canvas.drawLine(
      Offset(card.left + 9, card.bottom - 10),
      Offset(card.left + card.width * 0.55, card.bottom - 10),
      _stroke,
    );
    final fc = Offset(r.center.dx, card.bottom + r.height * 0.2);
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: fc, radius: i * 6.0),
        pi * 1.15,
        pi * 0.7,
        false,
        i == 2 ? _accent : _stroke,
      );
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
          startX + col * (w + 5),
          startY + row * (h + 5),
          w,
          h,
        );
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
      height: r.height * 0.2,
    );
    final rightBox = Rect.fromCenter(
      center: Offset(r.center.dx, r.center.dy + r.height * 0.24),
      width: r.width * 0.42,
      height: r.height * 0.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftBox, const Radius.circular(5)),
      _stroke,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightBox, const Radius.circular(5)),
      _stroke,
    );
    // Connecting cable with a plug node in the middle.
    canvas.drawLine(
      Offset(r.center.dx, leftBox.bottom),
      Offset(r.center.dx, rightBox.top),
      _accent,
    );
    canvas.drawCircle(r.center, 4, _accentFill);
    // Small "data" ticks flowing along the cable.
    for (var i = -1; i <= 1; i += 2) {
      canvas.drawCircle(
        Offset(r.center.dx, r.center.dy + i * r.height * 0.12),
        1.8,
        _accentFill,
      );
    }
  }

  /// ePRAC logistics: stacked warehouse crates, barcode on top, and a
  /// dotted delivery route running under the stack.
  void _paintBoxes(Canvas canvas, Rect r) {
    final c = r.center;
    final s = r.width * 0.24; // crate side length
    final bottomY = c.dy + s * 0.55;
    // Pyramid of crates: two on the floor, one centered on top.
    final crates = [
      Rect.fromCenter(
        center: Offset(c.dx - s * 0.55, bottomY),
        width: s,
        height: s,
      ),
      Rect.fromCenter(
        center: Offset(c.dx + s * 0.55, bottomY),
        width: s,
        height: s,
      ),
      Rect.fromCenter(
        center: Offset(c.dx, bottomY - s - 3),
        width: s,
        height: s,
      ),
    ];
    for (final crate in crates) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(crate, const Radius.circular(3)),
        _stroke,
      );
    }
    // Barcode strokes on the top crate: the scanned SKU.
    final top = crates[2];
    for (var i = 0; i < 4; i++) {
      final x = top.left + s * 0.24 + i * s * 0.18;
      canvas.drawLine(
        Offset(x, top.top + s * 0.24),
        Offset(x, top.bottom - s * 0.24),
        i == 1 ? (_accent..strokeWidth = 1.6) : _stroke,
      );
    }
    // Dotted route with a destination dot: merchandise on the move.
    final routeY = bottomY + s * 0.85;
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(c.dx - s * 1.1 + i * s * 0.5, routeY),
        1.6,
        _accentFill,
      );
    }
    canvas.drawCircle(Offset(c.dx + s * 1.4, routeY), 3.2, _accentFill);
  }

  @override
  bool shouldRepaint(_MotifPainter oldDelegate) =>
      oldDelegate.hovered != hovered || oldDelegate.motif != motif;
}

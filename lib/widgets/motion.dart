import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// Motion policy: one orchestrated hero entrance (staggered Intervals on a
/// single controller), scroll reveals that play once, animated counters,
/// a typing role rotator, and live physics demos in the Widget Lab.
/// `MediaQuery.disableAnimations` (prefers-reduced-motion) collapses all
/// of it to static content.
bool reducedMotion(BuildContext context) =>
    MediaQuery.of(context).disableAnimations;

/// Broadcasts "the viewport changed, re-check your visibility" to every
/// [Reveal] on the page. Fired on scroll and once after the first frame.
class RevealBus extends ChangeNotifier {
  void ping() => notifyListeners();
}

/// Inherited access to the page's [RevealBus] and [ScrollController].
class ScrollScope extends InheritedWidget {
  final RevealBus bus;
  final ScrollController controller;

  const ScrollScope({
    super.key,
    required this.bus,
    required this.controller,
    required super.child,
  });

  static ScrollScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollScope>()!;

  @override
  bool updateShouldNotify(ScrollScope oldWidget) =>
      bus != oldWidget.bus || controller != oldWidget.controller;
}

/// Fades, rises and slightly scales its child the first time it enters the
/// viewport. Plays exactly once.
class Reveal extends StatefulWidget {
  final Widget child;

  /// Extra delay after trigger, used to stagger siblings.
  final Duration delay;

  /// Rise distance in px.
  final double dy;

  /// Start scale; 1.0 disables the scale-in.
  final double fromScale;

  /// How far into the viewport the element must be before playing,
  /// as a fraction of viewport height measured from the top.
  final double threshold;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.dy = 28,
    this.fromScale = 0.98,
    this.threshold = 0.9,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  RevealBus? _bus;
  bool _played = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bus = ScrollScope.of(context).bus;
    if (!identical(bus, _bus)) {
      _bus?.removeListener(_check);
      _bus = bus..addListener(_check);
    }
    // Check once after layout so content already on screen plays too.
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_played || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top < viewport * widget.threshold) {
      _played = true;
      if (reducedMotion(context)) {
        _controller.value = 1; // reduced motion: appear instantly
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _bus?.removeListener(_check);
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final v = _curve.value;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, widget.dy * (1 - v)),
            child: Transform.scale(
              scale: widget.fromScale + (1 - widget.fromScale) * v,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Types out a rotating list of phrases with a blinking cursor:
/// type -> hold -> erase -> next. The classic hero role rotator.
class TypingText extends StatefulWidget {
  final List<String> phrases;
  final TextStyle style;

  const TypingText({super.key, required this.phrases, required this.style});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _phrase = 0;
  int _chars = 0;
  bool _erasing = false;
  bool _cursorOn = true;

  @override
  void initState() {
    super.initState();
    _schedule();
    _blink();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _blink() async {
    while (!_disposed) {
      await Future.delayed(const Duration(milliseconds: 480));
      if (_disposed || !mounted) return;
      setState(() => _cursorOn = !_cursorOn);
    }
  }

  Future<void> _schedule() async {
    // Reduced motion: show the first phrase, no typing loop.
    await Future.delayed(const Duration(milliseconds: 400));
    if (_disposed || !mounted) return;
    if (reducedMotion(context)) {
      setState(() => _chars = widget.phrases[_phrase].length);
      return;
    }
    while (!_disposed && mounted) {
      final current = widget.phrases[_phrase];
      if (!_erasing) {
        if (_chars < current.length) {
          setState(() => _chars++);
          await Future.delayed(const Duration(milliseconds: 55));
        } else {
          await Future.delayed(const Duration(milliseconds: 1700));
          if (_disposed || !mounted) return;
          _erasing = true;
        }
      } else {
        if (_chars > 0) {
          setState(() => _chars--);
          await Future.delayed(const Duration(milliseconds: 28));
        } else {
          _erasing = false;
          setState(() => _phrase = (_phrase + 1) % widget.phrases.length);
          await Future.delayed(const Duration(milliseconds: 250));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.phrases[_phrase].substring(0, _chars);
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: text, style: widget.style),
        // Block cursor, cyan, blinking independently of typing speed.
        TextSpan(
          text: '▋',
          style: widget.style.copyWith(
            color: _cursorOn
                ? Palette.cyan
                : Palette.cyan.withValues(alpha: 0),
          ),
        ),
      ]),
    );
  }
}

/// Counts from 0 to [value] the first time it becomes visible (parent gates
/// with [Reveal]); pass `play: true` once revealed.
class CountUp extends StatelessWidget {
  final int value;
  final String suffix;
  final TextStyle style;
  final bool play;

  const CountUp({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
    this.play = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!play || reducedMotion(context)) {
      return Text('$value$suffix', style: style);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) =>
          Text('${v.round()}$suffix', style: style),
    );
  }
}

/// Slow continuous rotation, used for the gradient ring around the avatar.
class SpinForever extends StatefulWidget {
  final Widget child;
  final Duration period;

  const SpinForever({
    super.key,
    required this.child,
    this.period = const Duration(seconds: 6),
  });

  @override
  State<SpinForever> createState() => _SpinForeverState();
}

class _SpinForeverState extends State<SpinForever>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // One repeating controller; parked entirely when motion is reduced.
    if (reducedMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * pi,
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Full-screen flash shown when the visitor presses R: the site pretends to
/// hot reload, then every entrance animation replays. A joke only Flutter
/// people get, which is exactly the audience.
class HotReloadFlash extends StatelessWidget {
  final Animation<double> progress;

  const HotReloadFlash({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        if (progress.value == 0) return const SizedBox.shrink();
        return IgnorePointer(
          child: Container(
            color: Palette.bg.withValues(alpha: 0.93 * progress.value),
            alignment: Alignment.center,
            child: Opacity(
              opacity: progress.value,
              child: Text(
                'Performing hot reload...\nReloaded 1 of 1 libraries.',
                textAlign: TextAlign.center,
                style: Type.mono(context, color: Palette.cyan),
              ),
            ),
          ),
        );
      },
    );
  }
}

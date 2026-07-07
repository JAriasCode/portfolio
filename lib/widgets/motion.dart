import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme.dart';

/// Motion policy for the whole site, N3 on the expressivity scale:
///  - one orchestrated hero entrance (staggered, plays once),
///  - small scroll reveals (24px rise, play once, never re-trigger),
///  - rich hovers under 300ms,
///  - everything animates transform + opacity only,
///  - `MediaQuery.disableAnimations` (prefers-reduced-motion) kills it all.
bool reducedMotion(BuildContext context) =>
    MediaQuery.of(context).disableAnimations;

/// Broadcasts "the viewport changed, re-check your visibility" to every
/// [Reveal] on the page. Fired on scroll and once after the first frame.
class RevealBus extends ChangeNotifier {
  void ping() => notifyListeners();
}

/// Inherited access to the page's [RevealBus] and [ScrollController],
/// so any widget can self-trigger when it scrolls into view.
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

/// Fades + rises its child the first time it enters the viewport.
/// Plays exactly once: re-triggering reveals on every scroll is a
/// template tell, and repeated motion on read content is hostile.
class Reveal extends StatefulWidget {
  final Widget child;

  /// Extra delay after trigger, used to stagger siblings.
  final Duration delay;

  /// Rise distance in px. Keep within 16-32: big slides read as slop.
  final double dy;

  /// How far into the viewport the element must be before playing,
  /// as a fraction of viewport height measured from the top.
  final double threshold;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.dy = 24,
    this.threshold = 0.88,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
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
        return Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, widget.dy * (1 - _curve.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Endless horizontal ticker for the stack strip. Content is duplicated and
/// the scroll position wraps at half the extent, so the loop is invisible.
class Marquee extends StatefulWidget {
  final List<Widget> children;
  final double speed; // px per second
  final double height;

  const Marquee({
    super.key,
    required this.children,
    this.speed = 42,
    this.height = 72,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  Ticker? _ticker;
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (!_scroll.hasClients ||
        !_scroll.position.hasContentDimensions ||
        reducedMotion(context)) {
      return; // extents are null until the strip's first layout pass
    }
    final half = _scroll.position.maxScrollExtent / 2;
    if (half <= 0) return;
    var next = _scroll.offset + widget.speed * dt;
    if (next >= half) next -= half; // seamless wrap at the duplicate seam
    _scroll.jumpTo(next);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Two copies of the content; the ticker wraps before the seam shows.
    final doubled = [...widget.children, ...widget.children];
    return SizedBox(
      height: widget.height,
      child: ScrollConfiguration(
        // Hide scrollbars; this strip is decorative, not navigable.
        behavior: ScrollConfiguration.of(context)
            .copyWith(scrollbars: false, overscroll: false),
        child: ListView(
          controller: _scroll,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          children: doubled,
        ),
      ),
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
            color: Palette.ink.withValues(alpha: 0.92 * progress.value),
            alignment: Alignment.center,
            child: Opacity(
              opacity: progress.value,
              child: Text(
                'Performing hot reload...\nReloaded 1 of 1 libraries.',
                textAlign: TextAlign.center,
                style: Type.code(context, color: Palette.amber),
              ),
            ),
          ),
        );
      },
    );
  }
}

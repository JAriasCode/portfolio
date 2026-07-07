import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';
import 'widgets/effects.dart';
import 'widgets/motion.dart';
import 'widgets/sections.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeffry Arias · Flutter engineer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.ink,
        fontFamily: 'Author',
        // Amber selection so even highlighting text stays on-palette.
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Palette.amber.withValues(alpha: 0.3),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _bus = RevealBus();

  // Anchor keys for nav jumps.
  final _workKey = GlobalKey();
  final _stackKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  /// Incremented by the hot-reload easter egg; keys the whole body so every
  /// entrance animation replays, exactly like a real reload would.
  int _reloadTick = 0;

  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    reverseDuration: const Duration(milliseconds: 420),
  );

  @override
  void dispose() {
    _flash.dispose();
    _scroll.dispose();
    _bus.dispose();
    super.dispose();
  }

  void _jump(String section) {
    final key = switch (section) {
      'work' => _workKey,
      'stack' => _stackKey,
      'about' => _aboutKey,
      _ => _contactKey,
    };
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: reducedMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  /// The easter egg: R flashes the console message, resets to the top and
  /// replays every entrance, like a hot reload of the page itself.
  Future<void> _hotReload() async {
    if (_flash.isAnimating) return;
    await _flash.forward();
    setState(() => _reloadTick++);
    _scroll.jumpTo(0);
    await Future.delayed(const Duration(milliseconds: 450));
    await _flash.reverse();
    // New subtree needs one ping so above-the-fold reveals re-check.
    WidgetsBinding.instance.addPostFrameCallback((_) => _bus.ping());
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.keyR &&
        !HardwareKeyboard.instance.isControlPressed &&
        !HardwareKeyboard.instance.isMetaPressed) {
      _hotReload();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: ScrollScope(
          bus: _bus,
          controller: _scroll,
          child: Stack(
            children: [
              // Main scroll. Sections stay mounted (no lazy list) so nav
              // anchors and reveal checks always have a context to measure.
              NotificationListener<ScrollUpdateNotification>(
                onNotification: (_) {
                  _bus.ping();
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: KeyedSubtree(
                    key: ValueKey(_reloadTick),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NavBar(onJump: _jump),
                        HeroSection(onSeeWork: () => _jump('work')),
                        const MarqueeStrip(),
                        WorkSection(key: _workKey),
                        StackSection(key: _stackKey),
                        AboutSection(key: _aboutKey),
                        ContactSection(key: _contactKey),
                      ],
                    ),
                  ),
                ),
              ),
              // Film grain across the viewport, above content, below chrome.
              const Positioned.fill(child: GrainOverlay()),
              // Reading progress hairline.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ScrollProgressBar(controller: _scroll),
              ),
              // Hot-reload flash overlay.
              Positioned.fill(child: HotReloadFlash(progress: _flash)),
            ],
          ),
        ),
      ),
    );
  }
}

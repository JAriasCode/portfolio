import 'package:flutter/material.dart';

import '../content.dart';
import '../theme.dart';
import '../util/open_url.dart';
import 'common.dart';
import 'effects.dart';
import 'motifs.dart';
import 'motion.dart';

// ---------------------------------------------------------------------------
// NAV
// ---------------------------------------------------------------------------

/// Top bar: brand on the left, numbered anchors on the right.
/// On phones the anchors collapse to just "work" and "contact",
/// the two links that actually matter there.
class NavBar extends StatelessWidget {
  final void Function(String section) onJump;

  const NavBar({super.key, required this.onJump});

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final entries = mobile
        ? const [('01', 'work'), ('04', 'contact')]
        : const [
            ('01', 'work'),
            ('02', 'stack'),
            ('03', 'about'),
            ('04', 'contact'),
          ];
    return Container(
      decoration: const BoxDecoration(
        color: Palette.ink,
        border: Border(bottom: BorderSide(color: Palette.line)),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: fluid(context, 20, 64), vertical: 18),
      child: Row(
        children: [
          Text('JAriasCode',
              style: Type.code(context).copyWith(fontSize: 15)),
          const Spacer(),
          for (final (index, name) in entries) ...[
            HoverLink(
              text: name,
              style: Type.label(context, color: Palette.paper),
              onTap: () => onJump(name),
            ),
            if ((index, name) != entries.last) const SizedBox(width: 28),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO
// ---------------------------------------------------------------------------

/// Orchestrated entrance: kicker, the two name lines, statement, CTA row,
/// each on its own delay. Plays once. The underline under "Flutter" is
/// the site's single hand-drawn mark.
class HeroSection extends StatefulWidget {
  final VoidCallback onSeeWork;

  const HeroSection({super.key, required this.onSeeWork});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _underline = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void initState() {
    super.initState();
    // The underline draws itself after the statement has settled.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _underline.forward();
    });
  }

  @override
  void dispose() {
    _underline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context).height;
    return SectionShell(
      child: ConstrainedBox(
        // Hero owns most of the first viewport but always leaves a sliver
        // of the next section visible: signal that there is more below.
        constraints: BoxConstraints(minHeight: viewport * 0.82),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: fluid(context, 48, 96)),
            Reveal(
              delay: const Duration(milliseconds: 80),
              child: Text(Copy.kicker, style: Type.label(context)),
            ),
            SizedBox(height: fluid(context, 20, 36)),
            // Name as monument, two staggered lines. The second line is
            // indented: asymmetry on purpose, nothing here is centered.
            Reveal(
              delay: const Duration(milliseconds: 220),
              dy: 34,
              child: Text(Copy.heroFirst, style: Type.display(context)),
            ),
            Reveal(
              delay: const Duration(milliseconds: 360),
              dy: 34,
              child: Padding(
                padding: EdgeInsets.only(left: fluid(context, 32, 140)),
                child: Text(Copy.heroSecond,
                    style: Type.display(context, color: Palette.paperDim)),
              ),
            ),
            SizedBox(height: fluid(context, 28, 48)),
            Reveal(
              delay: const Duration(milliseconds: 560),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: _statement(context),
              ),
            ),
            SizedBox(height: fluid(context, 28, 44)),
            Reveal(
              delay: const Duration(milliseconds: 720),
              child: Wrap(
                spacing: 32,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  HoverLink(
                    text: 'see the work',
                    showArrow: true,
                    style: Type.body(context)
                        .copyWith(fontWeight: FontWeight.w600),
                    onTap: widget.onSeeWork,
                  ),
                  HoverLink(
                    text: 'github/JAriasCode',
                    style: Type.code(context, color: Palette.paperDim),
                    onTap: () => openUrl(Links.github),
                  ),
                ],
              ),
            ),
            SizedBox(height: fluid(context, 48, 96)),
          ],
        ),
      ),
    );
  }

  /// Statement paragraph with the wobbly underline drawn under "Flutter".
  Widget _statement(BuildContext context) {
    final style = Type.lede(context);
    // The statement is split so the underlined word can carry its own stack.
    const before = 'Flutter';
    final after = Copy.heroStatement.substring(
        Copy.heroStatement.indexOf(' engineer'));
    return Text.rich(
      TextSpan(children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(before,
                  style: style.copyWith(fontWeight: FontWeight.w600)),
              Positioned(
                left: 0,
                right: 0,
                bottom: -4,
                child: AnimatedBuilder(
                  animation: _underline,
                  builder: (context, _) => WobblyUnderline(
                    progress: Curves.easeOutCubic.transform(
                        reducedMotion(context) ? 1 : _underline.value),
                  ),
                ),
              ),
            ],
          ),
        ),
        TextSpan(text: after, style: style),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// STACK MARQUEE STRIP
// ---------------------------------------------------------------------------

/// Continuous ticker between hero and work. Items are separated by amber
/// diamonds, a nod to the baseball infield up top.
class MarqueeStrip extends StatelessWidget {
  const MarqueeStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Palette.line),
          bottom: BorderSide(color: Palette.line),
        ),
      ),
      child: Marquee(
        children: [
          for (final item in marqueeItems)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item,
                      style: Type.heading(context, min: 18, max: 26)
                          .copyWith(color: Palette.paperDim)),
                  const SizedBox(width: 52),
                  Transform.rotate(
                    angle: 0.785398, // 45deg: a tiny infield diamond
                    child: Container(
                        width: 7, height: 7, color: Palette.amber),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WORK
// ---------------------------------------------------------------------------

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: fluid(context, 72, 140)),
          const SectionHeader(
              index: '01', label: 'Selected work', title: 'Shipped, not shelved'),
          SizedBox(height: fluid(context, 40, 80)),
          for (var i = 0; i < projects.length; i++) ...[
            _ProjectRow(project: projects[i], flip: i.isOdd),
            if (i != projects.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: fluid(context, 32, 56)),
                child: Container(height: 1, color: Palette.line),
              ),
          ],
          SizedBox(height: fluid(context, 48, 88)),
          const _SideProjects(),
          SizedBox(height: fluid(context, 72, 140)),
        ],
      ),
    );
  }
}

/// One editorial project row. Desktop alternates motif left / motif right;
/// mobile stacks. The whole row is one hover surface.
class _ProjectRow extends StatefulWidget {
  final Project project;
  final bool flip;

  const _ProjectRow({required this.project, required this.flip});

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final mobile = isMobile(context);

    final motif = Reveal(
      dy: 28,
      child: ProjectMotifView(motif: p.motif, hovered: _hover),
    );

    final info = Reveal(
      delay: const Duration(milliseconds: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Giant mono index, print-style folio number.
          Text(p.index,
              style: Type.code(context, color: Palette.amber)
                  .copyWith(fontSize: fluid(context, 14, 18))),
          const SizedBox(height: 10),
          AnimatedSlide(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            offset: _hover && !mobile
                ? const Offset(0.012, 0)
                : Offset.zero,
            child: Text(p.name,
                style: Type.heading(context, min: 30, max: 52)),
          ),
          const SizedBox(height: 8),
          Text(p.role.toUpperCase(),
              style: Type.label(context)),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(p.description,
                style: Type.body(context, color: const Color(0xFFBBB2A0))),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final tag in p.tags) TagChip(tag)],
          ),
        ],
      ),
    );

    final row = mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [motif, const SizedBox(height: 28), info],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.flip
                ? [
                    Expanded(flex: 7, child: info),
                    const SizedBox(width: 64),
                    Expanded(flex: 5, child: motif),
                  ]
                : [
                    Expanded(flex: 5, child: motif),
                    const SizedBox(width: 64),
                    Expanded(flex: 7, child: info),
                  ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: row,
    );
  }
}

/// The "also built" list: one line per item, no cards.
class _SideProjects extends StatelessWidget {
  const _SideProjects();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ALSO BUILT', style: Type.label(context)),
          const SizedBox(height: 16),
          for (final side in sideProjects)
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Palette.line)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: isMobile(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(side.name, style: Type.code(context)),
                        const SizedBox(height: 4),
                        Text(side.note,
                            style: Type.body(context,
                                color: Palette.paperDim)),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 220,
                            child:
                                Text(side.name, style: Type.code(context))),
                        Expanded(
                          child: Text(side.note,
                              style: Type.body(context,
                                  color: Palette.paperDim)),
                        ),
                      ],
                    ),
            ),
          Container(height: 1, color: Palette.line),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STACK (pubspec terminal)
// ---------------------------------------------------------------------------

/// The stack, presented as the file every Flutter dev opens first.
/// Types itself out once when scrolled into view.
class StackSection extends StatefulWidget {
  const StackSection({super.key});

  @override
  State<StackSection> createState() => _StackSectionState();
}

class _StackSectionState extends State<StackSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _typer = AnimationController(
    vsync: this,
    // Duration scales with content so typing speed feels constant.
    duration: Duration(milliseconds: pubspecLines.join().length * 8),
  );

  @override
  void dispose() {
    _typer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              index: '02',
              label: 'Stack',
              title: 'pubspec.yaml, the honest CV'),
          SizedBox(height: fluid(context, 32, 56)),
          Reveal(
            // Start the typewriter the first time the terminal shows up.
            child: _TerminalWindow(
              onVisible: () {
                if (_typer.status == AnimationStatus.dismissed) {
                  reducedMotion(context)
                      ? _typer.value = 1
                      : _typer.forward();
                }
              },
              typer: _typer,
            ),
          ),
          SizedBox(height: fluid(context, 72, 140)),
        ],
      ),
    );
  }
}

class _TerminalWindow extends StatefulWidget {
  final VoidCallback onVisible;
  final AnimationController typer;

  const _TerminalWindow({required this.onVisible, required this.typer});

  @override
  State<_TerminalWindow> createState() => _TerminalWindowState();
}

class _TerminalWindowState extends State<_TerminalWindow> {
  @override
  void initState() {
    super.initState();
    // The parent Reveal has already gated visibility; when this widget
    // first builds inside a played reveal we start typing shortly after.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) widget.onVisible();
      });
    });
  }

  /// Colors one pubspec line: keys dim-amber, values paper, comments muted.
  TextSpan _colorLine(BuildContext context, String line) {
    final comment = line.indexOf('#');
    final colon = line.indexOf(':');
    final base = Type.code(context);
    if (line.trimLeft().startsWith('#')) {
      return TextSpan(
          text: line, style: base.copyWith(color: Palette.paperDim));
    }
    final spans = <TextSpan>[];
    var body = line;
    var trailing = '';
    if (comment != -1) {
      trailing = line.substring(comment);
      body = line.substring(0, comment);
    }
    if (colon != -1 && (comment == -1 || colon < comment)) {
      spans.add(TextSpan(
          text: body.substring(0, colon + 1),
          style: base.copyWith(color: Palette.amber)));
      spans.add(TextSpan(text: body.substring(colon + 1), style: base));
    } else {
      spans.add(TextSpan(text: body, style: base));
    }
    if (trailing.isNotEmpty) {
      spans.add(TextSpan(
          text: trailing, style: base.copyWith(color: Palette.paperDim)));
    }
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final full = pubspecLines.join('\n');
    return Container(
      decoration: BoxDecoration(
        color: Palette.inkRaised,
        border: Border.all(color: Palette.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar with the three dots, outlined not filled: a wink at
          // the convention without cosplaying macOS.
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Palette.line)),
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.only(right: 7),
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Palette.paperDim),
                    ),
                  ),
                const SizedBox(width: 10),
                Text('~/jeffry_arias/pubspec.yaml',
                    style: Type.label(context)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(fluid(context, 16, 28)),
            child: AnimatedBuilder(
              animation: widget.typer,
              builder: (context, _) {
                final visible = full.substring(
                    0, (full.length * widget.typer.value).round());
                final lines = visible.split('\n');
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final line in lines)
                        Text.rich(_colorLine(context, line.isEmpty ? ' ' : line)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ABOUT
// ---------------------------------------------------------------------------

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final quote = Reveal(
      child: Text(
        '"An app is not done until it behaves offline, on a cheap Android, '
        'with bad signal."',
        style: Type.heading(context, min: 24, max: 40)
            .copyWith(color: Palette.paper),
      ),
    );
    final body = Reveal(
      delay: const Duration(milliseconds: 140),
      child: Text(Copy.aboutBody,
          style: Type.body(context, color: const Color(0xFFBBB2A0))),
    );

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              index: '03', label: 'About', title: Copy.aboutTitle),
          SizedBox(height: fluid(context, 36, 64)),
          // Editorial split: pull-quote column + reading column.
          mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [quote, const SizedBox(height: 28), body],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: quote),
                    const SizedBox(width: 80),
                    Expanded(flex: 6, child: body),
                  ],
                ),
          SizedBox(height: fluid(context, 72, 140)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CONTACT + FOOTER
// ---------------------------------------------------------------------------

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.line)),
      ),
      child: SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: fluid(context, 64, 120)),
            const SectionHeader(
                index: '04', label: 'Contact', title: Copy.contactTitle),
            SizedBox(height: fluid(context, 28, 48)),
            Reveal(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(Copy.contactNote,
                    style: Type.body(context, color: const Color(0xFFBBB2A0))),
              ),
            ),
            SizedBox(height: fluid(context, 32, 56)),
            // The email IS the CTA: giant, serif, underlined on hover.
            // One primary action on the whole page, on purpose.
            Reveal(
              delay: const Duration(milliseconds: 120),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hover = true),
                onExit: (_) => setState(() => _hover = false),
                child: GestureDetector(
                  onTap: () => openUrl('mailto:${Links.email}'),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      style: Type.display(context, min: 24, max: 72).copyWith(
                        color: _hover ? Palette.amber : Palette.paper,
                      ),
                      child: Text(Links.email),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: fluid(context, 28, 44)),
            Reveal(
              delay: const Duration(milliseconds: 220),
              child: Wrap(
                spacing: 32,
                runSpacing: 14,
                children: [
                  HoverLink(
                      text: 'GitHub',
                      showArrow: true,
                      onTap: () => openUrl(Links.github)),
                  HoverLink(
                      text: 'LinkedIn',
                      showArrow: true,
                      onTap: () => openUrl(Links.linkedin)),
                ],
              ),
            ),
            SizedBox(height: fluid(context, 64, 110)),
            const _Footer(),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final credit = Text(Copy.footerLine,
        style: Type.label(context, min: 10.5, max: 12));
    // The hot-reload hint only matters where there is a keyboard.
    final hint = Text(Copy.hotReloadHint.toUpperCase(),
        style: Type.label(context, min: 10.5, max: 12)
            .copyWith(color: Palette.amber));
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.line)),
      ),
      padding: const EdgeInsets.only(top: 22),
      child: mobile
          ? credit
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: credit),
                const SizedBox(width: 48),
                hint,
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../content.dart';
import '../theme.dart';
import '../util/open_url.dart';
import 'common.dart';
import 'effects.dart';
import 'lab.dart';
import 'motifs.dart';
import 'motion.dart';

// ---------------------------------------------------------------------------
// NAV
// ---------------------------------------------------------------------------

/// Top bar: gradient logo mark + name, section links on the right.
/// Mobile keeps only the links that matter on a phone.
class NavBar extends StatelessWidget {
  final void Function(String section) onJump;

  const NavBar({super.key, required this.onJump});

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final entries = mobile
        ? const ['projects', 'contact']
        : const ['about', 'experience', 'skills', 'projects', 'lab', 'contact'];
    return Container(
      decoration: BoxDecoration(
        color: Palette.bg.withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: Palette.line)),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: fluid(context, 20, 64), vertical: 14),
      child: Row(
        children: [
          // Logo mark: gradient rounded square with the initial.
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: Palette.gradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Palette.blue.withValues(alpha: 0.4),
                    blurRadius: 16),
              ],
            ),
            child: const Text('J',
                style: TextStyle(
                  fontFamily: 'Chillax',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF04101F),
                )),
          ),
          const SizedBox(width: 10),
          Text('Jeffry Arias.',
              style: Type.title(context).copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          for (final name in entries) ...[
            HoverLink(
              text: name,
              style: Type.label(context, color: Palette.text),
              onTap: () => onJump(name),
            ),
            if (name != entries.last) const SizedBox(width: 26),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HERO
// ---------------------------------------------------------------------------

/// Centered hero over the particle field. One controller drives the whole
/// entrance through staggered Intervals: ring, kicker, name, role, statement,
/// CTAs, stats. Plays once.
class HeroSection extends StatefulWidget {
  final VoidCallback onSeeWork;
  final VoidCallback onContact;

  const HeroSection(
      {super.key, required this.onSeeWork, required this.onContact});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  /// One eased window of the shared controller per element (skill pattern:
  /// staggered animation = one controller + offset Intervals).
  Animation<double> _window(double start, double end) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      reducedMotion(context) ? _entrance.value = 1 : _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Fade + rise wrapper bound to one interval window.
  Widget _staged(double start, double end, Widget child) {
    final anim = _window(start, end);
    return AnimatedBuilder(
      animation: anim,
      builder: (context, c) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
            offset: Offset(0, 26 * (1 - anim.value)), child: c),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context).height;
    return Stack(
      children: [
        // Constellation + glow depth, clipped to the hero band only.
        const Positioned.fill(child: ParticleField()),
        Positioned(
          top: -120,
          left: -80,
          child: GlowBlob(size: fluid(context, 320, 560)),
        ),
        Positioned(
          bottom: -60,
          right: -100,
          child: GlowBlob(
              size: fluid(context, 280, 520),
              color: Palette.cyan,
              opacity: 0.1),
        ),
        SectionShell(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: viewport * 0.9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: fluid(context, 40, 72)),
                _staged(0.0, 0.35, const _AvatarRing()),
                SizedBox(height: fluid(context, 26, 38)),
                _staged(
                  0.1,
                  0.45,
                  Text(Copy.kicker,
                      textAlign: TextAlign.center,
                      style: Type.label(context, color: Palette.cyan)),
                ),
                SizedBox(height: fluid(context, 14, 20)),
                _staged(
                  0.2,
                  0.55,
                  GradientText(Copy.name,
                      textAlign: TextAlign.center,
                      style: Type.display(context)),
                ),
                SizedBox(height: fluid(context, 10, 16)),
                _staged(
                  0.3,
                  0.65,
                  // Fixed-height slot so the hero never changes height while
                  // the role types/erases (a height change would resize the
                  // particle field behind it). FittedBox shrinks the longest
                  // phrase on narrow screens instead of wrapping.
                  SizedBox(
                    height: fluid(context, 30, 42),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: TypingText(
                        phrases: Copy.roles,
                        style: Type.title(context, min: 20, max: 30)
                            .copyWith(color: Palette.text),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: fluid(context, 18, 26)),
                _staged(
                  0.4,
                  0.75,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(Copy.heroStatement,
                        textAlign: TextAlign.center,
                        style: Type.lede(context)),
                  ),
                ),
                SizedBox(height: fluid(context, 26, 36)),
                _staged(
                  0.5,
                  0.85,
                  Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      GradientButton(
                        text: 'Explore my work',
                        icon: Icons.arrow_downward_rounded,
                        onTap: widget.onSeeWork,
                      ),
                      OutlineButton(
                          text: "Let's talk", onTap: widget.onContact),
                    ],
                  ),
                ),
                SizedBox(height: fluid(context, 40, 64)),
                _staged(0.62, 1.0, const _StatsCard()),
                SizedBox(height: fluid(context, 40, 72)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Monogram avatar inside a rotating gradient ring: the sweep gradient arc
/// spins forever (SpinForever) while the core stays still.
class _AvatarRing extends StatelessWidget {
  const _AvatarRing();

  @override
  Widget build(BuildContext context) {
    final size = fluid(context, 108, 148);
    return SizedBox(
      width: size + 14,
      height: size + 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SpinForever(
            child: Container(
              width: size + 14,
              height: size + 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Palette.blue,
                    Palette.cyan,
                    Colors.transparent,
                    Palette.blue,
                  ],
                  stops: [0.0, 0.45, 0.75, 1.0],
                ),
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.surface,
              boxShadow: [
                BoxShadow(
                    color: Palette.blue.withValues(alpha: 0.35),
                    blurRadius: 40),
              ],
            ),
            child: GradientText(
              'JA',
              style: Type.display(context, min: 34, max: 48),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats band with animated counters. Counters start when the card reveals.
class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return GlowCard(
      padding: EdgeInsets.symmetric(
          horizontal: fluid(context, 20, 48), vertical: fluid(context, 22, 34)),
      child: Wrap(
        spacing: fluid(context, 24, 64),
        runSpacing: 26,
        alignment: WrapAlignment.center,
        children: [
          for (final s in stats)
            SizedBox(
              width: mobile ? 130 : 170,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CountUp(value: s.value, style: Type.stat(context)),
                      GradientText(s.suffix,
                          style: Type.stat(context).copyWith(
                              fontSize: fluid(context, 24, 34))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(s.label.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Type.label(context, min: 9.5, max: 11)),
                ],
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
    final story = Reveal(
      delay: const Duration(milliseconds: 120),
      child: Text(Copy.aboutBody, style: Type.body(context)),
    );
    final facts = Reveal(
      delay: const Duration(milliseconds: 240),
      child: GlowCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QUICK FACTS', style: Type.label(context, color: Palette.cyan)),
            const SizedBox(height: 18),
            for (final fact in const [
              'Based in San José, Costa Rica',
              'Remote with US teams via FullStack Labs',
              'Flutter on iOS, Android and web',
              'AI-native workflow: Claude Code + MCP, daily',
              'Spanish and English, daily',
              'Side quests in WordPress and WooCommerce',
            ]) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: Palette.gradient,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(fact,
                          style: Type.body(context, color: Palette.text))),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );

    return SectionShell(
      child: Column(
        children: [
          SizedBox(height: fluid(context, 70, 130)),
          SectionHeader(
              label: 'About',
              title: Copy.aboutTitle,
              subtitle: Copy.aboutLead),
          SizedBox(height: fluid(context, 36, 56)),
          mobile
              ? Column(children: [story, const SizedBox(height: 28), facts])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: story),
                    const SizedBox(width: 56),
                    Expanded(flex: 5, child: facts),
                  ],
                ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EXPERIENCE TIMELINE
// ---------------------------------------------------------------------------

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        children: [
          SizedBox(height: fluid(context, 70, 130)),
          const SectionHeader(
            label: 'Experience',
            title: 'Where the commits went',
            subtitle:
                'Client work, team products and my own apps, all shipping.',
          ),
          SizedBox(height: fluid(context, 36, 56)),
          for (var i = 0; i < experience.length; i++)
            _TimelineEntry(
              entry: experience[i],
              isLast: i == experience.length - 1,
              delayMs: 100 * i,
            ),
        ],
      ),
    );
  }
}

/// One timeline row: gradient node + connecting line on the left,
/// glow card with the entry on the right.
class _TimelineEntry extends StatelessWidget {
  final Experience entry;
  final bool isLast;
  final int delayMs;

  const _TimelineEntry({
    required this.entry,
    required this.isLast,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rail: node + line.
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: Palette.gradient,
                    boxShadow: [
                      BoxShadow(
                          color: Palette.cyan.withValues(alpha: 0.5),
                          blurRadius: 12),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Palette.blue.withValues(alpha: 0.5),
                            Palette.blue.withValues(alpha: 0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 26),
              child: Reveal(
                delay: Duration(milliseconds: delayMs),
                child: GlowCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(entry.role, style: Type.title(context)),
                          TagChip(entry.status, accent: true),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          Text(entry.org,
                              style:
                                  Type.mono(context, color: Palette.cyan)),
                          Text(entry.period, style: Type.mono(context)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(entry.summary, style: Type.body(context)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final t in entry.tags) TagChip(t)],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SKILLS
// ---------------------------------------------------------------------------

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= Breaks.desktop ? 3 : (w >= Breaks.mobile ? 2 : 1);
    return SectionShell(
      child: Column(
        children: [
          SizedBox(height: fluid(context, 70, 130)),
          const SectionHeader(
            label: 'Skills',
            title: 'The toolbox',
            subtitle: 'Picked per problem. Sharpened in production.',
          ),
          SizedBox(height: fluid(context, 36, 56)),
          _CardGrid(
            columns: cols,
            children: [
              for (var i = 0; i < skillGroups.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 80 * (i % cols)),
                  child: GlowCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(skillGroups[i].title,
                            style: Type.title(context)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final item in skillGroups[i].items)
                              TagChip(item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Equal-width card grid built from Rows, so every card in a row stretches
/// to the same height (Wrap cannot do that).
class _CardGrid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  static const gap = 22.0;

  const _CardGrid({required this.columns, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final slice = children.sublist(
          i, (i + columns).clamp(0, children.length));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < columns; j++) ...[
                Expanded(
                  child: j < slice.length ? slice[j] : const SizedBox(),
                ),
                if (j != columns - 1) const SizedBox(width: _CardGrid.gap),
              ],
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: _CardGrid.gap));
    }
    if (rows.isNotEmpty) rows.removeLast();
    return Column(children: rows);
  }
}

// ---------------------------------------------------------------------------
// PROJECTS
// ---------------------------------------------------------------------------

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= Breaks.mobile ? 2 : 1;
    return SectionShell(
      child: Column(
        children: [
          SizedBox(height: fluid(context, 70, 130)),
          const SectionHeader(
            label: 'Projects',
            title: 'Shipped, not shelved',
            subtitle: 'Case studies from production, not prototypes.',
          ),
          SizedBox(height: fluid(context, 36, 56)),
          _CardGrid(
            columns: cols,
            children: [
              for (var i = 0; i < projects.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 90 * (i % cols)),
                  child: _ProjectCard(project: projects[i]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GlowCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motif band on top, like a cover image but hand-painted.
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Palette.line)),
              ),
              child: ProjectMotifView(motif: p.motif, hovered: _hover),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(p.name, style: Type.title(context))),
                      TagChip(p.status, accent: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(p.subtitle,
                      style: Type.mono(context, color: Palette.cyan)),
                  const SizedBox(height: 12),
                  Text(p.description, style: Type.body(context)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final t in p.tags) TagChip(t)],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WIDGET LAB
// ---------------------------------------------------------------------------

class LabSection extends StatelessWidget {
  const LabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w >= Breaks.desktop ? 3 : (w >= Breaks.mobile ? 2 : 1);
    final demos = <Widget>[
      const SpringOrbDemo(),
      const StaggerBarsDemo(),
      const MorphDemo(),
    ];
    return SectionShell(
      child: Column(
        children: [
          SizedBox(height: fluid(context, 70, 130)),
          const SectionHeader(
            label: 'Widget lab',
            title: 'Flutter, live on this page',
            subtitle:
                'This site is a Flutter app. These demos run in it right now: '
                'grab, tap and play.',
          ),
          SizedBox(height: fluid(context, 36, 56)),
          _CardGrid(
            columns: cols,
            children: [
              for (var i = 0; i < labDemos.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 100 * (i % cols)),
                  child: GlowCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full width so each demo's Stack centers in the
                        // card instead of shrink-wrapping to the left edge.
                        SizedBox(
                            height: 190,
                            width: double.infinity,
                            child: demos[i]),
                        const SizedBox(height: 10),
                        GradientText(labDemos[i].title,
                            style: Type.title(context, min: 16, max: 20)),
                        const SizedBox(height: 6),
                        Text(labDemos[i].note, style: Type.body(context)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CONTACT + FOOTER
// ---------------------------------------------------------------------------

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: -180,
          child: Center(
            child: GlowBlob(size: fluid(context, 400, 700), opacity: 0.14),
          ),
        ),
        SectionShell(
          child: Column(
            children: [
              SizedBox(height: fluid(context, 70, 130)),
              SectionHeader(
                label: 'Contact',
                title: Copy.contactTitle,
                subtitle: Copy.contactNote,
              ),
              SizedBox(height: fluid(context, 30, 44)),
              Reveal(
                delay: const Duration(milliseconds: 120),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => openUrl('mailto:${Links.email}'),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GradientText(
                        Links.email,
                        style: Type.display(context, min: 22, max: 54),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: fluid(context, 26, 40)),
              Reveal(
                delay: const Duration(milliseconds: 220),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    GradientButton(
                        text: 'Email me',
                        icon: Icons.mail_outline_rounded,
                        onTap: () => openUrl('mailto:${Links.email}')),
                    OutlineButton(
                        text: 'GitHub', onTap: () => openUrl(Links.github)),
                    OutlineButton(
                        text: 'LinkedIn',
                        onTap: () => openUrl(Links.linkedin)),
                  ],
                ),
              ),
              SizedBox(height: fluid(context, 60, 100)),
              const _Footer(),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final credit = Text(Copy.footerLine,
        style: Type.label(context, min: 10, max: 11.5));
    // The hot-reload hint only matters where there is a keyboard.
    final hint = Text(Copy.hotReloadHint.toUpperCase(),
        style:
            Type.label(context, min: 10, max: 11.5).copyWith(color: Palette.cyan));
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Palette.line)),
      ),
      padding: const EdgeInsets.only(top: 20),
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

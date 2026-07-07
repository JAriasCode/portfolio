# jeffry arias · portfolio

Personal site, written in Flutter and compiled for the web. No site builder,
no CSS framework, one third-party package (`web`, for opening links).

## Run it

```bash
flutter pub get
flutter run -d chrome
```

## Design notes

- Typographic-first: the type does the work, there are no stock images.
  Project illustrations are hand-written `CustomPainter`s.
- Type is self-hosted: [Erode](https://www.fontshare.com/fonts/erode) and
  [Author](https://www.fontshare.com/fonts/author) by Indian Type Foundry
  (Fontshare Free Font License, see `assets/fonts/FFL.txt`), plus
  [Fragment Mono](https://fonts.google.com/specimen/Fragment+Mono) (OFL).
- Motion respects `prefers-reduced-motion`: entrances, the marquee and the
  typewriter all collapse to static content when the OS asks for it.
- Press `R` on a keyboard. You know why.

## Structure

```
lib/
  main.dart            app shell, nav jumps, hot-reload easter egg
  theme.dart           palette + fluid type scale
  content.dart         every word of copy and all project data
  util/open_url.dart   external links via package:web
  widgets/
    motion.dart        Reveal (scroll entrances), Marquee, reload flash
    effects.dart       film grain, wobbly underline, progress hairline
    motifs.dart        per-project CustomPainter illustrations
    common.dart        section shell, headers, hover links, tag chips
    sections.dart      nav, hero, work, stack, about, contact
```

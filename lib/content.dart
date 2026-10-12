/// All copy and data for the site in one place, so wording edits never
/// require touching layout code.
library;

abstract class Links {
  static const email = 'jeffryariasp@gmail.com';
  static const github = 'https://github.com/JAriasCode';
  static const linkedin =
      'https://www.linkedin.com/in/jeffry-arias-palma-2a5a22189/';
}

abstract class Copy {
  static const kicker = 'SAN JOSÉ, COSTA RICA · OPEN TO REMOTE WORK';
  static const name = 'Jeffry Arias';

  /// Rotating roles for the hero typing effect.
  static const roles = [
    'Flutter Engineer',
    'Mobile App Developer',
    'Firebase Specialist',
    'AI-Assisted Engineering',
    'One Codebase, Every Platform',
  ];

  static const heroStatement =
      'I build production mobile apps in Flutter: advisor marketplaces, '
      'sports media, nutrition, banking and tabletop gaming. Six live '
      'products, one codebase each, shipped to both stores and the web.';

  static const aboutTitle = 'Career story';
  static const aboutLead =
      'From full-stack logistics to my own products in Flutter.';
  static const aboutBody =
      'I write Dart for a living and then keep writing it after hours. '
      'Days are split between two US clients: Ingenio, through Svitla, '
      'where I work on the Keen consumer and advisor apps, and Prep '
      'Baseball, through FullStack Labs, the consumer app of the largest '
      'amateur baseball scouting network in the US. Nights go to my own '
      'products: NuMbi, a freemium nutrition app for the Costa Rican '
      'market, and Tempo, a life counter and table clock for tabletop card '
      'games, plus Vivco, the condominium platform our four-person team '
      'is building.\n\n'
      'Before that I spent three years leading MutualMovil, mobile banking '
      'for a Costa Rican mutual that passed 100,000 downloads, migrating it '
      'from two native codebases into one Flutter app. And I got my '
      'full-stack start at ePRAC Supply, building the logistics platforms '
      'a supply chain runs on: warehouse management, delivery tracking and '
      'container yard control, across mobile, desktop and web.\n\n'
      'I also run an AI-native workflow: Claude Code as a daily pair '
      'programmer, custom skills and hooks tuned to each project, MCP '
      'servers wiring my tools together, and an AI review gate in CI that '
      'every pull request passes before a human merges it.';

  static const contactTitle = "Let's build something";
  static const contactNote =
      'Hiring a mobile engineer? Migrating an app to Flutter? Fastest way '
      'to reach me is email. I answer from Costa Rica, usually the same day.';

  static const footerLine =
      'Designed and built by hand in Flutter for the web. '
      'Type: Chillax, Supreme and Fragment Mono.';
  static const hotReloadHint = 'press R for hot reload';
}

/// Animated counters in the hero stats card. All numbers verifiable.
class Stat {
  final int value;
  final String suffix;
  final String label;
  const Stat(this.value, this.suffix, this.label);
}

const stats = [
  Stat(6, '+', 'Apps in production'),
  Stat(100, 'K+', 'Downloads on MutualMovil'),
  Stat(4, '', 'State management stacks'),
  Stat(2, '', 'App stores, plus web'),
];

/// Experience timeline entries, ordered by start date, most recent first.
class Experience {
  final String role;
  final String org;

  /// Date range shown next to the org line.
  final String period;

  /// Short status shown as the accent chip (Current, Live, ...).
  final String status;
  final String summary;
  final List<String> tags;
  const Experience({
    required this.role,
    required this.org,
    required this.period,
    required this.status,
    required this.summary,
    required this.tags,
  });
}

const experience = [
  Experience(
    role: 'Senior Mobile Engineer',
    org: 'Svitla · Ingenio',
    period: 'Sep 2026 - Present',
    status: 'Current',
    summary:
        'Keen, an advisor marketplace with live chat and calls. I work '
        'across both Flutter apps, the consumer app and the advisor app, '
        'shipping features and fixes and leading the advisor app migration '
        'from GraphQL to REST.',
    tags: ['Flutter', 'BLoC', 'GetIt', 'REST + GraphQL', 'Sentry'],
  ),
  Experience(
    role: 'Founder & Developer',
    org: 'Tempo',
    period: 'Aug 2026 - Present',
    status: 'Live',
    summary:
        'All-in-one table companion for card game nights: life counter and '
        'per-player chess clock on one phone lying flat in the middle of '
        'the table, with every quadrant rotated to face its seat. Offline, '
        'no account, live on the App Store.',
    tags: ['Flutter', 'Riverpod', 'Clean architecture', 'Offline'],
  ),
  Experience(
    role: 'Mobile Lead',
    org: 'Poker Jacks · Vivco',
    period: 'May 2026 - Present',
    status: 'In development',
    summary:
        'Condominium management platform for Costa Rica: visitor passes, '
        'amenity reservations, NFC and QR gate access. Offline-first, '
        'because guard houses have bad signal.',
    tags: ['Flutter', 'Riverpod', 'Isar', 'GoRouter', 'NFC + QR'],
  ),
  Experience(
    role: 'Flutter Engineer',
    org: 'FullStack Labs · Prep Baseball',
    period: '2025 - Present',
    status: 'Current',
    summary:
        'Consumer app for the largest amateur baseball scouting network in '
        'the US, serving 80,000+ annual tournament players. Player '
        'profiles, rankings and event coverage on iOS, Android and web '
        'from one codebase.',
    tags: ['Flutter', 'BLoC / Cubits', 'Dio', 'Firebase', 'Web + mobile'],
  ),
  Experience(
    role: 'Founder & Developer',
    org: 'NuMbi',
    period: '2024 - Present',
    status: 'Live',
    summary:
        'Freemium nutrition app for the Costa Rican market: macro '
        'tracking, recipes, an Instagram-style stories feed and premium '
        'subscriptions with in-app payments. I run the whole stack, from '
        'the Flutter app to the admin panel and push pipelines.',
    tags: ['Flutter', 'Riverpod', 'Firestore', 'FCM', 'GA4'],
  ),
  Experience(
    role: 'Flutter Developer',
    org: 'Grupo Mutual · MutualMovil',
    period: '2022 - 2025',
    status: 'Live',
    summary:
        'Led Flutter development of a mutual banking app that passed '
        '100,000 downloads, migrating separate native iOS and Android '
        'codebases into one. Biometric login, digital signatures, SSL '
        'pinning, and dual distribution for Google and Huawei devices.',
    tags: ['Flutter', 'GetX', 'Biometrics', 'SSL pinning', 'GMS + HMS'],
  ),
  Experience(
    role: 'Software Developer',
    org: 'ePRAC Supply',
    period: '2020 - 2022',
    status: 'Shipped',
    summary:
        'Three logistics platforms in daily operation: warehouse '
        'management (WMS), delivery tracking and container yard control. '
        'Full-stack ownership across mobile, desktop and web: API design, '
        'front end and database.',
    tags: ['Full-stack', 'WMS', 'REST APIs', 'Databases', 'Mobile + web'],
  ),
];

/// Skills grid: category -> items.
class SkillGroup {
  final String title;
  final List<String> items;
  const SkillGroup(this.title, this.items);
}

const skillGroups = [
  SkillGroup('Mobile Engineering', [
    'Flutter (Dart)',
    'iOS + Android + Web',
    'Responsive & adaptive UI',
    'Custom painters & animations',
    'Store publishing',
  ]),
  SkillGroup('State Management', [
    'Riverpod',
    'Provider',
    'BLoC / Cubits',
    'GetX',
    'Chosen per problem, not trend',
  ]),
  SkillGroup('AI & Agentic Workflows', [
    'Claude Code, daily driver',
    'Custom skills & hooks',
    'MCP servers (GitHub, Firebase, Figma)',
    'Multi-agent workflows',
    'AI review gates in CI',
  ]),
  SkillGroup('Backend & Firebase', [
    'Firestore · Auth · Storage',
    'Cloud Functions · FCM',
    'REST APIs with Dio',
    'GA4 analytics',
  ]),
  SkillGroup('Offline & Data', [
    'Isar local database',
    'Offline-first sync',
    'SharedPreferences · SecureStorage',
  ]),
  SkillGroup('Security', [
    'Biometric auth',
    'SSL pinning',
    'Secure session handling',
    'GMS + HMS dual builds',
  ]),
  SkillGroup('Tooling & CI/CD', [
    'GitHub Actions',
    'Codemagic',
    'Docker',
    'Firebase App Distribution',
    'WordPress plugin development',
  ]),
];

/// Featured project cards.
class Project {
  final String name;
  final String subtitle;
  final String status;
  final String description;
  final List<String> tags;
  final ProjectMotif motif;
  const Project({
    required this.name,
    required this.subtitle,
    required this.status,
    required this.description,
    required this.tags,
    required this.motif,
  });
}

enum ProjectMotif { chat, diamond, rings, hourglass, card, grid, plug, boxes }

const projects = [
  Project(
    name: 'Keen',
    subtitle: 'Advisor marketplace · Ingenio',
    status: 'Live',
    description:
        'Two Flutter apps, one for consumers and one for advisors, around '
        'live chat and phone sessions. Features, production fixes and an '
        'incremental GraphQL to REST migration without breaking live users.',
    tags: ['Flutter', 'BLoC', 'GoRouter', 'REST'],
    motif: ProjectMotif.chat,
  ),
  Project(
    name: 'Prep Baseball',
    subtitle: 'Sports media · FullStack Labs',
    status: 'Live',
    description:
        'Consumer app for the largest amateur baseball scouting network in '
        'the US, shipped to iOS, Android and the web from one Flutter '
        'codebase.',
    tags: ['Flutter', 'BLoC', 'Dio', 'Firebase'],
    motif: ProjectMotif.diamond,
  ),
  Project(
    name: 'NuMbi',
    subtitle: 'Nutrition · Own product',
    status: 'Live',
    description:
        'Freemium nutrition app: macro tracking, recipes, an '
        'Instagram-style stories feed and premium subscriptions with '
        'in-app payments. Includes a WordPress admin that edits Firestore '
        'directly.',
    tags: ['Flutter', 'Riverpod', 'Firestore', 'FCM'],
    motif: ProjectMotif.rings,
  ),
  Project(
    name: 'Tempo',
    subtitle: 'Tabletop gaming · Own product',
    status: 'Live',
    description:
        'Life counter and chess clock for 2 to 4 players sharing one phone. '
        'Seat-rotated quadrants, commander damage, card art backgrounds and '
        'saved player profiles. Built, branded and shipped solo.',
    tags: ['Flutter', 'Riverpod', 'CustomPainter', 'Offline'],
    motif: ProjectMotif.hourglass,
  ),
  Project(
    name: 'MutualMovil',
    subtitle: 'Banking · Grupo Mutual',
    status: 'In production',
    description:
        'Mobile banking past 100,000 downloads. Biometric login and SSL '
        'pinning, with dual builds for Google Play services and Huawei '
        'Mobile Services.',
    tags: ['Flutter', 'GetX', 'Biometrics', 'HMS'],
    motif: ProjectMotif.card,
  ),
  Project(
    name: 'Vivco',
    subtitle: 'Property management · Poker Jacks',
    status: 'In development',
    description:
        'Condominium platform for Costa Rica: visitor passes, amenity '
        'reservations, NFC and QR gate access, offline-first with Isar.',
    tags: ['Flutter', 'Riverpod', 'Isar', 'NFC + QR'],
    motif: ProjectMotif.grid,
  ),
  Project(
    name: 'numbi-admin',
    subtitle: 'WordPress plugin · Own product',
    status: 'Live',
    description:
        'WordPress admin panel for NuMbi: Firestore CRUD, Excel '
        'import/export with SKU matching, and food image management.',
    tags: ['PHP', 'Firestore REST', 'SheetJS'],
    motif: ProjectMotif.plug,
  ),
  Project(
    name: 'ePRAC Logistics',
    subtitle: 'Supply chain · ePRAC Supply',
    status: 'Shipped',
    description:
        'Warehouse management (WMS), delivery tracking and container yard '
        'control: three platforms running daily logistics operations, '
        'built full-stack across mobile, desktop and web.',
    tags: ['Full-stack', 'WMS', 'REST APIs', 'Databases'],
    motif: ProjectMotif.boxes,
  ),
];

/// Interactive demos in the Widget Lab section. Each card is a small
/// hand-built Flutter toy that shows motion craft, running live on the page.
class LabDemo {
  final String title;
  final String note;
  const LabDemo(this.title, this.note);
}

const labDemos = [
  LabDemo(
    'Spring physics',
    'Drag the orb and let go. SpringSimulation brings it home.',
  ),
  LabDemo(
    'Staggered intervals',
    'One controller, five bars, offset Interval curves. Tap to replay.',
  ),
  LabDemo(
    'Implicit morph',
    'Tap to morph. AnimatedContainer does all the work.',
  ),
];

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
    'One Codebase, Every Platform',
  ];

  static const heroStatement =
      'I build production mobile apps in Flutter: sports media, nutrition, '
      'banking and property management. Four live products, one codebase '
      'each, shipped to both stores and the web.';

  static const aboutTitle = 'Career story';
  static const aboutLead =
      'From client apps to my own products, always in Dart.';
  static const aboutBody =
      'I write Dart for a living and then keep writing it after hours. '
      'Days go to Prep Baseball through FullStack Labs, the consumer app '
      'of the largest amateur baseball scouting network in the US. Nights '
      'go to NuMbi, my nutrition app for a Costa Rican practice, and to '
      'Vivco, the condominium platform our four-person team is building.\n\n'
      'Along the way I shipped a mobile banking app with biometric login '
      'and SSL pinning for a Costa Rican mutual, built WordPress admin '
      'panels that talk straight to Firestore, and set up CI/CD pipelines '
      'so every release is a button, not a ritual.\n\n'
      'Opinions I will defend: state management should match the problem, '
      'not the trend. Ship to a cheap Android before you ship to an iPhone. '
      'And a well-kept CHANGELOG is a love letter to your future self.';

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
  Stat(4, '+', 'Apps in production'),
  Stat(117, '+', 'Automated tests in NuMbi'),
  Stat(3, '', 'State management stacks'),
  Stat(2, '', 'App stores, plus web'),
];

/// Experience timeline entries, most recent first.
class Experience {
  final String role;
  final String org;
  final String period;
  final String summary;
  final List<String> tags;
  const Experience({
    required this.role,
    required this.org,
    required this.period,
    required this.summary,
    required this.tags,
  });
}

const experience = [
  Experience(
    role: 'Flutter Engineer',
    org: 'FullStack Labs · Prep Baseball',
    period: 'Current',
    summary:
        'Consumer app for the largest amateur baseball scouting network in '
        'the US. Player profiles, rankings and event coverage on iOS, '
        'Android and web from one codebase.',
    tags: ['Flutter', 'BLoC / Cubits', 'Dio', 'Firebase', 'Web + mobile'],
  ),
  Experience(
    role: 'Mobile Lead',
    org: 'Poker Jacks · Vivco',
    period: 'In development',
    summary:
        'Condominium management platform for Costa Rica: visitor passes, '
        'amenity reservations, NFC and QR gate access. Offline-first, '
        'because guard houses have bad signal.',
    tags: ['Flutter', 'Riverpod', 'Isar', 'GoRouter', 'NFC + QR'],
  ),
  Experience(
    role: 'Founder & Developer',
    org: 'NuMbi',
    period: 'Live',
    summary:
        'Nutrition app for a Costa Rican practice: 2,800+ local foods, '
        'macro tracking, recipes and premium content, plus a WordPress '
        'admin panel that edits Firestore directly.',
    tags: ['Flutter', 'Riverpod', 'Firestore', 'FCM', 'GA4'],
  ),
  Experience(
    role: 'Flutter Developer',
    org: 'Freelance · MutualMovil',
    period: 'In production',
    summary:
        'Mobile banking for a Costa Rican mutual. Biometric login, SSL '
        'pinning, and dual distribution for Google and Huawei devices.',
    tags: ['Flutter', 'GetX', 'Biometrics', 'SSL pinning', 'GMS + HMS'],
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
    'BLoC / Cubits',
    'GetX',
    'Chosen per problem, not trend',
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

enum ProjectMotif { diamond, rings, card, grid, plug, cart }

const projects = [
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
        'Food database of 2,800+ local foods, macro tracking, recipes and '
        'premium content. Includes a WordPress admin that edits Firestore '
        'directly.',
    tags: ['Flutter', 'Riverpod', 'Firestore', 'FCM'],
    motif: ProjectMotif.rings,
  ),
  Project(
    name: 'MutualMovil',
    subtitle: 'Banking · Freelance client',
    status: 'In production',
    description:
        'Mobile banking with biometric login and SSL pinning. Dual builds: '
        'Google Play services and Huawei Mobile Services.',
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
    name: 'Pinky Singles',
    subtitle: 'E-commerce · Client',
    status: 'Live',
    description:
        'WooCommerce storefront for a trading card shop, with a custom '
        'Alpine.js admin panel for order management.',
    tags: ['WooCommerce', 'Alpine.js', 'PHP'],
    motif: ProjectMotif.cart,
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
  LabDemo('Spring physics',
      'Drag the orb and let go. SpringSimulation brings it home.'),
  LabDemo('Staggered intervals',
      'One controller, five bars, offset Interval curves. Tap to replay.'),
  LabDemo('Implicit morph',
      'Tap to morph. AnimatedContainer does all the work.'),
];

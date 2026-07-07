/// All copy and data for the site in one place, so wording edits never
/// require touching layout code.
library;

abstract class Links {
  static const email = 'jeffryariasp@gmail.com';
  static const github = 'https://github.com/JAriasCode';
  static const linkedin =
      'https://www.linkedin.com/in/jeffry-arias-palma-2a5a22189/';
}

/// One shipped project. `motif` picks which custom-painted illustration the
/// work section draws for it (no stock images anywhere on this site).
class Project {
  final String index;
  final String name;
  final String role;
  final String description;
  final List<String> tags;
  final ProjectMotif motif;

  const Project({
    required this.index,
    required this.name,
    required this.role,
    required this.description,
    required this.tags,
    required this.motif,
  });
}

enum ProjectMotif { diamond, rings, card, grid }

const projects = [
  Project(
    index: '01',
    name: 'Prep Baseball',
    role: 'Flutter engineer · contractor via FullStack Labs',
    description:
        'Consumer app for the largest amateur baseball scouting network in '
        'the US. Player profiles, rankings and event coverage, shipped to '
        'iOS, Android and the web from one Flutter codebase.',
    tags: ['BLoC / Cubits', 'Dio', 'Firebase', 'Web + mobile'],
    motif: ProjectMotif.diamond,
  ),
  Project(
    index: '02',
    name: 'NuMbi',
    role: 'Owner · design to deployment',
    description:
        'Nutrition app for a Costa Rican practice: a food database of '
        '2,800+ local foods, macro tracking, recipes and premium content. '
        'Includes a WordPress admin panel that edits Firestore directly, '
        'so the nutritionist manages everything from one place.',
    tags: ['Riverpod', 'Firestore', 'FCM', 'GA4', 'WP admin plugin'],
    motif: ProjectMotif.rings,
  ),
  Project(
    index: '03',
    name: 'MutualMovil',
    role: 'Freelance · in production',
    description:
        'Mobile banking for a Costa Rican mutual. Biometric login, SSL '
        'pinning, and dual distribution: Google Play services on one build, '
        'Huawei Mobile Services on the other.',
    tags: ['GetX', 'Biometrics', 'SSL pinning', 'GMS + HMS'],
    motif: ProjectMotif.card,
  ),
  Project(
    index: '04',
    name: 'Vivco',
    role: 'Mobile lead · four-person team',
    description:
        'Condominium management for Costa Rica: visitor passes, amenity '
        'reservations, and gate access with NFC and QR. Offline-first with '
        'a local Isar cache, because guard houses have bad signal.',
    tags: ['Riverpod', 'Dio', 'Isar', 'GoRouter', 'NFC + QR'],
    motif: ProjectMotif.grid,
  ),
];

/// Smaller things worth a line each, not a full case study.
class SideProject {
  final String name;
  final String note;
  const SideProject(this.name, this.note);
}

const sideProjects = [
  SideProject('numbi-admin',
      'WordPress plugin: Firestore CRUD, Excel import, image management'),
  SideProject('pj_ui', 'internal Flutter design system package for Vivco'),
  SideProject('Pinky Singles',
      'WooCommerce storefront and Alpine.js admin panel for a TCG shop'),
];

/// Items for the scrolling stack marquee.
const marqueeItems = [
  'Flutter',
  'Dart',
  'Riverpod',
  'BLoC',
  'GetX',
  'Dio',
  'Firebase',
  'Firestore',
  'Isar',
  'GoRouter',
  'GitHub Actions',
  'Codemagic',
  'Docker',
];

/// The stack section, written as the file every Flutter dev reads first.
/// Comments carry the meaning; versions are the real majors I work with.
const pubspecLines = <String>[
  'name: jeffry_arias',
  'description: Flutter engineer. San José, Costa Rica.',
  '',
  'environment:',
  '  sdk: ">=3.0.0 <4.0.0"',
  '',
  'dependencies:',
  '  flutter:',
  '    sdk: flutter',
  '  flutter_bloc: ^9.0.0     # day job, Prep Baseball',
  '  riverpod: ^2.0.0         # personal apps, NuMbi + Vivco',
  '  get: ^4.0.0              # client work, MutualMovil',
  '  dio: ^5.0.0              # every REST API so far',
  '  firebase_core: ^3.0.0    # auth, Firestore, storage, FCM',
  '  isar: ^3.0.0             # offline-first cache',
  '  go_router: ^14.0.0       # deep links included',
  '',
  'dev_dependencies:',
  '  github_actions: ci',
  '  codemagic: cd',
  '  docker: local web testing',
];

abstract class Copy {
  static const kicker = 'SAN JOSÉ, COSTA RICA · UTC-6';
  static const heroFirst = 'Jeffry';
  static const heroSecond = 'Arias';
  static const heroStatement =
      'Flutter engineer with four apps in production: sports media, '
      'nutrition, banking and property management. One codebase each, '
      'both stores, web when it earns its place.';

  static const aboutTitle = 'The short version';
  static const aboutBody =
      'I write Dart for a living and then keep writing it after hours. '
      'Days go to Prep Baseball through FullStack Labs. Nights go to NuMbi, '
      'my nutrition app, and to Vivco, the condominium platform our '
      'four-person team is building for the Costa Rican market.\n\n'
      'Opinions I will defend: state management should match the problem, '
      'not the trend. Ship to a cheap Android before you ship to an iPhone. '
      'And a well-kept CHANGELOG is a love letter to your future self.';

  static const contactTitle = 'Need a mobile engineer?';
  static const contactNote =
      'Fastest way to reach me is email. I answer from Costa Rica, '
      'usually the same day.';

  static const footerLine =
      'Designed and built by hand in Flutter, no site builder involved. '
      'Type: Erode and Author (Indian Type Foundry), Fragment Mono.';
  static const hotReloadHint = 'press R for hot reload';
}

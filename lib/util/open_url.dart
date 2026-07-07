import 'package:web/web.dart' as web;

/// Opens an external URL in a new tab. mailto: links reuse the current tab
/// so the visitor's reading position survives their email client opening.
void openUrl(String url) {
  if (url.startsWith('mailto:')) {
    web.window.location.href = url;
  } else {
    web.window.open(url, '_blank');
  }
}

import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static Future<void> makeCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    await launchUrl(uri);
  }

  static Future<void> openMap(String query) async {
    final Uri uri = Uri.parse('https://maps.google.com/?q=$query');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionBody(String body) {
    return Text(body, style: const TextStyle(fontSize: 15, height: 1.6));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.privacy_tip, size: 70, color: Colors.red),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                l10n.privacyPolicyTitle,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                l10n.privacyLastUpdated,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            sectionTitle(l10n.privacySection1Title),
            sectionBody(l10n.privacySection1Body),

            sectionTitle(l10n.privacySection2Title),
            sectionBody(l10n.privacySection2Body),

            sectionTitle(l10n.privacySection3Title),
            sectionBody(l10n.privacySection3Body),

            sectionTitle(l10n.privacySection4Title),
            sectionBody(l10n.privacySection4Body),

            sectionTitle(l10n.privacySection5Title),
            sectionBody(l10n.privacySection5Body),

            sectionTitle(l10n.privacySection6Title),
            sectionBody(l10n.privacySection6Body),

            sectionTitle(l10n.privacySection7Title),
            sectionBody(l10n.privacySection7Body),

            sectionTitle(l10n.privacySection8Title),
            sectionBody(l10n.privacySection8Body),

            sectionTitle(l10n.privacySection9Title),
            sectionBody(l10n.privacySection9Body),

            const SizedBox(height: 30),

            Center(
              child: Text(
                l10n.privacyCopyright,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

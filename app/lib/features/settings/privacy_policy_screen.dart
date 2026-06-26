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
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.privacy_tip, size: 70, color: Colors.red),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                "ResQ-KH Privacy Policy",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                "Last Updated: June 2026",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            sectionTitle("1. Introduction"),
            sectionBody(
              "ResQ-KH is an accessibility-first emergency assistance application developed as a university project. "
              "Your privacy is important to us. This policy explains how your information is collected and used while using the application.",
            ),

            sectionTitle("2. Information We Collect"),
            sectionBody(
              "We may collect:\n\n"
              "• Full Name\n"
              "• Phone Number\n"
              "• Email Address (optional)\n"
              "• Current Location (only when permission is granted)\n"
              "• Emergency Reports submitted through the application\n"
              "• App preferences such as language and theme.",
            ),

            sectionTitle("3. Why We Collect Your Information"),
            sectionBody(
              "Your information is collected only to:\n\n"
              "• Create your account\n"
              "• Verify your identity using OTP\n"
              "• Submit emergency reports\n"
              "• Help emergency responders locate incidents\n"
              "• Improve the overall user experience.",
            ),

            sectionTitle("4. Location Permission"),
            sectionBody(
              "Your location is only accessed after your permission has been granted. "
              "The location is used solely to assist emergency reporting and nearby emergency service recommendations.",
            ),

            sectionTitle("5. Data Sharing"),
            sectionBody(
              "Emergency reports may be shared with emergency service providers such as hospitals, police stations, fire departments, or ambulance services for demonstration purposes within this academic project. "
              "We do not sell or share your personal information with third-party advertisers.",
            ),

            sectionTitle("6. Data Security"),
            sectionBody(
              "We take reasonable measures to protect your information. "
              "However, as this application is developed for educational purposes, absolute security cannot be guaranteed.",
            ),

            sectionTitle("7. Your Rights"),
            sectionBody(
              "You may:\n\n"
              "• Update your personal information.\n"
              "• Request deletion of your account.\n"
              "• Withdraw location permission at any time through your device settings.",
            ),

            sectionTitle("8. Changes to this Policy"),
            sectionBody(
              "This Privacy Policy may be updated from time to time. "
              "Any significant changes will be reflected within the application.",
            ),

            sectionTitle("9. Contact"),
            sectionBody(
              "If you have questions regarding this Privacy Policy, please contact the ResQ-KH development team.\n\n"
              "Email: support@resq-kh.local",
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "© 2026 ResQ-KH",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosCallButton extends StatelessWidget {
  final VoidCallback? onCall;

  const SosCallButton({super.key, this.onCall});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: '119');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    onCall?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Semantics(
        label: l10n.callEmergency119,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _call,
            borderRadius: BorderRadius.circular(24),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 228, 93, 69), Color.fromARGB(255, 211, 42, 42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    offset: Offset(0, 12),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Container(
                height: 84,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.emergency,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.call119Now,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.emergencyHotlineDesc,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 18 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

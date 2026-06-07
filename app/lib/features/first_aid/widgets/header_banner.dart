import 'package:flutter/material.dart';
 
class HeaderBanner extends StatelessWidget {
  final String title;
  final String description;
 
  const HeaderBanner({
    super.key,
    required this.title,
    required this.description,
  });
 
  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: title,
      child: Container(
        color: const Color.fromARGB(255, 249, 78, 78),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFFF2F0),
                  size: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFFF2F0),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      height: 34 / 28,
                    ),
                  ),
                ),
              ],
            ),
 
            const SizedBox(height: 8),
 
            // Description
            Text(
              description,
              style: TextStyle(
                color: const Color(0xFFFFF2F0).withOpacity(0.9),
                fontSize: 18,
                height: 28 / 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 
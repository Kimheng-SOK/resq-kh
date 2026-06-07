import 'package:flutter/material.dart';

/// A blue-dot marker representing the user's current location on the map.
/// Outer semi-transparent circle + inner solid blue circle with white border.
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // ── Outer pulse ring ──────────────────────────────────
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0x4D3B82F6), // blue-500 @ 30%
            shape: BoxShape.circle,
          ),
        ),

        // ── Inner solid dot ───────────────────────────────────
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB), // blue-600
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }
}

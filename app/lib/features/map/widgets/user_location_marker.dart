import 'package:flutter/material.dart';

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
            color: Color(0x4D3B82F6),
            shape: BoxShape.circle,
          ),
        ),

        // ── Inner solid dot ───────────────────────────────────
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }
}

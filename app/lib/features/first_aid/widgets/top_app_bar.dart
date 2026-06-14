import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  const TopAppBar({super.key, this.onBack, this.onSettings});

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF9F9F9),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      titleSpacing: 24,
      title: Semantics(
        button: true,
        label: 'Go back to SOS Cambodia home',
        child: GestureDetector(
          onTap: onBack,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, color: Color(0xFFAF101A), size: 16),
              const SizedBox(width: 8),
              Text(
                'SOS CAMBODIA',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFAF101A),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Semantics(
            button: true,
            label: 'Settings',
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFFAF101A),
                size: 20,
              ),
              onPressed: onSettings,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum Severity { critical, urgent, stable }

class _SeverityConfig {
  final Color bg;
  final Color border;

  const _SeverityConfig({required this.bg, required this.border});
}

const _severityConfig = {
  Severity.critical: _SeverityConfig(
    bg: Color(0xFFCD4B4B),
    border: Color(0xFFF7D1D0),
  ),
  Severity.urgent: _SeverityConfig(
    bg: Color(0xFFF17B35),
    border: Color(0xFFF7D2B6),
  ),
  Severity.stable: _SeverityConfig(
    bg: Color(0xFF5D736E),
    border: Color(0xFFDBE3E1),
  ),
};

class UrgencyCard extends StatefulWidget {
  final String title;
  final String description;
  final Widget icon;
  final Severity severity;
  final VoidCallback? onStart;

  const UrgencyCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.severity,
    this.onStart,
  });

  @override
  State<UrgencyCard> createState() => _UrgencyCardState();
}

class _UrgencyCardState extends State<UrgencyCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = _severityConfig[widget.severity]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E9EA), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + severity badge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: config.bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(14),
                child: widget.icon,
              ),
              Container(
                decoration: BoxDecoration(
                  color: config.bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  widget.severity.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 18 / 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title + description
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 32,
              height: 1.0,
              color: Color(0xFF1A1C1C),
              letterSpacing: -0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 18,
              height: 28 / 18,
              color: Color(0xFF5B403D),
            ),
          ),

          const SizedBox(height: 12),

          // START STEPS button
          GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) {
              setState(() => _pressed = false);
              widget.onStart?.call();
            },
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              transform: _pressed
                  ? Matrix4.translationValues(0, 4, 0)
                  : Matrix4.identity(),
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFB9B6B), Color(0xFFF25F2F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: _pressed
                    ? []
                    : const [
                        BoxShadow(
                          color: Color(0x22000000),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: widget.onStart,
                  splashColor: Colors.white24,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.startSteps,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 28 / 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
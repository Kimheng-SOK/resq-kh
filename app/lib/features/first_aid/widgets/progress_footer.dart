import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProgressFooter extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool canGoBack;
  final bool canGoNext;

  const ProgressFooter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onBack,
    this.onNext,
    this.canGoBack = true,
    this.canGoNext = true,
  });

  @override
  State<ProgressFooter> createState() => _ProgressFooterState();
}

class _ProgressFooterState extends State<ProgressFooter> {
  bool _backPressed = false;
  bool _nextPressed = false;

  double get _progress =>
      (widget.currentStep / widget.totalSteps).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        border: Border(
          top: BorderSide(color: Color(0xFFE6E9EB), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // BACK button
          _buildBackButton(),

          // Progress indicator
          Expanded(child: _buildProgressIndicator()),

          // NEXT button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l10n.goToPrevStep,
      child: GestureDetector(
        onTapDown: widget.canGoBack
            ? (_) => setState(() => _backPressed = true)
            : null,
        onTapUp: widget.canGoBack
            ? (_) {
                setState(() => _backPressed = false);
                widget.onBack?.call();
              }
            : null,
        onTapCancel: () => setState(() => _backPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: _backPressed
              ? Matrix4.translationValues(1, 2, 0)
              : Matrix4.identity(),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E9EB), width: 1.5),
            boxShadow: _backPressed
                ? []
                : const [
                    BoxShadow(
                      color: Color(0x11000000),
                      offset: Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
          ),
          child: Opacity(
            opacity: widget.canGoBack ? 1.0 : 0.4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chevron_left, size: 16, color: Color(0xFF1A1C1C)),
                const SizedBox(width: 4),
                Text(
                  l10n.back,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 18,
                    height: 28 / 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      liveRegion: true,
      label: l10n.stepOf(widget.currentStep, widget.totalSteps),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.progress,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF5B403D),
              fontSize: 18,
              height: 28 / 18,
            ),
          ),
          Text(
            l10n.stepOf(widget.currentStep, widget.totalSteps),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFDD572E),
              fontSize: 18,
              height: 28 / 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Progress bar
          SizedBox(
            width: 96,
            height: 8,
            child: ClipRect(
              child: Stack(
                children: [
                  Container(color: const Color(0xFFEEF0F3)),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 300),
                    widthFactor: _progress,
                    child: Container(color: const Color(0xFFEF6E56)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l10n.goToNextStep,
      child: GestureDetector(
        onTapDown: widget.canGoNext
            ? (_) => setState(() => _nextPressed = true)
            : null,
        onTapUp: widget.canGoNext
            ? (_) {
                setState(() => _nextPressed = false);
                widget.onNext?.call();
              }
            : null,
        onTapCancel: () => setState(() => _nextPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          transform: _nextPressed
              ? Matrix4.translationValues(0, 4, 0)
              : Matrix4.identity(),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFB9B6B), Color(0xFFF25F2F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _nextPressed
                ? []
                : const [
                    BoxShadow(
                      color: Color(0x22000000),
                      offset: Offset(0, 10),
                      blurRadius: 20,
                    ),
                  ],
          ),
          child: Opacity(
            opacity: widget.canGoNext ? 1.0 : 0.4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.next,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 28 / 18,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
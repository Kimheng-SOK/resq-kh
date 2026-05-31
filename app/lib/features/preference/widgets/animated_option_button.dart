import 'package:flutter/material.dart';
import 'package:app/core/theme/app_color.dart';

/// A tappable option button with icon, label, scale-bounce animation on
/// selection, and smooth color transitions.
///
/// [T] is the value type this button represents (e.g. [String] for language,
/// [ThemeMode] for theme).
class AnimatedOptionButton<T> extends StatefulWidget {
  /// The value this button represents.
  final T value;

  /// The currently selected value in the group.
  final T selectedValue;

  /// Optional icon. When null the button renders as text-only.
  final IconData? icon;

  /// Display label shown below (or beside) the icon.
  final String label;

  /// Called when the button is tapped. The parent should update
  /// [selectedValue] to [value].
  final VoidCallback onTap;

  const AnimatedOptionButton({
    super.key,
    required this.value,
    required this.selectedValue,
    this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<AnimatedOptionButton<T>> createState() =>
      _AnimatedOptionButtonState<T>();
}

class _AnimatedOptionButtonState<T> extends State<AnimatedOptionButton<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;

  bool get _isSelected => widget.value == widget.selectedValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 0.94), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.94, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant AnimatedOptionButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger the bounce only when transitioning from unselected → selected.
    final wasSelected = oldWidget.value == oldWidget.selectedValue;
    if (!wasSelected && _isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final dimColor = isDark ? Colors.white54 : AppColors.textSecondary;

    final unselectedBg =
        isDark ? Colors.white.withAlpha(25) : Colors.grey.shade100;
    final unselectedBorder =
        isDark ? Colors.white.withAlpha(60) : Colors.grey.shade300;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            vertical: widget.icon != null ? 12 : 14,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: _isSelected ? primary : unselectedBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isSelected ? primary : unselectedBorder,
              width: _isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 22,
                  color: _isSelected ? Colors.white : dimColor,
                ),
                const SizedBox(height: 4),
              ],
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isSelected ? Colors.white : dimColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

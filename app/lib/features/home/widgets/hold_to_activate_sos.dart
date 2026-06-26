import 'package:flutter/material.dart';
import 'sos_button.dart';

class HoldToActivateSOS extends StatefulWidget {
  final VoidCallback onTap;       
  final VoidCallback onHoldComplete;

  const HoldToActivateSOS({
    super.key,
    required this.onTap,
    required this.onHoldComplete,
  });

  @override
  State<HoldToActivateSOS> createState() => _HoldToActivateSOSState();
}

class _HoldToActivateSOSState extends State<HoldToActivateSOS>
    with SingleTickerProviderStateMixin {
  late AnimationController _holdController;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onHoldComplete();
          _holdController.reset();
        }
      });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: (_) => _holdController.forward(from: 0),
      onLongPressEnd: (_) => _holdController.reverse(),
      onLongPressCancel: () => _holdController.reverse(),
      child: AnimatedBuilder(
        animation: _holdController,
        builder: (context, child) {
          return CustomPaint(
            painter: _HoldRingPainter(progress: _holdController.value),
            child: child,
          );
        },
        child: SOSButton(onTap: widget.onTap),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  final double progress;
  _HoldRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 + 10;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28318 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter old) => old.progress != progress;
}
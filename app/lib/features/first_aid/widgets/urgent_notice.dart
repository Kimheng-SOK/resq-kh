import 'package:flutter/material.dart';

class UrgentNotice extends StatefulWidget {
  const UrgentNotice({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<UrgentNotice> createState() => _UrgentNoticeState();
}

class _UrgentNoticeState extends State<UrgentNotice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'IMMEDIATE ACTION REQUIRED',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 81, 81),
              border: Border.all(
                color: const Color.fromARGB(255, 217, 218, 218),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  offset: Offset(0, 8),
                  blurRadius: 18,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading row
                Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color.fromARGB(255, 255, 242, 240),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'IMMEDIATE ACTION REQUIRED',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 242, 240),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Body text
                const Text(
                  'Select the condition below to start life-saving protocols. '
                  'Call emergency services immediately if not already done.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 242, 240),
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
}

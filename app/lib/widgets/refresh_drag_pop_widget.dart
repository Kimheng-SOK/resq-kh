import 'package:flutter/material.dart';

class RefreshDragPopWidget extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double refreshThreshold;
  final double swipeVelocityThreshold;
  final Duration minRefreshDuration;

  const RefreshDragPopWidget({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshThreshold = 80,
    this.swipeVelocityThreshold = 300,
    this.minRefreshDuration = const Duration(milliseconds: 600),
  });

  @override
  State<RefreshDragPopWidget> createState() => _RefreshDragPopWidgetState();
}

class _RefreshDragPopWidgetState extends State<RefreshDragPopWidget>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  bool _isRefreshing = false;
  late final AnimationController _springController;

  double get _progress =>
      (_dragOffset / widget.refreshThreshold).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _addOffset(double delta) {
    if (_isRefreshing) return;
    setState(() => _dragOffset = (_dragOffset + delta).clamp(0.0, 200.0));
  }

  void _onDragEnd() {
    if (_dragOffset >= widget.refreshThreshold && !_isRefreshing) {
      _startRefresh();
    } else {
      _springBack();
    }
  }

  Future<void> _startRefresh() async {
    setState(() {
      _dragOffset = widget.refreshThreshold; // hold at threshold
      _isRefreshing = true;
    });
    try {
      // Ensure the spinner is visible long enough to feel intentional.
      await Future.wait([
        widget.onRefresh(),
        Future.delayed(widget.minRefreshDuration),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
        _springBack();
      }
    }
  }

  void _springBack() {
    _springController
      ..reset()
      ..addListener(() {
        setState(() {
          _dragOffset =
              _dragOffset *
              (1 - Curves.easeOutCubic.transform(_springController.value));
        });
      })
      ..forward().then((_) {
        if (mounted) setState(() => _dragOffset = 0);
      });
  }

  void _popIfNeeded(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return NotificationListener<OverscrollNotification>(
      // ── Scrollable children: track overscroll at the top ──
      onNotification: (notification) {
        if (_isRefreshing) return false;
        if (notification.overscroll < 0) {
          _addOffset(-notification.overscroll - _dragOffset);
          return true;
        }
        return false;
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > widget.swipeVelocityThreshold) {
            _popIfNeeded(context);
          }
        },
        onVerticalDragUpdate: (details) => _addOffset(details.delta.dy),
        onVerticalDragEnd: (_) => _onDragEnd(),
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: widget.child,
            ),
            if (_dragOffset > 0)
              Positioned(
                top: (_dragOffset / 2).clamp(8.0, 36.0) - 16,
                left: 0,
                right: 0,
                child: Center(
                  child: _isRefreshing
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: primary,
                          ),
                        )
                      : Transform.scale(
                          scale: _progress,
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 24,
                            color: primary.withAlpha((180 * _progress).round()),
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

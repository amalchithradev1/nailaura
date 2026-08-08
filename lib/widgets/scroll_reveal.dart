import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double yOffset;
  final bool animateOnce;
  final Curve curve;

  const ScrollReveal({
    Key? key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.yOffset = 50.0,
    this.animateOnce = true,
    this.curve = Curves.easeOutQuart,
  }) : super(key: key);

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _isVisible = false;
  bool _hasAnimated = false;
  late final Key _key;

  @override
  void initState() {
    super.initState();
    _key = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (VisibilityInfo info) {
        if (!mounted) return;
        
        // Trigger animation when at least 15% visible
        if (info.visibleFraction > 0.15) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
              _hasAnimated = true;
            });
          }
        } else if (info.visibleFraction == 0.0 && !widget.animateOnce) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
      },
      child: widget.child.animate(
        target: (_isVisible || (widget.animateOnce && _hasAnimated)) ? 1 : 0,
        delay: widget.delay,
      )
      .fadeIn(
        duration: widget.duration,
        curve: widget.curve,
      )
      .slideY(
        begin: widget.yOffset / 100, // Approximate percentage for slide
        end: 0,
        duration: widget.duration,
        curve: widget.curve,
      ),
    );
  }
}

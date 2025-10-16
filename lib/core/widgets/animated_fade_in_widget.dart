import 'package:flutter/material.dart';

class AnimatedFadeInWidget extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Curve curve;

  const AnimatedFadeInWidget({
    super.key,
    required this.duration,
    required this.child,
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedFadeInWidget> createState() => _AnimatedFadeInWidgetState();
}

class _AnimatedFadeInWidgetState extends State<AnimatedFadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    // Iniciar la animación automáticamente
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}


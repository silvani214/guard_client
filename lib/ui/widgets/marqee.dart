import 'package:flutter/material.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class Marquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double velocity; // pixels per second

  Marquee({
    required this.text,
    required this.style,
    this.velocity = 50.0, // default velocity
  });

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAnimation();
      }
    });
  }

  void _startAnimation() {
    // Ensure the ScrollController is attached to a scroll view
    if (!_scrollController.hasClients) {
      return; // Do nothing if not attached
    }

    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double viewportWidth = _scrollController.position.viewportDimension;
    double totalWidth = maxScrollExtent + viewportWidth;

    double durationSeconds = totalWidth / widget.velocity;

    _animationController.duration = Duration(seconds: durationSeconds.toInt());

    _animationController.repeat();

    _scrollController
        .animateTo(
      _scrollController.position.maxScrollExtent,
      duration: _animationController.duration!,
      curve: Curves.linear,
    )
        .then((_) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      if (mounted) {
        _startAnimation();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, // Set a specific height for the Marquee widget
      child: FadingEdgeScrollView.fromScrollView(
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(widget.text, style: widget.style),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(widget.text, style: widget.style),
            ),
          ],
        ),
      ),
    );
  }
}

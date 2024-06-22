import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GifView.asset(
      'assets/spinner.gif',
      height: 40,
      frameRate: 30,
      color: const Color.fromARGB(255, 18, 64, 137),
    ));
  }
}

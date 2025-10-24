import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color? backgroundColor;
  final double size;
  final Color indicatorColor;
  final bool fullscreen;

  const Loading({
    super.key,
    this.backgroundColor = Colors.black54,
    this.size = 50,
    this.indicatorColor = Colors.white,
    this.fullscreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: indicatorColor),
      ),
    );

    if (fullscreen) {
      return Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: backgroundColor,
              child: indicator,
            ),
          ),
        ],
      );
    } else {
      return indicator;
    }
  }
}
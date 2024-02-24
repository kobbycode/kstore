import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double padding;
  final double? radius;
  final Color? color;
  final Widget? child;
  final EdgeInsets? margin;
  const CircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.padding = 0,
    this.color = Colors.white,
    this.child,
    this.radius = 400,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: color,
      ),
      child: child,
    );
  }
}

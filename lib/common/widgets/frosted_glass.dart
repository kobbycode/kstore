import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    Key? key,
    required this.theWidth,
    required this.theHeight,
    required this.gradientColors,
    required this.borderColor,
    this.child,
  }) : super(key: key);

  final double theWidth;
  final double theHeight;
  final List<Color> gradientColors;
  final Color borderColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: theWidth,
        height: theHeight,
        color: Colors.transparent,
        child: Stack(
          children: [
            //blur effect ==> the third layer of stack
            BackdropFilter(
              filter: ImageFilter.blur(
                //sigmaX is the Horizontal blur
                sigmaX: 4.0,
                //sigmaY is the Vertical blur
                sigmaY: 4.0,
              ),
              child: Container(),
            ),
            //gradient effect ==> the second layer of stack
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: borderColor.withOpacity(0.3)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    //begin color
                    gradientColors[0].withOpacity(0.15),
                    //end color
                    gradientColors[1].withOpacity(0.2),
                  ],
                ),
              ),
            ),
            //child ==> the first/top layer of stack
            Center(child: child),
          ],
        ),
      ),
    );
  }
}

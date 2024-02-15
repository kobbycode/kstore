import 'package:flutter/material.dart';

class CustomCurvedEdge extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    var firstPoint = Offset(0, size.height - 20);
    var secondPoint = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstPoint.dx,
      firstPoint.dy,
      secondPoint.dx,
      secondPoint.dy,
    );

    var secondFirstPoint = Offset(0, size.height - 20);
    var secondLastPoint = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      secondFirstPoint.dx,
      secondFirstPoint.dy,
      secondLastPoint.dx,
      secondLastPoint.dy,
    );

    var thirdFirstPoint = Offset(size.width, size.height - 20);
    var thirdLastPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
      thirdFirstPoint.dx,
      thirdFirstPoint.dy,
      thirdLastPoint.dx,
      thirdLastPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

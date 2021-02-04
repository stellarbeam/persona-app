import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  final double curvedDistance;
  final double paddingDistance;

  CurveClipper({
    this.curvedDistance = 80.0,
    this.paddingDistance = 120.0,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); // leftBottom
    path.lineTo(size.width, size.height); // rightBottom
    path.lineTo(size.width, 0); // rightTop

    // Curve from rightTop ->comeDown->turnLeft->moveLeft->turnDown
    path.lineTo(size.width, paddingDistance);
    path.quadraticBezierTo(size.width, curvedDistance + paddingDistance,
        size.width - curvedDistance, curvedDistance + paddingDistance);
    path.lineTo(curvedDistance, curvedDistance + paddingDistance);
    path.quadraticBezierTo(0, curvedDistance + paddingDistance, 0,
        2 * curvedDistance + paddingDistance);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

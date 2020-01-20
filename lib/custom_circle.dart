import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends CustomPainter{
  double currentProgress;
  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Color.fromRGBO(0, 0, 0, 0.1)
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 9
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;
    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 15;
    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle
    double angle = 2 * pi * (currentProgress/60);
    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }


}
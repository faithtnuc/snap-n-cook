import 'dart:math';

class CenterPoint{

  CenterPoint({required this.left, required this.top, required this.width, required this.height});
  final double left, top, width, height;

  Point<double> get centerPoint => Point<double>(
    left + width / 2,
    top + height / 2,
  );


}
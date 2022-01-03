import 'package:flutter/material.dart';

/// Model class to hold the bar chart data.
class BarChartData {
  String x;
  double y;
  Color barColor;

  BarChartData({
    required this.x,
    required this.y,
    this.barColor = Colors.grey,
  });
}

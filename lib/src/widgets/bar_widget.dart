import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../painters/bar_chart_painter.dart';

/// Bar Widget that paint bar chart using custom painter
class BarChartWidget extends StatefulWidget {
  const BarChartWidget({
    required this.minHeight,
    required this.maxHeight,
    required this.barValues,
    required this.isScrolling,
    this.yAxisIntervalCount = 5,
    this.xAxisTextRotationAngle = 0.0,
    Key? key,
  }) : super(key: key);

  final double minHeight;
  final double maxHeight;
  final List<BarChartData> barValues;
  final bool isScrolling;
  final int yAxisIntervalCount;
  final double xAxisTextRotationAngle;

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: AnimatedContainer(
          padding: EdgeInsets.all(widget.isScrolling ? 40.0 : 0.0),
          duration: const Duration(milliseconds: 500),
          child: CustomPaint(
            painter: BarChartPainter(
              minHeight: widget.minHeight,
              barValues: widget.barValues,
              isScrolling: widget.isScrolling,
              yAxisIntervalCount: (widget.yAxisIntervalCount <= 0)
                  ? 1
                  : widget.yAxisIntervalCount,
              xAxisTextRotationAngle: widget.xAxisTextRotationAngle,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}

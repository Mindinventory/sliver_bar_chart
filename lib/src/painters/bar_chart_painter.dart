import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/chart_data.dart';

/// Custom Painter Used to Draw Bar Chart
class BarChartPainter extends CustomPainter {
  /// Values
  final List<BarChartData> barValues;
  final int yAxisIntervalCount;
  final bool isScrolling;
  late final double _maxValue;
  double _sumOfValues = 0.0;

  /// Height
  late final double _doubleMinHeight;
  final double minHeight;

  /// Width
  double _lastWidth = 0;
  late final double _barWidth;
  late final double _halfBarWidth;
  late final double _availableWidth;
  final List<double> _projectedBarWidth = [];
  final List<double> _yAxisIntervalsText = [];
  late final double xAxisTextRotationAngle;

  /// Margin
  final double _margin = 5;
  late final double _totalMargin;

  /// Bar Painters
  final Paint _barPaint = Paint()..style = PaintingStyle.stroke;
  final Paint _barAxisPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..color = Colors.black;

  /// Text Painters
  final TextPainter _xAxisTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  final TextPainter _yAxisTextPainter = TextPainter(
    textDirection: TextDirection.rtl,
  );

  BarChartPainter({
    required this.minHeight,
    required this.barValues,
    required this.isScrolling,
    required this.yAxisIntervalCount,
    required this.xAxisTextRotationAngle,
  }) {
    /// Calculate total margin we need to add around and between bars
    _totalMargin = (_margin * (barValues.length + 1));

    /// Double of minimum height, which we use to start animation.
    _doubleMinHeight = minHeight * 2;

    /// Find max bar value
    _maxValue = barValues
        .reduce((currentData, nextData) =>
            currentData.y > nextData.y ? currentData : nextData)
        .y;

    /// Find total of values
    for (var barValue in barValues) {
      _sumOfValues += barValue.y;
    }

    final List<double> tempTexts = [];

    /// Setting Up Y axis text intervals
    for (var i = 0; i < yAxisIntervalCount; i++) {
      tempTexts.add(((_maxValue / yAxisIntervalCount) * i));
    }
    tempTexts.add(_maxValue);
    _yAxisIntervalsText.clear();
    _yAxisIntervalsText.addAll(tempTexts.reversed.toList());
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// if width of the view is changed then and then only recalculate this.
    if (size.width != _lastWidth) {
      /// find standard bar width
      _barWidth = (size.width - _totalMargin) / barValues.length;

      /// find half bar height
      _halfBarWidth = _barWidth / 2;

      /// calculate projected bar width
      _availableWidth = size.width - _totalMargin;

      /// calculate projected bar width when our view is fully collapsed
      for (var barValue in barValues) {
        _projectedBarWidth.add((barValue.y * _availableWidth) / _sumOfValues);
      }

      _lastWidth = size.width;
    }

    final List<double> _animatedBarWidths = [];

    for (var barIndex = 0; barIndex < barValues.length; barIndex++) {
      _barPaint.color = barValues[barIndex].barColor;

      /// Check here height if height less then double of minimum height,
      /// if so do some different rendering
      if (size.height <= _doubleMinHeight) {
        /// calc fraction between min height and double of minimum height.(0...0.5...1)
        double fraction = 1 - ((size.height - minHeight) / minHeight);

        /// BAR HEIGHT CALC
        /// take current bar height and do transition to full height
        double barHeight = lerpDouble(
            _doubleMinHeight * barValues[barIndex].y / _maxValue,
            size.height,
            fraction)!;

        /// BAR WIDTH CALC
        double particularBarWidth =
            lerpDouble(_barWidth, _projectedBarWidth[barIndex], fraction)!;
        _barPaint.strokeWidth = particularBarWidth;

        /// BAR POSITION CALC
        double barPosition = (_margin * (barIndex + 1)) +
            (_animatedBarWidths.isNotEmpty
                ? _animatedBarWidths.reduce((currentBarWidth, nextBarWidth) =>
                    currentBarWidth + nextBarWidth)
                : 0) +
            (particularBarWidth / 2);

        _animatedBarWidths.add(particularBarWidth);

        canvas.drawLine(
          Offset(barPosition, size.height),
          Offset(barPosition, size.height - barHeight),
          _barPaint,
        );
      } else {
        _barPaint.strokeWidth = _barWidth;
        double barPosition = _margin +
            ((_barWidth * (barIndex + 1)) - _halfBarWidth) +
            (_margin * barIndex);

        /// calculate bar height according to available height of view
        double barHeight =
            (size.height * barValues[barIndex].y / _maxValue).roundToDouble();

        /// Drawing Bar
        _barPaint.strokeWidth = _barWidth;

        canvas.drawLine(
          Offset(barPosition, size.height),
          Offset(barPosition, size.height - barHeight),
          _barPaint,
        );

        if (isScrolling) {
          /// Drawing X axis
          canvas.drawLine(
            Offset(-0.5, size.height),
            Offset(size.width, size.height),
            _barAxisPaint,
          );

          /// Drawing X axis text
          _xAxisTextPainter.text = TextSpan(
            text: barValues[barIndex].x,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
              height: 2.0,
            ),
          );

          _xAxisTextPainter.layout(
            maxWidth: size.width,
          );

          final offsetX = Offset((barPosition - (_margin * 2)), size.height);
          if (xAxisTextRotationAngle != 0.0) {
            canvas.save();
            canvas.translate(offsetX.dx, offsetX.dy);
            canvas.rotate(xAxisTextRotationAngle / 360.0);
            _xAxisTextPainter.paint(canvas, Offset(_margin * 2, 0.0));
            canvas.restore();
          } else {
            _xAxisTextPainter.paint(canvas, offsetX);
          }

          /// Drawing Y axis
          canvas.drawLine(
            Offset(0, size.height),
            const Offset(0, -0.5),
            _barAxisPaint,
          );

          /// Drawing Y axis text based on interval count
          for (var textIndex = 0;
              textIndex <= yAxisIntervalCount;
              textIndex++) {
            double yAxisInterval =
                (size.height / yAxisIntervalCount * textIndex);

            _yAxisTextPainter.text = TextSpan(
              text: _yAxisIntervalsText[textIndex].toInt().toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10.0,
                height: 2.0,
              ),
            );

            _yAxisTextPainter.layout(
              maxWidth: size.width,
            );

            final offsetY = Offset(-30, yAxisInterval);
            _yAxisTextPainter.paint(canvas, offsetY);
          }
        }
      }
    }
  }

  /// Calculating percentage for width calculate
  getBarWidthPercentage(totalSum, double perticularGraphvalue) {
    return (100 * perticularGraphvalue) / totalSum;
  }

  /// Managing Height values 160 to 80
  manageHeight(double perticularGraphvalue, double height) {
    return (height / perticularGraphvalue) + (height - (height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

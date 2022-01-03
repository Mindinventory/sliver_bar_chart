import 'package:flutter/material.dart';

/// Delegate for the sliver component.
class CustomSliverComponentDelegate extends SliverPersistentHeaderDelegate {
  final Widget childWidget;
  final double? minHeight;
  final bool? scrolling;
  final double? maxHeight;
  final double? maxWidth;
  final List heightArray;

  CustomSliverComponentDelegate({
    required this.heightArray,
    required this.childWidget,
    this.minHeight,
    this.scrolling,
    this.maxHeight,
    this.maxWidth,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return childWidget;
  }

  @override
  double get maxExtent => maxHeight ?? 0.0;

  @override
  double get minExtent => minHeight ?? 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

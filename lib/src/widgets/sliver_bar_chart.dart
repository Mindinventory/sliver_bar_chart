import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'bar_widget.dart';
import 'custom_sliver_component.dart';

/// A sliver whose size varies when the sliver is scrolled to the edge
/// of the viewport opposite the sliver's [GrowthDirection].
///
/// In the normal case of a [CustomScrollView] with no centered sliver, this
/// sliver will vary its size when scrolled to the leading edge of the viewport.
///
/// This is the layout primitive that [SliverAppBar] uses for its
/// shrinking/growing effect.
class SliverBarChart extends StatefulWidget {
  /// Creates a sliver that varies its size when it is scrolled to the start of
  /// a viewport.
  ///
  /// The [delegate], [restrain], and [fluctuating] arguments must not be null.
  const SliverBarChart({
    Key? key,
    this.restrain = false,
    this.scrolling,
    this.heightArray = const [50.0, 78.0, 90.0, 67.0, 36.0],
    this.maxWidth = 75.0,
    this.minHeight = 30.0,
    this.maxHeight = 175.0,
    this.fluctuating = false,
    required this.barWidget,
  }) : super(key: key);

  /// Configuration for the sliver's layout.
  ///
  /// The delegate provides the following information:
  ///
  ///  * The minimum and maximum dimensions of the sliver.
  ///
  ///  * The builder for generating the widgets of the sliver.
  ///
  ///  * The instructions for snapping the scroll offset, if [fluctuating] is true.

  final double maxWidth;
  final bool? scrolling;
  final double maxHeight;
  final double minHeight;
  final List<double> heightArray;
  final BarChartWidget barWidget;

  /// Whether to stick the header to the start of the viewport once it has
  /// reached its minimum size.
  ///
  /// If this is false, the header will continue scrolling off the screen after
  /// it has shrunk to its minimum extent.
  final bool restrain;

  /// Whether the header should immediately grow again if the user reverses
  /// scroll direction.
  ///
  /// If this is false, the header only grows again once the user reaches the
  /// part of the viewport that contains the sliver.
  ///
  /// The [delegate]'s [CustomSliverComponentDelegate.snapConfiguration] is
  /// ignored unless [fluctuating] is true.
  final bool fluctuating;

  @override
  _SliverBarChartState createState() => _SliverBarChartState();
}

class _SliverBarChartState extends State<SliverBarChart> {
  late CustomSliverComponentDelegate delegate;

  @override
  Widget build(BuildContext context) {
    delegate = CustomSliverComponentDelegate(
      childWidget: widget.barWidget,
      minHeight: widget.minHeight,
      scrolling: widget.scrolling,
      maxHeight: widget.maxHeight,
      maxWidth: widget.maxWidth,
      heightArray: widget.heightArray,
    );

    if (widget.fluctuating && widget.restrain) {
      return _SliverFloatingRestrainPersistentHeader(delegate: delegate);
    }
    if (widget.restrain) {
      return _SliverRestrainPersistentHeader(delegate: delegate);
    }
    if (widget.fluctuating) {
      return _SliverFluctuatingPersistentHeader(delegate: delegate);
    }
    return _SliverScrollingPersistentHeader(delegate: delegate);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<CustomSliverComponentDelegate>(
        'delegate',
        delegate,
      ),
    );
    final List<String> flags = <String>[
      if (widget.restrain) 'restrain',
      if (widget.fluctuating) 'floating',
    ];
    if (flags.isEmpty) flags.add('normal');
    properties.add(IterableProperty<String>('mode', flags));
  }
}

class _SliverPersistentHeaderElement extends RenderObjectElement {
  _SliverPersistentHeaderElement(
    _SliverPersistentHeaderRenderObjectWidget widget,
  ) : super(widget);

  @override
  _SliverPersistentHeaderRenderObjectWidget get widget =>
      super.widget as _SliverPersistentHeaderRenderObjectWidget;

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin get renderObject =>
      super.renderObject as _RenderSliverPersistentHeaderForWidgetsMixin;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._element = this;
  }

  @override
  void unmount() {
    super.unmount();
    renderObject._element = null;
  }

  @override
  void update(_SliverPersistentHeaderRenderObjectWidget newWidget) {
    final _SliverPersistentHeaderRenderObjectWidget oldWidget = widget;
    super.update(newWidget);
    final CustomSliverComponentDelegate newDelegate = newWidget.delegate;
    final CustomSliverComponentDelegate oldDelegate = oldWidget.delegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType ||
            newDelegate.shouldRebuild(oldDelegate))) {
      renderObject.triggerRebuild();
    }
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element? child;

  void _build(double shrinkOffset, bool overlapsContent) {
    owner!.buildScope(this, () {
      child = updateChild(
        child,
        widget.delegate.build(
          this,
          shrinkOffset,
          overlapsContent,
        ),
        null,
      );
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(covariant RenderBox child, Object? slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
  }

  @override
  void moveRenderObjectChild(
      covariant RenderObject child, Object? oldSlot, Object? newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, Object? slot) {
    renderObject.child = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) visitor(child!);
  }
}

abstract class _SliverPersistentHeaderRenderObjectWidget
    extends RenderObjectWidget {
  const _SliverPersistentHeaderRenderObjectWidget({
    Key? key,
    required this.delegate,
  }) : super(key: key);

  final CustomSliverComponentDelegate delegate;

  @override
  _SliverPersistentHeaderElement createElement() =>
      _SliverPersistentHeaderElement(this);

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(
      BuildContext context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(
      DiagnosticsProperty<CustomSliverComponentDelegate>(
        'delegate',
        delegate,
      ),
    );
  }
}

mixin _RenderSliverPersistentHeaderForWidgetsMixin
    on RenderSliverPersistentHeader {
  _SliverPersistentHeaderElement? _element;

  @override
  double get minExtent => _element!.widget.delegate.minExtent;

  @override
  double get maxExtent => _element!.widget.delegate.maxExtent;

  @override
  void updateChild(double shrinkOffset, bool overlapsContent) {
    assert(_element != null);
    _element!._build(shrinkOffset, overlapsContent);
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}

class _SliverScrollingPersistentHeader
    extends _SliverPersistentHeaderRenderObjectWidget {
  const _SliverScrollingPersistentHeader({
    Key? key,
    required CustomSliverComponentDelegate delegate,
  }) : super(
          key: key,
          delegate: delegate,
        );

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(
      BuildContext context) {
    return _RenderSliverScrollingPersistentHeaderForWidgets(
      stretchConfiguration: delegate.stretchConfiguration,
    );
  }
}

class _RenderSliverScrollingPersistentHeaderForWidgets
    extends RenderSliverScrollingPersistentHeader
    with _RenderSliverPersistentHeaderForWidgetsMixin {
  _RenderSliverScrollingPersistentHeaderForWidgets({
    RenderBox? child,
    OverScrollHeaderStretchConfiguration? stretchConfiguration,
  }) : super(
          child: child,
          stretchConfiguration: stretchConfiguration,
        );
}

class _SliverRestrainPersistentHeader
    extends _SliverPersistentHeaderRenderObjectWidget {
  const _SliverRestrainPersistentHeader({
    Key? key,
    required CustomSliverComponentDelegate delegate,
  }) : super(
          key: key,
          delegate: delegate,
        );

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(
      BuildContext context) {
    return _RenderSliverPinnedPersistentHeaderForWidgets(
      stretchConfiguration: delegate.stretchConfiguration,
      showOnScreenConfiguration: delegate.showOnScreenConfiguration,
    );
  }
}

class _RenderSliverPinnedPersistentHeaderForWidgets
    extends RenderSliverPinnedPersistentHeader
    with _RenderSliverPersistentHeaderForWidgetsMixin {
  _RenderSliverPinnedPersistentHeaderForWidgets({
    RenderBox? child,
    OverScrollHeaderStretchConfiguration? stretchConfiguration,
    PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration,
  }) : super(
          child: child,
          stretchConfiguration: stretchConfiguration,
          showOnScreenConfiguration: showOnScreenConfiguration,
        );
}

class _SliverFluctuatingPersistentHeader
    extends _SliverPersistentHeaderRenderObjectWidget {
  const _SliverFluctuatingPersistentHeader({
    Key? key,
    required CustomSliverComponentDelegate delegate,
  }) : super(
          key: key,
          delegate: delegate,
        );

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(
      BuildContext context) {
    return _RenderSliverFloatingPersistentHeaderForWidgets(
      vsync: delegate.vsync,
      snapConfiguration: delegate.snapConfiguration,
      stretchConfiguration: delegate.stretchConfiguration,
      showOnScreenConfiguration: delegate.showOnScreenConfiguration,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      _RenderSliverFloatingPersistentHeaderForWidgets renderObject) {
    renderObject.vsync = delegate.vsync;
    renderObject.snapConfiguration = delegate.snapConfiguration;
    renderObject.stretchConfiguration = delegate.stretchConfiguration;
    renderObject.showOnScreenConfiguration = delegate.showOnScreenConfiguration;
  }
}

class _RenderSliverFloatingPinnedPersistentHeaderForWidgets
    extends RenderSliverFloatingPinnedPersistentHeader
    with _RenderSliverPersistentHeaderForWidgetsMixin {
  _RenderSliverFloatingPinnedPersistentHeaderForWidgets({
    RenderBox? child,
    required TickerProvider? vsync,
    FloatingHeaderSnapConfiguration? snapConfiguration,
    OverScrollHeaderStretchConfiguration? stretchConfiguration,
    PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration,
  }) : super(
          child: child,
          vsync: vsync,
          snapConfiguration: snapConfiguration,
          stretchConfiguration: stretchConfiguration,
          showOnScreenConfiguration: showOnScreenConfiguration,
        );
}

class _SliverFloatingRestrainPersistentHeader
    extends _SliverPersistentHeaderRenderObjectWidget {
  const _SliverFloatingRestrainPersistentHeader({
    Key? key,
    required CustomSliverComponentDelegate delegate,
  }) : super(
          key: key,
          delegate: delegate,
        );

  @override
  _RenderSliverPersistentHeaderForWidgetsMixin createRenderObject(
      BuildContext context) {
    return _RenderSliverFloatingPinnedPersistentHeaderForWidgets(
      vsync: delegate.vsync,
      snapConfiguration: delegate.snapConfiguration,
      stretchConfiguration: delegate.stretchConfiguration,
      showOnScreenConfiguration: delegate.showOnScreenConfiguration,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      _RenderSliverFloatingPinnedPersistentHeaderForWidgets renderObject) {
    renderObject.vsync = delegate.vsync;
    renderObject.snapConfiguration = delegate.snapConfiguration;
    renderObject.stretchConfiguration = delegate.stretchConfiguration;
    renderObject.showOnScreenConfiguration = delegate.showOnScreenConfiguration;
  }
}

class _RenderSliverFloatingPersistentHeaderForWidgets
    extends RenderSliverFloatingPersistentHeader
    with _RenderSliverPersistentHeaderForWidgetsMixin {
  _RenderSliverFloatingPersistentHeaderForWidgets({
    RenderBox? child,
    required TickerProvider? vsync,
    FloatingHeaderSnapConfiguration? snapConfiguration,
    OverScrollHeaderStretchConfiguration? stretchConfiguration,
    PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration,
  }) : super(
          child: child,
          vsync: vsync,
          snapConfiguration: snapConfiguration,
          stretchConfiguration: stretchConfiguration,
          showOnScreenConfiguration: showOnScreenConfiguration,
        );
}

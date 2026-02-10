import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Defines widgets which are to be used as rating bar items.
class RatingWidget {
  /// Creates [RatingWidget] with the given [full], [half] and [empty] widgets.
  const RatingWidget({
    required this.full,
    required this.half,
    required this.empty,
  });

  /// Defines widget to be used as rating bar item when completely rated.
  final Widget full;

  /// Defines widget to be used as rating bar item when only half is rated.
  final Widget half;

  /// Defines widget to be used as rating bar item when unrated.
  final Widget empty;
}

/// A widget to receive rating input from users.
///
/// [RatingBar] can also be used to display rating.
/// Prefer using [RatingBarIndicator] for read-only display with fractional values.
class RatingBar extends StatefulWidget {
  /// Creates [RatingBar] using the [ratingWidget].
  const RatingBar({
    super.key,
    required RatingWidget ratingWidget,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
  })  : _itemBuilder = null,
        _ratingWidget = ratingWidget;

  /// Creates a read-only [RatingBar] for display only (no user interaction).
  ///
  /// Matches the API of `custom_rating_bar` package for easy migration.
  factory RatingBar.readOnly({
    Key? key,
    required IconData filledIcon,
    required IconData emptyIcon,
    double initialRating = 0.0,
    int maxRating = 5,
    IconData? halfFilledIcon,
    bool isHalfAllowed = false,
    Color filledColor = Colors.amber,
    Color emptyColor = Colors.grey,
    Color halfFilledColor = Colors.amber,
    double size = 32.0,
  }) {
    return RatingBar(
      key: key,
      ratingWidget: RatingWidget(
        full: Icon(filledIcon, color: filledColor),
        half: Icon(halfFilledIcon ?? filledIcon, color: halfFilledColor),
        empty: Icon(emptyIcon, color: emptyColor),
      ),
      onRatingUpdate: (_) {},
      ignoreGestures: true,
      initialRating: initialRating,
      itemCount: maxRating,
      itemSize: size,
      allowHalfRating: isHalfAllowed,
    );
  }

  /// Creates [RatingBar] using the [itemBuilder].
  const RatingBar.builder({
    super.key,
    required IndexedWidgetBuilder itemBuilder,
    required this.onRatingUpdate,
    this.glowColor,
    this.maxRating,
    this.textDirection,
    this.unratedColor,
    this.allowHalfRating = false,
    this.direction = Axis.horizontal,
    this.glow = true,
    this.glowRadius = 2,
    this.ignoreGestures = false,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.minRating = 0,
    this.tapOnlyMode = false,
    this.updateOnDrag = false,
    this.wrapAlignment = WrapAlignment.start,
  })  : _itemBuilder = itemBuilder,
        _ratingWidget = null;

  /// Return current rating whenever rating is updated.
  final ValueChanged<double> onRatingUpdate;

  /// Defines color for glow. Default is [ColorScheme.secondary].
  final Color? glowColor;

  /// Sets maximum rating. Default is [itemCount].
  final double? maxRating;

  /// The text direction. RTL if [TextDirection.rtl].
  final TextDirection? textDirection;

  /// Defines color for the unrated portion. Default is [ThemeData.disabledColor].
  final Color? unratedColor;

  /// Enables half rating support when true.
  final bool allowHalfRating;

  /// Direction of rating bar. Default is [Axis.horizontal].
  final Axis direction;

  /// If true, rating bar item will glow when touched.
  final bool glow;

  /// Defines the radius of glow.
  final double glowRadius;

  /// If true, disables any gestures over the rating bar.
  final bool ignoreGestures;

  /// Initial rating value.
  final double initialRating;

  /// Total number of rating bar items.
  final int itemCount;

  /// The amount of space by which to inset each rating item.
  final EdgeInsetsGeometry itemPadding;

  /// Width and height of each rating item.
  final double itemSize;

  /// Minimum rating value.
  final double minRating;

  /// If true, disables drag to rate. Also disables half rating.
  final bool tapOnlyMode;

  /// If true, [onRatingUpdate] is called while dragging.
  final bool updateOnDrag;

  /// How items should be placed in the main axis.
  final WrapAlignment wrapAlignment;

  final IndexedWidgetBuilder? _itemBuilder;
  final RatingWidget? _ratingWidget;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0;
  bool _isRTL = false;
  double iconRating = 0;

  late double _minRating;
  late double _maxRating;
  late final ValueNotifier<bool> _glow;

  @override
  void initState() {
    super.initState();
    _glow = ValueNotifier(false);
    _minRating = widget.minRating;
    _maxRating = widget.maxRating ?? widget.itemCount.toDouble();
    _rating = widget.initialRating;
  }

  @override
  void didUpdateWidget(RatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating;
    }
    _minRating = widget.minRating;
    _maxRating = widget.maxRating ?? widget.itemCount.toDouble();
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ?? Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    iconRating = 0.0;

    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: widget.wrapAlignment,
        textDirection: textDirection,
        direction: widget.direction,
        children: List.generate(
          widget.itemCount,
          (index) => _buildRating(context, index),
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context, int index) {
    final ratingWidget = widget._ratingWidget;
    final item = widget._itemBuilder?.call(context, index);
    final ratingOffset = widget.allowHalfRating ? 0.5 : 1.0;

    Widget resolvedRatingWidget;

    if (index >= _rating) {
      resolvedRatingWidget = _NoRatingWidget(
        size: widget.itemSize,
        enableMask: ratingWidget == null,
        unratedColor: widget.unratedColor ?? Theme.of(context).disabledColor,
        child: ratingWidget?.empty ?? item!,
      );
    } else if (index >= _rating - ratingOffset && widget.allowHalfRating) {
      if (ratingWidget?.half == null) {
        resolvedRatingWidget = _HalfRatingWidget(
          size: widget.itemSize,
          enableMask: ratingWidget == null,
          rtlMode: _isRTL,
          unratedColor: widget.unratedColor ?? Theme.of(context).disabledColor,
          child: item!,
        );
      } else {
        resolvedRatingWidget = SizedBox(
          width: widget.itemSize,
          height: widget.itemSize,
          child: FittedBox(
            child: _isRTL
                ? Transform(
                    transform: Matrix4.identity()..scale(-1.0, 1, 1),
                    alignment: Alignment.center,
                    transformHitTests: false,
                    child: ratingWidget!.half,
                  )
                : ratingWidget!.half,
          ),
        );
      }
      iconRating += 0.5;
    } else {
      resolvedRatingWidget = SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: FittedBox(
          child: ratingWidget?.full ?? item,
        ),
      );
      iconRating += 1.0;
    }

    return IgnorePointer(
      ignoring: widget.ignoreGestures,
      child: GestureDetector(
        onTapDown: (details) {
          double value;
          if (index == 0 && (_rating == 1 || _rating == 0.5)) {
            value = 0;
          } else {
            final tappedPosition = details.localPosition.dx;
            final tappedOnFirstHalf = tappedPosition <= widget.itemSize / 2;
            value = index +
                (tappedOnFirstHalf && widget.allowHalfRating ? 0.5 : 1.0);
          }

          value = math.max(value, widget.minRating);
          widget.onRatingUpdate(value);
          _rating = value;
          setState(() {});
        },
        onHorizontalDragStart: _isHorizontal ? _onDragStart : null,
        onHorizontalDragEnd: _isHorizontal ? _onDragEnd : null,
        onHorizontalDragUpdate: _isHorizontal ? _onDragUpdate : null,
        onVerticalDragStart: _isHorizontal ? null : _onDragStart,
        onVerticalDragEnd: _isHorizontal ? null : _onDragEnd,
        onVerticalDragUpdate: _isHorizontal ? null : _onDragUpdate,
        child: Padding(
          padding: widget.itemPadding,
          child: ValueListenableBuilder<bool>(
            valueListenable: _glow,
            builder: (context, glow, child) {
              if (glow && widget.glow) {
                final glowColor =
                    widget.glowColor ?? Theme.of(context).colorScheme.secondary;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withAlpha(30),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                      BoxShadow(
                        color: glowColor.withAlpha(20),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                    ],
                  ),
                  child: child,
                );
              }
              return child!;
            },
            child: resolvedRatingWidget,
          ),
        ),
      ),
    );
  }

  bool get _isHorizontal => widget.direction == Axis.horizontal;

  void _onDragUpdate(DragUpdateDetails dragDetails) {
    if (!widget.tapOnlyMode) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;

      final pos = box.globalToLocal(dragDetails.globalPosition);
      double i;
      if (widget.direction == Axis.horizontal) {
        i = pos.dx / (widget.itemSize + widget.itemPadding.horizontal);
      } else {
        i = pos.dy / (widget.itemSize + widget.itemPadding.vertical);
      }
      var currentRating = widget.allowHalfRating ? i : i.round().toDouble();
      if (currentRating > widget.itemCount) {
        currentRating = widget.itemCount.toDouble();
      }
      if (currentRating < 0) {
        currentRating = 0.0;
      }
      if (_isRTL && widget.direction == Axis.horizontal) {
        currentRating = widget.itemCount - currentRating;
      }

      _rating = currentRating.clamp(_minRating, _maxRating);
      if (widget.updateOnDrag) widget.onRatingUpdate(iconRating);
      setState(() {});
    }
  }

  void _onDragStart(DragStartDetails details) {
    _glow.value = true;
  }

  void _onDragEnd(DragEndDetails details) {
    _glow.value = false;
    widget.onRatingUpdate(iconRating);
    iconRating = 0.0;
  }
}

/// A read-only widget to display rating.
///
/// Use [RatingBar] for interactive rating input.
class RatingBarIndicator extends StatefulWidget {
  /// Creates a read-only rating bar indicator.
  const RatingBarIndicator({
    super.key,
    required this.itemBuilder,
    this.textDirection,
    this.unratedColor,
    this.direction = Axis.horizontal,
    this.itemCount = 5,
    this.itemPadding = EdgeInsets.zero,
    this.itemSize = 40.0,
    this.physics = const NeverScrollableScrollPhysics(),
    this.rating = 0.0,
  });

  /// Widget for each rating bar item.
  final IndexedWidgetBuilder itemBuilder;

  /// The text direction.
  final TextDirection? textDirection;

  /// Color for the unrated portion.
  final Color? unratedColor;

  /// Direction of rating bar.
  final Axis direction;

  /// Total number of rating bar items.
  final int itemCount;

  /// The amount of space by which to inset each rating item.
  final EdgeInsets itemPadding;

  /// Width and height of each rating item.
  final double itemSize;

  /// Controls scrolling behaviour. Default is [NeverScrollableScrollPhysics].
  final ScrollPhysics physics;

  /// The rating value to display.
  final double rating;

  @override
  State<RatingBarIndicator> createState() => _RatingBarIndicatorState();
}

class _RatingBarIndicatorState extends State<RatingBarIndicator> {
  double _ratingFraction = 0;
  int _ratingNumber = 0;
  bool _isRTL = false;

  @override
  Widget build(BuildContext context) {
    final textDirection = widget.textDirection ?? Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = widget.rating - _ratingNumber + 1;

    return SingleChildScrollView(
      scrollDirection: widget.direction,
      physics: widget.physics,
      child: widget.direction == Axis.horizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: textDirection,
              children: _children(context),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: textDirection,
              children: _children(context),
            ),
    );
  }

  List<Widget> _children(BuildContext context) {
    return List.generate(
      widget.itemCount,
      (index) {
        if (widget.textDirection != null &&
            widget.textDirection == TextDirection.rtl &&
            Directionality.of(context) != TextDirection.rtl) {
          return Transform(
            transform: Matrix4.identity()..scale(-1.0, 1, 1),
            alignment: Alignment.center,
            transformHitTests: false,
            child: _buildItems(context, index),
          );
        }
        return _buildItems(context, index);
      },
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    return Padding(
      padding: widget.itemPadding,
      child: SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              child: index + 1 < _ratingNumber
                  ? widget.itemBuilder(context, index)
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        widget.unratedColor ?? Theme.of(context).disabledColor,
                        BlendMode.srcIn,
                      ),
                      child: widget.itemBuilder(context, index),
                    ),
            ),
            if (index + 1 == _ratingNumber)
              FittedBox(
                child: ClipRect(
                  clipper: _IndicatorClipper(
                    ratingFraction: _ratingFraction,
                    rtlMode: _isRTL,
                  ),
                  child: widget.itemBuilder(context, index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IndicatorClipper extends CustomClipper<Rect> {
  _IndicatorClipper({
    required this.ratingFraction,
    this.rtlMode = false,
  });

  final double ratingFraction;
  final bool rtlMode;

  @override
  Rect getClip(Size size) {
    return rtlMode
        ? Rect.fromLTRB(
            size.width - size.width * ratingFraction,
            0,
            size.width,
            size.height,
          )
        : Rect.fromLTRB(
            0,
            0,
            size.width * ratingFraction,
            size.height,
          );
  }

  @override
  bool shouldReclip(_IndicatorClipper oldClipper) {
    return ratingFraction != oldClipper.ratingFraction ||
        rtlMode != oldClipper.rtlMode;
  }
}

class _HalfRatingWidget extends StatelessWidget {
  const _HalfRatingWidget({
    required this.size,
    required this.child,
    required this.enableMask,
    required this.rtlMode,
    required this.unratedColor,
  });

  final Widget child;
  final double size;
  final bool enableMask;
  final bool rtlMode;
  final Color unratedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: enableMask
          ? Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  child: _NoRatingWidget(
                    size: size,
                    unratedColor: unratedColor,
                    enableMask: enableMask,
                    child: child,
                  ),
                ),
                FittedBox(
                  child: ClipRect(
                    clipper: _HalfClipper(rtlMode: rtlMode),
                    child: child,
                  ),
                ),
              ],
            )
          : FittedBox(
              child: child,
            ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  _HalfClipper({required this.rtlMode});

  final bool rtlMode;

  @override
  Rect getClip(Size size) => rtlMode
      ? Rect.fromLTRB(
          size.width / 2,
          0,
          size.width,
          size.height,
        )
      : Rect.fromLTRB(
          0,
          0,
          size.width / 2,
          size.height,
        );

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class _NoRatingWidget extends StatelessWidget {
  const _NoRatingWidget({
    required this.size,
    required this.child,
    required this.enableMask,
    required this.unratedColor,
  });

  final double size;
  final Widget child;
  final bool enableMask;
  final Color unratedColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: FittedBox(
        child: enableMask
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  unratedColor,
                  BlendMode.srcIn,
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}

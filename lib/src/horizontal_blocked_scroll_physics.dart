import 'package:flutter/material.dart';

class _HorizontalDirection {
  bool isLeft;
  _HorizontalDirection({this.isLeft = false});
}

/// This [ScrollPhysics] allows you to block the movement in the horizontal axis.
/// You can block both right and left movement.
///
/// {@tool sample}
///
/// This sample shows a [HorizontalBlockedScrollPhysics] blocking left movement
///
/// ```dart
/// HorizontalBlockedScrollPhysics(blockLeft: true, blockRight: false);
/// ```
/// {@end-tool}
class HorizontalBlockedScrollPhysics extends ScrollPhysics {
  final direction = _HorizontalDirection();
  final bool blockLeft;
  final bool blockRight;

  HorizontalBlockedScrollPhysics(
      {ScrollPhysics parent, this.blockLeft = false, this.blockRight = false})
      : super(parent: parent);

  @override
  HorizontalBlockedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return HorizontalBlockedScrollPhysics(
      parent: buildParent(ancestor),
      blockLeft: blockLeft,
      blockRight: blockRight,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    direction.isLeft = offset.sign >= 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    //print("applyBoundaryConditions");
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
            'The proposed new position, $value, is exactly equal to the current position of the '
            'given ${position.runtimeType}, ${position.pixels}.\n'
            'The applyBoundaryConditions method should only be called when the value is '
            'going to actually change the pixels, otherwise it is redundant.\n'
            'The physics object in question was:\n'
            '  $this\n'
            'The position object in question was:\n'
            '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }

    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // overscroll
      return value - position.pixels;
    }

    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      // hit top edge
      return value - position.minScrollExtent;
    }

    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // hit bottom edge
      return value - position.maxScrollExtent;
    }

    if (direction.isLeft && blockLeft) {
      // block left
      return value - position.pixels;
    } else if (!direction.isLeft && blockRight) {
      // block right
      return value + position.pixels;
    }

    return 0.0;
  }
}

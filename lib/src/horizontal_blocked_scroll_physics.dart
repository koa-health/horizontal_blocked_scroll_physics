import 'package:flutter/material.dart';

/// This [ScrollPhysics] allows you to block the movement in the horizontal axis.
/// You can block both right and left movements.
///
/// {@tool sample}
///
/// This sample shows a [HorizontalBlockedScrollPhysics] blocking left movement
///
/// ```dart
/// HorizontalBlockedScrollPhysics(blockLeftMovent: true, blockRightMovement: false);
/// ```
/// {@end-tool}
class HorizontalBlockedScrollPhysics extends ScrollPhysics {
  /// If [true] it blocks the left movement.
  final bool blockLeftMovement;

  /// If [true] it blocks the right movement.
  final bool blockRightMovement;

  const HorizontalBlockedScrollPhysics({
    ScrollPhysics parent,
    this.blockLeftMovement = false,
    this.blockRightMovement = false,
  }) : super(parent: parent);

  @override
  HorizontalBlockedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return HorizontalBlockedScrollPhysics(
      parent: buildParent(ancestor),
      blockLeftMovement: blockLeftMovement,
      blockRightMovement: blockRightMovement,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
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

    // If true, movement goes to the left. If it's a swipe, it goes to the left.
    var isMovingLeft = value > position.pixels;
    var screenIndex = (value / position.viewportDimension).floor();
    var pointInScreen = value - (screenIndex * position.viewportDimension);
    // If true, the middle point of the screen is in the left side of the screen.
    // This will be useful in order to not block some movements when in returning position.
    var isPointInScreenLeftRange =
        pointInScreen < (position.viewportDimension / 2);
    var delta = value - position.pixels;

    // We're moving left and we want to block.
    if (isMovingLeft && blockLeftMovement && isPointInScreenLeftRange) {
      if (pointInScreen.abs() < delta.abs()) {
        // fix for strong movements
        return pointInScreen;
      }
      return delta;
    }

    // We're moving right and we want to block.
    if (!isMovingLeft && blockRightMovement && !isPointInScreenLeftRange) {
      return delta;
    }

    return super.applyBoundaryConditions(position, value);
  }
}

/// This [ScrollPhysics] blocks the left movement in the horizontal axis allowing only movements to the right.
///
/// {@tool sample}
///
/// This sample shows a [LeftBlockedScrollPhysics] blocking left movement
///
/// ```dart
/// LeftBlockedScrollPhysics();
/// ```
/// {@end-tool}
class LeftBlockedScrollPhysics extends HorizontalBlockedScrollPhysics {
  const LeftBlockedScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent, blockLeftMovement: true);

  @override
  LeftBlockedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return LeftBlockedScrollPhysics(
      parent: buildParent(ancestor),
    );
  }
}

// This [ScrollPhysics] blocks the right movement in the horizontal axis allowing only movements to the left.
///
/// {@tool sample}
///
/// This sample shows a [RightBlockedScrollPhysics] blocking right movement
///
/// ```dart
/// RightBlockedScrollPhysics();
/// ```
/// {@end-tool}
class RightBlockedScrollPhysics extends HorizontalBlockedScrollPhysics {
  const RightBlockedScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent, blockRightMovement: true);

  @override
  RightBlockedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return RightBlockedScrollPhysics(
      parent: buildParent(ancestor),
    );
  }
}

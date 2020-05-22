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

  /// If [true] it allows the movement to come back to the center,
  /// even if a specific horizontal movement is blocked,
  /// whenever the original movement has not completed a viewport move.
  final bool allowRecovery;

  const HorizontalBlockedScrollPhysics({
    ScrollPhysics parent,
    this.blockLeftMovement = false,
    this.blockRightMovement = false,
    this.allowRecovery = true,
  }) : super(parent: parent);

  @override
  HorizontalBlockedScrollPhysics applyTo(ScrollPhysics ancestor) {
    return HorizontalBlockedScrollPhysics(
      parent: buildParent(ancestor),
      blockLeftMovement: blockLeftMovement,
      blockRightMovement: blockRightMovement,
      allowRecovery: allowRecovery,
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

    // We're moving left and we want to block.
    // In case [allowRecovery] is true,
    // then we only want to block left movement in case the middle point of the screen
    // has already moved before the middle of the screen. This will allow the screen to automatically
    // go to the middle point (this would be effectively moving to the left) in case the page swipe
    // has not been completed.
    if (isMovingLeft &&
        blockLeftMovement &&
        (!allowRecovery || isPointInScreenLeftRange)) {
      return pointInScreen;
    }

    // We're moving right and we want to block.
    // In case [allowRecovery] is true,
    // then we only want to block right movement in case the middle point of the screen
    // has already moved beyond the middle of the screen. This will allow the screen to automatically
    // go to the middle point (this would be effectively moving to the right) in case the page swipe
    // has not been completed while trying to go.
    if (!isMovingLeft &&
        blockRightMovement &&
        (!allowRecovery || !isPointInScreenLeftRange)) {
      return pointInScreen;
    }

    return super.applyBoundaryConditions(position, value);
  }
}

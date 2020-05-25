import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';

class MovementResult {
  final double result;
  final double value;
  final double pixels;
  final double viewportDimension;

  MovementResult({
    this.result,
    this.value,
    this.pixels,
    this.viewportDimension,
  });

  bool get hasBeenBlocked {
    var screenIndex = (value / viewportDimension).floor();
    var pointInScreen = value - (screenIndex * viewportDimension);
    var delta = value - pixels;

    if (pointInScreen.abs() > delta.abs()) {
      return result == delta;
    } else {
      return result == pointInScreen;
    }
  }

  bool get hasNotBeenBlocked => result == 0.0;
}

MovementResult moveLeftInLeftRange(HorizontalBlockedScrollPhysics hs) {
  var position = FixedScrollMetrics(
    pixels: 10,
    minScrollExtent: 20,
    maxScrollExtent: 40,
    axisDirection: AxisDirection.right,
    viewportDimension: 100,
  );
  var value = 40.0;
  var result = hs.applyBoundaryConditions(position, value);
  return MovementResult(
    result: result,
    value: value,
    pixels: position.pixels,
    viewportDimension: position.viewportDimension,
  );
}

MovementResult moveLeftNotInLeftRange(HorizontalBlockedScrollPhysics hs) {
  var position = FixedScrollMetrics(
    pixels: 60,
    minScrollExtent: 0,
    maxScrollExtent: 200,
    axisDirection: AxisDirection.right,
    viewportDimension: 100,
  );
  var value = 70.0;
  var result = hs.applyBoundaryConditions(position, value);
  return MovementResult(
    result: result,
    value: value,
    pixels: position.pixels,
    viewportDimension: position.viewportDimension,
  );
}

MovementResult moveRightInLeftRange(HorizontalBlockedScrollPhysics hs) {
  var position = FixedScrollMetrics(
    pixels: 10,
    minScrollExtent: 0,
    maxScrollExtent: 200,
    axisDirection: AxisDirection.right,
    viewportDimension: 100,
  );
  var value = 8.0;
  var result = hs.applyBoundaryConditions(position, value);
  return MovementResult(
    result: result,
    value: value,
    pixels: position.pixels,
    viewportDimension: position.viewportDimension,
  );
}

MovementResult moveRightNotInLeftRange(HorizontalBlockedScrollPhysics hs) {
  var position = FixedScrollMetrics(
    pixels: 70,
    minScrollExtent: 0,
    maxScrollExtent: 200,
    axisDirection: AxisDirection.right,
    viewportDimension: 100,
  );
  var value = 60.0;
  var result = hs.applyBoundaryConditions(position, value);
  return MovementResult(
    result: result,
    value: value,
    pixels: position.pixels,
    viewportDimension: position.viewportDimension,
  );
}

void main() {
  test('not block by default', () {
    var hs = HorizontalBlockedScrollPhysics();
    expect(hs.blockLeftMovement, false);
    expect(hs.blockRightMovement, false);
  });

  test('constructor will set blockLeftMovement', () {
    var hs = HorizontalBlockedScrollPhysics(blockLeftMovement: true);
    expect(hs.blockLeftMovement, true);
    expect(hs.blockRightMovement, false);
  });

  test('constructor will set blockRightMovement', () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    expect(hs.blockLeftMovement, false);
    expect(hs.blockRightMovement, true);
  });

  test('movement won\'t be blocked by default', () {
    var hs = HorizontalBlockedScrollPhysics();

    var position = FixedScrollMetrics(
      pixels: 10,
      minScrollExtent: 20,
      maxScrollExtent: 40,
      axisDirection: AxisDirection.right,
      viewportDimension: 100,
    );

    var value = 40.0;
    var result = hs.applyBoundaryConditions(position, value);

    expect(result, 0.0);
  });

  test(
      'blockLeftMovement won\'t block movement to the left while not in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(
      blockLeftMovement: true,
    );
    var result = moveLeftNotInLeftRange(hs);
    expect(
      result.hasNotBeenBlocked,
      true,
    );
  });

  test(
      'blockRightMovement won\'t block movement to the right while in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    var result = moveRightInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);
  });

  test(
      'blockLeftMovement won\'t block movement to the left while not in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockLeftMovement: true);
    var result = moveLeftNotInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);
  });

  test(
      'blockRightMovement won\'t block movement to the right while in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    var result = moveRightInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);
  });

  test(
      'blockLeftMovement will block movement to the left while in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockLeftMovement: true);
    var result = moveLeftInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'blockRightMovement will block movement to the right while not in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    var result = moveRightNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'blockRightMovement and blockLeftMovement will block all movement except right in left range and left not in left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(
      blockRightMovement: true,
      blockLeftMovement: true,
    );
    MovementResult result;

    // test left in left range
    result = moveLeftInLeftRange(hs);
    expect(result.hasBeenBlocked, true);

    // test left not in left range
    result = moveLeftNotInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);

    // test right in left range
    result = moveRightInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);

    // test right not in left range
    result = moveRightNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';

class MovementResult {
  final double result;
  final double value;
  final double pixels;

  MovementResult({this.result, this.value, this.pixels});

  bool get hasBeenBlocked => result == value - pixels;
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
  return MovementResult(result: result, value: value, pixels: position.pixels);
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
  return MovementResult(result: result, value: value, pixels: position.pixels);
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
  return MovementResult(result: result, value: value, pixels: position.pixels);
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
  return MovementResult(result: result, value: value, pixels: position.pixels);
}

void main() {
  test('not block by default', () {
    var hs = HorizontalBlockedScrollPhysics();
    expect(hs.blockLeftMovement, false);
    expect(hs.blockRightMovement, false);
  });

  test('allowRecovery by default', () {
    var hs = HorizontalBlockedScrollPhysics();
    expect(hs.allowRecovery, true);
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

  test('constructor will set allowRecovery', () {
    var hs = HorizontalBlockedScrollPhysics(allowRecovery: false);
    expect(hs.allowRecovery, false);
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
      'if blockLeftMovement is true it won\'t block movement to the left while not in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockLeftMovement: true);
    var result = moveLeftNotInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);
  });

  test(
      'if blockLeftMovement is true and not allowRecovery it will always block movement to the left',
      () {
    var hs = HorizontalBlockedScrollPhysics(
        blockLeftMovement: true, allowRecovery: false);
    var result = moveLeftNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
    result = moveLeftInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'if blockLeftMovement is true it will block movement to the left while in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockLeftMovement: true);
    var result = moveLeftInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'if blockRightMovement is true it will block movement to the right while not in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    var result = moveRightNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'if blockRightMovement is true and not allowRecovery it will always block movement to the right',
      () {
    var hs = HorizontalBlockedScrollPhysics(
        blockRightMovement: true, allowRecovery: false);
    var result = moveRightNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
    result = moveRightInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });

  test(
      'if blockRightMovement is true it won\'t block movement to the right while in the left range',
      () {
    var hs = HorizontalBlockedScrollPhysics(blockRightMovement: true);
    var result = moveRightInLeftRange(hs);
    expect(result.hasNotBeenBlocked, true);
  });

  test(
      'if blockRightMovement and blockLeftMovement are true it will block all movement except right in left range and left not in left range',
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

  test(
      'if blockRightMovement and blockLeftMovement are true and allowRecovery is false it will block all movement ',
      () {
    var hs = HorizontalBlockedScrollPhysics(
      blockRightMovement: true,
      blockLeftMovement: true,
      allowRecovery: false,
    );
    MovementResult result;

    // test left in left range
    result = moveLeftInLeftRange(hs);
    expect(result.hasBeenBlocked, true);

    // test left not in left range
    result = moveLeftNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);

    // test right in left range
    result = moveRightInLeftRange(hs);
    expect(result.hasBeenBlocked, true);

    // test right not in left range
    result = moveRightNotInLeftRange(hs);
    expect(result.hasBeenBlocked, true);
  });
}

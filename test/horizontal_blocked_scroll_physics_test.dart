import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';

void main() {
  test('not block by default', () {
    var hs = HorizontalBlockedScrollPhysics();
    expect(hs.blockLeft, false);
    expect(hs.blockRight, false);
  });

  test('constructor will set blockleft', () {
    var hs = HorizontalBlockedScrollPhysics(blockLeft: true);
    expect(hs.blockLeft, true);
    expect(hs.blockRight, false);
  });

  test('constructor will set blockRight', () {
    var hs = HorizontalBlockedScrollPhysics(blockRight: true);
    expect(hs.blockLeft, false);
    expect(hs.blockRight, true);
  });

  test('movement won\'t be blocked by default', () {
    var hs = HorizontalBlockedScrollPhysics();
    hs.applyPhysicsToUserOffset(null, -12);

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

  test('if blockLeft is true it will block movement to the left', () {
    var hs = HorizontalBlockedScrollPhysics(blockLeft: true);
    hs.applyPhysicsToUserOffset(null, 12);

    var position = FixedScrollMetrics(
      pixels: 10,
      minScrollExtent: 20,
      maxScrollExtent: 40,
      axisDirection: AxisDirection.right,
      viewportDimension: 100,
    );

    var value = 40.0;
    var result = hs.applyBoundaryConditions(position, value);

    expect(result, value - position.pixels);
  });

  test('if blockRight is true it will block movement to the right', () {
    var hs = HorizontalBlockedScrollPhysics(blockRight: true);
    hs.applyPhysicsToUserOffset(null, -12);

    var position = FixedScrollMetrics(
      pixels: 10,
      minScrollExtent: 20,
      maxScrollExtent: 40,
      axisDirection: AxisDirection.right,
      viewportDimension: 100,
    );

    var value = 40.0;
    var result = hs.applyBoundaryConditions(position, value);

    expect(result, value - position.pixels);
  });

  test('if blockRight and blockLeft are true it will block movement', () {
    var hs = HorizontalBlockedScrollPhysics(blockRight: true, blockLeft: true);

    var position = FixedScrollMetrics(
      pixels: 10,
      minScrollExtent: 20,
      maxScrollExtent: 40,
      axisDirection: AxisDirection.right,
      viewportDimension: 100,
    );
    var value = 40.0;

    // right
    hs.applyPhysicsToUserOffset(null, -12);
    var result = hs.applyBoundaryConditions(position, value);
    expect(result, value - position.pixels);

    // left
    hs.applyPhysicsToUserOffset(null, 12);
    result = hs.applyBoundaryConditions(position, value);
    expect(result, value - position.pixels);
  });
}

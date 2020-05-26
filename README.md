# Horizontal Blocked ScrollPhysics

[![Build Status](https://travis-ci.com/alpha-health/horizontal_blocked_scroll_physics.svg?branch=master)](https://travis-ci.com/alpha-health/horizontal_blocked_scroll_physics) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Pub](https://img.shields.io/pub/v/horizontal_blocked_scroll_physics.svg)](https://pub.dartlang.org/packages/horizontal_blocked_scroll_physics)

A [ScrollPhysics](https://api.flutter.dev/flutter/widgets/ScrollPhysics-class.html) class that blocks movement in the horizontal axis.

## How to use it

The API of this `ScrollPhysics` is fairly straighforward.

We have two different classes:

- **LeftBlockedScrollPhysics**: will block left movements.
- **RightBlockedScrollPhysics**: will block right movements.

### Blocking movement

```dart
LeftBlockedScrollPhysics();
```

This will allow the content to be scrolled to the right and will block any scroll to the left.

There's one exception, though. You can see here that the user is `swiping` to the left (which is blocked) but the screen will be able to move to the left if the movement is not completed. Note that the text will go back to the center.

![swiping_left_recovery](assets/block_left_recovery.gif)

Alternatively, if you want to block movement to the right and allow scrolling to the left:

```dart
RightBlockedScrollPhysics();
```

## Why are we exposing two classes

You may have notice that we're exposing two classes instead of only one that uses properties to change the physics behavior. That's because of an optimization in the [Scrollable class](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/scrollable.dart#L135-L141) that doesn't allow to use the same type, even if it's a new instance, in order to change the [Scrollable](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/scrollable.dart#L135-L141) physics behavior.

> The physics can be changed dynamically, but new physics will only take
  effect if the _class_ of the provided object changes. Merely constructing
  a new instance with a different configuration is insufficient to cause the
  physics to be reapplied. (This is because the final object used is
  generated dynamically, which can be relatively expensive, and it would be
  inefficient to speculatively create this object each frame to see if the
  physics should be updated.)

That's why Flutter has specific [ScrollPhysics](https://api.flutter.dev/flutter/widgets/ScrollPhysics-class.html) like [NeverScrollableScrollPhysics](https://api.flutter.dev/flutter/widgets/NeverScrollableScrollPhysics-class.html) and [AlwaysScrollableScrollPhysics](https://api.flutter.dev/flutter/widgets/AlwaysScrollableScrollPhysics-class.html).

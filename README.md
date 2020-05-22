# Horizontal Blocked ScrollPhysics

[![Build Status](https://travis-ci.com/alpha-health/horizontal_blocked_scroll_physics.svg?branch=master)](https://travis-ci.com/alpha-health/horizontal_blocked_scroll_physics) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Pub](https://img.shields.io/pub/v/horizontal_blocked_scroll_physics.svg)](https://pub.dartlang.org/packages/horizontal_blocked_scroll_physics)

A [ScrollPhysics](https://api.flutter.dev/flutter/widgets/ScrollPhysics-class.html) class that blocks movement in the horizontal axis.

## How to use it

The API of this `ScrollPhysics` is fairly straighforward.

Basically, you have a couple of properties in order to block right (`blockRightMovement`) and left (`blockLeftMovement`) movements and another one, called `allowRecovery`, that will allow the scroll to recover its initial position in case the movement has not allowed the viewport to scroll to the next view.

### Blocking movement with allowRecovery

```dart
// allowRecovery is true by default
HorizontalBlockedScrollPhysics(blockLeftMovement: true);
```

You can see here that the user is `swiping` to the left (which is blocked) but the screen will be able to move to the left if the movement is not completed. Note that the text will go back to the center.

![swiping_left_recovery](/assets/block_left_recovery.gif)

### Blocking movement without allowRecovery

```dart
HorizontalBlockedScrollPhysics(blockLeftMovement: true, allowRecovery: false);
```

This case is similar to the previous one except that this time the screen won't return to the center position as all the left movement is always blocked.

![swiping_left_no_recovery](/assets/block_left_no_recovery.gif)

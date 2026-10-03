import 'package:flutter/widgets.dart';

/// The scroll controller of the page currently on screen. The embedded 3D
/// viewer forwards mouse-wheel events here so the page keeps scrolling while
/// the cursor is over the canvas.
ScrollController? activePageScroll;

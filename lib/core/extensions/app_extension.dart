import 'package:flutter/material.dart';

/// add Padding Property to widget
extension WidgetPaddingX on Widget {
  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: vertical,
          ),
          child: this);

  Widget paddingLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) =>
      Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(
        padding: EdgeInsets.zero,
        child: this,
      );

  Widget rotateX(double angle) {
    return Transform.rotate(
      angle: angle,
      alignment: Alignment.center,
      child: this,
    );
  }
}

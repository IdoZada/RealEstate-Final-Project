import 'package:flutter/material.dart';

class MyPressHandler extends InkWell {
  MyPressHandler(GestureTapCallback onTap, Widget child,
      {bool padding = false, double paddingPixels = 5})
      : super(
            child: paddingWidget(child, padding, paddingPixels), onTap: onTap);

  static Widget paddingWidget(
      Widget widget, bool padding, double paddingPixels) {
    if (!padding) return widget;
    return Padding(padding: EdgeInsets.all(paddingPixels), child: widget);
  }
}

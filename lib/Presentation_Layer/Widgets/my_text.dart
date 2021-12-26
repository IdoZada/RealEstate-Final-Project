import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum FontType { Normal, SemiBold, Bold }

const double XS = 12;
const double SMALL = 14;
const double MEDIUM = 16;
const double LARGE = 18;
const double XL = 20;
const double XXL = 22;
const double XXXL = 27;
const double XXXXL = 30;
const double TITLE = 34;

class MyText {
  static Widget text(String translationKey, double fontSize, Color color,
      {FontType fontType = FontType.Normal,
      AlignmentDirectional alignment = AlignmentDirectional.centerStart,
      int maxLines = 1,
      bool ellipsis = false,
      TextAlign textAlign = TextAlign.start,
      TextDecoration decoration: TextDecoration.none}) {
    double minFontSize = fontSize * 0.9;
    minFontSize = double.parse(minFontSize.toStringAsFixed(0));
    minFontSize = max(minFontSize, XS);
    Widget text = AutoSizeText(
      translationKey,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minFontSize,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: getWeight(fontType),
          fontStyle: FontStyle.normal,
          fontSize: fontSize,
          decoration: decoration,
          color: color),
    );
    return Align(alignment: alignment, child: text);
  }

  static FontWeight getWeight(FontType fontType) {
    switch (fontType) {
      case FontType.Normal:
        return FontWeight.w400;
      case FontType.SemiBold:
        return FontWeight.w600;
      case FontType.Bold:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }
}

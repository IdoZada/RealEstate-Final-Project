import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget getLoader({double sizeIcon = 50}) {
  return Center(
    child: SpinKitCircle(
      color: Colors.white,
      size: sizeIcon,
    ),
  );
}

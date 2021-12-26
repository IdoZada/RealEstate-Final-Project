import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAsset {
  static Image getImage(String assetName) {
    return Image(image: getImageAsset(assetName));
  }

  static AssetImage getImageAsset(String assetName) {
    assetName = assetName.replaceAll('assets/images/', '');
    assetName = assetName.replaceAll('.png', '');
    return AssetImage('assets/images/' + assetName + '.png');
  }

  static Widget getSvgImage(String assetName, {double height, double width}) {
    return SvgPicture.asset('assets/images/' + assetName + '.svg',
        height: height, width: width);
  }
}

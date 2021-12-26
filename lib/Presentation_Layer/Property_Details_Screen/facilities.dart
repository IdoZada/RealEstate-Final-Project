import 'package:flutter/material.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Utils/my_asset.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';

class Facilities {
  static EdgeInsets myPadding() {
    return EdgeInsets.only(left: 10, right: 10, bottom: 10);
  }

  static Widget _buildFeature(String iconName, String text) {
    return Column(
      children: [
        MyAsset.getSvgImage(iconName, height: 25, width: 25),
        SizedBox(
          height: 6,
        ),
        MyText.text(text, XS, Blackish,
            fontType: FontType.Bold,
            textAlign: TextAlign.center,
            alignment: AlignmentDirectional.center,
            maxLines: 3),
        SizedBox(
          height: 2,
        ),
      ],
    );
  }

  static Widget facilities(Property property) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.count(
        mainAxisSpacing: 2,
        addAutomaticKeepAlives: true,
        physics: const NeverScrollableScrollPhysics(),
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisCount: 4,
        shrinkWrap: true,
        children: _fillterFeature(property),
      ),
    );
  }

  static List<Widget> _fillterFeature(Property property) {
    List<Widget> list = [];
    int size = int.parse(property.totalBsmtSf) + int.parse(property.grLivArea);
    if (int.parse(property.overallQual) > 5)
      list.add(_buildFeature('quality', "Quality ${property.overallQual}"));
    if (size > 600)
      list.add(_buildFeature('house_measure',
          "House size $size sq/m")); // GrLivArea and TotalBsmtSF
    if (int.parse(property.garage) > 50)
      list.add(
          _buildFeature('private-garage', " Garage\n${property.garage} sq/m"));
    if (int.parse(property.fullBath) > 2)
      list.add(_buildFeature('bathroom', "${property.fullBath} Bathroom"));
    if (int.parse(property.yearBuilt) >= 2000)
      list.add(_buildFeature('sketch', " Year\n${property.yearBuilt} "));
    if (int.parse(property.yearRemodAdd) >= 2005)
      list.add(
          _buildFeature('repair', "Year Renovation ${property.yearRemodAdd} "));
    if (property.fireplaces != null && int.parse(property.fireplaces) >= 1)
      list.add(_buildFeature('fireplace', "${property.fireplaces} Fireplaces"));
    if (int.parse(property.bsmtFinSF1) >= 1000)
      list.add(_buildFeature(
          'home-repair', " ${property.bsmtFinSF1}\n Spacial Qual sq/m"));
    if (int.parse(property.woodDeckSF) >= 400)
      list.add(_buildFeature('floor', "${property.woodDeckSF} Wood Deck sq/m"));

    return list;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Presentation_Layer/Property_Details_Screen/property_details_screen.dart';
import 'package:real_estate/Shared/enums/screen.dart';
import 'package:real_estate/Shared/star_display/star_display.dart';
import 'package:real_estate/Utils/my_asset.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';

class DisplayProperties extends StatefulWidget {
  final List<Property> properties;
  final ScreenType screen;
  final Function updateCallback;

  DisplayProperties(
      {@required this.properties, this.screen, this.updateCallback});

  @override
  _DisplayPropertiesState createState() => _DisplayPropertiesState();
}

class _DisplayPropertiesState extends State<DisplayProperties> {
  @override
  Widget build(BuildContext context) {
    return propertyCard();
  }

  favoriteCallback() {
    setState(() {});
  }

  Widget propertyCard() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: buildProperties(),
        ),
      ),
    );
  }

  List<Widget> buildProperties() {
    List<Widget> list = [];
    for (var i = 0; i < this.widget.properties.length; i++) {
      list.add(Hero(
          tag: this.widget.properties[i].frontImage,
          child: buildProperty(this.widget.properties[i], i)));
    }
    return list;
  }

  Widget buildProperty(Property property, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsProperty(
                    property: property,
                    screen: this.widget.screen,
                    updateCallback: this.widget.screen == ScreenType.FAVORITE
                        ? this.widget.updateCallback
                        : null,
                  )),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Container(
          height: 210,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(property.frontImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                predictBoxText(property),
                Expanded(
                  child: Container(),
                ),
                Container(
                  color: Gray400.withOpacity(0.8),
                  child: Column(
                    children: [
                      nameAndPriceRow(property),
                      SizedBox(
                        height: 4,
                      ),
                      propertyDetails(property),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget propertyDetails(Property property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Blackish,
              size: 14,
            ),
            SizedBox(
              width: 4,
            ),
            MyText.text(property.location, SMALL, Blackish,
                fontType: FontType.SemiBold,
                alignment: AlignmentDirectional.center),
            SizedBox(
              width: 8,
            ),
            MyAsset.getSvgImage('measured', height: 15, width: 15),
            SizedBox(
              width: 4,
            ),
            MyText.text(property.sqm + " sq/m", SMALL, Blackish,
                fontType: FontType.SemiBold,
                alignment: AlignmentDirectional.center),
          ],
        ),
        Row(
          children: [
            StarDisplay(
              value: (double.parse(property.stars.toStringAsFixed(2)) / 2),
              textSize: 15,
            ),
            SizedBox(
              width: 4,
            ),
            MyText.text(
                property.stars.toStringAsFixed(2) + " Stars", SMALL, Blackish,
                fontType: FontType.SemiBold,
                alignment: AlignmentDirectional.center),
          ],
        ),
      ],
    );
  }

  Widget nameAndPriceRow(Property property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText.text(property.name, XL, Blackish,
            fontType: FontType.SemiBold,
            alignment: AlignmentDirectional.center),
        MyText.text(r"$" + (int.parse(property.price) / 1000).toString() + "K",
            XL, Blackish,
            fontType: FontType.SemiBold,
            alignment: AlignmentDirectional.center),
      ],
    );
  }

  Widget predictBoxText(Property property) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: property.predictSalePrice >= 0 ? Green : GentleRed,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          // width: 80,
          padding: EdgeInsets.symmetric(
            vertical: 4,
          ),
          child: Center(
            child: Text(
              property.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Flexible(child: Container()),
      ],
    );
  }
}

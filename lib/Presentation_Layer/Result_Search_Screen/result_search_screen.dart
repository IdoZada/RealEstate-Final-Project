import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Presentation_Layer/Search_Screen/search_screen.dart';
import 'package:real_estate/Presentation_Layer/google_maps_screen/google_maps.dart';
import 'package:real_estate/Shared/display_properties/display_properties.dart';
import 'package:real_estate/Shared/enums/screen.dart';
import '../../Shared/bottomBar/bottom_bar_categories.dart';
import '../../Utils/my_colors.dart';
import '../../Presentation_Layer/Widgets/my_scaffold.dart';
import '../../Presentation_Layer/Widgets/my_text.dart';

class ResultSearchScreen extends StatefulWidget {
  static const String routeName = '/PropertiesScreen';
  final List<Property> properties;
  final ScreenType screen;
  ResultSearchScreen(this.properties, this.screen);

  @override
  _ResultSearchScreenState createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  BitmapDescriptor myIcon;

  @override
  void initState() {
    super.initState();
    uploadMarkerIconToMap();
  }

  void uploadMarkerIconToMap() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'assets/images/home.png')
        .then((d) {
      myIcon = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, SearchScreen.routeName);
        return;
      },
      child: MyScaffold(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            arrowBack(),
            titleWithMapIcon(),
            DisplayProperties(
                properties: this.widget.properties, screen: this.widget.screen)
          ]),
          useBottomBarCategoryOn: BottomBarCategories.search),
    );
  }

  Widget arrowBack() {
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context, SearchScreen.routeName);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  Widget titleWithMapIcon() {
    return Padding(
      padding: EdgeInsets.only(right: 24, left: 24, bottom: 10),
      child: Row(
        children: [
          MyText.text(this.widget.properties.length.toString(), XXL, Blackish,
              fontType: FontType.SemiBold,
              alignment: AlignmentDirectional.center),
          SizedBox(
            width: 8,
          ),
          MyText.text("Best results found:", XXL, Blackish,
              fontType: FontType.SemiBold,
              alignment: AlignmentDirectional.center),
          SizedBox(
            width: 20,
          ),
          _showGoogleMaps()
        ],
      ),
    );
  }

  Widget _showGoogleMaps() {
    return this.widget.properties.length > 0
        ? Container(
            child: Row(
              children: [
                IconButton(
                    icon: Image.asset('assets/images/google-maps.png'),
                    color: Blackish,
                    iconSize: 35,
                    onPressed: () {
                      _openMapModalBottomSheet();
                    }),
                MyText.text("Map", LARGE, Blackish,
                    fontType: FontType.SemiBold,
                    alignment: AlignmentDirectional.center),
              ],
            ),
          )
        : Container();
  }

  void _openMapModalBottomSheet() {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0))),
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoogleMapScreen(this.widget.properties, myIcon),
          ),
        );
      },
    );
  }
}

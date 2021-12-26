import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Presentation_Layer/Property_Details_Screen/facilities.dart';
import 'package:real_estate/Shared/bottomBar/bottom_bar_categories.dart';
import 'package:real_estate/Shared/display_properties/display_properties.dart';
import 'package:real_estate/Shared/enums/screen.dart';
import 'package:real_estate/Shared/star_display/star_display.dart';
import 'package:real_estate/Shared/components.dart';
import 'package:real_estate/Utils/my_asset.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_scaffold.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/database.dart';

class FavoriteScreen extends StatelessWidget {
  static const String routeName = '/FavoriteScreen';

  @override
  Widget build(BuildContext context) {
    Investor myUser = Provider.of<Investor>(context);
    return MyScaffold(
      Container(
        child: FavoriteProperties(myUser),
      ),
      useBottomBarCategoryOn: BottomBarCategories.favorites,
    );
  }
}

class FavoriteProperties extends StatefulWidget {
  final Investor myUser;
  FavoriteProperties(this.myUser);

  @override
  _FavoritePropertiesState createState() => _FavoritePropertiesState();
}

class _FavoritePropertiesState extends State<FavoriteProperties> {
  bool loading = false;
  bool isEmpty = false;
  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    initFavoriteProperties(); //get all favorite properties from database
    setState(() {
      loading = false;
    });
  }

  //this callback invoke from favorite screen after dislike property
  void updateCallback() {
    setState(() {
      loading = true;
    });
    initFavoriteProperties();
  }

  void initFavoriteProperties() {
    properties.clear();
    DatabaseService()
        .getFavoritePropertiesByIds(this.widget.myUser.propetiesIds)
        .then((propertiesResponse) {
      if (propertiesResponse.isNotEmpty) {
        // there are favorite properties id's
        for (Property property in propertiesResponse) {
          if (this.widget.myUser.propetiesIds.contains(property.userId)) {
            property.isFavorite = true;
          }
          properties.add(property);
        }
        setState(() {
          isEmpty = false;
        });
      } else {
        // no favorite properties id's
        setState(() {
          isEmpty = true;
        });
      }

      setState(() {
        loading = false;
      });
      sortListFavoriteProperties();
    });
  }

  void sortListFavoriteProperties() {
    properties.sort((b, a) => a.score.compareTo(
        b.score)); // (a,b) for ascending order (b,a) for descending order
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title(),
        SizedBox(height: 10.0),
        displayProperties(),
        SizedBox(height: 10.0),
        !isEmpty ? _buildCompPropertiesBtn() : Container(),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.only(right: 24, left: 24, top: 40, bottom: 10),
      child: Row(
        children: [
          MyText.text("Favorite Properties", XXL, Blackish,
              fontType: FontType.SemiBold,
              alignment: AlignmentDirectional.center),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget displayProperties() {
    return loading
        ? getLoader()
        : DisplayProperties(
            properties: properties,
            screen: ScreenType.FAVORITE,
            updateCallback: updateCallback);
  }

  Widget _buildCompPropertiesBtn() {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(
            elevation:
                MaterialStateProperty.resolveWith<double>((states) => 5.0),
            padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                (states) => EdgeInsets.all(15.0)),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => Colors.white,
            )),
        onPressed: () {
          print("clicked on comparison properties button");
          _comparisonPropertiesModalBottomSheet();
        },
        child: Text(
          'Comparison Properties',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void _comparisonPropertiesModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: comparisonSection(),
            ),
          ),
        );
      },
    );
  }

  Widget comparisonSection() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.5,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Comparison Properties',
              style: TextStyle(
                color: Color.fromRGBO(39, 105, 171, 1),
                fontSize: 27,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2.5,
            ),
            SizedBox(
              height: 10,
            ),
            comaprisonList(height),
          ],
        ),
      ),
    );
  }

  Widget comaprisonList(height) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 24,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: createComparisonList(height),
        ),
      ),
    );
  }

  List<Widget> createComparisonList(height) {
    List<Widget> list = [];
    Widget space = SizedBox(
      height: 10,
    );

    for (Property property in properties) {
      list.add(space);
      list.add(buildBoxDetailes(property));
    }

    return list;
  }

  Widget textDetails(txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyText.text(txt, XS, BlueDark,
          fontType: FontType.SemiBold,
          alignment: AlignmentDirectional.topStart),
    );
  }

  Widget buildBoxDetailes(Property property) {
    return Container(
        padding: EdgeInsets.all(15),
        height: 400,
        decoration: BoxDecoration(
          color: LightGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            yellowBoxText(property),
            SizedBox(
              height: 10,
            ),
            nameAndPriceRow(property),
            SizedBox(
              height: 5,
            ),
            propertyDetails(property),
            SizedBox(
              height: 10,
            ),
            Facilities.facilities(property),
            SizedBox(
              height: 5,
            ),
          ],
        ));
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

  Widget yellowBoxText(Property property) {
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

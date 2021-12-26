import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/Presentation_Layer/Property_Details_Screen/facilities.dart';
import 'package:real_estate/Shared/enums/screen.dart';
import 'package:real_estate/Shared/star_display/star_display.dart';
import 'package:real_estate/Utils/my_asset.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_scaffold.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/database.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';
import '../../Business_Logic/Property/property.dart';

// ignore: must_be_immutable
class DetailsProperty extends StatefulWidget {
  final Property property;
  final ScreenType screen;
  final Function updateCallback;
  Size size;
  Investor user;

  DetailsProperty({@required this.property, this.screen, this.updateCallback});

  @override
  _DetailsPropertyState createState() => _DetailsPropertyState();
}

class _DetailsPropertyState extends State<DetailsProperty> {
  IconData _icfavorite;
  @override
  Widget build(BuildContext context) {
    _icfavorite = initFavoriteIcon(this.widget.property);

    this.widget.user = Provider.of<Investor>(
        context); // this allow to access the data of logged in user

    this.widget.size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        this.widget.updateCallback();
        Navigator.pop(context);
        return;
      },
      child: MyScaffold(
        Stack(
          children: [
            backgroundImage(),
            highlights(),
            profileDetailes(),
          ],
        ),
      ),
    );
  }

  Widget arrowBack() {
    return Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
      size: 24,
    );
  }

  Widget highlights() {
    return Container(
      height: this.widget.size.height * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topHighlight(),
          Expanded(
            child: Container(),
          ),
          middleHighlight(),
          botHighlight(),
        ],
      ),
    );
  }

  Widget backgroundImage() {
    return Hero(
      tag: this.widget.property.frontImage,
      child: Container(
        height: this.widget.size.height * 0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(this.widget.property.frontImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  //  //initilize the icon of favorite
  IconData initFavoriteIcon(Property property) {
    return property.isFavorite ? Icons.favorite : Icons.favorite_border;
  }

  List<Widget> buildPhotos(List<String> images) {
    List<Widget> list = [];
    list.add(SizedBox(
      width: 24,
    ));
    for (var i = 0; i < images.length; i++) {
      list.add(buildPhoto(images[i]));
    }
    return list;
  }

  Widget buildPhoto(String url) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        margin: EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
            image: AssetImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget topHighlight() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (this.widget.screen == ScreenType.FAVORITE) {
                this.widget.updateCallback();
              }
              Navigator.pop(context);
            },
            child: arrowBack(),
          ),
        ],
      ),
    );
  }

  Widget middleHighlight() {
    return Padding(
        padding: myPadding(),
        child: Container(
          color: Gray400.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title(),
              favorite(),
            ],
          ),
        ));
  }

  Widget botHighlight() {
    Widget middleText(str) {
      return MyText.text(
        str,
        MEDIUM,
        White,
        alignment: AlignmentDirectional.center,
        fontType: FontType.Bold,
      );
    }

    return Padding(
      padding: myPadding(),
      child: Container(
          color: Gray400.withOpacity(0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: OldYellow,
                    size: 16,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  middleText(this.widget.property.location),
                  SizedBox(
                    width: 8,
                  ),
                  MyAsset.getSvgImage('house-plan', height: 15, width: 15),
                  SizedBox(
                    width: 4,
                  ),
                  middleText(this.widget.property.sqm + " sq/m"),
                ],
              ),
              Row(
                children: [
                  StarDisplay(
                    value: (double.parse(
                            widget.property.stars.toStringAsFixed(2)) /
                        2),
                    textSize: 20,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  middleText(
                      this.widget.property.stars.toStringAsFixed(2) + " Stars"),
                ],
              ),
            ],
          )),
    );
  }

  Widget title() {
    return MyText.text(
      this.widget.property.name,
      XXXXL,
      Blackish,
      alignment: AlignmentDirectional.center,
      fontType: FontType.Bold,
    );
  }

  Widget favorite() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: White,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: GestureDetector(
          child: Icon(
            _icfavorite,
            color: OldYellow,
            size: 20,
          ),
          onTap: () {
            setState(() {
              if (!this.widget.property.isFavorite) {
                // add favorite property
                _icfavorite = Icons.favorite;
                this
                    .widget
                    .user
                    .addFavoriteProperty(this.widget.property.userId);
                this.widget.property.isFavorite = true;
              } else {
                //remove favorite property
                _icfavorite = Icons.favorite_border;
                this
                    .widget
                    .user
                    .removeFavoriteProperty(this.widget.property.userId);
                this.widget.property.isFavorite = false;
              }
              //Update database
              DatabaseService().updateUserFavorites(
                  this.widget.user.email, this.widget.user.propetiesIds);
            });
          },
        ),
      ),
    );
  }

  Widget profileDetailes() {
    Widget profileHighlight() {
      return Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(this.widget.property.ownerImage),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleDetailsSection("James Milner"),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Property Owner",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget description() {
      return Padding(
        padding: myPadding(),
        child: titleDetailsSection("Description"),
      );
    }

    Widget why() {
      return Padding(
        padding: myPadding(),
        child: titleDetailsSection("Why?"),
      );
    }

    List<Widget> list = buildPhotos(this.widget.property.images);

    String fromListdescription = "";
    for (var txt in this.widget.property.description)
      fromListdescription += txt;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: this.widget.size.height * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              profileHighlight(),
              why(),
              Container(height: 20),
              Facilities.facilities(this.widget.property),
              description(),
              Container(height: 20),
              Padding(
                padding: myPadding(),
                child: descriptionDetailes(),
              ),
              Container(height: 30),
              Padding(
                padding: myPadding(),
                child: titleDetailsSection("Photos"),
              ),
              Container(
                height: 200, // give it a fixed height constraint
                color: White,
                child: ListView.builder(
                  itemCount: list.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) => list[i],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descriptionDetailes() {
    return Column(
      children: descriptionRowsList(),
    );
  }

  List<Widget> descriptionRowsList() {
    List<Widget> list = [];
    List<String> labels = [
      'Year Built',
      'Year Remod Add',
      'Overall Quality',
      'Sqm',
      'Ground Live Area',
      'Total BsmtSf',
      'Garage',
      'Fireplaces',
      'BsmtFinSF1',
      'Wood Deck SF',
      'Neighborhood'
    ];
    List<String> valList = [
      this.widget.property.yearBuilt,
      this.widget.property.yearRemodAdd,
      this.widget.property.overallQual,
      this.widget.property.sqm,
      this.widget.property.grLivArea,
      this.widget.property.totalBsmtSf,
      this.widget.property.garage,
      this.widget.property.fireplaces,
      this.widget.property.bsmtFinSF1,
      this.widget.property.woodDeckSF,
      this.widget.property.neighborhood
    ];
    for (var ix = 0; ix < labels.length; ix++) {
      list.add(Row(
        children: [
          MyText.text(
            labels[ix] + ' : ',
            MEDIUM,
            Blackish,
            alignment: AlignmentDirectional.center,
            fontType: FontType.Bold,
          ),
          MyText.text(
            valList[ix],
            MEDIUM,
            Blackish,
            alignment: AlignmentDirectional.center,
            fontType: FontType.Normal,
          ),
        ],
      ));
    }
    return list;
  }

  Widget titleDetailsSection(str) {
    return MyText.text(
      str,
      XL,
      Blackish,
      alignment: AlignmentDirectional.topStart,
      fontType: FontType.Bold,
    );
  }

  EdgeInsets myPadding() {
    return EdgeInsets.symmetric(horizontal: 12);
  }
}

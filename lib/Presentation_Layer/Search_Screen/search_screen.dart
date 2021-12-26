import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Presentation_Layer/Result_Search_Screen/result_search_screen.dart';
import 'package:real_estate/Shared/enums/screen.dart';
import 'package:real_estate/Shared/components.dart';
import 'package:real_estate/Data_Access/firebase_service.dart';
import 'package:real_estate/Utils/system_consts.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_scaffold.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/search_button.dart';
import 'package:real_estate/Presentation_Layer/Widgets/slider.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import '../../Shared/bottomBar/bottom_bar_categories.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';
import 'CustomShapeClipper.dart';
import 'package:real_estate/Data_Access/database.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  static const String routeName = '/SearchScreen';
  Investor user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<Investor>(context);
    return !checkUser()
        ? loadingLogo(context)
        : MyScaffold(
            Column(
              children: [
                SearchScreenTopPart(),
              ],
            ),
            useBottomBarCategoryOn: BottomBarCategories.search);
  }

  bool checkUser() {
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Widget loadingLogo(BuildContext context) {
    return MyScaffold(
      Center(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3.0,
              left: MediaQuery.of(context).size.width / 3.0,
              right: MediaQuery.of(context).size.width / 3.0,
              height: MediaQuery.of(context).size.height / 4.0,
              child: Column(
                children: [
                  Expanded(
                    child: ImageIcon(
                      AssetImage("assets/images/logo.png"),
                      color: Colors.black,
                      size: 260,
                    ),
                  ),
                  Expanded(
                    child: getLoader(sizeIcon: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreenTopPart extends StatefulWidget {
  @override
  _SearchScreenTopPartState createState() => _SearchScreenTopPartState();
}

class _SearchScreenTopPartState extends State<SearchScreenTopPart> {
  var isSelected = true;
  final myController = TextEditingController();
  Investor user;
  bool loading = false;
  bool userExist = false;
  bool validate = false;
  int lowValue = Consts.MIN_PRICE;
  int highValue = Consts.MAX_PRICE;
  String errorMsg;
  List<Property> filteredProperties = [];
  int numOfPropertiesLimit = 10;

  List<ListItem> _dropdownItems = [];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<ListItem> getDropdownItems() {
    List<ListItem> list = [];
    List<String> neighborhood = FirebaseService.getNeighborhood();

    for (var ix = 0; ix < neighborhood.length; ix++) {
      list.add(ListItem(ix + 1, neighborhood[ix]));
    }
    return list;
  }

  Future<List<Property>> initiateSearch(
      String value, int lowPrice, int highPrice, Investor user) {
    return DatabaseService().searchByStreetPrice(value);
  }

  callbackFunc() async {
    // print(user.propetiesIds);
    setState(() {
      validate = false;
      filteredProperties.clear();
      // checkValidationInputSearchText(myController.text);
    });

    if (!validate) {
      setState(() {
        loading = true;
      });

      await initiateSearch(_selectedItem.name, lowValue, highValue, user)
          .then((properties) {
        filterByPrice(properties, lowValue, highValue);

        changeOrderWithLimit();

        setState(() {
          loading = false;
        });

        user.addHistorySearch(
            _selectedItem.name,
            lowValue.toString(),
            highValue.toString(),
            numOfPropertiesLimit.toString(),
            filteredProperties.length == 0
                ? "0"
                : filteredProperties[0].stars.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ResultSearchScreen(filteredProperties, ScreenType.SEARCH)));
      });
    }
  }

  void checkValidationInputSearchText(String inputText) {
    if (isNumeric(inputText)) {
      errorMsg = Consts.ERR_INPUT_ONLY_NUMERIC;
      validate = true;
    } else if (inputText.startsWith(RegExp(r"\d+[a-z]*[A-Z]*"))) {
      errorMsg = Consts.ERR_INPUT_START_NUMERIC;
      validate = true;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void filterByPrice(List<Property> properties, int lowPrice, int highPrice) {
    for (Property property in properties) {
      if ((int.parse(property.price) >= lowPrice) &&
          (int.parse(property.price) <= highPrice)) {
        // Check the properties are signed favorites
        if (user.propetiesIds.contains(property.userId)) {
          property.isFavorite = true;
        }
        filteredProperties.add(property);
      }
    }
  }

  void rangeSliderCallback(int min, int max) {
    lowValue = min;
    highValue = max;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Investor>(context);

    return Expanded(
      child: ClipPath(
        clipper: CustomShapeClipper(),
        child: Container(
          height: MediaQuery.of(context).size.height - 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              MyText.text(Consts.TITLE_SEARCH_SCREEN, XXL, White,
                  fontType: FontType.Bold,
                  alignment: AlignmentDirectional.center,
                  maxLines: 2,
                  textAlign: TextAlign.center),
              SizedBox(
                height: 30.0,
              ),
              searchDropdownList(),
              // searchBox(Consts.HINT_TEXT_SEARCH, user),
              SizedBox(
                height: 20.0,
              ),
              SliderWidget(this.rangeSliderCallback),
              limitField(),
              Container(
                height: 20,
              ),
              loading ? getLoader() : ButtonWidget("Search", this.callbackFunc),
            ],
          ),
        ),
      ),
    );
  }

  //Widget Search
  Widget searchBox(String contentText, Investor user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        child: TextField(
          controller: myController,
          decoration: InputDecoration(
            hintText: contentText,
            errorText: validate ? errorMsg : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            suffixIcon: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: Icon(
                Icons.search,
                color: Blackish,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeOrderWithLimit() {
    filteredProperties.sort((b, a) => a.score.compareTo(
        b.score)); // (a,b) for ascending order (b,a) for descending order

    if (filteredProperties.length >
        numOfPropertiesLimit) //numOfPropertiesLimit to limit num of item ( Top 10! )
      filteredProperties = filteredProperties.sublist(0, numOfPropertiesLimit);
  }

  Widget limitField() {
    return Container(
      width: 140,
      child: TextField(
        maxLines: 1,
        maxLength: 4,
        onChanged: (value) {
          numOfPropertiesLimit = int.parse(value);
        },
        decoration: new InputDecoration(
          labelText: "Limit Result to: ",
          border: OutlineInputBorder(),
          fillColor: White,
          filled: true,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
      ),
    );
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget searchDropdownList() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Center(
        child: DropdownButton<ListItem>(
            value: _selectedItem,
            items: _dropdownMenuItems,
            icon: Icon(
              Icons.search,
              color: Blackish,
            ),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
              });
            }),
      ),
    );
  }

  void initState() {
    super.initState();
    _dropdownItems = getDropdownItems();
    _selectedItem = _dropdownItems[0];
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    // _selectedItem = _dropdownMenuItems[0].value;
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

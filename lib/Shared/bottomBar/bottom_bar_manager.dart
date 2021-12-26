import 'package:flutter/material.dart';
import 'package:real_estate/Presentation_Layer/Personal_Area/profile_area_screen.dart';
import 'package:real_estate/Presentation_Layer/Search_Screen/search_screen.dart';
import 'package:real_estate/Presentation_Layer/favorite_screen/favorite_screen.dart';
import 'package:real_estate/Utils/my_asset.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_press_handler.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';

import 'bottom_bar_categories.dart';

class BottomBar extends StatefulWidget {
  final BottomBarCategories categoryChosen;
  BottomBar(this.categoryChosen);
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        height: 65,
        color: White,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [..._optionsList()],
        ));
  }

  List<Widget> _optionsList() {
    List<Widget> x = [
      _optionPressed('Search', 'bar_search', BottomBarCategories.search),
      _optionPressed('Favorites', 'favorites', BottomBarCategories.favorites),
      _optionPressed('My Profile', 'profile', BottomBarCategories.profileArea),
    ];
    return x;
  }

  void moveToChosenSelection(
      BottomBarCategories categoryChosen, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
        context, routeName, ModalRoute.withName(routeName));
  }

  void handlePressing(BottomBarCategories categoryChosen) {
    if (categoryChosen == widget.categoryChosen) return;

    if (categoryChosen == BottomBarCategories.search) {
      // Navigator.popUntil(context, ModalRoute.withName(SearchScreen.routeName));
      moveToChosenSelection(categoryChosen, SearchScreen.routeName);
    } else if (categoryChosen == BottomBarCategories.favorites)
      moveToChosenSelection(categoryChosen, FavoriteScreen.routeName);
    else if (categoryChosen == BottomBarCategories.profileArea)
      moveToChosenSelection(categoryChosen, ProfileAreaScreen.routeName);

    setState(() {});
  }

  Widget _optionPressed(
      String text, String asset, BottomBarCategories category) {
    Widget image = Image(
        height: 28,
        width: 28,
        image: MyAsset.getImageAsset(
            category == widget.categoryChosen ? asset + '_green' : asset),
        fit: BoxFit.fill);

    return MyPressHandler(() {
      handlePressing(category);
    },
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 28, width: 28, child: Stack(children: [image])),
            MyText.text(text, MEDIUM,
                category == widget.categoryChosen ? ButtonColor : Gray600,
                fontType: FontType.SemiBold),
          ],
        )));
  }
}

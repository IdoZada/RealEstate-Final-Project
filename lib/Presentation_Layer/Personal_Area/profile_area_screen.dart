import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/Shared/bottomBar/bottom_bar_categories.dart';
import 'package:real_estate/Utils/my_colors.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_scaffold.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/auth.dart';
import 'package:real_estate/wrapper.dart';

// ignore: must_be_immutable
class ProfileAreaScreen extends StatefulWidget {
  static const String routeName = '/ProfileAreaScreen';
  final AuthService _auth = AuthService();
  Investor myUser;
  @override
  _ProfileAreaScreenState createState() => _ProfileAreaScreenState();
}

class _ProfileAreaScreenState extends State<ProfileAreaScreen> {
  String displayFullName() {
    try {
      return this.widget.myUser.firstName + " " + this.widget.myUser.lastName;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    this.widget.myUser = Provider.of<Investor>(context);
    return MyScaffold(buildScreen(),
        useBottomBarCategoryOn: BottomBarCategories.profileArea);
  }

  Widget buildScreen() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
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
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
            child: Column(
              children: [
                logout(),
                SizedBox(
                  height: 20,
                ),
                title(),
                SizedBox(
                  height: 22,
                ),
                profileDetailes(),
                SizedBox(
                  height: 30,
                ),
                historySection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logout() {
    return InkWell(
      onTap: () async {
        await this.widget._auth.signOut();
        Navigator.of(context).pushNamedAndRemoveUntil(
            Wrapper.routeName, (Route<dynamic> route) => false);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyText.text("Logout", XXL, White,
              fontType: FontType.SemiBold,
              alignment: AlignmentDirectional.center),
          SizedBox(
            width: 20,
          ),
          Icon(
            AntDesign.logout,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Text(
      'My\nProfile',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontFamily: 'Nisebuschgardens',
      ),
    );
  }

  Widget profileDetailes() {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.43,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double innerHeight = constraints.maxHeight;
          double innerWidth = constraints.maxWidth;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: innerHeight * 0.72,
                  width: innerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        displayFullName(),
                        style: TextStyle(
                          color: Color.fromRGBO(39, 105, 171, 1),
                          fontFamily: 'Nunito',
                          fontSize: 37,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              edit(),
              profileImage(innerWidth),
            ],
          );
        },
      ),
    );
  }

  Widget historySection() {
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
              'My History Search',
              style: TextStyle(
                color: Color.fromRGBO(39, 105, 171, 1),
                fontSize: 27,
                fontFamily: 'Nunito',
              ),
            ),
            Divider(
              thickness: 2.5,
            ),
            SizedBox(
              height: 10,
            ),
            historyList(height),
          ],
        ),
      ),
    );
  }

  Widget edit() {
    return Positioned(
      top: 110,
      right: 20,
      child: InkWell(
        onTap: () {},
        child: Icon(
          AntDesign.edit,
          color: Colors.grey[700],
          size: 30,
        ),
      ),
    );
  }

  profileImage(innerWidth) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          child: Image.asset(
            'assets/images/user_profile.png',
            width: innerWidth * 0.45,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  historyList(height) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 24,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: createHistoryList(height),
        ),
      ),
    );
  }

  List<Widget> createHistoryList(height) {
    List<Widget> list = [];
    Widget space = SizedBox(
      height: 10,
    );

    if (this.widget.myUser != null) {
      for (var historySearch in widget.myUser.historySearches) {
        list.add(space);
        list.add(buildBoxDetailes(historySearch));
      }
    }
    return list;
  }

  Widget textDetails(txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyText.text(txt, SMALL, BlueDark,
          fontType: FontType.SemiBold,
          alignment: AlignmentDirectional.topStart),
    );
  }

  Widget buildBoxDetailes(Map<String, dynamic> historySearch) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        color: LightBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            textDetails('Date: ${historySearch['date']}'),
            textDetails('Search: ${historySearch['search']}'),
            textDetails('Low Price: ${historySearch['lowPrice']}'),
            textDetails('High Price: ${historySearch['highPrice']}'),
            textDetails('Limit: ${historySearch['limit']}'),
            textDetails('Best Result: ${historySearch['bestResult']}'),
          ],
        ),
      ),
    );
  }
}

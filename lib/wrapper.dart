import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/Presentation_Layer/Search_Screen/search_screen.dart';
import 'package:real_estate/Presentation_Layer/Login_Screens/authenticate.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';

class Wrapper extends StatelessWidget {
  static const String routeName = '/wrapper';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Investor>(context);
    print(user);
    // return either Home or Authenticate widget
    if (FirebaseAuth.instance.currentUser == null) {
      return Authenticate();
    } else {
      return SearchScreen();
    }
  }
}

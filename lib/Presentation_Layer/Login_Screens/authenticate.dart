import 'package:flutter/material.dart';
import 'package:real_estate/Presentation_Layer/Login_Screens/sign_in.dart';
import 'package:real_estate/Presentation_Layer/Login_Screens/sign_up.dart';

class Authenticate extends StatefulWidget {
  static const String routeName = '/authenticate';
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}

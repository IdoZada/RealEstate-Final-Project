import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/Presentation_Layer/Personal_Area/profile_area_screen.dart';
import 'package:real_estate/Presentation_Layer/Search_Screen/search_screen.dart';
import 'package:real_estate/Presentation_Layer/Login_Screens/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate/Presentation_Layer/Widgets/animation_screen.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/auth.dart';
import 'package:real_estate/wrapper.dart';

import 'Presentation_Layer/favorite_screen/favorite_screen.dart';
import 'Data_Access/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInit();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Investor>.value(
      value: AuthService()
          .user, // use provider stream to know if current user logged / registered or new user
      initialData: null,
      child: MaterialApp(
        title: 'Final Project',
        routes: {
          // login
          Animate.routeName: (ctx) => Animate(),
          Wrapper.routeName: (ctx) => Wrapper(),
          SearchScreen.routeName: (ctx) => SearchScreen(),
          Authenticate.routeName: (ctx) => Authenticate(),
          FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
          ProfileAreaScreen.routeName: (ctx) => ProfileAreaScreen(),
        },
        debugShowCheckedModeBanner: false,
        home: Animate(),
      ),
    );
  }
}

Future<void> firebaseInit() async {
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  await FirebaseService.copyFromStorageToFirestore();
}

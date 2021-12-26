import 'package:flutter/material.dart';
import 'package:real_estate/Shared/bottomBar/bottom_bar_categories.dart';
import 'package:real_estate/Shared/bottomBar/bottom_bar_manager.dart';
import 'package:real_estate/Utils/my_colors.dart';

class MyScaffold extends StatefulWidget {
  final Color backgroundColor;
  final Widget body;
  final bottomNavigationBar;
  final BottomBarCategories useBottomBarCategoryOn;
  final bool raiseBottomWhenKeyboardOpens;

  MyScaffold(this.body,
      {this.backgroundColor = Gray200,
      this.bottomNavigationBar,
      this.useBottomBarCategoryOn,
      this.raiseBottomWhenKeyboardOpens = true});

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  @override
  Widget build(BuildContext context) {
    var bottomNavigationBar = widget.bottomNavigationBar;

    if (widget.useBottomBarCategoryOn != null)
      bottomNavigationBar = BottomBar(widget.useBottomBarCategoryOn);
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              if (Navigator.of(context).canPop()) return true;
              return false;
            },
            child: Scaffold(
                // resizeToAvoidBottomInset: true,
                // should fix problem of entering screen with keyboard open
                // resizeToAvoidBottomPadding: widget.raiseBottomWhenKeyboardOpens,
                backgroundColor: widget.backgroundColor,
                body: Column(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: widget.body,
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: bottomNavigationBar)));
  }
}

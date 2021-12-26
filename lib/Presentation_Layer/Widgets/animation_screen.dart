import 'package:flutter/material.dart';
import 'package:real_estate/wrapper.dart';

class Animate extends StatefulWidget {
  static const String routeName = '/Animate';
  @override
  _AnimateState createState() => _AnimateState();
}

class _AnimateState extends State<Animate> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween(begin: 150.0, end: 500.0).animate(animationController);
    TickerFuture tf = animationController.forward();
    tf.whenComplete(() {
      Navigator.pushNamedAndRemoveUntil(
          context, Wrapper.routeName, ModalRoute.withName(Wrapper.routeName));
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                top: animation.value,
                left: MediaQuery.of(context).size.width / 3.0,
                right: MediaQuery.of(context).size.width / 3.0,
                height: MediaQuery.of(context).size.height / 4.0,
                child: ScaleTransition(
                  scale: animationController,
                  child: ImageIcon(
                    AssetImage("assets/images/logo.png"),
                    color: Colors.black,
                    size: 200,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

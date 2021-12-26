import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final Function callbackFunc;
  final buttonHintTitle;
  ButtonWidget(this.buttonHintTitle, this.callbackFunc);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 120.0),
          width: double.infinity,
          child: ElevatedButton(
            // elevation: 5.0,
            style: ButtonStyle(
                elevation:
                    MaterialStateProperty.resolveWith<double>((states) => 5.0),
                padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                    (states) => EdgeInsets.all(2.0)),
                shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                        (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.white,
                )),
            onPressed: () {
              this
                  .widget
                  .callbackFunc(); // Activates the search query with all the parameters
            },

            child: Container(
              constraints: BoxConstraints(maxWidth: 210.0, minHeight: 42.0),
              alignment: Alignment.center,
              child: Text(
                this.widget.buttonHintTitle,
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),

                // child: Text(
                //   this.widget.buttonHintTitle,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    );
  }
}

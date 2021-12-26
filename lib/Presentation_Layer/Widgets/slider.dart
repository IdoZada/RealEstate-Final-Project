import 'package:flutter/material.dart';
import 'package:real_estate/Presentation_Layer/Widgets/my_text.dart';
import 'package:real_estate/Utils/system_consts.dart';
import 'package:real_estate/Utils/my_colors.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;
  final Function sliderCallback;

  SliderWidget(
    this.sliderCallback, {
    this.sliderHeight = 35,
    this.max = Consts.MAX_PRICE,
    this.min = Consts.MIN_PRICE,
    this.fullWidth = true,
  });

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  RangeValues values =
      RangeValues(Consts.MIN_PRICE.toDouble(), Consts.MAX_PRICE.toDouble());
  RangeLabels labels =
      RangeLabels(Consts.MIN_PRICE.toString(), Consts.MAX_PRICE.toString());

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .2;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: this.widget.fullWidth
            ? double.infinity
            : (this.widget.sliderHeight) * 5.5,
        height: (this.widget.sliderHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular((this.widget.sliderHeight * .5)),
          ),
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
              2, this.widget.sliderHeight * paddingFactor, 2),
          child: Row(
            children: <Widget>[
              MyText.text(
                '${this.widget.min}\$',
                this.widget.sliderHeight * .4,
                White,
                textAlign: TextAlign.center,
                fontType: FontType.Bold,
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              Expanded(
                child: Center(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white.withOpacity(1),
                      inactiveTrackColor: Colors.white.withOpacity(.5),
                      trackHeight: 4.0,
                      overlayColor: Colors.white.withOpacity(.4),
                      valueIndicatorColor: Colors.black,
                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: RangeSlider(
                        divisions: 100,
                        min: this.widget.min.toDouble(),
                        max: this.widget.max.toDouble(),
                        values: values,
                        labels: labels,
                        onChanged: (value) {
                          print("START: ${value.start}, End: ${value.end}");
                          setState(() {
                            values = value;
                            this.widget.sliderCallback(
                                value.start.toInt(), value.end.toInt());
                            labels = RangeLabels(
                                "${(value.start.round() / 1000).toString()}\K\$",
                                "${(value.end.round() / 1000).toString()}\K\$");
                          });
                        }),
                  ),
                ),
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              MyText.text('${this.widget.max}\$', this.widget.sliderHeight * .4,
                  Colors.white,
                  fontType: FontType.Bold, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

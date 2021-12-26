import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  final double textSize;

  StarDisplay({Key key, this.value, this.textSize})
      : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: checkTheColorDisplayByRating(),
        size: textSize,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < value ? Icons.star : Icons.star_border,
          );
        }),
      ),
    );
  }

  Color checkTheColorDisplayByRating() {
    if (value < 3) {
      return Colors.red;
    } else if (value >= 3 && value <= 4) {
      return Colors.amber[800];
    } else {
      return Colors.green;
    }
  }
}

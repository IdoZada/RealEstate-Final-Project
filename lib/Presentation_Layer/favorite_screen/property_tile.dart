import 'package:flutter/material.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';

class PropertyTile extends StatelessWidget {
  final Property property;

  PropertyTile({this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[100],
          ),
          title: Text(property.name),
          subtitle: Text(property.price),
        ),
      ),
    );
  }
}

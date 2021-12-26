import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';

class DownloadPropertiesService {
  static List<Property> properties = [];
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  DownloadPropertiesService();

  static Future<void> downloadPropertiesFromFirestore() async {
    properties = [];
    QuerySnapshot querySnapshot =
        await firestore.collection("Properties").get();
    var propertiesColection = querySnapshot.docs;

    for (var json in propertiesColection) {
      properties.add(Property.fromJson(json.data()));
    }
    properties.shuffle();
  }

  static Future<void> downloadPropertiesFromFirestoreWithFilter(
      searchField) async {
    properties = [];
    QuerySnapshot querySnapshot = await firestore
        .collection("Properties")
        .where('Neighborhood', isEqualTo: searchField)
        .get();
    var propertiesColection = querySnapshot.docs;

    for (var json in propertiesColection) {
      properties.add(Property.fromJson(json.data()));
    }
    properties.shuffle();
  }
  // static Future<void> downloadPropertiesFromFirestoreUnderStreet(
  //     String streetName) async {
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('Properties')
  //       .where('Street', isEqualTo: streetName)
  //       .get();
  //   var propertiesCollection = querySnapshot.docs;

  //   for (var json in propertiesCollection) {
  //     properties.add(Property.fromJson(json.data()));
  //   }

  //   properties.shuffle();
  // }
}

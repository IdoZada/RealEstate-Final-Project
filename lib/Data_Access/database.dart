import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_estate/Data_Access/download_properties.dart';
import 'package:real_estate/Business_Logic/Property/property.dart';
import 'package:real_estate/Business_Logic/investor/investor.dart';
import 'package:real_estate/Data_Access/const_db.dart';

class DatabaseService {
  DatabaseService();

  // collection users reference
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // collection properties reference
  final CollectionReference propertiesCollection =
      FirebaseFirestore.instance.collection('Properties');

  Future createNewUser(String email, String firstname, String lastname) async {
    return await usersCollection
        .doc(email)
        .set({USER_FAV_KEY: [], 'firstname': firstname, 'lastname': lastname});
  }

  Future<Investor> getUserByEmail(String email) async {
    return await usersCollection.doc(email).get().then((userDocSnapshot) =>
        Investor.fromJson(userDocSnapshot.data(), userDocSnapshot.id));
  }

  Future<void> updateUserFavorites(
      String email, List<String> propertiesIds) async {
    return await usersCollection
        .doc(email)
        .update({USER_FAV_KEY: propertiesIds});
  }

  Future<void> updateUserHistorySearches(
      String email, List<Map<String, dynamic>> historySearches) async {
    return await usersCollection
        .doc(email)
        .update({USER_SEARCH_KEY: historySearches});
  }

  // ---------------------- Queries ------------------------------ //

  Future<List<Property>> searchByStreetPrice(String searchField) async {
    List<Property> properties = [];
    if (searchField == null ||
        searchField == '' ||
        searchField == 'All Streets..') {
      await DownloadPropertiesService.downloadPropertiesFromFirestore();
    } else {
      await DownloadPropertiesService.downloadPropertiesFromFirestoreWithFilter(
          searchField);
    }
    properties = DownloadPropertiesService.properties;
    return properties;
  }

  Future<List<Property>> getFavoritePropertiesByIds(
      List<String> propertiesIds) async {
    List<Property> favoriteProperties = [];
    if (propertiesIds.isNotEmpty) {
      return await propertiesCollection
          .where("Id", whereIn: propertiesIds)
          .get()
          .then((QuerySnapshot docs) {
        for (var json in docs.docs) {
          favoriteProperties.add(Property.fromJson(json.data()));
        }
        return favoriteProperties;
      });
    }
    return favoriteProperties;
  }
}

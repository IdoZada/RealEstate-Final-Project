import 'package:real_estate/Data_Access/const_db.dart';
import 'package:real_estate/Data_Access/database.dart';

class Investor {
  String firstName;
  String lastName;
  String email;
  List<String> propetiesIds;
  List<Map<String, dynamic>> historySearches = [];

  Investor({this.email, this.propetiesIds, this.firstName, this.lastName});

  void addFavoriteProperty(String propertyId) {
    propetiesIds.add(propertyId);
  }

  void removeFavoriteProperty(String propertyId) {
    propetiesIds.remove(propertyId);
  }

  void addHistorySearch(String search, String lowPrice, String highPrice,
      String limit, String bestResult) {
    Map<String, dynamic> historySearch = {};
    historySearch['date'] = DateTime.now().toString();
    historySearch['search'] = search;
    historySearch['lowPrice'] =
        (double.parse(lowPrice) / 1000).toString() + "K";
    historySearch['highPrice'] =
        (double.parse(highPrice) / 1000).toString() + "K";
    historySearch['limit'] = limit;
    historySearch['bestResult'] = double.parse(bestResult).toStringAsFixed(2);
    historySearches.add(historySearch);
    historySearches.sort((b, a) => sortHistoryAccordingDate(a, b));
    DatabaseService().updateUserHistorySearches(email, historySearches);
  }

  static Investor fromJson(Map<String, dynamic> json, String email) {
    if (json == null) return null;
    List<String> propertiesIds = [];
    for (var propertyId in json[USER_FAV_KEY]) {
      propertiesIds.add(propertyId.toString());
    }
    Investor myUser = Investor();
    myUser.email = email;
    myUser.propetiesIds = propertiesIds;
    myUser.firstName = json['firstname'];
    myUser.lastName = json['lastname'];

    if (json[USER_SEARCH_KEY] != null) {
      for (var history in json[USER_SEARCH_KEY]) {
        myUser.historySearches.add(history);
      }
      myUser.historySearches.sort((b, a) => sortHistoryAccordingDate(a, b));
    }

    return myUser;
  }

  static int sortHistoryAccordingDate(
      Map<String, dynamic> a, Map<String, dynamic> b) {
    return a['date'].compareTo(b['date']);
  }
}

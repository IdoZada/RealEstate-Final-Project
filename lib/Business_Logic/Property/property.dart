import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  String label;
  String name;
  String price;
  String location;
  String sqm;
  double stars;
  List<String> description;
  String frontImage;
  String ownerImage;
  bool isFavorite = false;
  List<String> images;
  double score;
  String neighborhood;
  String overallQual;

  String userId;
  Timestamp registrationTime;

  String grLivArea;
  String totalBsmtSf;

  String garage;
  String fullBath;
  String yearBuilt;
  String yearRemodAdd;
  String fireplaces;
  String bsmtFinSF1;
  String woodDeckSF;
  double predictSalePrice;
  double longitude;
  double latitude;

  Property();

  static Property fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    Property p = Property();
    p.registrationTime = json['registrationTime'];
    p.userId = json['Id'];
    p.price = json['SalePrice'];
    p.neighborhood = json['Neighborhood'];
    p.predictSalePrice = double.parse(json['predictSalePrice']);
    p.label = "Profit: ${(json['score'] / 1000).toStringAsFixed(2)}K\$";
    p.name = 'Name: ${json['Neighborhood']} ${json['Id']}';
    p.location = json['Street'];
    p.sqm = (0.09290304 * double.parse(json['LotArea']))
        .toInt()
        .toString(); // convert from feet^2 to meters^2
    p.stars = json['stars'];
    p.frontImage = randomFrontImage();
    p.latitude = double.parse(json['Latitude']);
    p.longitude = double.parse(json['Longitude']);

    p.ownerImage = "assets/images/owner.jpg";
    p.images = [
      "assets/images/kitchen.jpg",
      "assets/images/bath_room.jpg",
      "assets/images/swimming_pool.jpg",
      "assets/images/bed_room.jpg",
      "assets/images/living_room.jpg",
    ];
    p.score = json['score'];
    p.overallQual = json['OverallQual'];
    p.grLivArea =
        (0.09290304 * double.parse(json['GrLivArea'])).toInt().toString();
    p.totalBsmtSf =
        (0.09290304 * double.parse(json['TotalBsmtSF'])).toInt().toString();
    p.garage =
        (0.09290304 * double.parse(json['GarageArea'])).toInt().toString();
    p.fullBath = json['FullBath'];
    p.yearBuilt = json['YearBuilt'];
    p.yearRemodAdd = json['YearRemodAdd'];
    p.fireplaces = json['Fireplaces'];
    p.bsmtFinSF1 = json['BsmtFinSF1'];
    p.woodDeckSF = json['WoodDeckSF'];

    p.description = [
      'yearBuilt : ${p.yearBuilt}\n',
      'yearRemodAdd : ${p.yearRemodAdd}\n',
      'overallQual : ${p.overallQual}\n',
      'sqm : ${p.sqm}\n',
      'grLivArea : ${p.grLivArea}\n',
      'totalBsmtSf : ${p.totalBsmtSf}\n',
      'garage : ${p.garage}\n',
      'fireplaces : ${p.fireplaces}\n',
      'bsmtFinSF1 : ${p.bsmtFinSF1}\n',
      'woodDeckSF : ${p.woodDeckSF}\n',
      'neighborhood : ${p.neighborhood}\n',
    ];

    return p;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    map['price'] = this.price;
    return map;
  }

  static String randomFrontImage() {
    List<String> list = [
      "assets/images/house_01.jpg",
      "assets/images/house_02.jpg",
      "assets/images/house_03.jpg",
      "assets/images/house_04.jpg",
      "assets/images/house_05.jpg",
      "assets/images/house_06.jpg",
      "assets/images/house_07.jpg",
      "assets/images/house_08.jpg",
    ];
    list.shuffle();
    return list[0];
  }
}

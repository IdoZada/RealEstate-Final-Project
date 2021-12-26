import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:real_estate/Business_Logic/Property/property_score.dart';

class FirebaseService {
  static List<Map<String, dynamic>> _propertiesDetils = [];
  static List<String> _neighborhoodList = [];
  static List<dynamic> _excelParam = [];
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static bool updateFromExcel = false;

  static Future<void> copyFromStorageToFirestore() async {
    await _readExcelLines();
    await _uploadToFirestore();
  }

  static List<dynamic> getNeighborhood() {
    return _neighborhoodList;
  }

  static Future<void> _readExcelLines() async {
    ByteData data = await rootBundle.load("assets/data/test.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    _neighborhoodList.add('All Streets..');
    for (var table in excel.tables.keys) {
      print(table); //sheet Name

      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      var first = true;
      for (var row in excel.tables[table].rows) {
        if (first) {
          first = false;
          _excelParam = row;
        } else {
          _propertiesDetils.add(_getAllPropertyDetails(row));
        }
      }
      PropertyScore.getAllScores(_propertiesDetils);
      PropertyScore.getAllStars(_propertiesDetils);
      print(_propertiesDetils);
    }
  }

  static Map<String, dynamic> _getAllPropertyDetails(List<dynamic> row) {
    Map<String, dynamic> property = {};

    for (int ix = 0; ix < row.length; ix++) {
      if (_excelParam[ix] == 'Neighborhood') {
        if (!_neighborhoodList.contains(row[ix].toString()))
          _neighborhoodList.add(row[ix].toString());
        property[_excelParam[ix]] = row[ix].toString();
      } else
        property[_excelParam[ix]] = row[ix].toString();
    }

    return property;
  }

  static Future<void> _uploadToFirestore() async {
    for (var property in _propertiesDetils) {
      firestore.collection("Properties").doc(property['Id']).set(property);
    }
  }
}

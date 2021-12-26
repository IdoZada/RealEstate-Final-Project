import 'dart:io' as io;
import 'dart:core';
import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageDownloaded {
  static Future<Uint8List> downloadFileSync(String pathInCloud) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();

      // var storageRef = FirebaseStorage.instance.ref().child(pathInCloud);
      // print(storageRef.getData());
      String path = (await getApplicationDocumentsDirectory()).path +
          "/temp/dataFromStorage" +
          Guid.newGuid.toString();
      io.File file = io.File(path);

      //gs://final-project-c76c7.appspot.com
      // var storageFileDownloadTask =
      await FirebaseStorage.instance.ref().child(pathInCloud).writeToFile(file);
      // await storageFileDownloadTask;
      var bytes = file.readAsBytesSync();
      file.deleteSync();
      return bytes;
    } catch (ex) {
      return null;
    }
  }
}

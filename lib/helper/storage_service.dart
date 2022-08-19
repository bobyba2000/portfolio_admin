import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class Storage {
  static Future<String?> uploadFile(Uint8List bytes, String storagePath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    String fileName = getRandomString(10);
    try {
      final process = await storage.ref('$storagePath/$fileName.png').putData(bytes);
      final url = await process.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e);
    }
    return null;
  }

  static Future<String> downloadUrl(String fileName, String storagePath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    String downloadURL = await storage.ref('$storagePath/$fileName').getDownloadURL();
    return downloadURL;
  }

  static Future<ListResult?> getAllFiles({
    required String storagePath,
  }) async {
    try {
      ListResult result = await FirebaseStorage.instance.ref(storagePath).listAll();
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<List<String>> getAllFilesUrl({required String storagePath}) async {
    try {
      ListResult? listResultFile = await getAllFiles(storagePath: storagePath);
      if (listResultFile == null) {
        return [];
      }
      List<String> listFileUrls = [];
      for (int i = 0; i < (listResultFile.items).length; i++) {
        String url = await listResultFile.items[i].getDownloadURL();
        listFileUrls.add(url);
      }
      return listFileUrls;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static final Random _rnd = Random();
  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

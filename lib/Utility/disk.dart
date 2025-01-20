import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Disk {
  static Future<void> saveToDisk(
      {required String filePath, required String data}) async {
    filePath =
        filePath.replaceFirst(RegExp(r'^/+'), ''); // remove leading slashes
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/$filePath");
    await offlineCopy.writeAsString(data, flush: true);
  }

  static Future<String?> readFromDisk(String filePath) async {
    filePath =
        filePath.replaceFirst(RegExp(r'^/+'), ''); // remove leading slashes
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/$filePath");
    String? data;
    if (offlineCopy.existsSync()) {
      data = await offlineCopy.readAsString();
    }
    return data;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderList {
  // Map of all folders, UUID as Key
  Map<String, Folder> byIDList = {};
  // Map of all folders, DisplayName as Key
  Map<String, Folder> byNameList = {};

  FolderList._();

  /// add [folder] to this FolderList
  void add(Folder folder) {
    byIDList[folder.uuid!] = folder;
    byNameList[folder.displayName] = folder;
  }

  /// remove Folder with ID [folderUUID] from this FolderList
  void remove(String folderUUID) {
    Folder? temp = byIDList[folderUUID];
    if (temp != null) {
      byIDList.remove(folderUUID);
      byNameList.remove(temp.displayName);
    }
  }

  // Get simple List<Folder> of this FolderList
  List<Folder> toList() {
    return byIDList.values.toList();
  }

  // Get Folderdata by folderUUID
  Folder? byUUID(String uuid) {
    return byIDList[uuid];
  }

  /// Function to deserialize FolderList from Local Storage
  ///
  /// How to use:
  ///
  /// import 'dart:convert';
  ///
  /// String test = jsonEncode(data);
  ///
  /// FolderList list = await FolderList.fromJson(jsonDecode(test));
  static FolderList fromJson(List<dynamic> json) {
    FolderList data = FolderList._();
    for (var folder in json) {
      Folder temp = Folder.fromJson(folder);
      data.add(temp);
    }
    return data;
  }

  /// Function to read FolderList from App Document Directory
  static Future<FolderList> readFromDisk() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/folders.json");
    String json = await offlineCopy.readAsString();
    return fromJson(jsonDecode(json));
  }

  /// Function to serialize FolderList to store in Local Storage
  List<dynamic> toJson() => byIDList.values.toList();

  /// Function to write FolderList to App Document Directory
  Future<void> saveToDisk() async {
    String json = jsonEncode(toJson());

    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/folders.json");
    await offlineCopy.writeAsString(json, flush: true);
  }

  /// Function to get new FolderList from `All` API endpoint response
  static FolderList getFromAPI(
      {required api.FoldersGetAllResponseBody folders}) {
    FolderList data = FolderList._();
    for (var folder in folders.folder!) {
      Folder? temp = Folder(
          uuid: folder.uuid!,
          displayName: folder.name!,
          iconData: folder.icon!);
      data.add(temp);
    }
    data.saveToDisk();
    return data;
  }

  /// Function to update Folder Entry in FolderList using Folder Object
  Future<FolderList> updateFromLocalObject({required Folder folder}) async {
    Folder? temp = byIDList[folder.uuid];
    if (temp != null) {
      remove(folder.uuid!);
      add(folder);
      await saveToDisk();
    }
    return this;
  }

  /// Function to get entire FolderList from Backend
  static Future<FolderList?> getFromAPIFull() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url'); // Get Backend URL
    Map<String, String> authdata =
        await AuthService.getAuthenticationCredentials();
    if (url != null) {
      api.ApiClient apiClient =
          RequestUtility.getApiWithAuth(authdata["token"]!, url);
      api.FoldersApi apiPoint = api.FoldersApi(apiClient);
      api.FoldersGetAllResponseBody? response =
          await apiPoint.foldersGetAllGet();

      if (response != null) {
        FolderList data = FolderList.getFromAPI(folders: response);
        return data;
      }
    }
    return null;
  }
}

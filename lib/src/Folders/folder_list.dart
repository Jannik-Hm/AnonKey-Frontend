import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/Folders/folder_data.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderList {
  Map<String, Folder> byIDList = {};
  Map<String, Folder> byNameList = {};

  FolderList._();

  void add(Folder folder) {
    byIDList[folder.uuid!] = folder;
    byNameList[folder.displayName] = folder;
  }

  void remove(String folderUUID) {
    Folder? temp = byIDList[folderUUID];
    if(temp != null){
      byIDList.remove(folderUUID);
      byNameList.remove(temp.displayName);
    }
  }

  List<Folder> toList() {
    return byIDList.values.toList();
  }

  Folder? byUUID(String uuid) {
    return byIDList[uuid];
  }

  static FolderList getFromAPI({required api.FoldersGetAllResponseBody folders}) {
    FolderList data = FolderList._();
    for (var folder in folders.folder!) {
      Folder? temp = Folder(
          uuid: folder.uuid!,
          displayName: folder.name!,
          iconData: folder.icon!
          );
      data.add(temp);
    }
    return data;
  }

  Future<FolderList> updateFromLocalObject({required Folder folder}) async {
    Folder? temp = byIDList[folder.uuid];
    if(temp != null){
      remove(folder.uuid!);
      add(folder);
    }
    return this;
  }

  static Future<FolderList?> getFromAPIFull() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
    if (url != null) {
      api.ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
      api.FoldersApi apiPoint = api.FoldersApi(apiClient);
      api.FoldersGetAllResponseBody? response = await apiPoint.foldersGetAllGet();

      if (response != null) {
        FolderList data = FolderList.getFromAPI(folders: response);
        return data;
      }
    }
    return null;
  }
}

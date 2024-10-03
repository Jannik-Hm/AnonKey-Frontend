import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialList {
  Map<String, Credential> byIDList = {};
  Map<String, List<Credential>> byFolderMap = {};

  CredentialList._();

  void add(Credential credential) {
    byIDList[credential.uuid] = credential;
    //
    String folder = credential.folderUuid ?? "";
    if (byFolderMap[folder] == null) byFolderMap[folder] = [];
    byFolderMap[folder]!.add(credential);
  }

  void remove(String credentialUUID) {
    Credential? credential = byIDList[credentialUUID];
    if (credential != null) {
      byFolderMap[credential.folderUuid ?? ""]?.remove(credential);
      byIDList.remove(credentialUUID);
    }
  }

  static Future<CredentialList> getFromAPI({required api.CredentialsGetAllResponseBody credentials, required String masterPassword}) async {
    CredentialList data = CredentialList._();
    for (var credential in credentials.credentials!) {
      Credential temp = await Credential.fromApi(
          uuid: credential.uuid!,
          masterPassword: masterPassword,
          encryptedWebsiteUrl: credential.websiteUrl!,
          websiteUrlSalt: credential.websiteUrlSalt!,
          encryptedUsername: credential.username!,
          usernameSalt: credential.usernameSalt!,
          encryptedPassword: credential.password!,
          passwordSalt: credential.passwordSalt!,
          encryptedDisplayName: credential.displayName!,
          displayNameSalt: credential.displayNameSalt!,
          encryptedNote: credential.note!,
          noteSalt: credential.noteSalt!,
          folderUuid: credential.folderUuid,
          createdTimeStamp: credential.createdTimestamp,
          changedTimeStamp: credential.changedTimestamp,
          deletedTimeStamp: credential.deletedTimestamp);
      data.add(temp);
    }
    return data;
  }

  void updateFromLocal({
    required String uuid,
    required String masterPassword,
    required String clearWebsiteUrl,
    required String clearUsername,
    required String clearPassword,
    required String clearDisplayName,
    String clearNote = "",
    required String? folderUuid,
    int? changedTimeStamp,
  }) async {
    Credential? temp = byIDList[uuid];
    if(temp != null){
      remove(uuid);
      add(await Credential.newEntry(masterPassword: masterPassword, uuid: uuid, clearWebsiteUrl: clearWebsiteUrl, clearUsername: clearUsername, clearPassword: clearPassword, clearDisplayName: clearDisplayName, folderUuid: folderUuid, createdTimeStamp: temp.getCreatedTimeStamp()!.millisecondsSinceEpoch~/1000, clearNote: clearNote));
    }
  }

  CredentialList updateFromLocalObject({required Credential credential}) {
    Credential? temp = byIDList[credential.uuid];
    if(temp != null){
      remove(credential.uuid);
      add(credential);
    }
    return this;
  }

  static Future<CredentialList?> getFromAPIFull() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
    if (url != null) {
      api.ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
      api.CredentialsApi credentialApi = api.CredentialsApi(apiClient);
      api.CredentialsGetAllResponseBody? response = await credentialApi.credentialsGetAllGet();

      if (response != null) {
        CredentialList data = await CredentialList.getFromAPI(credentials: response, masterPassword: authdata["password"]!);
        return data;
      }
    }
    return null;
  }
}

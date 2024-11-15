import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CredentialList {
  // Map of all credentials, UUID as Key
  Map<String, Credential> byIDList = {};
  // Map of all credentials, folderUuid as Key
  Map<String, List<Credential>> byFolderMap = {};
  // Map of all soft-deleted credentials, UUID as Key
  Map<String, Credential> deletedList = {};

  CredentialList._();

  /// add [credential] to this CredentialList
  void add(Credential credential) {
    // check if soft deleted
    if(credential.getDeletedTimeStamp() != null){
      deletedList[credential.uuid] = credential;
    }else{
      byIDList[credential.uuid] = credential;
      //
      String folder = credential.folderUuid ?? "";
      if (byFolderMap[folder] == null) byFolderMap[folder] = [];
      byFolderMap[folder]!.add(credential);
    }
  }

  /// remove Credential with ID [credentialUUID] from this CredentialList
  void remove(String credentialUUID) {
    deletedList.remove(credentialUUID);
    Credential? credential = byIDList[credentialUUID];
    if (credential != null) {
      byFolderMap[credential.folderUuid ?? ""]?.remove(credential);
      byIDList.remove(credentialUUID);
    }
  }

  /// restore soft-deleted Credential with ID [credentialUUID] from this CredentialList
  void restore(String credentialUUID) {
    Credential? credential = deletedList[credentialUUID];
    if (credential != null){
      deletedList.remove(credentialUUID);
      credential.clearDeletedTimeStamp();
      add(credential);
    }
  }

  /// soft-delete Credential with ID [credentialUUID] from this CredentialList
  void softDelete(String credentialUUID) {
    Credential? credential = byIDList[credentialUUID];
    if (credential != null) {
      remove(credentialUUID);
      deletedList[credentialUUID] = credential;
    }
  }

  // TODO: save serialized (JSON) data in file storage as shared preferences will probably be too small and sqlite would be inefficient for this usecase

  /// Function to deserialize CredentialList from Local Storage
  ///
  /// How to use:
  ///
  /// import 'dart:convert';
  ///
  /// String test = jsonEncode(data);
  ///
  /// CredentialList list = await CredentialList.fromJson(jsonDecode(test));
  static Future<CredentialList> fromJson(List<dynamic> json) async {
    CredentialList data = CredentialList._();
    for (var credential in json) {
      Credential temp = await Credential.fromJson(credential);
      data.add(temp);
    }
    return data;
  }

  /// Function to serialize CredentialList to store in Local Storage
  List<dynamic> toJson() => byIDList.values.toList();

  /// Function to get new CredentialList from `All` API endpoint response
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

  /// Function to update Credential Entry in CredentialList using parameters
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
    if (temp != null) {
      remove(uuid);
      add(await Credential.newEntry(
          masterPassword: masterPassword,
          uuid: uuid,
          clearWebsiteUrl: clearWebsiteUrl,
          clearUsername: clearUsername,
          clearPassword: clearPassword,
          clearDisplayName: clearDisplayName,
          folderUuid: folderUuid,
          createdTimeStamp: temp.getCreatedTimeStamp()!.millisecondsSinceEpoch ~/ 1000,
          clearNote: clearNote));
    }
  }

  /// Function to update Credential Entry in CredentialList using Credential Object
  CredentialList updateFromLocalObject({required Credential credential}) {
    Credential? temp = byIDList[credential.uuid];
    if (temp != null) {
      remove(credential.uuid);
      add(credential);
    }
    return this;
  }

  /// Function to update this entire CredentialList using `All` API endpoint (with minimal decryption)
  Future<CredentialList> updateFromAPI({required api.CredentialsGetAllResponseBody credentials, required String masterPassword}) async {
    CredentialList data = CredentialList._();
    for (var credential in credentials.credentials!) {
      Credential? origin = this.byIDList[credential.uuid!];
      Credential temp;
      if (origin != null) {
        temp = await origin.updateFromApi(
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
      } else {
        temp = await Credential.fromApi(
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
      }
      data.add(temp);
    }
    return data;
  }

  /// Helper to get `All` API endpoint
  static Future<api.CredentialsGetAllResponseBody?> _getResponseFromAllAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('url');
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();
    if (url != null) {
      api.ApiClient apiClient = RequestUtility.getApiWithAuth(authdata["token"]!, url);
      api.CredentialsApi credentialApi = api.CredentialsApi(apiClient);
      api.CredentialsGetAllResponseBody? response = await credentialApi.credentialsGetAllGet();

      return response;
    }
    return null;
  }

  /// Function to get entire CredentialList from Backend
  static Future<CredentialList?> getFromAPIFull() async {
    api.CredentialsGetAllResponseBody? response = await _getResponseFromAllAPI();
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();

      if (response != null) {
        CredentialList data = await CredentialList.getFromAPI(credentials: response, masterPassword: authdata["password"]!);
        return data;
      }
    return null;
  }

  /// Function to update this entire CredentialList from Backend (with minimal decryption)
  Future<CredentialList?> updateFromAPIFull() async {
    api.CredentialsGetAllResponseBody? response = await _getResponseFromAllAPI();
    Map<String, String> authdata = await AuthService.getAuthenticationCredentials();

      if (response != null) {
        CredentialList data = await updateFromAPI(credentials: response, masterPassword: authdata["password"]!);
        return data;
      }
    return null;
  }
}

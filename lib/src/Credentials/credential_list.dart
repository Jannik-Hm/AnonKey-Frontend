import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anonkey_frontend/Utility/api_base_data.dart';
import 'package:anonkey_frontend/Utility/request_utility.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/Credentials/credential_data.dart';
import 'package:anonkey_frontend/src/service/auth_service.dart';
import 'package:path_provider/path_provider.dart';

class CredentialListTimeout implements Exception {
  CredentialList fallbackData;
  static String message = "Credential fetch failed, using local data instead.";
  CredentialListTimeout(this.fallbackData);
}

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
    if (credential.getDeletedTimeStamp() != null) {
      deletedList[credential.uuid] = credential;
    } else {
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
    if (credential != null) {
      deletedList.remove(credentialUUID);
      credential.clearDeletedTimeStamp();
      add(credential);
      saveToDisk();
    }
  }

  /// soft-delete Credential with ID [credentialUUID] from this CredentialList
  void softDelete(String credentialUUID) {
    Credential? credential = byIDList[credentialUUID];
    if (credential != null) {
      credential.setDeletedTimeStamp(DateTime.now());
      remove(credentialUUID);
      deletedList[credentialUUID] = credential;
      saveToDisk();
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

    List<Future<Credential>> futures =
        json.map((credential) => Credential.fromJson(credential)).toList();
    List<Credential> credentials = await Future.wait(futures);

    credentials.forEach(data.add);
    return data;
  }

  /// Function to read encrypted CredentialList from App Document Directory
  static Future<CredentialList> readFromDisk() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/vault.json");
    String json = "[]";
    if (offlineCopy.existsSync()) {
      json = await offlineCopy.readAsString();
    }
    return await fromJson(jsonDecode(json));
  }

  /// Function to serialize CredentialList to store in App Storage
  List<dynamic> toJson() => {
        ...byIDList,
        ...deletedList,
      }.values.toList();

  /// Function to write encrypted CredentialList to App Document Directory
  Future<void> saveToDisk() async {
    String json = jsonEncode(toJson());

    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    File offlineCopy = File("${appDocumentsDir.path}/vault.json");
    await offlineCopy.writeAsString(json, flush: true);
  }

  /// Function to get new CredentialList from `All` API endpoint response
  static Future<CredentialList> getFromAPI(
      {required api.CredentialsGetAllResponseBody credentials,
      required String masterPassword}) async {
    CredentialList data = CredentialList._();

    List<Future<Credential>> futures = credentials.credentials!
        .map((credential) => Credential.fromApi(
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
            deletedTimeStamp: credential.deletedTimestamp))
        .toList();
    List<Credential> futureCredentials = await Future.wait(futures);
    futureCredentials.forEach(data.add);
    await data.saveToDisk();
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
          createdTimeStamp:
              temp.getCreatedTimeStamp()!.millisecondsSinceEpoch ~/ 1000,
          clearNote: clearNote));
      await saveToDisk();
    }
  }

  /// Function to update Credential Entry in CredentialList using Credential Object
  CredentialList updateFromLocalObject({required Credential credential}) {
    Credential? temp = byIDList[credential.uuid];
    if (temp != null) {
      remove(credential.uuid);
      add(credential);
      saveToDisk();
    }
    return this;
  }

  /// Function to update this entire CredentialList using `All` API endpoint (with minimal decryption)
  Future<CredentialList> updateFromAPI(
      {required api.CredentialsGetAllResponseBody credentials,
      required String masterPassword}) async {
    CredentialList data = CredentialList._();

    List<Future<Credential>> futures =
        credentials.credentials!.map((credential) {
      Credential? origin = this.byIDList[credential.uuid!];
      Future<Credential> temp;
      if (origin != null) {
        temp = origin.updateFromApi(
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
        temp = Credential.fromApi(
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
      return temp;
    }).toList();

    List<Credential> futureCredentials = await Future.wait(futures);
    futureCredentials.forEach(data.add);

    await data.saveToDisk();

    return data;
  }

  /// Helper to get `All` API endpoint
  /// throws [TimeoutException] if timeout is specified and exceeded
  static Future<api.CredentialsGetAllResponseBody?>
      _getResponseFromAllAPI() async {
    String? url = await ApiBaseData.getURL();
    Map<String, String> authdata =
        await AuthService.getAuthenticationCredentials();
    if (url != null) {
      api.ApiClient apiClient =
          RequestUtility.getApiWithAuth(authdata["token"]!, url);
      api.CredentialsApi credentialApi = api.CredentialsApi(apiClient);
      api.CredentialsGetAllResponseBody? response =
          await ApiBaseData.apiCallWrapper(credentialApi.credentialsGetAllGet(),
              logMessage: "Credential Fetch failed, using local data instead.",
              returnNullOnTimeout: true);
      return response;
    }
    return null;
  }

  /// Function to get entire CredentialList from Backend
  static Future<CredentialList?> getFromAPIFull() async {
    Future<api.CredentialsGetAllResponseBody?> responseFuture = (() async {
      try {
        return await _getResponseFromAllAPI();
      } catch (e) {
        if (e is AnonKeyServerOffline) {
          return null;
        }
        rethrow; // Propagate exceptions
      }
    })();
    Map<String, String> authdata =
        await AuthService.getAuthenticationCredentials();

    Future<CredentialList> futureLocalData = readFromDisk();

    List<dynamic> futureData =
        await Future.wait([responseFuture, futureLocalData]);

    api.CredentialsGetAllResponseBody? response =
        (futureData[0] as api.CredentialsGetAllResponseBody?);

    CredentialList localData = (futureData[1] as CredentialList);

    if (response != null) {
      CredentialList data = await localData.updateFromAPI(
          credentials: response, masterPassword: authdata["encryptionKDF"]!);
      return data;
    }
    throw CredentialListTimeout(localData);
  }

  /// Function to update this entire CredentialList from Backend (with minimal decryption)
  Future<CredentialList?> updateFromAPIFull() async {
    api.CredentialsGetAllResponseBody? response =
        await _getResponseFromAllAPI();
    Map<String, String> authdata =
        await AuthService.getAuthenticationCredentials();

    if (response != null) {
      CredentialList data = await updateFromAPI(
          credentials: response, masterPassword: authdata["encryptionKDF"]!);
      return data;
    } else {
      throw CredentialListTimeout(this);
    }
  }
}

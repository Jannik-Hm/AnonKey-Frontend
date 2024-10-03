import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;

//TODO: Error Handling if Master Password or Salt is incorrect
//TODO: Save encryptedPass as well to minimize AES runs by checking before de-/encrypting?

class Credential {
  final String uuid;
  String? folderUuid;

  String encryptedPassword;
  String clearPassword;
  String passwordSalt;

  String encryptedUsername;
  String clearUsername;
  String usernameSalt;

  String encryptedWebsiteUrl;
  String clearWebsiteUrl;
  String websiteUrlSalt;

  String encryptedNote;
  String clearNote;
  String noteSalt;

  String clearDisplayName;
  String encryptedDisplayName;
  String displayNameSalt;

  DateTime? createdTimeStamp;
  DateTime? changedTimeStamp;
  DateTime? deletedTimeStamp;

  Credential({
    required this.clearWebsiteUrl,
    required this.encryptedWebsiteUrl,
    required this.websiteUrlSalt,
    required this.clearUsername,
    required this.encryptedUsername,
    required this.encryptedPassword,
    required this.clearPassword,
    required this.clearDisplayName,
    required this.encryptedDisplayName,
    required this.displayNameSalt,
    required this.uuid,
    required this.passwordSalt,
    required this.usernameSalt,
    required this.clearNote,
    required this.encryptedNote,
    required this.noteSalt,
    required this.folderUuid,
    this.createdTimeStamp,
    this.changedTimeStamp,
    this.deletedTimeStamp,
  });

  @override
  String toString() {
    return """

    UUID: ${this.uuid},
    Folder UUID: ${this.folderUuid},
    Credential Name: ${this.clearDisplayName},
    URL: ${this.clearWebsiteUrl},
    Username: ${this.clearUsername},
    Password: ${this.clearPassword},
    Note: ${this.clearNote},
    Created: ${this.createdTimeStamp},
    Changed: ${this.changedTimeStamp},
    Deleted: ${this.deletedTimeStamp},
    """;
  }

  /// Function to generate a Credential Object from API get requests
  static Future<Credential> fromApi({
    required String uuid,
    required String masterPassword,
    required String encryptedWebsiteUrl,
    required String websiteUrlSalt,
    required String encryptedUsername,
    required String usernameSalt,
    required String encryptedPassword,
    required String passwordSalt,
    required String encryptedDisplayName,
    required String displayNameSalt,
    required String encryptedNote,
    required String noteSalt,
    required String? folderUuid,
    required int? createdTimeStamp,
    required int? changedTimeStamp,
    required int? deletedTimeStamp,
  }) async {
    //Encrypter encrypter = Encrypter(AES());
    return Credential(
      uuid: uuid,
      folderUuid: folderUuid,
      //
      clearWebsiteUrl: await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedWebsiteUrl,
        encryptedSalt: websiteUrlSalt,
      ),
      encryptedWebsiteUrl: encryptedWebsiteUrl,
      websiteUrlSalt: websiteUrlSalt,
      //
      clearUsername: await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedUsername,
        encryptedSalt: usernameSalt,
      ),
      encryptedUsername: encryptedUsername,
      usernameSalt: usernameSalt,
      //
      clearPassword: await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedPassword,
        encryptedSalt: passwordSalt,
      ),
      encryptedPassword: encryptedPassword,
      passwordSalt: passwordSalt,
      //
      clearDisplayName: await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedDisplayName,
        encryptedSalt: displayNameSalt,
      ),
      encryptedDisplayName: encryptedDisplayName,
      displayNameSalt: displayNameSalt,
      //
      clearNote: await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedNote,
        encryptedSalt: noteSalt,
      ),
      encryptedNote: encryptedNote,
      noteSalt: noteSalt,
      //
      createdTimeStamp: (createdTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(createdTimeStamp * 1000),
      changedTimeStamp: (changedTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(changedTimeStamp * 1000),
      deletedTimeStamp: (deletedTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(deletedTimeStamp * 1000),
    );
  }

  /// Function to generate a New Credential entry
  static Future<Credential> newEntry({
    required String masterPassword,
    required String uuid,
    required String clearWebsiteUrl,
    required String clearUsername,
    required String clearPassword,
    required String clearDisplayName,
    String clearNote = "",
    required String? folderUuid,
    required int? createdTimeStamp,
  }) async {
    final websiteUrlSalt = Cryptography.createCryptoRandomString(16);
    final passwordSalt = Cryptography.createCryptoRandomString(16);
    final usernameSalt = Cryptography.createCryptoRandomString(16);
    final displayNameSalt = Cryptography.createCryptoRandomString(16);
    final noteSalt = Cryptography.createCryptoRandomString(16);
    print(passwordSalt);
    Cryptography.getKDFBase64(masterPassword: masterPassword, salt: uuid).then(print);
    String tempString = await Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearPassword, encryptedSalt: passwordSalt);
    print(tempString);
    Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: tempString /* "0y9P8H+AzqfAQQuLGB/MhQ==" */, encryptedSalt: passwordSalt /* "IU0e-CSGD6QK7g==" */).then(print);
    return Credential(
      uuid: uuid,
      folderUuid: folderUuid,
      //
      clearWebsiteUrl: clearWebsiteUrl,
      encryptedWebsiteUrl: await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearWebsiteUrl,
        encryptedSalt: websiteUrlSalt,
      ),
      websiteUrlSalt: websiteUrlSalt,
      //
      clearUsername: clearUsername,
      encryptedUsername: await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearUsername,
        encryptedSalt: usernameSalt,
      ),
      usernameSalt: usernameSalt,
      //
      clearPassword: clearPassword,
      encryptedPassword: await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearPassword,
        encryptedSalt: passwordSalt,
      ),
      passwordSalt: passwordSalt,
      //
      clearDisplayName: clearDisplayName,
      encryptedDisplayName: await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearDisplayName,
        encryptedSalt: displayNameSalt,
      ),
      displayNameSalt: displayNameSalt,
      //
      clearNote: clearNote,
      encryptedNote: await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearNote,
        encryptedSalt: noteSalt,
      ),
      noteSalt: noteSalt,
      //
      createdTimeStamp: (createdTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(createdTimeStamp),
    );
  }

  Future<String> getEncryptedPassword({required String masterPassword}) async {
    return Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this.clearPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getClearPassword({required String masterPassword}) async {
    return Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this.encryptedPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getEncryptedUsername({required String masterPassword}) async {
    return Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this.clearPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getClearUsername({required String masterPassword}) async {
    return Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this.encryptedPassword, encryptedSalt: this.passwordSalt);
  }

  static Future<Credential>? fromSingleApi({required api.CredentialsGetResponseBody response, required String masterPassword}) {
    api.CredentialsGetCredential? credential = response.credential;
    if (credential == null) {
      return null;
    } else {
      return fromApi(
        uuid: credential.uuid!,
        encryptedWebsiteUrl: credential.websiteUrl!,
        websiteUrlSalt: credential.websiteUrlSalt!,
        encryptedUsername: credential.username!,
        usernameSalt: credential.usernameSalt!,
        masterPassword: masterPassword,
        encryptedPassword: credential.password!,
        passwordSalt: credential.passwordSalt!,
        encryptedDisplayName: credential.displayName!,
        displayNameSalt: credential.displayNameSalt!,
        encryptedNote: credential.note!,
        noteSalt: credential.note!,
        folderUuid: credential.folderUuid!,
        createdTimeStamp: credential.createdTimestamp,
        changedTimeStamp: credential.changedTimestamp,
        deletedTimeStamp: credential.deletedTimestamp,
      );
      //return Credential(websiteUrl: credential.websiteUrl!, clearUsername: credential.username!, encryptedUsername: encryptedUsername, encryptedPassword: encryptedPassword, clearPassword: clearPassword, displayName: displayName, uuid: uuid, passwordSalt: passwordSalt, usernameSalt: usernameSalt, note: note, folderUuid: folderUuid)
    }
  }

  /// returns a Map with key folderUUID and list of Credentials in said folder
  static Future<Map<String, List<Credential>>?> fromAllApi({required api.CredentialsGetAllResponseBody credentials, required String masterPassword}) async {
    Map<String, List<Credential>> credentialmap = {};

    for (var credential in credentials.credentials!) {
      String folder = credential.folderUuid ?? "";
      if(credentialmap[folder] == null) credentialmap[folder] = [];
      credentialmap[folder]?.add(
        await fromApi(
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
          deletedTimeStamp: credential.deletedTimestamp));
    }
    return credentialmap;
  }

  /*
  api.Credential createAPICredential() {
    return api.FoldersCreateFolder(
      icon: this._iconData,
      name: this.displayName,
    );
  }

  api.FoldersUpdateFolder updateFolder() {
    return api.FoldersUpdateFolder(
      icon: this._iconData,
      name: this.displayName,
      uuid: this.uuid,
    );
  } */
}

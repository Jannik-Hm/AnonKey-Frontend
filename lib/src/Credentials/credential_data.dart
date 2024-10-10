import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:anonkey_frontend/api/lib/api.dart' as api;
import 'package:anonkey_frontend/src/service/auth_service.dart';

//TODO: Error Handling if Master Password or Salt is incorrect -> Notify User -> Can only happen when manually changing things via API

class Credential {
  final String uuid;
  String? folderUuid;

  String _encryptedPassword;
  String _clearPassword;
  String _passwordSalt;

  String _encryptedUsername;
  String _clearUsername;
  String _usernameSalt;

  String _encryptedWebsiteUrl;
  String _clearWebsiteUrl;
  String _websiteUrlSalt;

  String _encryptedNote;
  String _clearNote;
  String _noteSalt;

  String _encryptedDisplayName;
  String _clearDisplayName;
  String _displayNameSalt;

  DateTime? _createdTimeStamp;
  DateTime? _changedTimeStamp;
  DateTime? _deletedTimeStamp;

  Credential({
    required String clearWebsiteUrl,
    required String encryptedWebsiteUrl,
    required String websiteUrlSalt,
    required String clearUsername,
    required String encryptedUsername,
    required String encryptedPassword,
    required String clearPassword,
    required String clearDisplayName,
    required String encryptedDisplayName,
    required String displayNameSalt,
    required this.uuid,
    required String passwordSalt,
    required String usernameSalt,
    required String clearNote,
    required String encryptedNote,
    required String noteSalt,
    required this.folderUuid,
    DateTime? createdTimeStamp,
    DateTime? changedTimeStamp,
    DateTime? deletedTimeStamp,
  })  : _deletedTimeStamp = deletedTimeStamp,
        _changedTimeStamp = changedTimeStamp,
        _createdTimeStamp = createdTimeStamp,
        _displayNameSalt = displayNameSalt,
        _encryptedDisplayName = encryptedDisplayName,
        _clearDisplayName = clearDisplayName,
        _noteSalt = noteSalt,
        _clearNote = clearNote,
        _encryptedNote = encryptedNote,
        _websiteUrlSalt = websiteUrlSalt,
        _clearWebsiteUrl = clearWebsiteUrl,
        _encryptedWebsiteUrl = encryptedWebsiteUrl,
        _usernameSalt = usernameSalt,
        _clearUsername = clearUsername,
        _encryptedUsername = encryptedUsername,
        _passwordSalt = passwordSalt,
        _clearPassword = clearPassword,
        _encryptedPassword = encryptedPassword;

  static Future<Credential> fromJson(Map<String, dynamic> json) async {
    return Credential.fromApi(
      uuid: json["uuid"],
      masterPassword: (await AuthService.getAuthenticationCredentials())["password"]!,
      encryptedWebsiteUrl: json["encryptedWebsiteUrl"],
      websiteUrlSalt: json["websiteUrlSalt"],
      encryptedUsername: json["encryptedUsername"],
      usernameSalt: json["usernameSalt"],
      encryptedPassword: json["encryptedPassword"],
      passwordSalt: json["passwordSalt"],
      encryptedDisplayName: json["encryptedDisplayName"],
      displayNameSalt: json["displayNameSalt"],
      encryptedNote: json["encryptedNote"],
      noteSalt: json["noteSalt"],
      folderUuid: json["folderUuid"],
      createdTimeStamp: json["createdTimeStamp"],
      changedTimeStamp: json["changedTimeStamp"],
      deletedTimeStamp: json["deletedTimeStamp"],
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'encryptedWebsiteUrl': _encryptedWebsiteUrl,
        'websiteUrlSalt': _websiteUrlSalt,
        'encryptedUsername': _encryptedUsername,
        'usernameSalt': _usernameSalt,
        'encryptedPassword': _encryptedPassword,
        'passwordSalt': _passwordSalt,
        'encryptedDisplayName': _encryptedDisplayName,
        'displayNameSalt': _displayNameSalt,
        'encryptedNote': _encryptedNote,
        'noteSalt': _noteSalt,
        'folderUuid': folderUuid,
        'createdTimeStamp': (_createdTimeStamp == null) ? null : (_createdTimeStamp!.millisecondsSinceEpoch ~/ 1000),
        'changedTimeStamp': (_changedTimeStamp == null) ? null : (_changedTimeStamp!.millisecondsSinceEpoch ~/ 1000),
        'deletedTimeStamp': (_deletedTimeStamp == null) ? null : (_deletedTimeStamp!.millisecondsSinceEpoch ~/ 1000),
      };

  String getClearDisplayName() {
    return this._clearDisplayName;
  }

  String getClearWebsiteUrl() {
    return this._clearWebsiteUrl;
  }

  String getClearUsername() {
    return this._clearUsername;
  }

  String getClearPassword() {
    return this._clearPassword;
  }

  String getClearNote() {
    return this._clearNote;
  }

  DateTime? getCreatedTimeStamp() {
    return this._createdTimeStamp;
  }

  DateTime? getChangedTimeStamp() {
    return this._changedTimeStamp;
  }

  DateTime? getDeletedTimeStamp() {
    return this._deletedTimeStamp;
  }

  /// Use when Restoring Credential (Soft-Undelete)
  void clearDeletedTimeStamp() {
    this._deletedTimeStamp = null;
  }

  @override
  String toString() {
    return """

    UUID: ${this.uuid},
    Folder UUID: ${this.folderUuid},
    Credential Name: ${this._clearDisplayName},
    URL: ${this._clearWebsiteUrl},
    Username: ${this._clearUsername},
    Password: ${this._clearPassword},
    Note: ${this._clearNote},
    Created: ${this._createdTimeStamp},
    Changed: ${this._changedTimeStamp},
    Deleted: ${this._deletedTimeStamp},
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

  Future<Credential> updateFromApi({
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
    this.folderUuid = folderUuid;
    //
    if (this._encryptedWebsiteUrl != encryptedWebsiteUrl && this._websiteUrlSalt != websiteUrlSalt) {
      this._clearWebsiteUrl = await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedWebsiteUrl,
        encryptedSalt: websiteUrlSalt,
      );
      this._encryptedWebsiteUrl = encryptedWebsiteUrl;
      this._websiteUrlSalt = websiteUrlSalt;
    }
    //
    if (this._encryptedUsername != encryptedUsername && this._usernameSalt != usernameSalt) {
      this._clearUsername = await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedUsername,
        encryptedSalt: usernameSalt,
      );
      this._encryptedUsername = encryptedUsername;
      this._usernameSalt = usernameSalt;
    }
    //
    if (this._encryptedPassword != encryptedPassword && this._passwordSalt != passwordSalt) {
      this._clearPassword = await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedPassword,
        encryptedSalt: passwordSalt,
      );
      this._encryptedPassword = encryptedPassword;
      this._passwordSalt = passwordSalt;
    }
    //
    if (this._encryptedDisplayName != encryptedDisplayName && this._displayNameSalt != displayNameSalt) {
      this._clearDisplayName = await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedDisplayName,
        encryptedSalt: displayNameSalt,
      );
      this._encryptedDisplayName = encryptedDisplayName;
      this._displayNameSalt = displayNameSalt;
    }
    //
    if (this._encryptedNote != encryptedNote && this._noteSalt != noteSalt) {
      this._clearNote = await Cryptography.getClearString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        encryptedString: encryptedNote,
        encryptedSalt: noteSalt,
      );
      this._encryptedNote = encryptedNote;
      this._noteSalt = noteSalt;
    }
    //
    this._createdTimeStamp = (createdTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(createdTimeStamp * 1000);
    this._changedTimeStamp = (changedTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(changedTimeStamp * 1000);
    this._deletedTimeStamp = (deletedTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(deletedTimeStamp * 1000);
    //
    return this;
  }

  Future<Credential> updateFromLocal({
    required String masterPassword,
    required String clearWebsiteUrl,
    required String clearUsername,
    required String clearPassword,
    required String clearDisplayName,
    String clearNote = "",
    required String? folderUuid,
    int? changedTimeStamp,
  }) async {
    this.folderUuid = folderUuid;
    //
    if (this._clearWebsiteUrl != clearWebsiteUrl) {
      this._clearWebsiteUrl = clearWebsiteUrl;
      this._encryptedWebsiteUrl = await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearWebsiteUrl,
        encryptedSalt: this._websiteUrlSalt,
      );
    }
    //
    if (this._clearUsername != clearUsername) {
      this._clearUsername = clearUsername;
      this._encryptedUsername = await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearUsername,
        encryptedSalt: this._usernameSalt,
      );
    }
    //
    if (this._clearPassword != clearPassword) {
      this._clearPassword = clearPassword;
      this._encryptedPassword = await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearPassword,
        encryptedSalt: this._passwordSalt,
      );
    }
    //
    if (this._clearDisplayName != clearDisplayName) {
      this._clearDisplayName = clearDisplayName;
      this._encryptedDisplayName = await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearDisplayName,
        encryptedSalt: this._displayNameSalt,
      );
    }
    //
    if (this._clearNote != clearNote) {
      this._clearNote = clearNote;
      this._encryptedNote = await Cryptography.encryptString(
        masterPassword: masterPassword,
        kdfSalt: uuid,
        clearString: clearNote,
        encryptedSalt: this._noteSalt,
      );
    }
    //
    this._changedTimeStamp = (changedTimeStamp == null) ? null : DateTime.fromMillisecondsSinceEpoch(changedTimeStamp);
    return this;
  }

  /* Future<String> getEncryptedPassword({required String masterPassword}) async {
    return Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this._clearPassword, encryptedSalt: this._passwordSalt);
  }

  Future<String> getClearPassword({required String masterPassword}) async {
    return Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this._encryptedPassword, encryptedSalt: this._passwordSalt);
  }

  Future<String> getEncryptedUsername({required String masterPassword}) async {
    return Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this._clearPassword, encryptedSalt: this._passwordSalt);
  }

  Future<String> getClearUsername({required String masterPassword}) async {
    return Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this._encryptedPassword, encryptedSalt: this._passwordSalt);
  } */

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
    }
  }

  api.CredentialsCreateCredential createAPICredential() {
    return api.CredentialsCreateCredential(
      uuid: this.uuid,
      folderUuid: this.folderUuid,
      //
      displayName: this._encryptedDisplayName,
      displayNameSalt: this._displayNameSalt,
      //
      websiteUrl: this._encryptedWebsiteUrl,
      websiteUrlSalt: this._websiteUrlSalt,
      //
      username: this._encryptedUsername,
      usernameSalt: this._usernameSalt,
      //
      password: this._encryptedPassword,
      passwordSalt: this._passwordSalt,
      //
      note: this._encryptedNote,
      noteSalt: this._noteSalt,
    );
  }

  api.CredentialsUpdateCredentialRequest updateAPICredentialRequest() {
    return api.CredentialsUpdateCredentialRequest(
      uuid: this.uuid,
      folderUuid: this.folderUuid,
      displayName: this._encryptedDisplayName,
      displayNameSalt: this._displayNameSalt,
      websiteUrl: this._encryptedWebsiteUrl,
      websiteUrlSalt: this._websiteUrlSalt,
      username: this._encryptedUsername,
      usernameSalt: this._usernameSalt,
      password: this._encryptedPassword,
      passwordSalt: this._passwordSalt,
      note: this._encryptedNote,
      noteSalt: this._noteSalt,
      //deletedTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  api.CredentialsUpdateRequestBody updateAPICredentialRequestBody({api.CredentialsUpdateCredentialRequest? requestdata}) {
    return api.CredentialsUpdateRequestBody(
      credential: requestdata ?? this.updateAPICredentialRequest(),
    );
  }
}

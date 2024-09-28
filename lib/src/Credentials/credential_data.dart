import 'dart:convert';
import 'dart:math';
import 'package:anonkey_frontend/Utility/cryptography.dart';

//TODO: Error Handling if Master Password or Salt is incorrect
//TODO: Save encryptedPass as well to minimize AES runs by checking before de-/encrypting?

class Credential {
  final String uuid;
  String encryptedPassword;
  String clearPassword;
  String passwordSalt;
  String encryptedUsername;
  String clearUsername;
  String usernameSalt;
  String websiteUrl;
  String note;
  String displayName;
  String folderUuid;
  DateTime? createdTimeStamp;
  DateTime? changedTimeStamp;
  DateTime? deletedTimeStamp;

  static final Random _random = Random.secure();

  static String _createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  Credential({
    required this.websiteUrl,
    required this.clearUsername,
    required this.encryptedUsername,
    required this.encryptedPassword,
    required this.clearPassword,
    required this.displayName,
    required this.uuid,
    required this.passwordSalt,
    required this.usernameSalt,
    required this.note,
    required this.folderUuid,
    this.createdTimeStamp,
    this.changedTimeStamp,
    this.deletedTimeStamp,
  });

  /// Function to generate a Credential Object from API get requests
  static Future<Credential> fromApi({
    required String masterPassword,
    required String websiteUrl,
    required String encryptedUsername,
    required String encryptedPassword,
    required String displayName,
    required String uuid,
    required String passwordSalt,
    required String usernameSalt,
    required String note,
    required String folderUuid,
    required int createdTimeStamp,
    required int changedTimeStamp,
    required int deletedTimeStamp,
  }) async {
    //Encrypter encrypter = Encrypter(AES());
    return Credential(
      websiteUrl: websiteUrl,
      clearUsername: await Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: encryptedUsername, encryptedSalt: usernameSalt),
      encryptedUsername: encryptedUsername,
      encryptedPassword: encryptedPassword,
      clearPassword: await Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: encryptedPassword, encryptedSalt: passwordSalt),
      displayName: displayName,
      uuid: uuid,
      passwordSalt: passwordSalt,
      usernameSalt: usernameSalt,
      note: note,
      folderUuid: folderUuid,
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(createdTimeStamp),
      changedTimeStamp: DateTime.fromMillisecondsSinceEpoch(changedTimeStamp),
      deletedTimeStamp: DateTime.fromMillisecondsSinceEpoch(deletedTimeStamp),
    );
  }

  /// Function to generate a New Credential entry
  static Future<Credential> newEntry({
    required String masterPassword,
    required String uuid,
    required String websiteUrl,
    required String clearUsername,
    required String clearPassword,
    required String displayName,
    String note = "",
    required String folderUuid,
    required int createdTimeStamp,
  }) async {
    final passwordSalt = _createCryptoRandomString(10);
    final usernameSalt = _createCryptoRandomString(10);
    print(passwordSalt);
    Cryptography.getKDFBase64(masterPassword: masterPassword, salt: uuid).then(print);
    Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearPassword, encryptedSalt: passwordSalt).then(print);
    Cryptography.getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: "0y9P8H+AzqfAQQuLGB/MhQ==", encryptedSalt: "IU0e-CSGD6QK7g==").then(print);
    return Credential(
      uuid: uuid,
      websiteUrl: websiteUrl,
      clearUsername: clearUsername,
      encryptedUsername: await Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearUsername, encryptedSalt: usernameSalt),
      encryptedPassword: await Cryptography.encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearPassword, encryptedSalt: passwordSalt),
      clearPassword: clearPassword,
      displayName: displayName,
      passwordSalt: passwordSalt,
      usernameSalt: usernameSalt,
      note: note,
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(createdTimeStamp),
      folderUuid: folderUuid,
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
}

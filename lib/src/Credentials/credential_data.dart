import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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
  int folderUuid;
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
    required int folderUuid,
    required int createdTimeStamp,
    required int changedTimeStamp,
    required int deletedTimeStamp,
  }) async {
    //Encrypter encrypter = Encrypter(AES());
    return Credential(
      websiteUrl: websiteUrl,
      clearUsername: await getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: encryptedUsername, encryptedSalt: usernameSalt),
      encryptedUsername: encryptedUsername,
      encryptedPassword: encryptedPassword,
      clearPassword: await getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: encryptedPassword, encryptedSalt: passwordSalt),
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
  static Future<Credential> New({
    required String masterPassword,
    required String uuid,
    required String websiteUrl,
    required String clearUsername,
    required String clearPassword,
    required String displayName,
    String note = "",
    required int folderUuid,
    required int createdTimeStamp,
  }) async {
    final passwordSalt = _createCryptoRandomString(10);
    final usernameSalt = _createCryptoRandomString(10);
    print(passwordSalt);
    getKDFBase64(masterPassword: masterPassword, salt: uuid).then(print);
    encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearPassword, encryptedSalt: passwordSalt).then(print);
    getClearString(masterPassword: masterPassword, kdfSalt: uuid, encryptedString: "0y9P8H+AzqfAQQuLGB/MhQ==", encryptedSalt: "IU0e-CSGD6QK7g==").then(print);
    return Credential(
      uuid: uuid,
      websiteUrl: websiteUrl,
      clearUsername: clearUsername,
      encryptedUsername: await encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearUsername, encryptedSalt: usernameSalt),
      encryptedPassword: await encryptString(masterPassword: masterPassword, kdfSalt: uuid, clearString: clearPassword, encryptedSalt: passwordSalt),
      clearPassword: clearPassword,
      displayName: displayName,
      passwordSalt: passwordSalt,
      usernameSalt: usernameSalt,
      note: note,
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(createdTimeStamp),
      folderUuid: folderUuid,
    );
  }

  /// Returns an async String containing the encrypted content of [clearString] in base64.
  /// Needs the [masterPassword] and [kdfSalt] to generate the KDF and the [encryptedSalt] to encrypt.
  static Future<String> encryptString({required String masterPassword, required String kdfSalt, required String clearString, required String encryptedSalt}) async {
    return getKDFKey(masterPassword: masterPassword, salt: kdfSalt).then(
      (value) => encrypt.Encrypter(encrypt.AES(value))
          .encrypt(
            clearString,
            iv: encrypt.IV.fromUtf8(encryptedSalt),
          )
          .base64,
    );
  }

  /// Returns an async String containing the decrypted content of [encryptedString].
  /// Needs the [masterPassword] and [kdfSalt] to generate the KDF and the [encryptedSalt] to decrypt.
  static Future<String> getClearString({required String masterPassword, required String kdfSalt, required String encryptedString, required String encryptedSalt}) async {
    try {
      return getKDFKey(masterPassword: masterPassword, salt: kdfSalt).then(
        (value) => encrypt.Encrypter(encrypt.AES(value)).decrypt64(
          encryptedString,
          iv: encrypt.IV.fromUtf8(encryptedSalt),
        ),
      );
    } catch (error) {
      throw ArgumentError("Decryption Arguments do not match encrypted String");
    }
  }

  Future<String> getEncryptedPassword({required String masterPassword}) async {
    return encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this.clearPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getClearPassword({required String masterPassword}) async {
    return getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this.encryptedPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getEncryptedUsername({required String masterPassword}) async {
    return encryptString(masterPassword: masterPassword, kdfSalt: this.uuid, clearString: this.clearPassword, encryptedSalt: this.passwordSalt);
  }

  Future<String> getClearUsername({required String masterPassword}) async {
    return getClearString(masterPassword: masterPassword, kdfSalt: this.uuid, encryptedString: this.encryptedPassword, encryptedSalt: this.passwordSalt);
  }

  /// Async function to generate a KDF in byte form.
  static Future<Uint8List> getKDFBytes({required String masterPassword, required String salt}) async {
    return Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000, // 20k iterations
      bits: 256, // 256 bits = 32 bytes output
    ).deriveKeyFromPassword(password: masterPassword, nonce: utf8.encode(salt)).then((kdf) => kdf.extractBytes().then((value) => Uint8List.fromList(value)));
  }

  /// Async function to generate a KDF in encrypt.key form for AES de-/encryption.
  static Future<encrypt.Key> getKDFKey({required String masterPassword, required String salt}) async {
    return getKDFBytes(masterPassword: masterPassword, salt: salt).then((value) => encrypt.Key(value));
  }

  /// Async function to generate a KDF in base64 form.
  static Future<String> getKDFBase64({required String masterPassword, required String salt}) async {
    return getKDFBytes(masterPassword: masterPassword, salt: salt).then((value) => base64Encode(value));
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Credential {
  final String uuid;
  String password;
  String passwordSalt;
  String username;
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
    required this.username,
    required this.password,
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

  Future<Credential> fromApi({
    required String masterPassword,
    required String websiteUrl,
    required String username,
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
      username: username,
      password: await getClearPassword(masterPassword: masterPassword, kdfSalt: uuid, encryptedPassword: encryptedPassword, encryptedSalt: passwordSalt),
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

  static Credential New({
    required String masterPassword,
    required String uuid,
    required String websiteUrl,
    required String username,
    required String clearPassword,
    required String displayName,
    String note = "",
    required int folderUuid,
    required int createdTimeStamp,
  }) {
    final passwordSalt = _createCryptoRandomString(10);
    print(passwordSalt);
    encryptPassword(masterPassword: masterPassword, kdfSalt: uuid, clearPassword: clearPassword, encryptedSalt: passwordSalt).then(print);
    getClearPassword(masterPassword: masterPassword, kdfSalt: uuid, encryptedPassword: "0y9P8H+AzqfAQQuLGB/MhQ==", encryptedSalt: "IU0e-CSGD6QK7g==").then(print);
    return Credential(
      uuid: uuid,
      websiteUrl: websiteUrl,
      username: username,
      password: clearPassword,
      displayName: displayName,
      passwordSalt: passwordSalt,
      usernameSalt: _createCryptoRandomString(32),
      note: note,
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(createdTimeStamp),
      folderUuid: folderUuid,
    );
  }

  static Future<String> encryptPassword({required String masterPassword, required String kdfSalt, required String clearPassword, required String encryptedSalt}) async {
    return getKDF(masterPassword: masterPassword, salt: kdfSalt).then(
      (value) => encrypt.Encrypter(encrypt.AES(value)).encrypt(
        clearPassword,
        iv: encrypt.IV.fromUtf8(encryptedSalt),
      ).base64,
    );
  }

  static Future<String> getClearPassword({required String masterPassword, required String kdfSalt, required String encryptedPassword, required String encryptedSalt}) async {
    return getKDF(masterPassword: masterPassword, salt: kdfSalt).then(
      (value) => encrypt.Encrypter(encrypt.AES(value)).decrypt64(
        encryptedPassword,
        iv: encrypt.IV.fromUtf8(encryptedSalt),
      ),
    );
  }

  static Future<encrypt.Key> getKDF({required String masterPassword, required String salt}) async {
    return Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 10000, // 20k iterations
      bits: 256, // 256 bits = 32 bytes output
    ).deriveKeyFromPassword(password: masterPassword, nonce: utf8.encode(salt)).then((kdf) => kdf.extractBytes().then((value) => encrypt.Key(Uint8List.fromList(value))));
  }
}

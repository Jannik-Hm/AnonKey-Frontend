import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

enum KDFMode { credential, master }

class Cryptography {
  static final Random _random = Random.secure();

  static final Pbkdf2 _credentialKDF = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 1000, // 1k iterations for credentials
    bits: 256,
  );
  static final Pbkdf2 _masterKDF = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 20000, // 20k iterations for auth, etc.
    bits: 256,
  );

  /// function to generate pseudo Random String for Random Salt generation
  static String createCryptoRandomString([int length = 32]) {
    int byteLength = 3 * (length ~/ 4) - 2;
    var values = List<int>.generate(byteLength, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  static Future<Uint8List> getKDFBytes(
      {required String masterPassword,
      required String salt,
      KDFMode kdfMode = KDFMode.master}) async {
    Pbkdf2 kdfObject;
    switch (kdfMode) {
      case KDFMode.credential:
        kdfObject = _credentialKDF;
        break;
      case KDFMode.master:
        kdfObject = _masterKDF;
        break;
      default:
        kdfObject = _masterKDF;
    }
    return kdfObject
        .deriveKeyFromPassword(
            password: masterPassword, nonce: utf8.encode(salt))
        .then((kdf) =>
            kdf.extractBytes().then((value) => Uint8List.fromList(value)));
  }

  /// Async function to generate a KDF in encrypt.key form for AES de-/encryption.
  static Future<encrypt.Key> getKDFKey(
      {required String masterPassword,
      required String salt,
      KDFMode kdfMode = KDFMode.master}) async {
    return getKDFBytes(
            masterPassword: masterPassword, salt: salt, kdfMode: kdfMode)
        .then((value) => encrypt.Key(value));
  }

  /// Async function to generate a KDF in base64 form.
  static Future<String> getKDFBase64(
      {required String masterPassword,
      required String salt,
      KDFMode kdfMode = KDFMode.master}) async {
    return getKDFBytes(
            masterPassword: masterPassword, salt: salt, kdfMode: kdfMode)
        .then((value) => base64Encode(value));
  }

  /// Returns an async String containing the encrypted content of [clearString] in base64.
  ///
  /// Needs the [kdfKey] as Key and the [encryptedSalt] to encrypt.
  static Future<String> encryptStringWithKey(
      {required encrypt.Key kdfKey,
      required String clearString,
      required String encryptedSalt}) async {
    return (clearString.isEmpty)
        ? ""
        : encrypt.Encrypter(encrypt.AES(kdfKey, mode: encrypt.AESMode.sic, padding: 'PKCS7'))
            .encrypt(
              clearString,
              iv: encrypt.IV.fromUtf8(encryptedSalt),
            )
            .base64;
  }

  /// Returns an async String containing the encrypted content of [clearString] in base64.
  ///
  /// Needs the [masterPassword] and [kdfSalt] to generate the KDF and the [encryptedSalt] to encrypt.
  static Future<String> encryptString(
      {required String masterPassword,
      required String kdfSalt,
      required String clearString,
      required String encryptedSalt,
      KDFMode kdfMode = KDFMode.master}) async {
    return (clearString.isEmpty)
        ? ""
        : await getKDFKey(
                masterPassword: masterPassword, salt: kdfSalt, kdfMode: kdfMode)
            .then(
            (value) => encrypt.Encrypter(encrypt.AES(value, mode: encrypt.AESMode.sic, padding: 'PKCS7'))
                .encrypt(
                  clearString,
                  iv: encrypt.IV.fromUtf8(encryptedSalt),
                )
                .base64,
          );
  }

  /// Returns an async String containing the decrypted content of [encryptedString].
  ///
  /// Needs the [kdfKey] as Key and the [encryptedSalt] to decrypt.
  static Future<String> getClearStringWithKey(
      {required encrypt.Key kdfKey,
      required String encryptedString,
      required String encryptedSalt}) async {
    if (encryptedString.isEmpty) {
      return "";
    } else {
      try {
        return encrypt.Encrypter(encrypt.AES(kdfKey, mode: encrypt.AESMode.sic, padding: 'PKCS7')).decrypt64(
          encryptedString,
          iv: encrypt.IV.fromUtf8(encryptedSalt),
        );
      } catch (error) {
        throw ArgumentError(
            "Decryption Arguments do not match encrypted String");
      }
    }
  }

  /// Returns an async String containing the decrypted content of [encryptedString].
  ///
  /// Needs the [masterPassword] and [kdfSalt] to generate the KDF and the [encryptedSalt] to decrypt.
  static Future<String> getClearString(
      {required String masterPassword,
      required String kdfSalt,
      required String encryptedString,
      required String encryptedSalt,
      KDFMode kdfMode = KDFMode.master}) async {
    if (encryptedString.isEmpty) {
      return "";
    } else {
      try {
        return getKDFKey(
                masterPassword: masterPassword, salt: kdfSalt, kdfMode: kdfMode)
            .then(
          (value) => encrypt.Encrypter(encrypt.AES(value, mode: encrypt.AESMode.sic, padding: 'PKCS7')).decrypt64(
            encryptedString,
            iv: encrypt.IV.fromUtf8(encryptedSalt),
          ),
        );
      } catch (error) {
        throw ArgumentError(
            "Decryption Arguments do not match encrypted String");
      }
    }
  }
}

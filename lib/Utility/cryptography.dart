import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class Cryptography {
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
}
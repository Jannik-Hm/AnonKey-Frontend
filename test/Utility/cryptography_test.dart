import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String encryptionKDF;
  late Key credentialKDF;
  late String uuid;

  setUpAll(() async {
    uuid = "ebd1ef35-cade-4e2a-8117-3ed58bd13143";
    encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: "test1234",
      salt: "anonkey_encryption",
      kdfMode: KDFMode.master,
    );
    credentialKDF = await Cryptography.getKDFKey(
      masterPassword: encryptionKDF,
      salt: uuid,
      kdfMode: KDFMode.credential,
    );
  });

  test('Generate KDFBase64', () async {
    String kdfKey = await Cryptography.getKDFBase64(
      masterPassword: "test1234",
      salt: "anonkey_authentication",
    );
    expect(kdfKey, "iWhH930n2YxEYnGSXr71Lz7U20zu45A//I13Sw3xxrY=");
  });

  group('Encryption', () {
    test('- With given KDF', () async {
      String encryptedString = await Cryptography.encryptStringWithKey(
        clearString: "Google",
        encryptedSalt: "FkC3woj-MPraog==",
        kdfKey: credentialKDF,
      );
      expect(encryptedString, "xFW26xJ+GvhxerJPEqfGBw==");
    });

    test('- With given Password', () async {
      String encryptedString = await Cryptography.encryptString(
        clearString: "Google",
        encryptedSalt: "FkC3woj-MPraog==",
        masterPassword: encryptionKDF,
        kdfSalt: uuid,
        kdfMode: KDFMode.credential,
      );
      expect(encryptedString, "xFW26xJ+GvhxerJPEqfGBw==");
    });
  });

  group('Decryption', () {
    test('- With given KDF', () async {
      String decryptedString = await Cryptography.getClearStringWithKey(
        encryptedString: "is4zOsVVvc4P/gdbyzeAlA==",
        encryptedSalt: "y8MA8gqAo7Bm6A==",
        kdfKey: credentialKDF,
      );
      expect(decryptedString, "Test");
    });

    test('- With given Password', () async {
      String decryptedString = await Cryptography.getClearString(
        encryptedString: "is4zOsVVvc4P/gdbyzeAlA==",
        encryptedSalt: "y8MA8gqAo7Bm6A==",
        masterPassword: encryptionKDF,
        kdfSalt: uuid,
        kdfMode: KDFMode.credential,
      );
      expect(decryptedString, "Test");
    });
  });

  group('En- and Decryption', () {
    test('- With given KDF', () async {
      String origin = "Test1234";
      String randomSalt = Cryptography.createCryptoRandomString(16);
      String encryptedString = await Cryptography.encryptStringWithKey(
        clearString: origin,
        encryptedSalt: randomSalt,
        kdfKey: credentialKDF,
      );
      String decryptedString = await Cryptography.getClearStringWithKey(
        encryptedString: encryptedString,
        encryptedSalt: randomSalt,
        kdfKey: credentialKDF,
      );
      expect(decryptedString, origin);
    });

    test('- With given Password', () async {
      String origin = "Test1234";
      String randomSalt = Cryptography.createCryptoRandomString(16);
      String encryptedString = await Cryptography.encryptString(
        clearString: origin,
        encryptedSalt: randomSalt,
        masterPassword: encryptionKDF,
        kdfSalt: uuid,
        kdfMode: KDFMode.credential,
      );
      String decryptedString = await Cryptography.getClearString(
        encryptedString: encryptedString,
        encryptedSalt: randomSalt,
        masterPassword: encryptionKDF,
        kdfSalt: uuid,
        kdfMode: KDFMode.credential,
      );
      expect(decryptedString, origin);
    });
  });
}

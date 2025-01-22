import 'package:anonkey_frontend/Utility/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:test/test.dart';

void main() {
  late String encryptionKDF;
  late Key credentialKDF;

  setUpAll(() async {
    encryptionKDF = await Cryptography.getKDFBase64(
      masterPassword: "test1234",
      salt: "anonkey_encryption",
      kdfMode: KDFMode.master,
    );
    credentialKDF = await Cryptography.getKDFKey(
      masterPassword: encryptionKDF,
      salt: "ebd1ef35-cade-4e2a-8117-3ed58bd13143",
      kdfMode: KDFMode.credential,
    );
  });

  test('Generate KDF', () async {
    String kdfKey = await Cryptography.getKDFBase64(
      masterPassword: "test1234",
      salt: "anonkey_authentication",
    );
    expect(kdfKey, "iWhH930n2YxEYnGSXr71Lz7U20zu45A//I13Sw3xxrY=");
  });

  group('Encryption', () {
    test('Encrypt with given KDF', () async {
      String encryptedString = await Cryptography.encryptStringWithKey(
        clearString: "Google",
        encryptedSalt: "FkC3woj-MPraog==",
        kdfKey: credentialKDF,
      );
      expect(encryptedString, "xFW26xJ+GvhxerJPEqfGBw==");
    });

    test('Encrypt with given MasterPassword', () async {
      String encryptedString = await Cryptography.encryptString(
        clearString: "Google",
        encryptedSalt: "FkC3woj-MPraog==",
        masterPassword: encryptionKDF,
        kdfSalt: "ebd1ef35-cade-4e2a-8117-3ed58bd13143",
        kdfMode: KDFMode.credential,
      );
      expect(encryptedString, "xFW26xJ+GvhxerJPEqfGBw==");
    });
  });

  group('Decryption', () {
    test('Decrypt with given KDF', () async {
      String decryptedString = await Cryptography.getClearStringWithKey(
        encryptedString: "is4zOsVVvc4P/gdbyzeAlA==",
        encryptedSalt: "y8MA8gqAo7Bm6A==",
        kdfKey: credentialKDF,
      );
      expect(decryptedString, "Test");
    });

    test('Decrypt with given MasterPassword', () async {
      String decryptedString = await Cryptography.getClearString(
        encryptedString: "is4zOsVVvc4P/gdbyzeAlA==",
        encryptedSalt: "y8MA8gqAo7Bm6A==",
        masterPassword: encryptionKDF,
        kdfSalt: "ebd1ef35-cade-4e2a-8117-3ed58bd13143",
        kdfMode: KDFMode.credential,
      );
      expect(decryptedString, "Test");
    });
  });
}

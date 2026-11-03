import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;

class DramaCrypto {
  static const String defaultKey = "0123456789abcdef";
  static const String defaultIv = "fedcba9876543210";

  /// Encrypts plain text or JSON payload using AES-128-CBC with PKCS7 padding.
  /// Generates the standard Drama Live envelope: `Base64(IV):Base64(Ciphertext)`.
  static String encrypt(
    String plainText, {
    String keyStr = defaultKey,
    String ivStr = defaultIv,
  }) {
    try {
      // Key normalization to 16 bytes (padded with '0' or truncated)
      String normalizedKey = keyStr;
      if (normalizedKey.length < 16) {
        normalizedKey = normalizedKey.padRight(16, '0');
      } else if (normalizedKey.length > 16) {
        normalizedKey = normalizedKey.substring(0, 16);
      }

      final keyBytes = Uint8List.fromList(latin1.encode(normalizedKey));
      final ivBytes = Uint8List.fromList(latin1.encode(ivStr.substring(0, 16)));

      final key = enc.Key(keyBytes);
      final iv = enc.IV(ivBytes);

      final encrypter = enc.Encrypter(
        enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'),
      );

      final encrypted = encrypter.encrypt(plainText, iv: iv);

      final base64Iv = base64.encode(ivBytes);
      final base64Cipher = encrypted.base64;

      return "$base64Iv:$base64Cipher";
    } catch (e) {
      // Fallback
      return plainText;
    }
  }

  /// Decrypts Drama Live `Base64(IV):Base64(Ciphertext)` envelope into plain UTF-8 string.
  static String decrypt(
    String encryptedEnvelope, {
    String keyStr = defaultKey,
  }) {
    try {
      final parts = encryptedEnvelope.trim().split(':');
      if (parts.length != 2) {
        return encryptedEnvelope;
      }

      final ivBytes = base64.decode(parts[0]);
      final cipherBytes = base64.decode(parts[1]);

      String normalizedKey = keyStr;
      if (normalizedKey.length < 16) {
        normalizedKey = normalizedKey.padRight(16, '0');
      } else if (normalizedKey.length > 16) {
        normalizedKey = normalizedKey.substring(0, 16);
      }

      final keyBytes = Uint8List.fromList(latin1.encode(normalizedKey));
      final key = enc.Key(keyBytes);
      final iv = enc.IV(ivBytes);

      final encrypter = enc.Encrypter(
        enc.AES(key, mode: enc.AESMode.cbc, padding: 'PKCS7'),
      );

      final decrypted = encrypter.decrypt(
        enc.Encrypted(cipherBytes),
        iv: iv,
      );

      return decrypted;
    } catch (e) {
      return encryptedEnvelope;
    }
  }
}

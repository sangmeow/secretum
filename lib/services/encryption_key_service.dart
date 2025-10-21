import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Service for managing AES-256-GCM encryption keys
/// Generates, stores, and retrieves encryption keys securely
class EncryptionKeyService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Storage key for the AES encryption key
  static const String _aesKeyStorageKey = 'aes_encryption_key';

  /// Generate a random 256-bit (32 bytes) AES key
  /// Returns the key as a base64-encoded string
  static String generateAesKey() {
    final random = Random.secure();
    final keyBytes = Uint8List(32); // 256 bits = 32 bytes

    for (int i = 0; i < keyBytes.length; i++) {
      keyBytes[i] = random.nextInt(256);
    }

    // Convert to base64 for storage
    final base64Key = base64Encode(keyBytes);
    debugPrint('✅ AES-256 key generated successfully');
    return base64Key;
  }

  /// Save the AES encryption key to secure storage
  static Future<void> saveEncryptionKey(String key) async {
    try {
      await _storage.write(key: _aesKeyStorageKey, value: key);
      debugPrint('✅ AES encryption key saved to secure storage');
    } catch (e) {
      debugPrint('❌ Error saving encryption key: $e');
      rethrow;
    }
  }

  /// Retrieve the AES encryption key from secure storage
  /// Returns null if no key exists
  static Future<String?> getEncryptionKey() async {
    try {
      final key = await _storage.read(key: _aesKeyStorageKey);
      if (key != null) {
        debugPrint('✅ AES encryption key retrieved from secure storage');
      } else {
        debugPrint('⚠️ No encryption key found in secure storage');
      }
      return key;
    } catch (e) {
      debugPrint('❌ Error retrieving encryption key: $e');
      return null;
    }
  }

  /// Delete the AES encryption key from secure storage
  static Future<void> deleteEncryptionKey() async {
    try {
      await _storage.delete(key: _aesKeyStorageKey);
      debugPrint('✅ AES encryption key deleted from secure storage');
    } catch (e) {
      debugPrint('❌ Error deleting encryption key: $e');
      rethrow;
    }
  }

  /// Check if an encryption key exists
  static Future<bool> hasEncryptionKey() async {
    final key = await getEncryptionKey();
    return key != null;
  }

  /// Generate and save a new AES encryption key
  /// Returns the generated key
  static Future<String> generateAndSaveKey() async {
    final key = generateAesKey();
    await saveEncryptionKey(key);
    return key;
  }
}

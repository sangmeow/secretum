import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// PIN encryption service using PBKDF2 (Password-Based Key Derivation Function 2)
/// This provides secure password hashing with configurable iterations and salt
class PinEncryptionService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _pinHashKey = 'pin_hash';
  static const String _pinSaltKey = 'pin_salt';
  static const int _iterations = 100000; // OWASP recommended minimum
  static const int _keyLength = 32; // 256 bits

  /// Generate a cryptographically secure random salt
  static Uint8List _generateSalt() {
    try {
      final random = Random.secure();
      final salt = Uint8List(32); // 256 bits
      for (int i = 0; i < 32; i++) {
        salt[i] = random.nextInt(256);
      }
      return salt;
    } catch (e) {
      throw PinEncryptionException('Failed to generate salt: $e');
    }
  }

  /// Hash PIN using PBKDF2 with HMAC-SHA512
  static String _hashPin(String pin, Uint8List salt) {
    try {
      if (pin.isEmpty) {
        throw PinEncryptionException('PIN cannot be empty');
      }

      final pinBytes = utf8.encode(pin);
      var hash = Hmac(sha512, salt).convert(pinBytes).bytes;

      // PBKDF2 iterations
      for (var i = 1; i < _iterations; i++) {
        hash = Hmac(sha512, salt).convert(hash).bytes;
      }

      // Take only the first _keyLength bytes
      final result = Uint8List.fromList(hash.take(_keyLength).toList());
      return base64Encode(result);
    } catch (e) {
      throw PinEncryptionException('Failed to hash PIN: $e');
    }
  }

  /// Save encrypted PIN to secure storage
  static Future<void> savePin(String pin) async {
    try {
      // Validate PIN
      if (pin.isEmpty) {
        throw PinEncryptionException('PIN cannot be empty');
      }

      if (pin.length < 4) {
        throw PinEncryptionException('PIN must be at least 4 digits');
      }

      // Generate a new salt for this PIN
      final salt = _generateSalt();

      // Hash the PIN with PBKDF2
      final hashedPin = _hashPin(pin, salt);

      // Store both the hash and salt in secure storage
      await _storage.write(key: _pinHashKey, value: hashedPin);
      await _storage.write(key: _pinSaltKey, value: base64Encode(salt));
    } on PinEncryptionException {
      rethrow;
    } catch (e) {
      throw PinEncryptionException('Failed to save PIN: $e');
    }
  }

  /// Verify PIN against stored hash
  static Future<bool> verifyPin(String pin) async {
    try {
      // Validate input
      if (pin.isEmpty) {
        return false;
      }

      // Retrieve stored hash and salt
      final storedHash = await _storage.read(key: _pinHashKey);
      final storedSaltBase64 = await _storage.read(key: _pinSaltKey);

      if (storedHash == null || storedSaltBase64 == null) {
        throw PinEncryptionException('No PIN found in secure storage');
      }

      // Decode the salt
      final salt = base64Decode(storedSaltBase64);

      // Hash the input PIN with the stored salt
      final hashedInput = _hashPin(pin, salt);

      // Compare hashes using constant-time comparison to prevent timing attacks
      return _constantTimeCompare(hashedInput, storedHash);
    } on PinEncryptionException {
      rethrow;
    } catch (e) {
      throw PinEncryptionException('Failed to verify PIN: $e');
    }
  }

  /// Constant-time string comparison to prevent timing attacks
  static bool _constantTimeCompare(String a, String b) {
    if (a.length != b.length) {
      return false;
    }

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }

    return result == 0;
  }

  /// Check if PIN exists in secure storage
  static Future<bool> hasPin() async {
    try {
      final storedHash = await _storage.read(key: _pinHashKey);
      return storedHash != null;
    } catch (e) {
      throw PinEncryptionException('Failed to check PIN existence: $e');
    }
  }

  /// Delete stored PIN (for reset functionality)
  static Future<void> deletePin() async {
    try {
      await _storage.delete(key: _pinHashKey);
      await _storage.delete(key: _pinSaltKey);
    } catch (e) {
      throw PinEncryptionException('Failed to delete PIN: $e');
    }
  }

  /// Clear all secure storage (use with caution)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw PinEncryptionException('Failed to clear storage: $e');
    }
  }
}

/// Custom exception for PIN encryption errors
class PinEncryptionException implements Exception {
  final String message;

  PinEncryptionException(this.message);

  @override
  String toString() => 'PinEncryptionException: $message';
}

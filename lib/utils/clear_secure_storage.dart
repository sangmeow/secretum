import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Utility function to clear all data from FlutterSecureStorage
/// This is useful for testing and development
Future<void> clearSecureStorage() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  try {
    await storage.deleteAll();
    debugPrint('✅ FlutterSecureStorage cleared successfully');
  } catch (e) {
    debugPrint('❌ Error clearing FlutterSecureStorage: $e');
  }
}

/// Clear all data from SharedPreferences
/// This is useful for testing and development
Future<void> clearSharedPreferences() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint('✅ SharedPreferences cleared successfully');
  } catch (e) {
    debugPrint('❌ Error clearing SharedPreferences: $e');
  }
}

/// Clear Hive secretum box
/// This is useful for clearing all secrets during testing and development
Future<void> clearHiveSecretum() async {
  try {
    final box = Hive.box('secretum');
    await box.clear();
    debugPrint('✅ Hive secretum box cleared successfully');
  } catch (e) {
    debugPrint('❌ Error clearing Hive secretum box: $e');
  }
}

/// Clear all app storage (FlutterSecureStorage, SharedPreferences, and Hive)
/// This is useful for complete reset during testing and development
Future<void> clearAllStorage() async {
  await Future.wait([
    clearSecureStorage(),
    clearSharedPreferences(),
    clearHiveSecretum(),
  ]);
  debugPrint('✅ All storage cleared successfully');
}

/// Clear specific PIN-related data from FlutterSecureStorage
Future<void> clearPinData() async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  try {
    await storage.delete(key: 'pin_hash');
    await storage.delete(key: 'pin_salt');
    await storage.delete(key: 'aes_encryption_key');
    debugPrint('✅ PIN and encryption key data cleared successfully');
  } catch (e) {
    debugPrint('❌ Error clearing PIN data: $e');
  }
}

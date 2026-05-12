import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:indogrip/core/database/hive_keys.dart';
import 'package:indogrip/features/auth/presentation/view/login_panel.dart';

/// Service class for managing local storage using Hive
class HiveService {
  static const String _boxName = 'appBox';
  static Box<dynamic>? _box;

  // Common keys
  static const String kUserId = 'userId';
  static const String kUserName = 'userName';
  static const String kEmail = 'email';
  static const String kPhone = 'phone';
  static const String kRole = 'role';
  static const String kIsLoggedIn = 'isLoggedIn';
  static const String kAuthToken = 'authToken';
  static const String kLastLogin = 'lastLogin';
  static const String kTheme = 'theme';
  static const String kLanguage = 'language';
  static const String kAppVersion = 'appVersion';
  static const String kAppBuildNumber = 'appBuildNumber';
  static const String kAppInstallMarker =
      'appInstallMarker'; // NEW: Track app installation

  // Update this version number whenever you release a new version
  // This helps clear stale login data when app is updated or reinstalled
  static const String currentAppVersion = '1.12.0';

  /// Initialize Hive and open box
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);

    // Check if this is a fresh install/reinstall on desktop
    // Clear old login data to force re-login
    await _validateAndClearStaleData();
  }

  /// Validate app data and clear stale login info from previous sessions
  /// This helps fix the issue where reinstalled apps still show "already logged in"
  static Future<void> _validateAndClearStaleData() async {
    try {
      final previousInstallMarker = get(kAppInstallMarker);
      final currentInstallMarker = DateTime.now().year
          .toString(); // Changes yearly

      // Generate a unique marker for this app installation/version
      // This helps detect app reinstalls or version changes
      final installMarker = '$currentAppVersion-$currentInstallMarker';

      // If installation marker doesn't exist (first time) or doesn't match (reinstalled)
      // then clear all login data to force re-authentication
      if (previousInstallMarker == null ||
          previousInstallMarker != installMarker) {
        await clearLoginData(); // Force clear on app install/version change
        await save(key: kAppInstallMarker, value: installMarker);
        return;
      }

      // Check version change
      final storedVersion = get(kAppVersion);
      if (storedVersion == null || storedVersion != currentAppVersion) {
        await clearAllData();
        await save(key: kAppVersion, value: currentAppVersion);
        return;
      }

      // Check if last login was more than 30 days ago
      final lastLogin = getLastLogin();
      if (lastLogin != null) {
        final daysSinceLogin = DateTime.now().difference(lastLogin).inDays;
        if (daysSinceLogin > 30) {
          await clearAllData();
        }
      }
    } catch (e) {
      print('Error validating data: $e');
    }
  }

  /// Clear login data for fresh login on reinstall
  /// Call this when you need to force users to login again
  /// This clears all authentication tokens and user session info
  static Future<void> clearLoginData() async {
    try {
      // Clear authentication tokens
      await delete(kAuthToken);
      await delete(kIsLoggedIn);
      await delete(kLastLogin);

      // Clear user info
      await delete(kUserId);
      await delete(kUserName);
      await delete(kEmail);
      await delete(kPhone);
      await delete(kRole);

      // Clear all HiveKeys user data
      await clearUserData();
    } catch (e) {
      print('Error clearing login data: $e');
    }
  }

  /// Save a value with key
  static Future<void> save({
    required String key,
    required dynamic value,
  }) async {
    await _box?.put(key, value);
  }

  /// Get a value by key
  static dynamic get(String key) {
    return _box?.get(key);
  }

  /// Delete a value by key
  static Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  /// Check if key exists
  static bool hasKey(String key) {
    return _box?.containsKey(key) ?? false;
  }

  /// Get all keys
  static List<dynamic> getAllKeys() {
    return _box?.keys.toList() ?? [];
  }

  /// Save login information
  static Future<void> saveLoginInfo({
    required String userId,
    required String userName,
    required String email,
    String? phone,
    required String role,
    required String token,
  }) async {
    await save(key: kUserId, value: userId);
    await save(key: kUserName, value: userName);
    await save(key: kEmail, value: email);
    if (phone != null) await save(key: kPhone, value: phone);
    await save(key: kRole, value: role);
    await save(key: kAuthToken, value: token);
    await save(key: kIsLoggedIn, value: true);
    await save(key: kLastLogin, value: DateTime.now().toIso8601String());
  }

  /// Check if user is logged in
  static bool get isLoggedIn => get(kIsLoggedIn) ?? false;

  /// Get auth token
  static String? getAuthToken() => get(kAuthToken);

  /// Get user ID
  static String? getUserId() => get(HiveKeys.userIDKey);

  /// Get user Email

  static String? getUserEmail() => get(HiveKeys.emailKey);

  /// Get user name
  static String? getFName() => get(HiveKeys.fNameKey);

  /// Get user last name
  static String? getLName() => get(HiveKeys.lNameKey);

  /// Get user mobile number
  static String? getMobile() => get(HiveKeys.mobileKey);

  ///Get alternate mobile number
  static String? getAlternateMobile() => get(HiveKeys.alternateMobileKey);

  /// Get user email
  static String? getEmail() => get(HiveKeys.emailKey);

  /// Get user role
  static String? getRole() => get(HiveKeys.role);

  static String? userImage() => get(HiveKeys.userImage);

  static String? getPanels() => get(HiveKeys.panels);

  //  static String? getPan() => get(HiveKeys.panels);

  /// Get last login time
  static DateTime? getLastLogin() {
    final lastLogin = get(kLastLogin);
    if (lastLogin != null) {
      return DateTime.parse(lastLogin);
    }
    return null;
  }

  /// Clear user session (logout)
  /// This completely clears all login data and user information
  /// ensuring user must login again on next app launch
  static Future<void> logout(BuildContext context) async {
    try {
      // Clear all user login data first
      await clearUserData();
      await clearLoginData();

      // Close box
      if (_box?.isOpen ?? false) {
        await _box?.close();
      }

      // Delete box from disk completely
      try {
        await Hive.deleteBoxFromDisk(_boxName);
      } catch (e) {
        print('Could not delete box from disk: $e');
      }

      // Clear Hive's in-memory cache
      await Hive.close();

      // Reinitialize the box for continued app usage
      _box = await Hive.openBox(_boxName);

      // Navigate to login
      if (context.mounted) {
        GoRouter.of(context).goNamed(IndoGripLoginPanel.routeName);
      }
    } catch (e) {
      print('Error during logout: $e');
      // Still try to navigate to login even if error occurred
      try {
        if (context.mounted) {
          GoRouter.of(context).goNamed(IndoGripLoginPanel.routeName);
        }
      } catch (navError) {
        print('Navigation error: $navError');
      }
    }
  }

  /// Clear all data in the box
  static Future<void> clearAll() async {
    try {
      await _box?.clear();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  /// Clear all user data (more aggressive than clearAll)
  /// This will completely delete all stored data and can be used
  /// when user wants to clear app data before uninstalling
  static Future<void> clearAllData() async {
    try {
      // First clear all user and login data
      await clearUserData();
      await clearLoginData();

      // Close the box
      if (_box?.isOpen ?? false) {
        await _box?.close();
      }

      // Delete the entire box from disk
      try {
        await Hive.deleteBoxFromDisk(_boxName);
      } catch (e) {
        print('Could not delete box: $e');
      }

      // Clear Hive's registry
      await Hive.close();

      // Reinitialize Hive and the box for continued app usage
      await init();
    } catch (e) {
      print('Error clearing all data: $e');
      rethrow;
    }
  }

  /// Clear specific user data while keeping app settings
  static Future<void> clearUserData() async {
    try {
      await delete(kUserId);
      await delete(kUserName);
      await delete(kEmail);
      await delete(kPhone);
      await delete(kRole);
      await delete(kAuthToken);
      await delete(kIsLoggedIn);
      await delete(kLastLogin);

      // Also delete from HiveKeys
      await delete(HiveKeys.userIDKey);
      await delete(HiveKeys.emailKey);
      await delete(HiveKeys.fNameKey);
      await delete(HiveKeys.lNameKey);
      await delete(HiveKeys.mobileKey);
      await delete(HiveKeys.alternateMobileKey);
      await delete(HiveKeys.personalEmailKey);
      await delete(HiveKeys.userImage);
    } catch (e) {
      print('Error clearing user data: $e');
      rethrow;
    }
  }
}

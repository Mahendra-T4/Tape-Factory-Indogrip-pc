import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class EnvConfig {
  static String get indoGripBaseUrl => dotenv.env['IndoGrip_BASE_URL2'] ?? '';
  // static String get accountSureBaseUrl =>
  //     dotenv.env['IndoGrip_BASE_URL2'] ?? '';
  //  ?? 'http://accountsure.in/development/app/inventory/TFour/software-api/'dindex.php';
  static String get apiKey => dotenv.env['API_KEY'] ?? 'tfour2444666668888888';
  static String get appName => dotenv.env['APP_NAME'] ?? 'TFour PC';
  static String get environment => dotenv.env['ENV'] ?? 'development';
  static String get encryptionKey =>
      dotenv.env['ENCRYPTION_KEY'] ?? 'default32charencryptionkeyhere123456';

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
      developer.log('Environment loaded successfully', name: 'EnvConfig');
      _validateConfig();
    } catch (e) {
      developer.log(
        'Error loading .env file, using default values',
        name: 'EnvConfig',
        error: e,
      );
      // Don't rethrow - use default values instead
    }
  }

  static void _validateConfig() {
    if (indoGripBaseUrl.isEmpty) {
      developer.log('Warning: TFour_BASE_URL is empty', name: 'EnvConfig');
    }
    if (apiKey.isEmpty) {
      developer.log('Warning: API_KEY is empty', name: 'EnvConfig');
    }
  }
}

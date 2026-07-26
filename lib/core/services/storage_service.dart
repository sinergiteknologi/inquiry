import 'package:shared_preferences/shared_preferences.dart';

abstract final class StorageService {
  static const _isConnectKey = 'isConnect';
  static const _isUrlKey = 'isUrl';

  static Future<bool> isConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isConnectKey) ?? false;
  }

  static Future<String?> getServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_isUrlKey);
  }

  static Future<void> saveConnection({
    required String serverUrl,
    required bool isConnected,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isConnectKey, isConnected);
    await prefs.setString(_isUrlKey, serverUrl);
  }

  static Future<void> clearConnection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

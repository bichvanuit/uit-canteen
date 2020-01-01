import 'package:shared_preferences/shared_preferences.dart';
class Token {
  final String _storageKeyMobileToken = "token";
  final String _storageKeyMobileWating = "waiting";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getMobileToken() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileToken) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------
  Future<bool> setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileToken, token);
  }

  Future<String> getMobileWaiting() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString(_storageKeyMobileWating) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------
  Future<bool> setMobileWaiting(String token) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString(_storageKeyMobileWating, token);
  }

  Future<bool> removeMobileWaiting() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.remove(_storageKeyMobileWating);
  }

  Future<bool> removeMobileToken() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.remove(_storageKeyMobileToken);
  }

}
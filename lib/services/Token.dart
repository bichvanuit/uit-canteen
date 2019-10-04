import 'package:shared_preferences/shared_preferences.dart';
class Token {
  final String _storageKeyMobileToken = "token";

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
}
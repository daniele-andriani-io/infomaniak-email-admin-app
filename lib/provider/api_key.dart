import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyProvider {
  late final SharedPreferences _prefs;
  static const String KEY_NAME = 'API_KEY';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getKey() {
    return _prefs.getString(KEY_NAME);
  }

  void changeKey(String newKey) async {
    await _prefs.setString(KEY_NAME, newKey);
  }

  void removeKey() async {
    await _prefs.remove(KEY_NAME);
  }
}

final apiKeyProvider = ApiKeyProvider();

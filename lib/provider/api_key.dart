import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyProvider {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getKey() {
    return _prefs.getString('API_KEY');
  }

  void changeKey(String newKey) async {
    await _prefs.setString('API_KEY', newKey);
  }

  void removeKey() async {
    await _prefs.remove('API_KEY');
  }
}

final apiKeyProvider = ApiKeyProvider();

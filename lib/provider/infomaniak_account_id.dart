import 'package:shared_preferences/shared_preferences.dart';

class InfomaniakAccountIdProvider {
  late final SharedPreferences _prefs;
  static const String KEY_NAME = 'INFOMANIAK_ACCOUNT_ID';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int? getAccountId() {
    return _prefs.getInt(KEY_NAME);
  }

  void changeAccountId(int newAccountId) async {
    await _prefs.setInt(KEY_NAME, newAccountId);
  }

  void removeAccountId() async {
    await _prefs.remove(KEY_NAME);
  }
}

final infomaniakAccountIdProvider = InfomaniakAccountIdProvider();

import 'package:shared_preferences/shared_preferences.dart';

class AdsWatchedProvider {
  late final SharedPreferences _prefs;
  static const String KEY_NAME = 'ADS_WATCHED';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getInt(KEY_NAME) == null) {
      await _prefs.setInt(KEY_NAME, 0);
    }
  }

  int getNumberOfAdsWatched() {
    return _prefs.getInt(KEY_NAME)!;
  }

  void incrementNumberOfAdsWatched() async {
    _prefs.setInt(KEY_NAME, _prefs.getInt(KEY_NAME)! + 1);
  }

  String getThanksPhrase() {
    int adsWatched = this.getNumberOfAdsWatched();
    if (adsWatched >= 100) {
      return "WOW, you really like this app! ($adsWatched ads seen)";
    } else if (adsWatched >= 50) {
      return "HUGE thank you for your support! ($adsWatched ads seen)";
    } else if (adsWatched >= 10) {
      return "Big thank you for your support! ($adsWatched ads seen)";
    } else if (adsWatched > 1) {
      return "Thank you for your support! ($adsWatched ads seen)";
    }
    return 'Thank you for your support!';
  }
}

final adsWatchedProvider = AdsWatchedProvider();

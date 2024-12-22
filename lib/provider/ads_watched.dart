import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  String getThanksPhrase(BuildContext context) {
    int adsWatched = getNumberOfAdsWatched();
    if (adsWatched >= 100) {
      return AppLocalizations.of(context)!.ad_watch_thanks_100(adsWatched);
    } else if (adsWatched >= 50) {
      return AppLocalizations.of(context)!.ad_watch_thanks_50(adsWatched);
    } else if (adsWatched >= 10) {
      return AppLocalizations.of(context)!.ad_watch_thanks_10(adsWatched);
    }
    return AppLocalizations.of(context)!.ad_watch_thanks(adsWatched);
  }
}

final adsWatchedProvider = AdsWatchedProvider();

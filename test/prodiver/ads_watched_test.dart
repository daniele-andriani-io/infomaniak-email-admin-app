import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/provider/ads_watched.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await adsWatchedProvider.init();
  });
  group('Testing ads watched provider', () {
    test('At start', () {
      expect(adsWatchedProvider.getNumberOfAdsWatched(), 0);
    });
    test('Increment number', () {
      adsWatchedProvider.incrementNumberOfAdsWatched();
      expect(adsWatchedProvider.getNumberOfAdsWatched(), 1);
    });
  });
}

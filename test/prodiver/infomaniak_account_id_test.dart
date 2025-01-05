import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/provider/ads_watched.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_account_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await infomaniakAccountIdProvider.init();
  });
  group('Testing Infomaniak account ID provider', () {
    test('At start', () {
      expect(infomaniakAccountIdProvider.getAccountId(), null);
    });
    test('Change number', () {
      infomaniakAccountIdProvider.changeAccountId(1111);
      expect(infomaniakAccountIdProvider.getAccountId(), 1111);
    });
    test('Remove number', () {
      infomaniakAccountIdProvider.changeAccountId(1111);
      expect(infomaniakAccountIdProvider.getAccountId(), 1111);
      infomaniakAccountIdProvider.removeAccountId();
      expect(infomaniakAccountIdProvider.getAccountId(), null);
    });
  });
}

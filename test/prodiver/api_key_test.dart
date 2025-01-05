import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await apiKeyProvider.init();
  });
  group('Testing API key provider', () {
    test('Empty API key', () {
      expect(apiKeyProvider.getKey(), null);
    });
    test('Setup an API key', () {
      apiKeyProvider.changeKey('HelloWorld');
      expect(apiKeyProvider.getKey(), 'HelloWorld');
    });
    test('Change an API key', () {
      apiKeyProvider.changeKey('HelloWorld');
      expect(apiKeyProvider.getKey(), 'HelloWorld');
      apiKeyProvider.changeKey('HelloWorld2');
      expect(apiKeyProvider.getKey(), 'HelloWorld2');
    });
  });
}

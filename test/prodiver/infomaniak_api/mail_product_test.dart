import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/profile.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_test.mocks.dart';

Future<String> returnExample() async {
  File file =
      File('test/prodiver/infomaniak_api/json_examples/mail_product.json');
  return await file.readAsString();
}

Future<String> returnError() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/error_not_authorized.json');
  return await file.readAsString();
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await apiKeyProvider.init();
  });
  group('Infomaniak Mail Product API', () {
    test('fetch successfully', () async {
      final client = MockClient();

      when(client.get(MailProductApi().getEndpoint(),
              headers: MailProductApi().getHeaders()))
          .thenAnswer((_) async => http.Response(await returnExample(), 200));

      List<MailProductModel> mailProducts =
          await MailProductApi().fetchProductList(client: client);

      expect(mailProducts.length, 1);
      expect(mailProducts.first.id, 70128);
      expect(mailProducts.first.accountId, 15595);
      expect(mailProducts.first.customerName, 'example');
    });

    test('fetch with 404 error', () async {
      final client = MockClient();

      when(client.get(MailProductApi().getEndpoint(),
              headers: MailProductApi().getHeaders()))
          .thenAnswer((_) async => http.Response('Not found', 404));

      try {
        List<MailProductModel> mailProducts =
            await MailProductApi().fetchProductList(client: client);
        expect(mailProducts, false);
      } catch (e) {
        expect(e.toString(), 'Exception: Something went wrong');
      }
    });

    test('fetch not authorized', () async {
      final client = MockClient();

      when(client.get(MailProductApi().getEndpoint(),
              headers: MailProductApi().getHeaders()))
          .thenAnswer((_) async => http.Response(await returnError(), 401));

      try {
        List<MailProductModel> mailProducts =
            await MailProductApi().fetchProductList(client: client);
        expect(mailProducts, false);
      } catch (e) {
        expect(e.toString(), 'Exception: Authorization required (401)');
      }
    });
  });
}

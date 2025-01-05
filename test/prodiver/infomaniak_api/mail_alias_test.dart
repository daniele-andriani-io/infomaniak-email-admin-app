import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/profile.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.mocks.dart';

Future<String> fetchExample() async {
  File file =
      File('test/prodiver/infomaniak_api/json_examples/mail_account.json');
  return await file.readAsString();
}

Future<String> createExample() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/mail_account_create.json');
  return await file.readAsString();
}

Future<String> deleteExample() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/mail_account_delete.json');
  return await file.readAsString();
}

Future<String> returnError() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/error_not_authorized.json');
  return await file.readAsString();
}

const int TEST_MAIL_HOSTING_ID = 1;

@GenerateMocks([http.Client])
void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await apiKeyProvider.init();
  });
  group('Infomaniak Mail Account API', () {
    group('fetch', () {
      test('fetch successfully', () async {
        final client = MockClient();

        when(client.get(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await fetchExample(), 200));

        List<MailAccountModel> mailProducts = await MailAccountApi()
            .fetchAccountList(TEST_MAIL_HOSTING_ID, client: client);

        expect(mailProducts.length, 1);
      });

      test('fetch with 404 error', () async {
        final client = MockClient();

        when(client.get(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          List<MailAccountModel> mailProducts = await MailAccountApi()
              .fetchAccountList(TEST_MAIL_HOSTING_ID, client: client);
          expect(mailProducts, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('fetch not authorized', () async {
        final client = MockClient();

        when(client.get(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          List<MailAccountModel> mailProducts = await MailAccountApi()
              .fetchAccountList(TEST_MAIL_HOSTING_ID, client: client);
          expect(mailProducts, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Authorization required (401)');
        }
      });
    });
    group('create', () {
      test('create successfully', () async {
        final client = MockClient();

        when(client.post(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await createExample(), 201));

        bool wasCreated = await MailAccountApi().createAccount(
            TEST_MAIL_HOSTING_ID, 'accountName', 'accountPWD',
            client: client);

        expect(wasCreated, true);
      });

      test('create with 404 error', () async {
        final client = MockClient();

        when(client.post(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          bool wasCreated = await MailAccountApi().createAccount(
              TEST_MAIL_HOSTING_ID, 'accountName', 'accountPWD',
              client: client);
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('create not authorized', () async {
        final client = MockClient();

        when(client.post(MailAccountApi().getEndpoint(TEST_MAIL_HOSTING_ID),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          bool wasCreated = await MailAccountApi().createAccount(
              TEST_MAIL_HOSTING_ID, 'accountName', 'accountPWD',
              client: client);
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Authorization required (401)');
        }
      });
    });
    group('delete', () {
      String accountName = 'hello';
      test('delete successfully', () async {
        final client = MockClient();

        when(client.delete(
                MailAccountApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  deleteEndpoint: true,
                  accountName: accountName,
                ),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await deleteExample(), 200));

        bool wasCreated = await MailAccountApi()
            .deleteAccount(TEST_MAIL_HOSTING_ID, accountName, client: client);

        expect(wasCreated, true);
      });

      test('delete with 404 error', () async {
        final client = MockClient();

        when(client.delete(
                MailAccountApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  deleteEndpoint: true,
                  accountName: accountName,
                ),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          bool wasCreated = await MailAccountApi()
              .deleteAccount(TEST_MAIL_HOSTING_ID, accountName, client: client);
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('delete not authorized', () async {
        final client = MockClient();

        when(client.delete(
                MailAccountApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  deleteEndpoint: true,
                  accountName: accountName,
                ),
                headers: MailAccountApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          bool wasCreated = await MailAccountApi()
              .deleteAccount(TEST_MAIL_HOSTING_ID, accountName, client: client);
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Authorization required (401)');
        }
      });
    });
  });
}

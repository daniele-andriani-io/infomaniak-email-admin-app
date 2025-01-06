import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/profile.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_test.mocks.dart';

Future<String> fetchExample() async {
  File file =
      File('test/prodiver/infomaniak_api/json_examples/mail_alias.json');
  return await file.readAsString();
}

Future<String> createExample() async {
  File file =
      File('test/prodiver/infomaniak_api/json_examples/mail_alias_create.json');
  return await file.readAsString();
}

Future<String> deleteExample() async {
  File file =
      File('test/prodiver/infomaniak_api/json_examples/mail_alias_delete.json');
  return await file.readAsString();
}

Future<String> returnError() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/error_not_authorized.json');
  return await file.readAsString();
}

const int TEST_MAIL_HOSTING_ID = 1;
const String TEST_MAILBOX_NAME = 'test';
const String TEST_ALIAS = 'hello';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await apiKeyProvider.init();
  });
  group('Infomaniak Mail Alias API', () {
    group('fetch', () {
      test('fetch successfully', () async {
        final client = MockClient();

        when(client.get(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await fetchExample(), 200));

        List<String> mailAliases = await MailAliasApi().fetchAliasesList(
          TEST_MAIL_HOSTING_ID,
          TEST_MAILBOX_NAME,
          client: client,
        );

        expect(mailAliases.length, 1);
        expect(mailAliases[0], 'example');
      });

      test('fetch with 404 error', () async {
        final client = MockClient();

        when(client.get(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          List<String> mailAliases = await MailAliasApi().fetchAliasesList(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            client: client,
          );
          expect(mailAliases, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('fetch not authorized', () async {
        final client = MockClient();

        when(client.get(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          List<String> mailAliases = await MailAliasApi().fetchAliasesList(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            client: client,
          );
          expect(mailAliases, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Authorization required (401)');
        }
      });
    });
    group('create', () {
      test('create successfully', () async {
        final client = MockClient();

        when(
          client.post(
            MailAliasApi().getEndpoint(
              TEST_MAIL_HOSTING_ID,
              TEST_MAILBOX_NAME,
            ),
            headers: MailAliasApi().getHeaders(),
            body: {"alias": TEST_ALIAS},
          ),
        ).thenAnswer((_) async => http.Response(await createExample(), 200));

        bool wasCreated = await MailAliasApi().createAlias(
          TEST_MAIL_HOSTING_ID,
          TEST_MAILBOX_NAME,
          TEST_ALIAS,
          client: client,
        );

        expect(wasCreated, true);
      });

      test('create with 404 error', () async {
        final client = MockClient();

        when(client.post(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                ),
                headers: MailAliasApi().getHeaders(),
                body: {"alias": TEST_ALIAS}))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          bool wasCreated = await MailAliasApi().createAlias(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            TEST_ALIAS,
            client: client,
          );
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('create not authorized', () async {
        final client = MockClient();

        when(client.post(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                ),
                headers: MailAliasApi().getHeaders(),
                body: {"alias": TEST_ALIAS}))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          bool wasCreated = await MailAliasApi().createAlias(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            TEST_ALIAS,
            client: client,
          );
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
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                  aliasToDelete: TEST_ALIAS,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await deleteExample(), 200));

        bool wasCreated = await MailAliasApi().removeAlias(
          TEST_MAIL_HOSTING_ID,
          TEST_MAILBOX_NAME,
          TEST_ALIAS,
          client: client,
        );

        expect(wasCreated, true);
      });

      test('delete with 404 error', () async {
        final client = MockClient();

        when(client.delete(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                  aliasToDelete: TEST_ALIAS,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response('Not found', 404));

        try {
          bool wasCreated = await MailAliasApi().removeAlias(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            TEST_ALIAS,
            client: client,
          );
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Something went wrong');
        }
      });

      test('delete not authorized', () async {
        final client = MockClient();

        when(client.delete(
                MailAliasApi().getEndpoint(
                  TEST_MAIL_HOSTING_ID,
                  TEST_MAILBOX_NAME,
                  aliasToDelete: TEST_ALIAS,
                ),
                headers: MailAliasApi().getHeaders()))
            .thenAnswer((_) async => http.Response(await returnError(), 401));

        try {
          bool wasCreated = await MailAliasApi().removeAlias(
            TEST_MAIL_HOSTING_ID,
            TEST_MAILBOX_NAME,
            TEST_ALIAS,
            client: client,
          );
          expect(wasCreated, false);
        } catch (e) {
          expect(e.toString(), 'Exception: Authorization required (401)');
        }
      });
    });
  });
}

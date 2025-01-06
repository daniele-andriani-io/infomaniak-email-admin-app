import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/profile.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'profile_test.mocks.dart';

Future<String> returnExample() async {
  File file = File('test/prodiver/infomaniak_api/json_examples/profile.json');
  return await file.readAsString();
}

Future<String> returnError() async {
  File file = File(
      'test/prodiver/infomaniak_api/json_examples/error_not_authorized.json');
  return await file.readAsString();
}

@GenerateMocks([http.Client])
void main() {
  group('Infomaniak Profile API', () {
    test('fetch successfully', () async {
      final client = MockClient();

      when(client.get(ProfileApi().getEndpoint(),
              headers: ProfileApi().getHeaders(tempKey: 'APIkey')))
          .thenAnswer((_) async => http.Response(await returnExample(), 200));

      ProfileModel? profileModel =
          await ProfileApi().fetchProfile('APIkey', client: client);

      expect(profileModel!.displayName, 'example');
    });

    test('fetch with 404 error', () async {
      final client = MockClient();

      when(client.get(ProfileApi().getEndpoint(),
              headers: ProfileApi().getHeaders(tempKey: 'APIkey')))
          .thenAnswer((_) async => http.Response('Not found', 404));

      try {
        ProfileModel? profileModel =
            await ProfileApi().fetchProfile('APIkey', client: client);
        expect(profileModel, false);
      } catch (e) {
        expect(e.toString(), 'Exception: Something went wrong');
      }
    });

    test('fetch not authorized', () async {
      final client = MockClient();

      when(client.get(ProfileApi().getEndpoint(),
              headers: ProfileApi().getHeaders(tempKey: 'APIkey')))
          .thenAnswer((_) async => http.Response(await returnError(), 401));

      try {
        ProfileModel? profileModel =
            await ProfileApi().fetchProfile('APIkey', client: client);
        expect(profileModel, false);
      } catch (e) {
        expect(e.toString(), 'Exception: Authorization required (401)');
      }
    });
  });
}

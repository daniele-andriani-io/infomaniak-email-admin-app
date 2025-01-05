import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';

Future<Map<String, dynamic>> returnExampleJSON() async {
  File file = File('test/models/infomaniak/json_examples/profile.json');
  String jsonString = await file.readAsString();
  return jsonDecode(jsonString);
}

main() {
  group('Testing profile model', () {
    test('Creating a model from JSON', () async {
      // Arrange
      Map<String, dynamic> json = await returnExampleJSON();
      // Act
      ProfileModel profileModel = ProfileModel.fromJson(json);
      // Assert
      expect(profileModel, isInstanceOf<ProfileModel>());
      expect(profileModel.displayName, 'example');
      expect(profileModel.firstName, 'Norene');
      expect(profileModel.lastName, 'Greenholt');
      expect(profileModel.email, 'freeda.bauch@abernathy.com');
      expect(profileModel.id, 26502);
      expect(profileModel.currentAccountId, 26502);
    });
  });
}

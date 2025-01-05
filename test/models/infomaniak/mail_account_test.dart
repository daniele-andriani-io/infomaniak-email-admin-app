import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';

Future<Map<String, dynamic>> returnExampleJSON() async {
  File file = File('test/models/infomaniak/json_examples/mail_account.json');
  String jsonString = await file.readAsString();
  return jsonDecode(jsonString);
}

main() {
  group('Testing mail account model', () {
    test('Creating a model from JSON', () async {
      // Arrange
      Map<String, dynamic> json = await returnExampleJSON();
      // Act
      MailAccountModel maitAccountModel = MailAccountModel.fromJson(json);
      // Assert
      expect(maitAccountModel, isInstanceOf<MailAccountModel>());
      expect(maitAccountModel.mailboxName, 'user');
      expect(maitAccountModel.mailboxIdn, 'user@êxample.com');
      expect(maitAccountModel.isLimited, false);
      expect(maitAccountModel.isFreeMail, true);
    });
  });
}

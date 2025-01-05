import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';

Future<Map<String, dynamic>> returnExampleJSON() async {
  File file = File('test/models/infomaniak/json_examples/mail_product.json');
  String jsonString = await file.readAsString();
  return jsonDecode(jsonString);
}

main() {
  group('Testing mail product model', () {
    test('Creating a model from JSON', () async {
      // Arrange
      Map<String, dynamic> json = await returnExampleJSON();
      // Act
      MailProductModel mailProductModel = MailProductModel.fromJson(json);
      // Assert
      expect(mailProductModel, isInstanceOf<MailProductModel>());
      expect(mailProductModel.customerName, 'example');
      expect(mailProductModel.id, 98530);
      expect(mailProductModel.accountId, 18547);
    });
  });
}

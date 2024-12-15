import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';

class MailAccountApi {
  List<MailAccountModel> accounts = [];
  String version = "1";
  String endpointName = "mail_hostings";
  String endpointSubName = "mailboxes";

  Map<String, String> getHeaders() {
    final Map<String, String> headers = <String, String>{};
    String apiKey = apiKeyProvider.getKey() ?? "";
    headers['Authorization'] = "Bearer $apiKey";
    return headers;
  }

  Future<List<MailAccountModel>> fetchAccountList(
      BuildContext context, int mailHostingId) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName";

    try {
      http.Response apiResponse = await http.get(
        Uri.parse(endpoint),
        headers: getHeaders(),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        accounts.removeRange(0, accounts.length);
        for (var account in response['data']) {
          accounts.add(MailAccountModel.fromJson(account));
        }
      } else {
        if (response.containsKey('error')) {
          String message = response['error']['description'];
          int code = apiResponse.statusCode;
          throw Exception("$message ($code)");
        }
        throw Exception("Call to API failed.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.toString(),
      )));
    }
    return accounts;
  }
}

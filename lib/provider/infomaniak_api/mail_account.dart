import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/provider/api_key.dart';

class MailAccountApi {
  List<AccountModel> accounts = [];
  String version = "1";
  String endpointName = "mail_hostings";
  String endpointSubName = "mailboxes";

  Map<String, String> getHeaders() {
    final Map<String, String> headers = <String, String>{};
    String apiKey = apiKeyProvider.getKey() ?? "";
    headers['Authorization'] = "Bearer $apiKey";
    return headers;
  }

  Future<List<AccountModel>> fetchAccountList(
      BuildContext context, int mailAccountId) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailAccountId";

    try {
      http.Response apiResponse = await http.get(
        Uri.parse(endpoint),
        headers: getHeaders(),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        accounts.removeRange(0, accounts.length);
        for (var account in response['data']) {
          accounts.add(AccountModel.fromJson(account));
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

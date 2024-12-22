import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountApi {
  List<AccountModel> accounts = [];
  String version = "1";
  String endpointName = "accounts";

  Map<String, String> getHeaders() {
    final Map<String, String> headers = <String, String>{};
    String apiKey = apiKeyProvider.getKey() ?? "";
    headers['Authorization'] = "Bearer $apiKey";
    return headers;
  }

  Future<List<AccountModel>> fetchAccountList(context) async {
    String endpoint = "$infomaniakApiBaseUrl/$version/$endpointName";

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
        throw Exception(AppLocalizations.of(context)!.api_call_failed!);
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

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      BuildContext context, int mailHostingId,
      [String? search]) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName";

    try {
      http.Response apiResponse = await http.get(
        search == null
            ? Uri.parse(endpoint)
                .replace(queryParameters: {'order_by': 'mailbox'})
            : Uri.parse(endpoint).replace(queryParameters: {
                'search': search,
                'order_by': 'mailbox',
                'filter_by': 'mailbox_name'
              }),
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

  Future<void> createAccount(BuildContext context, int mailHostingId,
      String accountName, String accountPassword) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName";

    final Map<String, String> data = <String, String>{};
    data['mailbox_name'] = accountName;
    data['password'] = accountPassword;

    try {
      http.Response apiResponse = await http.post(
        Uri.parse(endpoint),
        headers: getHeaders(),
        body: data,
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 201 && response['result'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.api_new_account_added)));
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
  }

  Future<void> deleteAccount(
      BuildContext context, int mailHostingId, String accountName) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName/$accountName";

    try {
      http.Response apiResponse = await http.delete(
        Uri.parse(endpoint),
        headers: getHeaders(),
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!
                .api_account_removed(accountName))));
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
  }
}

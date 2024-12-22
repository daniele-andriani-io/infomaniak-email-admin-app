import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MailAliasApi {
  List<String> aliases = [];
  String version = "1";
  String endpointName = "mail_hostings";
  String endpointSubName = "mailboxes";
  String endpointSubSubName = "aliases";

  Map<String, String> getHeaders() {
    final Map<String, String> headers = <String, String>{};
    String apiKey = apiKeyProvider.getKey() ?? "";
    headers['Authorization'] = "Bearer $apiKey";
    return headers;
  }

  Future<List<String>> fetchAliasesList(
      BuildContext context, int mailHostingId, String mailboxName) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName/$mailboxName/$endpointSubSubName";

    try {
      http.Response apiResponse = await http.get(
        Uri.parse(endpoint),
        headers: getHeaders(),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        aliases.removeRange(0, aliases.length);
        for (var alias in response['data']['aliases']) {
          aliases.add(alias);
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
    aliases.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return aliases;
  }

  Future<void> createAlias(BuildContext context, int mailHostingId,
      String mailboxName, String newAlias) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName/$mailboxName/$endpointSubSubName";

    final Map<String, String> data = <String, String>{};
    data['alias'] = newAlias;
    try {
      http.Response apiResponse = await http.post(
        Uri.parse(endpoint),
        headers: getHeaders(),
        body: data,
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.api_new_alias_added)));
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

  Future<void> removeAlias(BuildContext context, int mailHostingId,
      String mailboxName, String alias) async {
    String endpoint =
        "$infomaniakApiBaseUrl/$version/$endpointName/$mailHostingId/$endpointSubName/$mailboxName/$endpointSubSubName/$alias";

    try {
      http.Response apiResponse = await http.delete(
        Uri.parse(endpoint),
        headers: getHeaders(),
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.api_alias_deleted(alias))));
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

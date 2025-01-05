import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/abstract.dart';

class MailAliasApi extends InfomaniakApi {
  List<String> aliases = [];
  String version = "1";
  String endpointName = "mail_hostings";
  String endpointSubName = "mailboxes";
  String endpointSubSubName = "aliases";

  Uri getEndpoint(
    int mailHostingId,
    String mailboxName, {
    String? aliasToDelete,
  }) {
    if (aliasToDelete != null && aliasToDelete.isNotEmpty) {
      return Uri.https(
        infomaniakApiBaseUrl,
        "/$version/$endpointName/$mailHostingId/$endpointSubName/$mailboxName/$endpointSubSubName/$aliasToDelete",
      );
    }
    return Uri.https(
      infomaniakApiBaseUrl,
      "/$version/$endpointName/$mailHostingId/$endpointSubName/$mailboxName/$endpointSubSubName",
    );
  }

  Future<List<String>> fetchAliasesList(
    int mailHostingId,
    String mailboxName, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.get(
        getEndpoint(mailHostingId, mailboxName),
        headers: getHeaders(),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        aliases = [];
        for (var alias in response['data']['aliases']) {
          aliases.add(alias);
        }
        aliases.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        return aliases;
      } else if (response.containsKey('error')) {
        String message = response['error']['description'];
        int code = apiResponse.statusCode;
        throw Exception("$message ($code)");
      }
    } on FormatException catch (e) {
      throw Exception("Something went wrong");
    } on Exception catch (e) {
      rethrow;
    }
    return aliases;
  }

  Future<bool> createAlias(
    int mailHostingId,
    String mailboxName,
    String newAlias, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    final Map<String, String> data = <String, String>{};
    data['alias'] = newAlias;

    try {
      http.Response apiResponse = await client.post(
        getEndpoint(mailHostingId, mailboxName),
        headers: getHeaders(),
        body: data,
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        return true;
      } else if (response.containsKey('error')) {
        String message = response['error']['description'];
        int code = apiResponse.statusCode;
        throw Exception("$message ($code)");
      }
    } on FormatException catch (e) {
      throw Exception("Something went wrong");
    } on Exception catch (e) {
      rethrow;
    }
    return false;
  }

  Future<bool> removeAlias(
    int mailHostingId,
    String mailboxName,
    String alias, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.delete(
        getEndpoint(mailHostingId, mailboxName, aliasToDelete: alias),
        headers: getHeaders(),
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        return true;
      } else if (response.containsKey('error')) {
        String message = response['error']['description'];
        int code = apiResponse.statusCode;
        throw Exception("$message ($code)");
      }
    } on FormatException catch (e) {
      throw Exception("Something went wrong");
    } on Exception catch (e) {
      rethrow;
    }
    return false;
  }
}

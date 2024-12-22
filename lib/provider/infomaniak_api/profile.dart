import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileApi {
  ProfileModel? profileModel;
  String version = "2";
  String endpointName = "profile";

  Map<String, String> getHeaders(String tempApiKey) {
    final Map<String, String> headers = <String, String>{};
    headers['Authorization'] = "Bearer $tempApiKey";
    return headers;
  }

  Future<ProfileModel?> fetchProfile(
    BuildContext context,
    String tempApiKey,
  ) async {
    String endpoint = "$infomaniakApiBaseUrl/$version/$endpointName";

    try {
      http.Response apiResponse = await http.get(
        Uri.parse(endpoint),
        headers: getHeaders(tempApiKey),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        profileModel = ProfileModel.fromJson(response['data']);
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

    return profileModel;
  }
}

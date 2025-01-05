import 'dart:convert';
import 'dart:core';

import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/abstract.dart';

class ProfileApi extends InfomaniakApi {
  ProfileModel? profileModel;
  String version = "2";
  String endpointName = "profile";

  Uri getEndpoint() {
    return Uri.https(infomaniakApiBaseUrl, '/$version/$endpointName');
  }

  Future<ProfileModel?> fetchProfile(
    String tempApiKey, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.get(
        getEndpoint(),
        headers: getHeaders(tempKey: tempApiKey),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        profileModel = ProfileModel.fromJson(response['data']);
        return profileModel;
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
  }
}

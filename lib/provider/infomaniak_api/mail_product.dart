import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/abstract.dart';

class MailProductApi extends InfomaniakApi {
  List<MailProductModel> products = [];
  String version = "1";
  String endpointName = "mail_hostings";

  Uri getEndpoint() {
    return Uri.https(
      infomaniakApiBaseUrl,
      '/$version/$endpointName',
      {'order_by': 'customer_name'},
    );
  }

  Future<List<MailProductModel>> fetchProductList({
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.get(
        getEndpoint(),
        headers: getHeaders(),
      );
      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 200 && response['result'] == "success") {
        products.removeRange(0, products.length);
        for (var account in response['data']) {
          products.add(MailProductModel.fromJson(account));
        }
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
    return products;
  }
}

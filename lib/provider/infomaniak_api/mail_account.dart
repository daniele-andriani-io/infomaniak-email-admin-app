import 'dart:convert';
import 'dart:core';

import 'package:infomaniak_email_admin_app/constants/links.dart';
import 'package:http/http.dart' as http;
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mailbox_store.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/abstract.dart';

class MailAccountApi extends InfomaniakApi {
  List<MailAccountModel> accounts = [];
  String version = "1";
  String endpointName = "mail_hostings";
  String endpointSubName = "mailboxes";

  Uri getEndpoint(int mailHostingId,
      {bool? deleteEndpoint, String? accountName}) {
    if (deleteEndpoint != null &&
        deleteEndpoint &&
        accountName != null &&
        accountName.isNotEmpty) {
      return Uri.https(
        infomaniakApiBaseUrl,
        '/$version/$endpointName/$mailHostingId/$endpointSubName/$accountName',
      );
    }
    return Uri.https(
      infomaniakApiBaseUrl,
      '/$version/$endpointName/$mailHostingId/$endpointSubName',
      {'order_by': 'mailbox'},
    );
  }

  Future<List<MailAccountModel>> fetchAccountList(
    int mailHostingId, {
    http.Client? client,
    String? search,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.get(
        search == null
            ? getEndpoint(mailHostingId)
            : getEndpoint(mailHostingId).replace(queryParameters: {
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
    return accounts;
  }

  Future<MailboxStoreModel?> createAccount(
    int mailHostingId,
    String accountName,
    String accountPassword, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();

    final Map<String, String> data = <String, String>{};
    data['mailbox_name'] = accountName;
    data['password'] = accountPassword;

    try {
      http.Response apiResponse = await client.post(
        getEndpoint(mailHostingId),
        headers: getHeaders(),
        body: data,
      );

      Map<String, dynamic> response = jsonDecode(apiResponse.body);

      if (apiResponse.statusCode == 201 && response['result'] == "success") {
        return MailboxStoreModel.fromJson(response['data']);
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
    return null;
  }

  Future<bool> deleteAccount(
    int mailHostingId,
    String accountName, {
    http.Client? client,
  }) async {
    client = client ?? http.Client();
    try {
      http.Response apiResponse = await client.delete(
        getEndpoint(mailHostingId,
            deleteEndpoint: true, accountName: accountName),
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

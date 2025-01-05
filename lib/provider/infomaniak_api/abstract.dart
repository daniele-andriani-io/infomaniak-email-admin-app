import 'package:infomaniak_email_admin_app/provider/api_key.dart';

abstract class InfomaniakApi {
  Map<String, String> getHeaders({String? tempKey}) {
    final Map<String, String> headers = <String, String>{};
    String apiKey = tempKey ?? apiKeyProvider.getKey() ?? "";
    headers['Authorization'] = "Bearer $apiKey";
    return headers;
  }
}

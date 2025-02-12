import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/how_to_start.dart';

class ApiKeyWidget extends StatefulWidget {
  const ApiKeyWidget({super.key});

  @override
  State<ApiKeyWidget> createState() {
    return _ApiKeyWidgetState();
  }
}

class _ApiKeyWidgetState extends State<ApiKeyWidget> {
  String? _apiKey = apiKeyProvider.getKey();

  @override
  ListTile build(BuildContext context) {
    if (_apiKey == null) {
      return ListTile(
        title: Text(AppLocalizations.of(context)!.settings_add_API_key),
        trailing: const Icon(Icons.edit),
        onTap: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const HowToStartScreen()));
          setState(() {
            _apiKey = apiKeyProvider.getKey();
          });
        },
      );
    }

    return ListTile(
      title: Text(AppLocalizations.of(context)!.settings_delete_API_key),
      onTap: () => _removeApiKeyValidation(context),
      trailing: const Icon(Icons.delete),
    );
  }

  Future<void> _removeApiKeyValidation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .settings_delete_API_key_modal_title),
          content: Text(
            AppLocalizations.of(context)!.settings_delete_API_key_modal_text,
            style: Theme.of(ctx).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  apiKeyProvider.removeKey();
                  _apiKey = apiKeyProvider.getKey();
                });
                Navigator.of(ctx).pop();
              },
              child: Text(AppLocalizations.of(context)!
                  .settings_delete_API_key_modal_confirm),
            ),
          ],
        );
      },
    );
  }
}

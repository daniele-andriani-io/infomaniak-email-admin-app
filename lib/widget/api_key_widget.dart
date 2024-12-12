import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';

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
        title: const Text('Add API key'),
        trailing: IconButton(
          onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const HowToStartScreen()));
            setState(() {
              _apiKey = apiKeyProvider.getKey();
            });
          },
          icon: const Icon(
            Icons.edit,
          ),
        ),
      );
    }

    return ListTile(
      title: const Text('Delete API key'),
      trailing: IconButton(
        onPressed: () => _removeApiKeyValidation(context),
        icon: const Icon(
          Icons.delete,
        ),
      ),
    );
  }

  Future<void> _removeApiKeyValidation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(
            'Once the API key is deleted you won\'t be able to retrieve it. Are you sure you want to delete this key?',
            style: Theme.of(ctx).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  apiKeyProvider.removeKey();
                  _apiKey = apiKeyProvider.getKey();
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Delete the API key'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';

class HowToStartScreen extends StatefulWidget {
  const HowToStartScreen({
    super.key,
  });

  @override
  State<HowToStartScreen> createState() {
    return _HowToStartScreenState();
  }
}

class _HowToStartScreenState extends State<HowToStartScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredAPIKey = '';

  void _saveAPIKey() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        apiKeyProvider.changeKey(_enteredAPIKey);
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello dear user!',
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'For the application to work you will need to create an API key in your Infomaniak Manager account. To do so please follow these steps:',
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                '1. Go to https://manager.infomaniak.com/v3/ng/accounts/token/list to create a new API token',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '2. Give access to "user_info" and "mail" scopes to allow the application to access this data',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '3. Copy the given API key (will only be visible once)',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '4. Paste it in the following box',
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.start,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  decoration: const InputDecoration(
                    label: Text('Infomaniak API key'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'API key is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredAPIKey = value!;
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: const Text('Cancel'),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: _saveAPIKey,
                    label: const Text('Save API key'),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Please note that you can revoke the API key at any time and this will block any access this application hase on your account. Also everything is run locally, no data will ever be shared with third party partners.',
                  style: Theme.of(context).textTheme.bodyMedium!,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

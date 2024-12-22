import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/profile.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_account_id.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ProfileApi profileApi = ProfileApi();
  String _enteredAPIKey = '';
  bool _isTesting = false;

  void _saveAPIKey() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _testAPIKey(andSave: true);
      setState(() {
        apiKeyProvider.changeKey(_enteredAPIKey);
        Navigator.of(context).pop();
      });
    }
  }

  void _testAPIKey({bool andSave = false}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isTesting = true;
      });
      ProfileModel? tempProfil =
          await profileApi.fetchProfile(context, _enteredAPIKey);
      setState(() {
        String message = "Something went wrong try again";
        IconData icon = Icons.error;
        if (tempProfil != null) {
          message =
              "The API key you tested is linked to ${tempProfil.displayName}";
          icon = Icons.check;
          if (andSave) {
            infomaniakAccountIdProvider
                .changeAccountId(tempProfil.currentAccountId!);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          children: [
            Text(message),
            const SizedBox(
              width: 8,
            ),
            Icon(icon),
          ],
        )));
        _isTesting = false;
      });
    }
  }

  Future<void> _launchUrl(String link, String? title, String other) async {
    final Uri _url = Uri.parse(link);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.how_to_start_title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: AppLocalizations.of(context)!.how_to_start_description,
                onTapLink: (title, link, other) async {
                  await _launchUrl(link!, title, other);
                },
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  textScaler: TextScaler.linear(1.2),
                  h1: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  decoration: InputDecoration(
                    label: Text(
                      AppLocalizations.of(context)!.settings_API_key_field,
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return AppLocalizations.of(context)!
                          .settings_API_key_validation;
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
                    label: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: _saveAPIKey,
                    label: Text(
                        AppLocalizations.of(context)!.settings_save_API_key),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    icon: _isTesting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Icons.approval),
                    onPressed: _testAPIKey,
                    label: Text(
                        AppLocalizations.of(context)!.settings_test_API_key),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  AppLocalizations.of(context)!.settings_API_important_info,
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

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMailAliasesScreen extends StatefulWidget {
  final int mailHostingId;
  final String mailboxName;
  const AddMailAliasesScreen(
      {super.key, required this.mailHostingId, required this.mailboxName});

  @override
  State<AddMailAliasesScreen> createState() {
    return _AddMailAliasesScreensState();
  }
}

class _AddMailAliasesScreensState extends State<AddMailAliasesScreen> {
  final _formKey = GlobalKey<FormState>();
  String _newAlias = '';
  bool _isLoading = false;
  MailAliasApi mailAliasApi = MailAliasApi();

  void _saveAlias() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await mailAliasApi.createAlias(
          context, widget.mailHostingId, widget.mailboxName, _newAlias);
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.alias_create_new),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.alias_new)),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return AppLocalizations.of(context)!.alias_new_validation;
                  }
                  return null;
                },
                onSaved: (value) {
                  _newAlias = value!;
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
                  icon: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const Icon(Icons.add),
                  onPressed: _saveAlias,
                  label: Text(AppLocalizations.of(context)!.alias_save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

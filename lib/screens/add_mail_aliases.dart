import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';

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
      appBar: AppBar(title: const Text('Create new alias')),
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
                decoration: const InputDecoration(
                  label: Text('New alias'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return 'An alias name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newAlias = value!;
                },
              ),
            ),
            SizedBox(
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
                  label: const Text('Save API key'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

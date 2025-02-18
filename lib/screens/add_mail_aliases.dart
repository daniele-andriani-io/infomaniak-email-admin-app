import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/helpers/notification_helper.dart';
import 'package:infomaniak_email_admin_app/helpers/string_helper.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/widget/circular_progress_icon_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';
import 'package:word_generator/word_generator.dart';

class AddMailAliasesScreen extends StatefulWidget {
  final int mailHostingId;
  final MailAccountModel mailbox;
  const AddMailAliasesScreen(
      {super.key, required this.mailHostingId, required this.mailbox});

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
      try {
        bool aliasCreated = await mailAliasApi.createAlias(
            widget.mailHostingId, widget.mailbox.mailboxName!, _newAlias);
        if (aliasCreated) {
          setState(() {
            Navigator.of(context).pop();
          });
        }
      } catch (e) {
        NotificationHelper.displayMessage(context, e.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _generateAlias() {
    String randomSentence = WordGenerator().randomSentence();
    randomSentence = randomSentence.trim();
    _newAlias = randomSentence.replaceAll(' ', '.');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String domain = StringHelper.getDomain(widget.mailbox.mailboxIdn!);

    return PageWidget(
      title: AppLocalizations.of(context)!.alias_create_new,
      getBody: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.alias_new),
                  suffixText: domain,
                ),
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
                controller: TextEditingController()..text = _newAlias,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  onPressed: _generateAlias,
                  label: Text(AppLocalizations.of(context)!.alias_generate),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton.icon(
                  icon: _isLoading
                      ? const CircularProgressIcon()
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

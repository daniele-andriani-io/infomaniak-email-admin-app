import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/helpers/notification_helper.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mailbox_store.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/widget/circular_progress_icon_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';
import 'package:word_generator/word_generator.dart';

class AddMailAccountScreen extends StatefulWidget {
  final MailProductModel mailProduct;
  const AddMailAccountScreen({super.key, required this.mailProduct});

  @override
  State<AddMailAccountScreen> createState() {
    return _AddMailAccountScreensState();
  }
}

class _AddMailAccountScreensState extends State<AddMailAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _newAccount = '';
  String _newPassword = '';
  bool _showPWD = false;
  bool _showPWDMsg = false;
  bool _isLoading = false;
  MailAccountApi mailAccountApi = MailAccountApi();

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        MailboxStoreModel? mailboxStoreModel =
            await mailAccountApi.createAccount(
          widget.mailProduct.id!,
          _newAccount,
          _newPassword,
        );

        if (mailboxStoreModel != null) {
          NotificationHelper.displayMessage(
              context,
              AppLocalizations.of(context)!.api_new_account_added(
                  "${mailboxStoreModel.used}/${mailboxStoreModel.total}"));
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

  void _generatePWD() {
    String randomSentence = PasswordGenerator().generatePassword();
    randomSentence = randomSentence.replaceAll(RegExp('[@%]'), '.');
    _formKey.currentState!.save();
    _newPassword = randomSentence;
    _showPWD = true;
    _showPWDMsg = true;
    setState(() {});
  }

  Widget getPwdMsg() {
    if (_showPWDMsg) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          AppLocalizations.of(context)!.account_generate_msg,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.justify,
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: AppLocalizations.of(context)!.account_create_new,
      getBody: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.account_name),
                      suffixText: '@' + widget.mailProduct.customerName!,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1) {
                        return AppLocalizations.of(context)!
                            .account_name_validation;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newAccount = value!;
                    },
                    controller: TextEditingController()..text = _newAccount,
                  ),
                  TextFormField(
                    obscureText: !_showPWD,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.account_pwd),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _showPWD = !_showPWD;
                          });
                        },
                        icon: _showPWD
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1) {
                        return AppLocalizations.of(context)!
                            .account_pwd_validation;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newPassword = value!;
                    },
                    controller: TextEditingController()..text = _newPassword,
                  ),
                ],
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
                  onPressed: _generatePWD,
                  label:
                      Text(AppLocalizations.of(context)!.account_generate_pwd),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton.icon(
                  icon: _isLoading
                      ? const CircularProgressIcon()
                      : const Icon(Icons.add),
                  onPressed: _saveAccount,
                  label: Text(AppLocalizations.of(context)!.account_save),
                ),
              ],
            ),
            getPwdMsg()
          ],
        ),
      ),
    );
  }
}

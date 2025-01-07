import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/screens/add_mail_account.dart';
import 'package:infomaniak_email_admin_app/screens/mail_aliases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/widget/alert_dialog_widget.dart';
import 'package:infomaniak_email_admin_app/widget/circular_progress_icon_widget.dart';
import 'package:infomaniak_email_admin_app/widget/loading_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';
import 'package:infomaniak_email_admin_app/helpers/notification_helper.dart';

class MailAccountsScreen extends StatefulWidget {
  final MailProductModel account;
  const MailAccountsScreen({
    super.key,
    required this.account,
  });

  @override
  State<MailAccountsScreen> createState() {
    return _MailAccountsScreensState();
  }
}

class _MailAccountsScreensState extends State<MailAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';
  MailAccountApi mailAccountApi = MailAccountApi();
  List<MailAccountModel>? mailAccounts;

  @override
  void initState() {
    _loadEmail();
    super.initState();
  }

  void _loadEmail() async {
    mailAccounts = null;
    setState(() {});
    mailAccounts = await mailAccountApi.fetchAccountList(widget.account.id!);
    setState(() {});
  }

  void _searchEmail() async {
    _formKey.currentState!.save();
    mailAccounts = null;
    setState(() {});

    try {
      mailAccounts = _searchQuery.isEmpty
          ? await mailAccountApi.fetchAccountList(widget.account.id!)
          : await mailAccountApi.fetchAccountList(
              widget.account.id!,
              search: _searchQuery,
            );
    } on bool catch (e) {
      NotificationHelper.displayMessage(
        context,
        AppLocalizations.of(context)!.api_call_failed!,
      );
      mailAccounts = [];
    } catch (e) {
      NotificationHelper.displayMessage(
        context,
        e.toString(),
      );
      mailAccounts = [];
    }
    setState(() {});
  }

  void _removeAccount(index) async {
    try {
      bool wasDeleted = await mailAccountApi.deleteAccount(
          widget.account.id!, mailAccounts![index].mailboxName!);
      if (wasDeleted) {
        NotificationHelper.displayMessage(
          context,
          AppLocalizations.of(context)!
              .api_account_removed(mailAccounts![index].mailboxName!),
        );
        _searchEmail();
        Navigator.pop(context);
        setState(() {});
      }
    } catch (e) {
      NotificationHelper.displayMessage(
        context,
        e.toString(),
      );
    }
  }

  Future<void> _removeAccountDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialogWidget(
          title:
              AppLocalizations.of(context)!.settings_delete_API_key_modal_title,
          content: AppLocalizations.of(context)!.account_delete_account_title_msg(
              "${mailAccounts![index].mailboxName!}@${widget.account.customerName!}"),
          confirm: AppLocalizations.of(context)!.account_delete_confirm,
          onPressed: () {
            _removeAccount(index);
          },
        );
      },
    );
  }

  Widget getBody() {
    if (mailAccounts != null) {
      return RefreshIndicator(
        child: ListView(
          children: [
            ListTile(
              title: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: _searchQuery,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  onSaved: (value) {
                    _searchQuery = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return AppLocalizations.of(context)!.alias_new_validation;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchQuery = '';
                        _loadEmail();
                        _formKey.currentState!.reset();
                      },
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: mailAccounts == null
                    ? const CircularProgressIcon()
                    : const Icon(Icons.search),
                onPressed: () {
                  _searchEmail();
                },
              ),
            ),
            mailAccounts!.isNotEmpty
                ? ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mailAccounts!.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.email),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => MailAliasesScreen(
                              mailHostingId: widget.account.id!,
                              mailAccount: mailAccounts![index],
                            ),
                          ),
                        );
                      },
                      title: Text(mailAccounts![index].mailbox!),
                      trailing: IconButton(
                          onPressed: () async {
                            await _removeAccountDialog(context, index);
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  )
                : ListTile(
                    title: Text(AppLocalizations.of(context)!.not_found),
                  ),
          ],
        ),
        onRefresh: () async {
          _searchQuery.isEmpty ? _loadEmail() : _searchEmail();
        },
      );
    }

    return LoadingWidget(elements: mailAccounts);
  }

  IconButton getActionButton() {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddMailAccountScreen(
                  mailProduct: widget.account,
                )));
        await mailAccountApi.fetchAccountList(widget.account.id!);
        setState(() {});
      },
      icon: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: AppLocalizations.of(context)!.mail_accounts!,
      action: getActionButton(),
      getBody: getBody(),
    );
  }
}

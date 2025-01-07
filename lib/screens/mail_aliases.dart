import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/helpers/notification_helper.dart';
import 'package:infomaniak_email_admin_app/helpers/string_helper.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:infomaniak_email_admin_app/screens/add_mail_aliases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/widget/loading_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';

import '../widget/circular_progress_icon_widget.dart';

class MailAliasesScreen extends StatefulWidget {
  final int mailHostingId;
  final MailAccountModel mailAccount;
  const MailAliasesScreen(
      {super.key, required this.mailHostingId, required this.mailAccount});

  @override
  State<MailAliasesScreen> createState() {
    return _MailAliasesScreensState();
  }
}

class _MailAliasesScreensState extends State<MailAliasesScreen> {
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';
  MailAliasApi mailAliasApi = MailAliasApi();
  List<String>? mailAliases;
  bool _isLoading = true;
  final List<String> _beingDeletedIndex = [];

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    mailAliases = await mailAliasApi.fetchAliasesList(
        widget.mailHostingId, widget.mailAccount.mailboxName!);
    _isLoading = false;
    setState(() {});
  }

  void _searchAlias() async {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    mailAliases = mailAliases!.where((item) {
      return item.contains(_searchQuery);
    }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  Widget getBody() {
    String domain = StringHelper.getDomain(widget.mailAccount.mailboxIdn!);

    if (mailAliases != null) {
      return RefreshIndicator(
        child: ListView(
          children: [
            ListTile(
              title: Form(
                key: _formKey,
                child: TextFormField(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  onSaved: (value) {
                    _searchQuery = value!;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _initMailAccounts();
                        _searchQuery = '';
                        _formKey.currentState!.reset();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                icon: _isLoading
                    ? const CircularProgressIcon()
                    : const Icon(Icons.search),
                onPressed: () {
                  _searchAlias();
                },
              ),
            ),
            mailAliases!.isEmpty
                ? ListTile(
                    title: Text(AppLocalizations.of(context)!.not_found),
                  )
                : ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mailAliases!.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.email),
                      title: _beingDeletedIndex.contains(mailAliases![index])
                          ? Text(
                              AppLocalizations.of(context)!.api_deleting_alias)
                          : Text(mailAliases![index] + domain),
                      trailing: IconButton(
                        onPressed: () async {
                          String alias = mailAliases![index];
                          setState(() {
                            _beingDeletedIndex.add(alias);
                          });
                          try {
                            bool aliasRemoved = await mailAliasApi.removeAlias(
                              widget.mailHostingId,
                              widget.mailAccount.mailboxName!,
                              alias,
                            );
                            if (aliasRemoved) {
                              _initMailAccounts();
                              NotificationHelper.displayMessage(
                                  context,
                                  AppLocalizations.of(context)!
                                      .api_alias_deleted(alias));
                            }
                          } catch (e) {
                            NotificationHelper.displayMessage(
                                context, e.toString());
                          }
                          _beingDeletedIndex.remove(alias);
                        },
                        icon: _beingDeletedIndex.contains(mailAliases![index])
                            ? const CircularProgressIcon()
                            : const Icon(Icons.delete),
                      ),
                    ),
                  ),
          ],
        ),
        onRefresh: () async {
          _searchQuery.isEmpty
              ? mailAliases = await mailAliasApi.fetchAliasesList(
                  widget.mailHostingId,
                  widget.mailAccount.mailboxName!,
                )
              : null;
          setState(() {});
        },
      );
    }

    return LoadingWidget(elements: mailAliases);
  }

  IconButton getActionButton() {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => AddMailAliasesScreen(
                  mailHostingId: widget.mailHostingId,
                  mailbox: widget.mailAccount,
                )));
        mailAliases = await mailAliasApi.fetchAliasesList(
          widget.mailHostingId,
          widget.mailAccount.mailboxName!,
        );
        setState(() {});
      },
      icon: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: AppLocalizations.of(context)!
          .mail_aliases(widget.mailAccount.mailboxIdn!),
      action: getActionButton(),
      getBody: getBody(),
    );
  }
}

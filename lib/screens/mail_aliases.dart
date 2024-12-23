import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:infomaniak_email_admin_app/screens/add_mail_aliases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  MailAliasApi mailAliasApi = MailAliasApi();
  List<String> mailAliases = [];

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    mailAliases = await mailAliasApi.fetchAliasesList(
        context, widget.mailHostingId, widget.mailAccount.mailboxName!);
    setState(() {});
  }

  Widget getBody() {
    String domain = widget.mailAccount.mailboxIdn!
        .substring(widget.mailAccount.mailboxIdn!.indexOf('@'));

    if (mailAliases.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    }

    if (mailAliases.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailAliases.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(mailAliases[index] + domain),
                  trailing: IconButton(
                    onPressed: () async {
                      String alias = mailAliases[index];
                      setState(() {
                        mailAliases[index] =
                            AppLocalizations.of(context)!.api_deleting_alias;
                      });
                      await mailAliasApi.removeAlias(
                          context,
                          widget.mailHostingId,
                          widget.mailAccount.mailboxName!,
                          alias);
                      await mailAliasApi.fetchAliasesList(
                        context,
                        widget.mailHostingId,
                        widget.mailAccount.mailboxName!,
                      );
                      setState(() {});
                    },
                    icon: mailAliases[index] ==
                            AppLocalizations.of(context)!.api_deleting_alias
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const Icon(Icons.delete),
                  ),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await mailAliasApi.fetchAliasesList(
              context,
              widget.mailHostingId,
              widget.mailAccount.mailboxName!,
            );
            setState(() {});
          });
    }
    return const SizedBox(
      height: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .mail_aliases(widget.mailAccount.mailboxIdn!),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddMailAliasesScreen(
                        mailHostingId: widget.mailHostingId,
                        mailbox: widget.mailAccount,
                      )));
              await mailAliasApi.fetchAliasesList(
                context,
                widget.mailHostingId,
                widget.mailAccount.mailboxName!,
              );
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: getBody(),
      ),
    );
  }
}

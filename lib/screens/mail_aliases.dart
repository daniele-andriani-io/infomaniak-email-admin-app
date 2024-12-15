import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_alias.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/add_mail_aliases.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';

class MailAliasesScreen extends StatefulWidget {
  final int mailHostingId;
  final String mailboxName;
  const MailAliasesScreen(
      {super.key, required this.mailHostingId, required this.mailboxName});

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
        context, widget.mailHostingId, widget.mailboxName);
    setState(() {});
  }

  Widget getBody() {
    if (mailAliases.isEmpty) {
      return Center(
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
              Container(
                height: 40,
                child: const Center(
                  child: Text('mail aliases'),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailAliases.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.email),
                  title: Text(mailAliases[index]),
                  trailing: IconButton(
                    onPressed: () async {
                      String alias = mailAliases[index];
                      setState(() {
                        mailAliases[index] = 'deleting...';
                      });
                      await mailAliasApi.removeAlias(context,
                          widget.mailHostingId, widget.mailboxName, alias);
                      await mailAliasApi.fetchAliasesList(
                        context,
                        widget.mailHostingId,
                        widget.mailboxName,
                      );
                      setState(() {});
                    },
                    icon: mailAliases[index] == 'deleting...'
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
              Container(
                height: 40,
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => AddMailAliasesScreen(
                                mailHostingId: widget.mailHostingId,
                                mailboxName: widget.mailboxName,
                              )));
                      await mailAliasApi.fetchAliasesList(
                        context,
                        widget.mailHostingId,
                        widget.mailboxName,
                      );
                      setState(() {});
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
              )
            ],
          ),
          onRefresh: () async {
            await mailAliasApi.fetchAliasesList(
              context,
              widget.mailHostingId,
              widget.mailboxName,
            );
            setState(() {});
          });
    }
    return SizedBox(
      height: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infomaniak mail admin tool'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
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

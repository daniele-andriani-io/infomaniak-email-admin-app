import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/screens/mail_aliases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MailAccountsScreen extends StatefulWidget {
  final int accountId;
  const MailAccountsScreen({super.key, required this.accountId});

  @override
  State<MailAccountsScreen> createState() {
    return _MailAccountsScreensState();
  }
}

class _MailAccountsScreensState extends State<MailAccountsScreen> {
  MailAccountApi mailAccountApi = MailAccountApi();
  List<MailAccountModel> mailAccounts = [];

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    mailAccounts =
        await mailAccountApi.fetchAccountList(context, widget.accountId);
    setState(() {});
  }

  Widget getBody() {
    if (mailAccounts.isEmpty) {
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

    if (mailAccounts.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailAccounts.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MailAliasesScreen(
                          mailHostingId: widget.accountId,
                          mailAccount: mailAccounts[index],
                        ),
                      ),
                    );
                  },
                  title: Text(mailAccounts[index].mailbox!),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await mailAccountApi.fetchAccountList(context, widget.accountId);
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
        title: Text(AppLocalizations.of(context)!.mail_accounts!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: getBody(),
      ),
    );
  }
}

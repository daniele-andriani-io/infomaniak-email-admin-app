import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';

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

    if (mailAccounts.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              Container(
                height: 40,
                child: const Center(
                  child: Text('Mail accounts'),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailAccounts.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.email),
                  onTap: () {},
                  title: Text(mailAccounts[index].mailbox!),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await mailAccountApi.fetchAccountList(context, widget.accountId);
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

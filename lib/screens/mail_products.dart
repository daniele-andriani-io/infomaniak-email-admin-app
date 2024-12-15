import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/mail_accounts.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';

class MailProductsScreen extends StatefulWidget {
  final int accountId;
  const MailProductsScreen({super.key, required this.accountId});

  @override
  State<MailProductsScreen> createState() {
    return _MailProductsScreensState();
  }
}

class _MailProductsScreensState extends State<MailProductsScreen> {
  MailProductApi mailProductApi = MailProductApi();
  List<MailProductModel> mailProducts = [];

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    mailProducts = await mailProductApi.fetchProductList(context);
    setState(() {});
  }

  Widget getBody() {
    if (mailProducts.isEmpty) {
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

    if (mailProducts.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              Container(
                height: 40,
                child: const Center(
                  child: Text('Mail products'),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailProducts.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MailAccountsScreen(
                            accountId: mailProducts[index].id!)));
                  },
                  title: Text(mailProducts[index].customerName!),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await mailProductApi.fetchProductList(context);
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

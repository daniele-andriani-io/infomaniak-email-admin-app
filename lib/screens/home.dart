import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/account.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/account.dart';
import 'package:infomaniak_email_admin_app/screens/how_to_start.dart';
import 'package:infomaniak_email_admin_app/screens/mail_products.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String? _apiKey;
  AccountApi accountApi = AccountApi();
  List<AccountModel> accounts = [];

  @override
  void initState() {
    _apiKey = apiKeyProvider.getKey();
    _initAccounts();
    super.initState();
  }

  void _initAccounts() async {
    accounts = await accountApi.fetchAccountList(context);
    setState(() {});
  }

  Widget getBody() {
    if (_apiKey == null || accounts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please setup an API key to start'),
            Text('To do so, please go to the settings menu in the top right'),
          ],
        ),
      );
    }

    if (accounts.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              Container(
                height: 40,
                child: const Center(
                  child: Text('Accounts'),
                ),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MailProductsScreen(
                            accountId: accounts[index].id!)));
                  },
                  title: Text(accounts[index].name!),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await accountApi.fetchAccountList(context);
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

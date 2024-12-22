import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/mail_accounts.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String? _apiKey;
  MailProductApi mailProductApi = MailProductApi();
  List<MailProductModel> mailProducts = [];

  @override
  void initState() {
    _apiKey = apiKeyProvider.getKey();
    if (_apiKey != null) {
      _initMailAccounts();
    }
    super.initState();
  }

  void _initMailAccounts() async {
    mailProducts = await mailProductApi.fetchProductList(context);
    setState(() {});
  }

  Widget getBody() {
    if (mailProducts.isNotEmpty) {
      return RefreshIndicator(
          child: ListView(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailProducts.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.email),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MailAccountsScreen(
                            accountId: mailProducts[index].id!)));
                    setState(() {});
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

    if (mailProducts.isEmpty && _apiKey != null) {
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.start_APIinfo),
          Text(AppLocalizations.of(context)!.start_APIconfig),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mail_products),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
              );
              _initMailAccounts();
              setState(() {});
            },
            icon: const Icon(Icons.settings),
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

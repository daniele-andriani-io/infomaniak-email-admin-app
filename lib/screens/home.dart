import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_product.dart';
import 'package:infomaniak_email_admin_app/screens/mail_accounts.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infomaniak_email_admin_app/widget/loading_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';
import 'package:infomaniak_email_admin_app/helpers/notification_helper.dart';

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
  List<MailProductModel>? mailProducts;

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    if (apiKeyProvider.getKey() != null) {
      try {
        mailProducts = await mailProductApi.fetchProductList();
        setState(() {});
      } on bool catch (e) {
        NotificationHelper.displayMessage(
          context,
          AppLocalizations.of(context)!.api_call_failed!,
        );
      } catch (e) {
        NotificationHelper.displayMessage(
          context,
          e.toString(),
        );
      }
    } else {
      mailProducts = null;
    }
  }

  Widget getBody() {
    if (mailProducts != null) {
      return RefreshIndicator(
          child: ListView(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: mailProducts!.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.email),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MailAccountsScreen(
                          account: mailProducts![index],
                        ),
                      ),
                    );
                    _initMailAccounts();
                    setState(() {});
                  },
                  title: Text(mailProducts![index].customerName!),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            _initMailAccounts();
          });
    } else if (_apiKey != null) {
      return LoadingWidget(elements: mailProducts);
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

  IconButton getActionButton() {
    return IconButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
        );
        _initMailAccounts();
        setState(() {});
      },
      icon: const Icon(Icons.settings),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: AppLocalizations.of(context)!.mail_products,
      action: getActionButton(),
      getBody: getBody(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_account.dart';
import 'package:infomaniak_email_admin_app/models/infomaniak/mail_product.dart';
import 'package:infomaniak_email_admin_app/provider/infomaniak_api/mail_account.dart';
import 'package:infomaniak_email_admin_app/screens/add_mail_account.dart';
import 'package:infomaniak_email_admin_app/screens/mail_aliases.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MailAccountsScreen extends StatefulWidget {
  final MailProductModel account;
  const MailAccountsScreen({super.key, required this.account});

  @override
  State<MailAccountsScreen> createState() {
    return _MailAccountsScreensState();
  }
}

class _MailAccountsScreensState extends State<MailAccountsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = '';
  MailAccountApi mailAccountApi = MailAccountApi();
  List<MailAccountModel> mailAccounts = [];
  bool _isLoading = false;
  bool _isFiltered = false;

  @override
  void initState() {
    _initMailAccounts();
    super.initState();
  }

  void _initMailAccounts() async {
    mailAccounts =
        await mailAccountApi.fetchAccountList(context, widget.account.id!);
    setState(() {});
  }

  void _searchEmail(bool isFiltered) async {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
      _isFiltered = isFiltered;
    });

    if (!_isFiltered) {
      _searchQuery = '';
    }

    mailAccounts = _searchQuery.length == 0
        ? await mailAccountApi.fetchAccountList(context, widget.account.id!)
        : await mailAccountApi.fetchAccountList(
            context, widget.account.id!, _searchQuery);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _removeAccount(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!
              .settings_delete_API_key_modal_title),
          content: Text(
            AppLocalizations.of(context)!.account_delete_account_title_msg(
                "${mailAccounts[index].mailboxName!}@${widget.account.customerName!}"),
            style: Theme.of(ctx).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                await mailAccountApi.deleteAccount(context, widget.account.id!,
                    mailAccounts[index].mailboxName!);
                _searchEmail(true);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text(AppLocalizations.of(context)!.account_delete_confirm),
            ),
          ],
        );
      },
    );
  }

  Widget getBody() {
    if (mailAccounts.isNotEmpty || _searchQuery.length > 0) {
      if (mailAccounts.isEmpty) {
        return ListView(
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
                      onPressed: () {
                        _searchEmail(false);
                        _formKey.currentState!.reset();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  _searchEmail(true);
                },
                icon: _isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.search),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.not_found),
            )
          ],
        );
      }
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
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1) {
                        return AppLocalizations.of(context)!
                            .alias_new_validation;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchEmail(false);
                          _formKey.currentState!.reset();
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    _searchEmail(true);
                  },
                  icon: _isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.search),
                ),
              ),
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
                          mailHostingId: widget.account.id!,
                          mailAccount: mailAccounts[index],
                        ),
                      ),
                    );
                  },
                  title: Text(mailAccounts[index].mailbox!),
                  trailing: IconButton(
                      onPressed: () async {
                        await _removeAccount(context, index);
                      },
                      icon: Icon(Icons.delete)),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            await mailAccountApi.fetchAccountList(context, widget.account.id!);
            setState(() {});
          });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mail_accounts!),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddMailAccountScreen(
                        mailProduct: widget.account,
                      )));
              await mailAccountApi.fetchAccountList(
                  context, widget.account.id!);
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

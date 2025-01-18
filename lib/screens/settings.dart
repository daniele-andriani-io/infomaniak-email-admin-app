import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/widget/api_key_widget.dart';
import 'package:infomaniak_email_admin_app/widget/hall_of_fame_widget.dart';
import 'package:infomaniak_email_admin_app/widget/page_widget.dart';
import 'package:infomaniak_email_admin_app/widget/rewarded_ad_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: AppLocalizations.of(context)!.settings,
      getBody: ListView(
        children: const [
          RewardedAdWidget(),
          HallOfFameWidget(),
          ApiKeyWidget(),
        ],
      ),
    );
  }
}

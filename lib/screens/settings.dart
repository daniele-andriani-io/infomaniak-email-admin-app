import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/widget/api_key_widget.dart';
import 'package:infomaniak_email_admin_app/widget/rewarded_ad_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ApiKeyWidget(),
          RewardedAdWidget(),
        ],
      ),
    );
  }
}

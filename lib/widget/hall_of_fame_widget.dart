import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/how_to_start.dart';

class HallOfFameWidget extends StatefulWidget {
  const HallOfFameWidget({super.key});

  @override
  State<HallOfFameWidget> createState() {
    return _HallOfFameWidgetState();
  }
}

class _HallOfFameWidgetState extends State<HallOfFameWidget> {
  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.settings_hall_of_fame),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.monetization_on,
        ),
      ),
    );
  }
}

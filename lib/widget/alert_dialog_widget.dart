import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressed;
  final String confirm;

  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.confirm,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black,
            ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async {
            onPressed();
          },
          child: Text(confirm),
        ),
      ],
    );
  }
}

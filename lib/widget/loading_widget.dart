import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingWidget extends StatelessWidget {
  final List? elements;

  const LoadingWidget({super.key, this.elements});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          elements == null
              ? const CircularProgressIndicator()
              : Text(AppLocalizations.of(context)!.non_found),
        ],
      ),
    );
  }
}

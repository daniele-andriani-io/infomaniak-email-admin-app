import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          children: [
            ListTile(
              title: Text('Delete API key'),
              trailing: IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('API_KEY');
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete,
                ),
              ),
            )
          ],
        ));
  }
}

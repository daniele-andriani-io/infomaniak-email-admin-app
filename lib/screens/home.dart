import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infomaniak_email_admin_app/provider/api_key.dart';
import 'package:infomaniak_email_admin_app/screens/how_to_start.dart';
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

  Widget getBody() {
    if (_apiKey == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please setup an API key to start'),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => HowToStartScreen()));
                setState(() {
                  _apiKey = apiKeyProvider.getKey();
                });
              },
              child: Text('Go to API key setting'),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Setting done"),
        ],
      ),
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

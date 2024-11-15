import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infomaniak_email_admin_app/screens/how_to_start.dart';
import 'package:infomaniak_email_admin_app/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> _apiKey;

  @override
  void initState() {
    super.initState();
    _apiKey = _loadAPIKey();
  }

  Future<String?> _loadAPIKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('API_KEY');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _apiKey,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          print('API_KEY is null');
          return Scaffold(
            body: HowToStartScreen(),
          );
        }

        print('API_KEY is NOT null');
        return Scaffold(
          appBar: AppBar(
            title: Text('Infomaniak mail admin tool'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => SettingsScreen()),
                    );
                  });
                },
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:ck/pages/login_page.dart';
import 'package:ck/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.username});

  final String? username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPrefs prefs = SharedPrefs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Text(
              "Welcome ${widget.username}",
              style: const TextStyle(color: Colors.red, fontSize: 30.0),
            ),
            ElevatedButton(
              onPressed: () {
                prefs.setIsLogin(false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Home"),
            ),
          ],
        ),
      ),
    );
  }
}
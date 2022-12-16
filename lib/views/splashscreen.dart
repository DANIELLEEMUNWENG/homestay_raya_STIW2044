import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _MyAppState();
}

class _MyAppState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User user=User(
        id: "id",
        name: "name",
        email: "email",
        phone: "phone",
        address: "address",
        regdate: "regdate");
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user:user,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Home Stay Raya",
                  style: TextStyle(
                      fontSize: 32,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              CircularProgressIndicator(),
            ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:homestay_raya/views/profilescreen.dart';
import 'package:homestay_raya/views/updatescreen.dart';

import '../models/user.dart';
import 'signupscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main page'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 204, 255, 229)),
                accountEmail: Text(widget.user.email.toString(),
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0,
                            0))), // keep blank text because email is required
                accountName: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.check,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.user.name.toString(),
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          widget.user.phone.toString(),
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (content) => MainScreen(
                              user: User(
                                  id: "id",
                                  name: "name",
                                  email: "email",
                                  phone: "phone",
                                  address: "address",
                                  regdate: "regdate"))));
                },
              ),
              ListTile(
                title: const Text('Sign Up'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => const SignUp()));
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>  ProfileScreen(user: User(id: "id", name: "name", email: "email", phone: "phone", address: "address", regdate: "regdate"))));
                },
              ),
              ListTile(
                title: const Text('Update Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => UpdateScreen(user: User(id: "id", name: "name", email: "email", phone: "phone", address: "address", regdate: "regdate"))));
                },
              ),
            ],
          ),
        ));
  }
}

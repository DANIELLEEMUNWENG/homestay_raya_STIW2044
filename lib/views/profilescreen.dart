import 'package:flutter/material.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/loginscreen.dart';
import 'package:homestay_raya/views/mainscreen.dart';

import 'signupscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Text('Profile '),
          actions: [IconButton(onPressed: _loginform, icon: const Icon(Icons.login))],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 204, 255, 229)),
                accountEmail:
                    const Text('',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))), // keep blank text because email is required
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
                      children: const <Widget>[
                        Text(
                          'user',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Text(
                          '@User',
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
                          builder: (content) =>MainScreen(user:User(id: "id", name: "name", email: "email", phone: "phone", address: "address", regdate: "regdate"),)));
                  
                },
              ),
              ListTile(
                title: const Text('Sign Up'),
                onTap: () {
                   Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const SignUp()));
                  
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                   Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const ProfileScreen()));
                  
                },
              ),
            ],
          ),
        )
    );
  }

  void _loginform() {
    Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const Login()));
  }
}
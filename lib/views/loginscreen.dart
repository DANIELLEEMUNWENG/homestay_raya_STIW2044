import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homestay_raya/views/mainscreen.dart';

import 'package:homestay_raya/views/signupscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../confiq.dart';
import '../models/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailEditingController = TextEditingController();
  final _passEditingController = TextEditingController();

  bool? check1 = false;
  bool _passwordVisible = true;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(16),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains(".")
                          ? "enter a valid email"
                          : null,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.email),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ))),
                  TextFormField(
                      controller: _passEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(),
                        icon: const Icon(Icons.lock),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                        value: check1,
                        onChanged: (bool? value) {
                          setState(() {
                            check1 = value!;
                            saveremovepref(value);
                          });
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: null,
                          child: const Text('Remember me',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: _loginUser,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _goResgister,
                    child: const Text(
                      "Dont have an account?" "create one",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
        ),
      )),
    );
  }

  void _goResgister() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const SignUp()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences;
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formkey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        check1 = true;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        check1 = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<void> loadPref() async {
    SharedPreferences;
    final prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        check1 = true;
      });
    }
  }

  void _loginUser() {
    if (!_formkey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    http.post(Uri.parse("${Confiq.SERVER}/php/login_user.php"),
        body: {"email": _email, "password": _password}).then((response) {
      print(response.body);

      // var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        //     User user = User.fromJson(jsonResponse['data']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                    user: User(
                        id: "id",
                        name: "name",
                        email: "email",
                        phone: "phone",
                        address: "address",
                        regdate: "regdate"))));
      } else {
        Fluttertoast.showToast(
            msg: "Login failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }
}

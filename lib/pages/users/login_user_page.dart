import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/pages/home_page.dart';
import 'package:http/http.dart' as http;

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({Key? key}) : super(key: key);

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final _formLogin = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  late CurrentUser currentUser;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void login() async {
    if (_formLogin.currentState!.validate()) {
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      };
      Map<String, String> body = {
        "username": username.text,
        "password": password.text
      };
      try {
        final response = await http.post(
            Uri.parse('http://localhost/api/users/login'),
            headers: headers,
            body: body);
        if (response.statusCode == 200) {
          currentUser = CurrentUser.fromJson(jsonDecode(response.body));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(currentUser: currentUser)));
        } else if (response.statusCode == 403) {
          Map<String, dynamic> message = jsonDecode(response.body);
          String snackBarMessage = message['message'];
          showSnackBar(snackBarMessage);
        } else {
          throw Exception('Failed to connect to server');
        }
      } catch (e) {
        String snackBarMessage = 'Failed to connect to server';
        showSnackBar(snackBarMessage);
      }
    }
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.red),
      ),
      body: Form(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Image(
                    height: 100,
                    image: AssetImage('assets/images/car.png'),
                  ),
                  Text(
                    'Vehicle Tracking Management System',
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Form(
              key: _formLogin,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Column(children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Username',
                    ),
                    validator: (String? username) {
                      if (username == null || username.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    controller: username,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (String? password) {
                      if (password == null || password.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    controller: password,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: login,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

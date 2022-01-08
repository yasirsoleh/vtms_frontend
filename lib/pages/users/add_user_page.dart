// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;

class AddUserPage extends StatefulWidget {
  final CurrentUser currentUser;
  const AddUserPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final name = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final password_confirmation = TextEditingController();
  final _formAddUser = GlobalKey<FormState>();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    password_confirmation.dispose();
    name.dispose();
    super.dispose();
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addUser(BuildContext context) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, String> body = {
      "name": name.text,
      "username": username.text,
      "password": password.text,
      "password_confirmation": password_confirmation.text,
    };

    final response = await http.post(Uri.parse('http://10.0.2.2/api/users'),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
      Navigator.pop(context);
    } else if (response.statusCode != 200) {
      Map<String, dynamic> errorMessage = jsonDecode(response.body);
      showSnackBar(errorMessage['message']);
    } else {
      throw Exception('Failed to add user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add New User'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (_formAddUser.currentState!.validate()) {
                  addUser(context);
                }
              },
              icon: const Icon(Icons.save),
            ),
          ]),
      body: Form(
        key: _formAddUser,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: name,
                validator: (String? name) {
                  if (name == null || name.isEmpty) {
                    return 'Please enter user name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                controller: username,
                validator: (String? username) {
                  if (username == null || username.isEmpty) {
                    return 'Please enter user username';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                controller: password,
                validator: (String? password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter user password';
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Confirmation',
                ),
                controller: password_confirmation,
                validator: (String? password_confirmation) {
                  if (password_confirmation == null ||
                      password_confirmation.isEmpty) {
                    return 'Please enter user password confirmation';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

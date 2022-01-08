// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;

class ChangePasswordUserPage extends StatefulWidget {
  final CurrentUser currentUser;
  const ChangePasswordUserPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ChangePasswordUserPage> createState() => _ChangePasswordUserPageState();
}

class _ChangePasswordUserPageState extends State<ChangePasswordUserPage> {
  final password = TextEditingController();
  final password_confirmation = TextEditingController();

  @override
  void dispose() {
    password.dispose();
    password_confirmation.dispose();
    super.dispose();
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> changePassword(
      {required String password, required String password_confirmation}) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };

    Map<String, String> body = {
      "password": password,
      "password_confirmation": password_confirmation,
    };

    final response = await http.post(
        Uri.parse('http://10.0.2.2/api/users/change_password'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
      Navigator.pop(context);
    } else if (response.statusCode == 422) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage =
          message['errors']['password'][0] ?? message['errors']['password'][1];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Cannot change password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Change Password'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                changePassword(
                  password: password.text,
                  password_confirmation: password_confirmation.text,
                );
              },
              icon: const Icon(Icons.save),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              controller: password,
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Confirmation',
              ),
              controller: password_confirmation,
            ),
          ],
        ),
      ),
    );
  }
}

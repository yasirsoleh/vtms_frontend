// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ChangePasswordUserPage extends StatefulWidget {
  const ChangePasswordUserPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordUserPage> createState() => _ChangePasswordUserPageState();
}

class _ChangePasswordUserPageState extends State<ChangePasswordUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Change Password'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
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
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Confirmation',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

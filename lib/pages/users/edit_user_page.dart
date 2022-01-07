// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/user.dart';
import 'package:http/http.dart' as http;

class EditUserPage extends StatefulWidget {
  final CurrentUser currentUser;
  final User user;
  const EditUserPage({
    Key? key,
    required this.currentUser,
    required this.user,
  }) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late Future<User> futureUser;
  final _formEditProfile = GlobalKey<FormState>();
  final name = TextEditingController();
  final username = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<User> fetchUser() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse('http://localhost/api/users/${widget.user.id}'),
        headers: headers);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };

    Map<String, String> body = {
      "name": name.text,
      "username": username.text,
    };

    final response = await http.put(
        Uri.parse('http://localhost/api/users/${widget.user.id}'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else if (response.statusCode != 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (_formEditProfile.currentState!.validate()) {
                updateUser().then((_) {
                  Navigator.pop(context, true);
                });
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              name.text = snapshot.data!.name;
              username.text = snapshot.data!.username;
              return Form(
                key: _formEditProfile,
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
                            return 'Please enter your username';
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
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          }),
    );
  }
}

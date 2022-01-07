import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/user.dart';
import 'package:vtms_frontend/pages/users/edit_profile_user_page.dart';
import 'package:http/http.dart' as http;

class ViewProfileUserPage extends StatefulWidget {
  final CurrentUser currentUser;

  const ViewProfileUserPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ViewProfileUserPage> createState() => _ViewProfileUserPageState();
}

class _ViewProfileUserPageState extends State<ViewProfileUserPage> {
  late Future<User> futureUser;

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
    final response = await http.get(Uri.parse('http://localhost/api/users/'),
        headers: headers);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileUserPage(
                    currentUser: widget.currentUser,
                  ),
                ),
              ).then((_) {
                setState(() {
                  futureUser = fetchUser();
                });
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.name,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Username',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.username,
                    textScaleFactor: 2,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

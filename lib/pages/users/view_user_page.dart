import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:vtms_frontend/pages/users/edit_user_page.dart';

class ViewUserPage extends StatefulWidget {
  final User user;
  final CurrentUser currentUser;
  const ViewUserPage({Key? key, required this.currentUser, required this.user})
      : super(key: key);

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
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
    final response = await http.get(
        Uri.parse('http://10.0.2.2/api/users/${widget.user.id}'),
        headers: headers);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> deleteUser() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.delete(
        Uri.parse('http://10.0.2.2/api/users/${widget.user.id}'),
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Widget _deletePopUp(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Are you sure you want to delete this user?"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            deleteUser();
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserPage(
                    currentUser: widget.currentUser,
                    user: widget.user,
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _deletePopUp(context),
              ).then(
                (_) => Navigator.pop(context),
              );
            },
            icon: const Icon(Icons.delete),
          )
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

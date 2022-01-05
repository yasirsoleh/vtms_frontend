// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/users/add_user_page.dart';
import 'package:vtms_frontend/pages/users/view_user_page.dart';

class ListUsersPage extends StatefulWidget {
  const ListUsersPage({Key? key}) : super(key: key);

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUserPage()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 20,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: const Text('WERKRKRK'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewUserPage()));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 2);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/users/edit_user_page.dart';

class ViewUserPage extends StatelessWidget {
  const ViewUserPage({Key? key}) : super(key: key);

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
                      builder: (context) => const EditUserPage()));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Name',
              textScaleFactor: 1,
            ),
            Text(
              'Mohammad Alif Yasir',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Usermame',
              textScaleFactor: 1,
            ),
            Text(
              'yasirsoleh',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

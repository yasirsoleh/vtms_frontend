import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/users/login_user_page.dart';

void main() {
  runApp(const VtmsApp());
}

class VtmsApp extends StatelessWidget {
  const VtmsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTMS',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const LoginUserPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

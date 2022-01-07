// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/camera.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;

class EditCameraPage extends StatefulWidget {
  final Camera camera;
  final CurrentUser currentUser;
  const EditCameraPage({
    Key? key,
    required this.currentUser,
    required this.camera,
  }) : super(key: key);

  @override
  State<EditCameraPage> createState() => _EditCameraPageState();
}

class _EditCameraPageState extends State<EditCameraPage> {
  final _formEditCamera = GlobalKey<FormState>();
  String _traffic_direction = 'inbound';

  late Future<Camera> futureCamera;

  @override
  void initState() {
    super.initState();
    futureCamera = fetchCamera();
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Camera> fetchCamera() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse('http://localhost/api/cameras/${widget.camera.id}'),
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
      return Camera.fromJson(jsonDecoded['camera']);
    } else {
      throw Exception('Failed to load camera');
    }
  }

  Future<void> updateCamera() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };

    Map<String, String> body = {
      "name": _formEditCamera.currentState?.value['name'],
      "username": username.text,
    };

    final response = await http.put(
        Uri.parse('http://localhost/api/cameras/${widget.camera.id}'),
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
        title: const Text('Edit Camera'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: FutureBuilder<Camera>(
        future: futureCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formEditCamera,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Camera Name',
                      ),
                      initialValue: snapshot.data!.name,
                      validator: (String? username) {
                        if (username == null || username.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: _traffic_direction,
                      decoration: const InputDecoration(
                        labelText: 'Traffic Direction',
                      ),
                      icon: const Icon(Icons.arrow_downward),
                      items: const [
                        DropdownMenuItem(
                          child: Text('inbound'),
                          value: 'inbound',
                        ),
                        DropdownMenuItem(
                          child: Text('outbound'),
                          value: 'outbound',
                        )
                      ],
                      onChanged: (String? newValue) async {
                        setState(() {
                          _traffic_direction = newValue!;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                      ),
                      initialValue: snapshot.data!.latitude,
                      validator: (String? username) {
                        if (username == null || username.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                      ),
                      initialValue: snapshot.data!.longitude,
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
        },
      ),
    );
  }
}

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;

class AddCameraPage extends StatefulWidget {
  final CurrentUser currentUser;
  const AddCameraPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AddCameraPage> createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  final name = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  String traffic_direction = 'inbound';
  final _formAddCamera = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    latitude.dispose();
    longitude.dispose();
    super.dispose();
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addCamera(BuildContext context) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, String> body = {
      "name": name.text,
      "latitude": latitude.text,
      "longitude": longitude.text,
      "traffic_direction": traffic_direction,
    };

    final response = await http.post(Uri.parse('http://10.0.2.2/api/cameras'),
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
          title: const Text('Add New Camera'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (_formAddCamera.currentState!.validate()) {
                  addCamera(context);
                }
              },
              icon: const Icon(Icons.save),
            ),
          ]),
      body: Form(
        key: _formAddCamera,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Camera Name',
                ),
                controller: name,
                validator: (String? name) {
                  if (name == null || name.isEmpty) {
                    return 'Please enter camera name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: traffic_direction,
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
                    traffic_direction = newValue!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                ),
                controller: latitude,
                validator: (String? latitude) {
                  if (latitude == null || latitude.isEmpty) {
                    return 'Please enter camera latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                ),
                controller: longitude,
                validator: (String? longitude) {
                  if (longitude == null || longitude.isEmpty) {
                    return 'Please enter camera longitude';
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

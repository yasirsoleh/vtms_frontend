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
  final _name = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  late String _traffic_direction;

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
      "Content-Type": "application/x-www-form-urlencoded",
    };

    Map<String, String> body = {
      "name": _name.text,
      "traffic_direction": _traffic_direction,
      "latitude": _latitude.text,
      "longitude": _longitude.text,
    };

    print('_traffic_direction at body: ${body['traffic_direction']}');

    final response = await http.put(
        Uri.parse('http://localhost/api/cameras/${widget.camera.id}'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      print(message);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else if (response.statusCode != 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      print(message);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Failed to load camera');
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
            onPressed: () {
              if (_formEditCamera.currentState!.validate()) {
                _formEditCamera.currentState!.save();
                updateCamera().then((_) {
                  Navigator.pop(context);
                });
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: FutureBuilder<Camera>(
        future: futureCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _name.text = snapshot.data!.name;
            _traffic_direction = snapshot.data!.traffic_direction;
            _latitude.text = snapshot.data!.latitude;
            _longitude.text = snapshot.data!.longitude;
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
                      controller: _name,
                      validator: (String? name) {
                        if (name == null || name.isEmpty) {
                          return 'Please enter camera name';
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
                      items: [
                        DropdownMenuItem(
                          child: const Text('inbound'),
                          value: 'inbound',
                          onTap: () {
                            setState(() {
                              _traffic_direction = 'inbound';
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: const Text('outbound'),
                          value: 'outbound',
                          onTap: () {
                            setState(() {
                              _traffic_direction = 'outbound';
                            });
                          },
                        )
                      ],
                      onChanged: (String? traffic_direction) {
                        setState(() {
                          _traffic_direction = traffic_direction!;
                        });
                      },
                      onSaved: (String? traffic_direction) {
                        setState(() {
                          _traffic_direction = traffic_direction!;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                      ),
                      controller: _latitude,
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
                      controller: _longitude,
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

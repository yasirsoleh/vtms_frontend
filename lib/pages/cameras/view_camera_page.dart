import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/camera.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/pages/cameras/edit_camera_page.dart';
import 'package:http/http.dart' as http;

class ViewCameraPage extends StatefulWidget {
  final Camera camera;
  final CurrentUser currentUser;
  const ViewCameraPage({
    Key? key,
    required this.currentUser,
    required this.camera,
  }) : super(key: key);

  @override
  State<ViewCameraPage> createState() => _ViewCameraPageState();
}

class _ViewCameraPageState extends State<ViewCameraPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCameraPage(
                    currentUser: widget.currentUser,
                    camera: widget.camera,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder<Camera>(
        future: futureCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Camera Name',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.name,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Token',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.plain_text_token!,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Traffic Direction',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.traffic_direction,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Latitude',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.latitude,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Longitude',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.longitude,
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

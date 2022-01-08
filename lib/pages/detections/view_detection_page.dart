import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/detection.dart';
import 'package:vtms_frontend/models/detection_with_camera.dart';
import 'package:http/http.dart' as http;

class ViewDetectionPage extends StatefulWidget {
  final Detection detection;
  final CurrentUser currentUser;
  const ViewDetectionPage({
    Key? key,
    required this.currentUser,
    required this.detection,
  }) : super(key: key);

  @override
  State<ViewDetectionPage> createState() => _ViewDetectionPageState();
}

class _ViewDetectionPageState extends State<ViewDetectionPage> {
  late Future<DetectionWithCamera> futureDetectionWithCamera;

  @override
  void initState() {
    super.initState();
    futureDetectionWithCamera = fetchDetectionWithCamera();
  }

  Future<DetectionWithCamera> fetchDetectionWithCamera() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse('http://10.0.2.2/api/detections/${widget.detection.id}'),
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
      return DetectionWithCamera.fromJson(jsonDecoded['detection']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<DetectionWithCamera>(
        future: futureDetectionWithCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plate Number',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.plate_number,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Timestamp',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.created_at.toString(),
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Camera Name',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.camera.name,
                    textScaleFactor: 2,
                  ),
                  const Text(
                    'Direction',
                    textScaleFactor: 1,
                  ),
                  Text(
                    snapshot.data!.camera.traffic_direction,
                    textScaleFactor: 2,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

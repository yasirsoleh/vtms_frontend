import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final Completer<GoogleMapController> _controller = Completer();

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
        Uri.parse('http://192.168.0.139/api/detections/${widget.detection.id}'),
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
      return DetectionWithCamera.fromJson(jsonDecoded['detection']);
    } else {
      throw Exception('Failed to load detections');
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
            CameraPosition _initPos = CameraPosition(
                target: LatLng(
                  double.parse(snapshot.data!.camera.latitude),
                  double.parse(snapshot.data!.camera.longitude),
                ),
                zoom: 16);
            Marker marker = Marker(
                markerId: MarkerId(snapshot.data!.camera.id),
                position: LatLng(
                  double.parse(snapshot.data!.camera.latitude),
                  double.parse(snapshot.data!.camera.longitude),
                ),
                infoWindow: InfoWindow(
                  title: snapshot.data!.camera.name,
                  snippet: snapshot.data!.created_at.toLocal().toString(),
                ));
            Set<Marker> markers = {marker};
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plate Number',
                  textScaleFactor: 1.5,
                ),
                Text(
                  snapshot.data!.plate_number,
                  textScaleFactor: 2,
                ),
                const Text(
                  'Timestamp',
                  textScaleFactor: 1.5,
                ),
                Text(
                  snapshot.data!.created_at.toLocal().toString(),
                  textScaleFactor: 2,
                ),
                const Text(
                  'Camera Name',
                  textScaleFactor: 1.5,
                ),
                Text(
                  snapshot.data!.camera.name,
                  textScaleFactor: 2,
                ),
                const Text(
                  'Direction',
                  textScaleFactor: 1.5,
                ),
                Text(
                  snapshot.data!.camera.traffic_direction,
                  textScaleFactor: 2,
                ),
                const Text(
                  'Location',
                  textScaleFactor: 1.5,
                ),
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _initPos,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                  ),
                ),
              ],
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

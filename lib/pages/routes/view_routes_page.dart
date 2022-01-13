// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/detection_with_camera.dart';
import 'package:http/http.dart' as http;

class ViewRoutePage extends StatefulWidget {
  final String plate_number;
  final CurrentUser currentUser;
  const ViewRoutePage({
    Key? key,
    required this.currentUser,
    required this.plate_number,
  }) : super(key: key);

  @override
  State<ViewRoutePage> createState() => _ViewRoutePageState();
}

class _ViewRoutePageState extends State<ViewRoutePage> {
  final Completer<GoogleMapController> _controller = Completer();

  late Future<List<DetectionWithCamera>> futureDetectionsWithCamera;

  @override
  void initState() {
    super.initState();
    futureDetectionsWithCamera = fetchDetectionsWithCamera();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<DetectionWithCamera>> fetchDetectionsWithCamera() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse(
            'http://10.0.2.2/api/detections/plate_numbers/show/${widget.plate_number}'),
        headers: headers);
    if (response.statusCode == 200) {
      List jsonDecoded = jsonDecode(response.body);
      return jsonDecoded.map((m) => DetectionWithCamera.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load detections');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DetectionWithCamera>>(
        future: futureDetectionsWithCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Set<Marker> markers = Set.from(
              snapshot.data!.map(
                (e) => Marker(
                  markerId: MarkerId(e.id),
                  position: LatLng(
                    double.parse(e.camera.latitude),
                    double.parse(e.camera.longitude),
                  ),
                  infoWindow: InfoWindow(
                    title: e.camera.name,
                    snippet: e.created_at.toLocal().toString(),
                  ),
                ),
              ),
            );

            CameraPosition _initPos = CameraPosition(
                target: LatLng(
                  double.parse(snapshot.data!.elementAt(0).camera.latitude),
                  double.parse(snapshot.data!.elementAt(0).camera.longitude),
                ),
                zoom: 16);
            //return Text(snapshot.data!.elementAt(0).camera.name);
            return GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initPos,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

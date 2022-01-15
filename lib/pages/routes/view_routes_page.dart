// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/detection_with_camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  late List<DetectionWithCamera> detectionsWithCamera;

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
            'http://192.168.0.139/api/detections/plate_numbers/show/${widget.plate_number}'),
        headers: headers);
    if (response.statusCode == 200) {
      List jsonDecoded = jsonDecode(response.body);
      return jsonDecoded.map((m) => DetectionWithCamera.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load detections');
    }
  }

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(
      DetectionWithCamera start, DetectionWithCamera destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAr45bUxXAtWl2UhR-CVZa1wVzhEnGh7Bg", // Google Maps API Key
      PointLatLng(double.parse(start.camera.latitude),
          double.parse(start.camera.longitude)),
      PointLatLng(double.parse(destination.camera.latitude),
          double.parse(destination.camera.longitude)),
      travelMode: TravelMode.walking,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    // Defining an ID
    PolylineId id = PolylineId('${start.id}-to-${destination.id}');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
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

            detectionsWithCamera = snapshot.data!;
            detectionsWithCamera.sort((a, b) =>
                a.created_at.toLocal().compareTo(b.created_at.toLocal()));

            // for (var i = 0; i < detectionsWithCamera.length - 1; i++) {
            //   _createPolylines(detectionsWithCamera.elementAt(i),
            //       detectionsWithCamera.elementAt(i + 1));
            // }

            CameraPosition _initPos = CameraPosition(
                target: LatLng(
                  double.parse(snapshot.data!.elementAt(0).camera.latitude),
                  double.parse(snapshot.data!.elementAt(0).camera.longitude),
                ),
                zoom: 14);

            //Set<Polyline> test = Set<Polyline>.of(polylines.values);
            //print(test.elementAt().points);

            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initPos,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
              //polylines: test,
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

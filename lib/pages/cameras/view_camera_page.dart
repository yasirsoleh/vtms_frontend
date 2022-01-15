import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final Completer<GoogleMapController> _controller = Completer();

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
        Uri.parse('http://192.168.0.139/api/cameras/${widget.camera.id}'),
        headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonDecoded = jsonDecode(response.body);
      return Camera.fromJson(jsonDecoded['camera']);
    } else {
      throw Exception('Failed to load camera');
    }
  }

  Future<void> deleteCamera() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.delete(
        Uri.parse('http://192.168.0.139/api/cameras/${widget.camera.id}'),
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Failed to load camera');
    }
  }

  Widget _deletePopUp(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Are you sure you want to delete this camera?"),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            deleteCamera();
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _columnIsAdmin(AsyncSnapshot snapshot) {
    if (widget.currentUser.user.is_admin == "true") {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
    } else {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    }
  }

  List<Widget> _createAppBarAction() {
    if (widget.currentUser.user.is_admin != "true") {
      return [];
    } else {
      return [
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
            ).then((_) {
              setState(() {
                futureCamera = fetchCamera();
              });
            });
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _deletePopUp(context),
            ).then(
              (_) => Navigator.pop(context),
            );
          },
          icon: const Icon(Icons.delete),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Details'),
        centerTitle: true,
        actions: _createAppBarAction(),
      ),
      body: FutureBuilder<Camera>(
        future: futureCamera,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _columnIsAdmin(snapshot),
                ),
                Flexible(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(snapshot.data!.latitude),
                        double.parse(snapshot.data!.longitude),
                      ),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId(snapshot.data!.id),
                        position: LatLng(
                          double.parse(snapshot.data!.latitude),
                          double.parse(snapshot.data!.longitude),
                        ),
                        infoWindow: InfoWindow(
                          title: snapshot.data!.name,
                          snippet: snapshot.data!.traffic_direction,
                        ),
                      )
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final name = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  late String _traffic_direction;
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _initialMarkerPosition;
  late Future<Camera> futureCamera;

  @override
  void initState() {
    super.initState();
    futureCamera = fetchCamera();
    _initialMarkerPosition = LatLng(
      double.parse(widget.camera.latitude),
      double.parse(widget.camera.longitude),
    );
    name.text = widget.camera.name;
    _traffic_direction = widget.camera.traffic_direction;
    latitude.text = widget.camera.latitude;
    longitude.text = widget.camera.longitude;
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
        Uri.parse('http://vtms.online/api/cameras/${widget.camera.id}'),
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
      "name": name.text,
      "traffic_direction": _traffic_direction,
      "latitude": latitude.text,
      "longitude": longitude.text,
    };

    final response = await http.put(
        Uri.parse('http://vtms.online/api/cameras/${widget.camera.id}'),
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
            onPressed: () async {
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
      body: Column(
        children: [
          Padding(
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
                    controller: name,
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
          Flexible(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _initialMarkerPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: const MarkerId('current_position'),
                  position: _initialMarkerPosition,
                  draggable: true,
                  onDragEnd: (value) {
                    setState(() {
                      latitude.text = value.latitude.toString();
                      longitude.text = value.longitude.toString();
                    });
                  },
                ),
              },
            ),
          )
        ],
      ),
    );
  }
}

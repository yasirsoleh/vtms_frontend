// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  final Completer<GoogleMapController> _controller = Completer();
  late Future<LatLng> initialPosition;
  late LatLng _initialMarkerPosition;

  @override
  void dispose() {
    name.dispose();
    latitude.dispose();
    longitude.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialPosition = _getInitialPosition();
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

    final response = await http.post(
        Uri.parse('http://vtms.online/api/cameras'),
        headers: headers,
        body: body);

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

  Future<LatLng> _getInitialPosition() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } on Exception catch (e) {
      throw Exception('$e');
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
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
          Flexible(
            child: FutureBuilder<LatLng>(
              future: initialPosition,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _initialMarkerPosition =
                      LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
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
                        anchor: const Offset(0.5, 0.5),
                        onDragEnd: (value) {
                          setState(() {
                            latitude.text = value.latitude.toString();
                            longitude.text = value.longitude.toString();
                          });
                        },
                      ),
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

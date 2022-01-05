// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class EditCameraPage extends StatefulWidget {
  const EditCameraPage({Key? key}) : super(key: key);

  @override
  State<EditCameraPage> createState() => _EditCameraPageState();
}

class _EditCameraPageState extends State<EditCameraPage> {
  String _traffic_direction = 'inbound';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Camera'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Camera Name',
              ),
            ),
            DropdownButtonFormField(
              value: _traffic_direction,
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
                  _traffic_direction = newValue!;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Latitude',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Longitude',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddCameraPage extends StatefulWidget {
  const AddCameraPage({Key? key}) : super(key: key);

  @override
  State<AddCameraPage> createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
  String _traffic_direction = 'inbound';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Camera'),
        centerTitle: true,
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
            const SizedBox(
              height: 10,
            ),
            const Text('Traffic Direction'),
            RadioListTile(
              title: const Text('Inbound'),
              groupValue: _traffic_direction,
              value: 'inbound',
              onChanged: (value) {
                setState(() {
                  _traffic_direction = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('Outbound'),
              groupValue: _traffic_direction,
              value: 'outbound',
              onChanged: (value) {
                setState(() {
                  _traffic_direction = value.toString();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/cameras/edit_camera_page.dart';

class ViewCameraPage extends StatelessWidget {
  const ViewCameraPage({Key? key}) : super(key: key);

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
                      builder: (context) => const EditCameraPage()));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Camera Name',
              textScaleFactor: 1,
            ),
            Text(
              'Main Gate 1',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Token',
              textScaleFactor: 1,
            ),
            Text(
              '52|fVYh2Rnxn0gcNS0ecLh30GEoRK6g8jkCJ5Uw48Yk',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Traffic Direction',
              textScaleFactor: 1,
            ),
            Text(
              'Outbound',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Latitude',
              textScaleFactor: 1,
            ),
            Text(
              '3.547966172323439',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Longitude',
              textScaleFactor: 1,
            ),
            Text(
              '103.43754957238477',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

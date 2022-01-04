import 'package:flutter/material.dart';

class DetectionDetailsPage extends StatelessWidget {
  const DetectionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Plate Number',
              textScaleFactor: 1,
            ),
            Text(
              'TW7155',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Timestamp',
              textScaleFactor: 1,
            ),
            Text(
              '10/12/2022 10.00 PM',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Camera Name',
              textScaleFactor: 1,
            ),
            Text(
              'Main Gate 7',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Direction',
              textScaleFactor: 1,
            ),
            Text(
              'Outbound',
              textScaleFactor: 2,
              //style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

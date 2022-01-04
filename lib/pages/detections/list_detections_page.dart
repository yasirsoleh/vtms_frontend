import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/detections/detection_details_page.dart';

class ListDetectionsPage extends StatefulWidget {
  const ListDetectionsPage({Key? key}) : super(key: key);

  @override
  State<ListDetectionsPage> createState() => _ListDetectionsPageState();
}

class _ListDetectionsPageState extends State<ListDetectionsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: const Text('TW7155'),
          subtitle: const Text('10/12/2022 12.00 PM'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DetectionDetailsPage()));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 2);
      },
    );
  }
}

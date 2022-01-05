import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/cameras/view_camera_page.dart';

class ListCamerasPage extends StatefulWidget {
  const ListCamerasPage({Key? key}) : super(key: key);

  @override
  State<ListCamerasPage> createState() => _ListCamerasPageState();
}

class _ListCamerasPageState extends State<ListCamerasPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: const Text('Main Gate 1'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewCameraPage()));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 2);
      },
    );
  }
}

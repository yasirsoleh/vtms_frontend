import 'package:flutter/material.dart';

class RouteDetailsPage extends StatelessWidget {
  const RouteDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('Here Maps')),
      ),
    );
  }
}

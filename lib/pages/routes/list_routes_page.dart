import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:vtms_frontend/pages/routes/view_routes_page.dart';

class ListRoutesPage extends StatefulWidget {
  final CurrentUser currentUser;
  const ListRoutesPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ListRoutesPage> createState() => _ListRoutesPageState();
}

class _ListRoutesPageState extends State<ListRoutesPage> {
  late Future<List<String>> futureListPlateNumbers;
  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<String>> fetchListPlateNumbers() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse("http://192.168.0.139/api/detections/plate_numbers/list"),
        headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => e.toString()).toList();
    } else {
      throw Exception('Failed to load routes');
    }
  }

  @override
  void initState() {
    super.initState();
    futureListPlateNumbers = fetchListPlateNumbers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureListPlateNumbers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 2);
            },
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRoutePage(
                        currentUser: widget.currentUser,
                        plate_number: snapshot.data![index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

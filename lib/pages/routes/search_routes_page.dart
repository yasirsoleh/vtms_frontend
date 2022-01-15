import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:vtms_frontend/pages/routes/view_routes_page.dart';

class SearchRoutesPage extends StatefulWidget {
  final CurrentUser currentUser;
  const SearchRoutesPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _SearchRoutesPageState createState() => _SearchRoutesPageState();
}

class _SearchRoutesPageState extends State<SearchRoutesPage> {
  final name = TextEditingController();
  late Future<List<String>> futureListRoute;

  Future<List<String>> fetchListRoute() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final http.Response response;
    if (name.text == '') {
      response = await http.get(
          Uri.parse("http://192.168.0.139/api/detections/plate_numbers/search"),
          headers: headers);
    } else {
      response = await http.get(
          Uri.parse(
              "http://192.168.0.139/api/detections/plate_numbers/search/${name.text}"),
          headers: headers);
    }

    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => e.toString()).toList();
    } else if (response.statusCode != 200) {
      return [];
    } else {
      throw Exception('Failed to load cameras');
    }
  }

  @override
  void initState() {
    super.initState();
    futureListRoute = fetchListRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    name.text = '';
                    setState(() {
                      futureListRoute = fetchListRoute();
                    });
                  },
                ),
                hintText: 'Search Route...',
                border: InputBorder.none),
            controller: name,
            validator: (String? name) {
              if (name == null || name.isEmpty) {
                return 'Please enter camera name';
              }
              return null;
            },
            onChanged: (_) {
              setState(() {
                futureListRoute = fetchListRoute();
              });
            },
          ),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: futureListRoute,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 2);
              },
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.elementAt(index)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewRoutePage(
                          currentUser: widget.currentUser,
                          plate_number: snapshot.data!.elementAt(index),
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
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/user.dart';
import 'package:vtms_frontend/pages/cameras/add_camera_page.dart';
import 'package:vtms_frontend/pages/cameras/list_cameras_page.dart';
import 'package:vtms_frontend/pages/cameras/search_cameras_page.dart';
import 'package:vtms_frontend/pages/detections/list_detections_page.dart';
import 'package:vtms_frontend/pages/detections/search_detections_page.dart';
import 'package:vtms_frontend/pages/routes/list_routes_page.dart';
import 'package:vtms_frontend/pages/routes/search_routes_page.dart';
import 'package:vtms_frontend/pages/users/change_password_user_page.dart';
import 'package:vtms_frontend/pages/users/list_users_page.dart';
import 'package:vtms_frontend/pages/users/login_user_page.dart';
import 'package:vtms_frontend/pages/users/view_profile_user_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final CurrentUser currentUser;
  const HomePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<User> futureUser;

  Future<User> fetchUser() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(Uri.parse('http://vtms.online/api/users/'),
        headers: headers);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> logoutUser() async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(
        Uri.parse('http://vtms.online/api/users/logout'),
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      String snackBarMessage = message['message'];
      showSnackBar(snackBarMessage);
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showSnackBar(String snackBarMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(snackBarMessage),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _widgetOptions(int option) {
    switch (option) {
      case 0:
        return ListDetectionsPage(
          currentUser: widget.currentUser,
        );
      case 1:
        return ListRoutesPage(
          currentUser: widget.currentUser,
        );
      case 2:
        return ListCamerasPage(
          currentUser: widget.currentUser,
        );
      default:
        return ListDetectionsPage(
          currentUser: widget.currentUser,
        );
    }
  }

  static const List<Widget> _titleOptions = <Widget>[
    Text('Detections'),
    Text('Routes'),
    Text('Cameras'),
  ];

  List<Widget> _createAppBarActions() {
    switch (_selectedIndex) {
      case 0:
        return <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchDetectionPage(
                    currentUser: widget.currentUser,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ];
      case 1:
        return <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchRoutesPage(
                    currentUser: widget.currentUser,
                  ),
                ),
              ).then((value) {});
            },
            icon: const Icon(Icons.search),
          ),
        ];
      case 2:
        if (widget.currentUser.user.is_admin != "true") {
          return <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchCamerasPage(
                      currentUser: widget.currentUser,
                    ),
                  ),
                ).then((value) {});
              },
              icon: const Icon(Icons.search),
            ),
          ];
        } else {
          return <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCameraPage(
                      currentUser: widget.currentUser,
                    ),
                  ),
                ).then((value) {});
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchCamerasPage(
                      currentUser: widget.currentUser,
                    ),
                  ),
                ).then((value) {});
              },
              icon: const Icon(Icons.search),
            ),
          ];
        }
      default:
        return <Widget>[];
    }
  }

  List<BottomNavigationBarItem> createBottomNavigationBarItem() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.car_repair_outlined),
        label: 'Detections',
        activeIcon: Icon(Icons.car_repair_sharp),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.navigation_outlined),
        label: 'Routes',
        activeIcon: Icon(Icons.navigation_sharp),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt_outlined),
        label: 'Cameras',
        activeIcon: Icon(Icons.camera_alt_sharp),
      ),
    ];
  }

  List<Widget> _createDrawerItems() {
    if (widget.currentUser.user.is_admin != "true") {
      return [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          child: Row(
            children: const [
              Center(
                child: Image(
                  image: AssetImage('assets/images/car.png'),
                  height: 60,
                ),
              ),
              Expanded(
                child: Text(
                  'Vehicle Tracking Management System',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              }
              return Text(widget.currentUser.user.name);
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewProfileUserPage(currentUser: widget.currentUser),
              ),
            ).then((_) {
              setState(() {
                futureUser = fetchUser();
              });
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text('Change Password'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordUserPage(
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            logoutUser();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginUserPage(),
                ),
                (route) => false);
          },
        ),
      ];
    } else {
      return [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          child: Row(
            children: const [
              Center(
                child: Image(
                  image: AssetImage('assets/images/car.png'),
                  height: 60,
                ),
              ),
              Expanded(
                child: Text(
                  'Vehicle Tracking Management System',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.5,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              }
              return Text(widget.currentUser.user.name);
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewProfileUserPage(currentUser: widget.currentUser),
              ),
            ).then((_) {
              setState(() {
                futureUser = fetchUser();
              });
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.group),
          title: const Text('Users'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListUsersPage(
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.password),
          title: const Text('Change Password'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordUserPage(
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            logoutUser();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginUserPage(),
                ),
                (route) => false);
          },
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titleOptions.elementAt(_selectedIndex),
        centerTitle: true,
        actions: _createAppBarActions(),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.red),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: _createDrawerItems(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.red,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: createBottomNavigationBarItem(),
      ),
      body: Center(
        child: _widgetOptions(_selectedIndex),
      ),
    );
  }
}

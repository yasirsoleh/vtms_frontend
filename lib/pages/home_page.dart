import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vtms_frontend/pages/cameras/add_camera_page.dart';
import 'package:vtms_frontend/pages/cameras/list_cameras_page.dart';
import 'package:vtms_frontend/pages/detections/list_detections_page.dart';
import 'package:vtms_frontend/pages/routes/list_routes_page.dart';
import 'package:vtms_frontend/pages/users/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ListDetectionsPage(),
    ListRoutesPage(),
    ListCamerasPage(),
  ];

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
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ];
      case 1:
        return <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ];
      case 2:
        return <Widget>[
          IconButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCameraPage()));
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ];
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
        title: const Text('Your Name von Aguero'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.group),
        title: const Text('Users'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.password),
        title: const Text('Change Password'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () async {
          Navigator.pop(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        },
      ),
    ];
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
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

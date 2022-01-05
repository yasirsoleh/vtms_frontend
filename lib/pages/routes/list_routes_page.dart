import 'package:flutter/material.dart';
import 'package:vtms_frontend/pages/routes/view_routes_page.dart';

class ListRoutesPage extends StatefulWidget {
  const ListRoutesPage({Key? key}) : super(key: key);

  @override
  State<ListRoutesPage> createState() => _ListRoutesPageState();
}

class _ListRoutesPageState extends State<ListRoutesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: const Text('TW7155'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ViewRoutePage()));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 2);
      },
    );
  }
}

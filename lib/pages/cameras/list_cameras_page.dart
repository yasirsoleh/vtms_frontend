import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/camera.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/paginated_cameras.dart';
import 'package:vtms_frontend/pages/cameras/view_camera_page.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListCamerasPage extends StatefulWidget {
  final CurrentUser currentUser;
  const ListCamerasPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ListCamerasPage> createState() => _ListCamerasPageState();
}

class _ListCamerasPageState extends State<ListCamerasPage> {
  final PagingController<Uri, Camera> _pagingController =
      PagingController(firstPageKey: Uri.parse('http://localhost/api/cameras'));

  Future<PaginatedCameras> fetchNextPaginatedUsers(Uri next) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(next, headers: headers);

    if (response.statusCode == 200) {
      return PaginatedCameras.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cameras');
    }
  }

  Future<void> _fetchPage(Uri pageKey) async {
    try {
      final newPaginatedCamera = await fetchNextPaginatedUsers(pageKey);
      final isLastPage = newPaginatedCamera.links.next == null;
      if (isLastPage) {
        _pagingController.appendLastPage(newPaginatedCamera.data);
      } else {
        _pagingController.appendPage(
            newPaginatedCamera.data, newPaginatedCamera.links.next);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<Uri, Camera>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Camera>(
        itemBuilder: (context, item, index) => ListTile(
          title: Text(item.name),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewCameraPage(
                  currentUser: widget.currentUser,
                  camera: item,
                ),
              ),
            ).then((_) {
              setState(() {
                _pagingController.refresh();
              });
            });
          },
        ),
      ),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 2);
      },
    );
  }
}

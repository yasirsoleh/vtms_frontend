import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/detection.dart';
import 'package:vtms_frontend/models/paginated_detections.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vtms_frontend/pages/detections/view_detection_page.dart';

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
  final PagingController<Uri, Detection> _pagingController = PagingController(
      firstPageKey: Uri.parse('http://10.0.2.2/api/detections/plate_numbers'));

  Future<PaginatedDetections> fetchNextPaginatedUsers(Uri next) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(next, headers: headers);

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return PaginatedDetections.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cameras');
    }
  }

  Future<void> _fetchPage(Uri pageKey) async {
    try {
      final newPaginatedDetections = await fetchNextPaginatedUsers(pageKey);
      final isLastPage = newPaginatedDetections.next_page_url == null;
      if (isLastPage) {
        _pagingController.appendLastPage(newPaginatedDetections.data);
      } else {
        _pagingController.appendPage(
            newPaginatedDetections.data, newPaginatedDetections.next_page_url);
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
  void dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<Uri, Detection>.separated(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Detection>(
        itemBuilder: (context, item, index) => ListTile(
          title: Text(item.plate_number),
          trailing: const Icon(Icons.arrow_forward_ios),
          subtitle: Text(item.created_at.toLocal().toString()),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewDetectionPage(
                  currentUser: widget.currentUser,
                  detection: item,
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

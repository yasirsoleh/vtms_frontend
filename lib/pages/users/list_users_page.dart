// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/models/paginated_users.dart';
import 'package:vtms_frontend/models/user.dart';
import 'package:vtms_frontend/pages/users/add_user_page.dart';
import 'package:vtms_frontend/pages/users/view_user_page.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListUsersPage extends StatefulWidget {
  final CurrentUser currentUser;
  const ListUsersPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  final PagingController<Uri, User> _pagingController = PagingController(
      firstPageKey: Uri.parse('http://localhost/api/users/list'));

  Future<PaginatedUsers> fetchNextPaginatedUsers(Uri next_page_url) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${widget.currentUser.token}",
    };
    final response = await http.get(next_page_url, headers: headers);

    if (response.statusCode == 200) {
      return PaginatedUsers.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> _fetchPage(Uri pageKey) async {
    try {
      final newPaginatedUser = await fetchNextPaginatedUsers(pageKey);
      final isLastPage = newPaginatedUser.next_page_url == null;
      if (isLastPage) {
        _pagingController.appendLastPage(newPaginatedUser.data);
      } else {
        _pagingController.appendPage(
            newPaginatedUser.data, newPaginatedUser.next_page_url);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddUserPage()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PagedListView<Uri, User>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<User>(
          itemBuilder: (context, item, index) => ListTile(
            title: Text(item.name),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewUserPage(
                    currentUser: widget.currentUser,
                    user: item,
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
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:vtms_frontend/models/detection.dart';

class PaginatedDetections extends Equatable {
  final List<Detection> data;
  final Uri path;
  final int per_page;
  final Uri? next_page_url;
  final Uri? prev_page_url;

  const PaginatedDetections(
      {required this.data,
      required this.path,
      required this.per_page,
      this.next_page_url,
      this.prev_page_url});

  factory PaginatedDetections.fromJson(Map<String, dynamic> json) =>
      PaginatedDetections(
        data: (json['data'] as List)
            .map((data) => Detection.fromJson(data))
            .toList(),
        path: Uri.parse(json['path'] as String),
        per_page: json['per_page'] as int,
        next_page_url: (json['next_page_url'] != null)
            ? Uri.parse(json['next_page_url'] as String)
            : null,
        prev_page_url: (json['prev_page_url'] != null)
            ? Uri.parse(json['prev_page_url'] as String)
            : null,
      );

  @override
  List<Object?> get props => [
        data,
        path,
        per_page,
        next_page_url,
        prev_page_url,
      ];
}

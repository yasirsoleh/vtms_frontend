// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:vtms_frontend/models/camera.dart';
import 'package:vtms_frontend/models/paginated_links.dart';

class PaginatedCameras extends Equatable {
  final List<Camera> data;
  final PaginatedLinks links;

  const PaginatedCameras({required this.data, required this.links});

  factory PaginatedCameras.fromJson(Map<String, dynamic> json) =>
      PaginatedCameras(
        data: (json['data'] as List)
            .map((data) => Camera.fromJson(data))
            .toList(),
        links: PaginatedLinks.fromJson(json['links']),
      );

  @override
  List<Object?> get props => [
        data,
        links,
      ];
}

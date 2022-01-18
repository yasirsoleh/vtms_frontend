// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:vtms_frontend/models/camera.dart';

class DetectionWithCamera extends Equatable {
  final String id;
  final String camera_id;
  final String plate_number;
  final String? image;
  final Camera camera;
  final DateTime created_at;
  final DateTime updated_at;

  const DetectionWithCamera({
    required this.id,
    required this.camera_id,
    required this.plate_number,
    required this.camera,
    this.image,
    required this.created_at,
    required this.updated_at,
  });

  factory DetectionWithCamera.fromJson(Map<String, dynamic> json) =>
      DetectionWithCamera(
        id: (json['id'] as int).toString(),
        camera_id: (json['camera_id'] as int).toString(),
        plate_number: json['plate_number'] as String,
        camera: Camera.fromJson(json['camera'] as Map<String, dynamic>),
        image: json['image'] as dynamic,
        created_at: DateTime.parse(json['created_at'] as String),
        updated_at: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'camera_id': camera_id,
        'plate_number': plate_number,
        'image': image,
        'camera': camera.toJson(),
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        camera_id,
        plate_number,
        image,
        camera,
        created_at,
        updated_at,
      ];
}

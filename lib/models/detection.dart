// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class Detection extends Equatable {
  final String id;
  final String camera_id;
  final String plate_number;
  final String? image;
  final DateTime created_at;
  final DateTime updated_at;

  const Detection({
    required this.id,
    required this.camera_id,
    required this.plate_number,
    this.image,
    required this.created_at,
    required this.updated_at,
  });

  factory Detection.fromJson(Map<String, dynamic> json) => Detection(
        id: (json['id'] as int).toString(),
        camera_id: (json['camera_id'] as int).toString(),
        plate_number: json['plate_number'] as String,
        image: json['image'] as dynamic,
        created_at: DateTime.parse(json['created_at'] as String),
        updated_at: DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'camera_id': camera_id,
        'plate_number': plate_number,
        'image': image,
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        camera_id,
        plate_number,
        image,
        created_at,
        updated_at,
      ];
}

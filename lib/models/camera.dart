// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class Camera extends Equatable {
  final String id;
  final String name;
  final String? plain_text_token;
  final String traffic_direction;
  final String latitude;
  final String longitude;
  final DateTime created_at;
  final DateTime updated_at;

//create constructor for Camera
  const Camera({
    required this.id,
    required this.name,
    this.plain_text_token,
    required this.traffic_direction,
    required this.latitude,
    required this.longitude,
    required this.created_at,
    required this.updated_at,
  });

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        id: json["id"].toString(),
        name: json["name"] as String,
        plain_text_token: json["plain_text_token"] as String,
        traffic_direction: json["traffic_direction"] as String,
        latitude: json["latitude"] as String,
        longitude: json["longitude"] as String,
        created_at: DateTime.parse(json["created_at"] as String),
        updated_at: DateTime.parse(json["updated_at"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "plain_text_token": plain_text_token,
        "traffic_direction": traffic_direction,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        plain_text_token,
        traffic_direction,
        latitude,
        longitude,
        created_at,
        updated_at,
      ];
}

// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String is_admin;
  final String username;
  final DateTime created_at;
  final DateTime updated_at;

  const User({
    required this.id,
    required this.name,
    required this.is_admin,
    required this.username,
    required this.created_at,
    required this.updated_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"].toString(),
        name: json["name"],
        is_admin: json["is_admin"].toString(),
        username: json["username"] as String,
        created_at: DateTime.parse(json["created_at"]),
        updated_at: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_admin": is_admin,
        "username": username,
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        is_admin,
        username,
        created_at,
        updated_at,
      ];
}

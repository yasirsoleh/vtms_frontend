import 'package:equatable/equatable.dart';
import 'package:vtms_frontend/models/user.dart';

class CurrentUser extends Equatable {
  final String token;
  final User user;

  const CurrentUser({required this.token, required this.user});

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>));

  @override
  List<Object?> get props => [token, user];
}

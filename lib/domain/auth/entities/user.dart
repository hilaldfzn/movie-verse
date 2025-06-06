import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final bool isLoggedIn;
  final DateTime lastLoginDate;

  const User({
    required this.id,
    required this.username,
    required this.isLoggedIn,
    required this.lastLoginDate,
  });

  @override
  List<Object?> get props => [id, username, isLoggedIn, lastLoginDate];
}
import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int? id;
  final String name;
  final String? avatar;
  final String userId;
  final DateTime createdAt;

  const Profile({
    this.id,
    required this.name,
    this.avatar,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, avatar, userId, createdAt];
}
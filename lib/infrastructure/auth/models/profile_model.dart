import '../../../domain/auth/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    int? id,
    required String name,
    String? avatar,
    required String userId,
    required DateTime createdAt,
  }) : super(
          id: id,
          name: name,
          avatar: avatar,
          userId: userId,
          createdAt: createdAt,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
import '../../../domain/auth/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String username,
    required bool isLoggedIn,
    required DateTime lastLoginDate,
  }) : super(
          id: id,
          username: username,
          isLoggedIn: isLoggedIn,
          lastLoginDate: lastLoginDate,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      isLoggedIn: json['isLoggedIn'],
      lastLoginDate: DateTime.parse(json['lastLoginDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isLoggedIn': isLoggedIn,
      'lastLoginDate': lastLoginDate.toIso8601String(),
    };
  }
}
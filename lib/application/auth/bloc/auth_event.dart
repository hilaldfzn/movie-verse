part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class ProfileCreationRequested extends AuthEvent {
  final String name;
  final String? avatar;
  final String userId;

  const ProfileCreationRequested({
    required this.name,
    this.avatar,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, avatar, userId];
}

class ProfilesLoadRequested extends AuthEvent {
  final String userId;

  const ProfilesLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LogoutRequested extends AuthEvent {}
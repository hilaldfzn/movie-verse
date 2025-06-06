part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileCreated extends AuthState {
  final Profile profile;

  const ProfileCreated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfilesLoaded extends AuthState {
  final List<Profile> profiles;

  const ProfilesLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
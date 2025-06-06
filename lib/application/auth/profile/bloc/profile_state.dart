part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfilesLoaded extends ProfileState {
  final List<Profile> profiles;

  const ProfilesLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}

class ProfileSelected extends ProfileState {
  final Profile profile;

  const ProfileSelected(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileCreated extends ProfileState {
  final Profile profile;

  const ProfileCreated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileDeleted extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
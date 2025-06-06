part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilesEvent extends ProfileEvent {
  final String userId;

  const LoadProfilesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateProfileEvent extends ProfileEvent {
  final String name;
  final String? avatar;
  final String userId;

  const CreateProfileEvent({
    required this.name,
    this.avatar,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, avatar, userId];
}

class SelectProfileEvent extends ProfileEvent {
  final int profileId;

  const SelectProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}

class DeleteProfileEvent extends ProfileEvent {
  final int profileId;

  const DeleteProfileEvent(this.profileId);

  @override
  List<Object?> get props => [profileId];
}
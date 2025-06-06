import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/auth/entities/profile.dart';
import '../../../../domain/auth/usecases/create_profile.dart';
import '../../../../domain/auth/usecases/get_profiles.dart';
import '../../../../domain/auth/repositories/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CreateProfile createProfile;
  final GetProfiles getProfiles;
  final AuthRepository authRepository;

  ProfileBloc({
    required this.createProfile,
    required this.getProfiles,
    required this.authRepository,
  }) : super(ProfileInitial()) {
    on<LoadProfilesEvent>(_onLoadProfiles);
    on<CreateProfileEvent>(_onCreateProfile);
    on<SelectProfileEvent>(_onSelectProfile);
    on<DeleteProfileEvent>(_onDeleteProfile);
  }

  Future<void> _onLoadProfiles(
    LoadProfilesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await getProfiles(GetProfilesParams(userId: event.userId));
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profiles) => emit(ProfilesLoaded(profiles)),
    );
  }

  Future<void> _onCreateProfile(
    CreateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await createProfile(CreateProfileParams(
      name: event.name,
      avatar: event.avatar,
      userId: event.userId,
    ));
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileCreated(profile)),
    );
  }

  Future<void> _onSelectProfile(
    SelectProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    final result = await authRepository.selectProfile(event.profileId);
    
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) async {
        final profileResult = await authRepository.getCurrentProfile();
        profileResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (profile) => emit(ProfileSelected(profile!)),
        );
      },
    );
  }

  Future<void> _onDeleteProfile(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    // Implementation for profile deletion would go here
    // For now, just emit success
    emit(ProfileDeleted());
  }
}
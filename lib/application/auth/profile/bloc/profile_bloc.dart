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
    print('ProfileBloc: Loading profiles for userId: ${event.userId}'); // Debug log
    emit(ProfileLoading());
    
    try {
      final result = await getProfiles.call(GetProfilesParams(userId: event.userId));
      
      result.fold(
        (failure) {
          print('ProfileBloc: Failed to load profiles: ${failure.message}'); // Debug log
          emit(ProfileError(failure.message));
        },
        (profiles) {
          print('ProfileBloc: Loaded ${profiles.length} profiles'); // Debug log
          emit(ProfilesLoaded(profiles));
        },
      );
    } catch (e) {
      print('ProfileBloc: Exception loading profiles: $e'); // Debug log
      emit(ProfileError('Failed to load profiles: $e'));
    }
  }

  Future<void> _onCreateProfile(
    CreateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    print('ProfileBloc: Creating profile: ${event.name}'); // Debug log
    emit(ProfileLoading());
    
    try {
      final result = await createProfile.call(CreateProfileParams(
        name: event.name,
        avatar: event.avatar,
        userId: event.userId,
      ));
      
      result.fold(
        (failure) {
          print('ProfileBloc: Failed to create profile: ${failure.message}'); // Debug log
          emit(ProfileError(failure.message));
        },
        (profile) {
          print('ProfileBloc: Profile created successfully: ${profile.name}'); // Debug log
          emit(ProfileCreated(profile));
        },
      );
    } catch (e) {
      print('ProfileBloc: Exception creating profile: $e'); // Debug log
      emit(ProfileError('Failed to create profile: $e'));
    }
  }

  Future<void> _onSelectProfile(
    SelectProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    print('ProfileBloc: Selecting profile: ${event.profileId}'); // Debug log
    emit(ProfileLoading());
    
    try {
      final result = await authRepository.selectProfile(event.profileId);
      
      result.fold(
        (failure) {
          print('ProfileBloc: Failed to select profile: ${failure.message}'); // Debug log
          emit(ProfileError(failure.message));
        },
        (_) async {
          final profileResult = await authRepository.getCurrentProfile();
          profileResult.fold(
            (failure) {
              print('ProfileBloc: Failed to get current profile: ${failure.message}'); // Debug log
              emit(ProfileError(failure.message));
            },
            (profile) {
              if (profile != null) {
                print('ProfileBloc: Profile selected successfully: ${profile.name}'); // Debug log
                emit(ProfileSelected(profile));
              } else {
                emit(ProfileError('Selected profile not found'));
              }
            },
          );
        },
      );
    } catch (e) {
      print('ProfileBloc: Exception selecting profile: $e'); // Debug log
      emit(ProfileError('Failed to select profile: $e'));
    }
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
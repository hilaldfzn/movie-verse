import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/entities/profile.dart';
import '../../../domain/auth/usecases/login_user.dart';
import '../../../domain/auth/usecases/create_profile.dart';
import '../../../domain/auth/usecases/get_profiles.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final CreateProfile createProfile;
  final GetProfiles getProfiles;

  AuthBloc({
    required this.loginUser,
    required this.createProfile,
    required this.getProfiles,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<ProfileCreationRequested>(_onProfileCreationRequested);
    on<ProfilesLoadRequested>(_onProfilesLoadRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await loginUser(event.username, event.password);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }

  Future<void> _onProfileCreationRequested(
    ProfileCreationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await createProfile(event.name, event.avatar, event.userId);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) => emit(ProfileCreated(profile)),
    );
  }

  Future<void> _onProfilesLoadRequested(
    ProfilesLoadRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await getProfiles(event.userId);
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profiles) => emit(ProfilesLoaded(profiles)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInitial());
  }
}
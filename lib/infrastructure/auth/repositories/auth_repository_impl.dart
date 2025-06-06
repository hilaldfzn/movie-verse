import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/entities/profile.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> loginUser(String username, String password) async {
    try {
      print('AuthRepository: Attempting login for user: $username'); // Debug log
      
      // Simple validation: username and password must be the same
      if (username != password) {
        return Left(ServerFailure('Username and password must be the same'));
      }

      final userModel = UserModel(
        id: username,
        username: username,
        isLoggedIn: true,
        lastLoginDate: DateTime.now(),
      );

      await localDataSource.cacheUser(userModel);
      print('AuthRepository: User logged in successfully: $username'); // Debug log
      return Right(userModel);
    } on CacheException catch (e) {
      print('AuthRepository: Cache exception during login: $e'); // Debug log
      return Left(CacheFailure('Failed to save user data: ${e.message}'));
    } catch (e) {
      print('AuthRepository: Exception during login: $e'); // Debug log
      return Left(ServerFailure('Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure('Failed to logout: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure('No user found: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Profile>> createProfile(String name, String? avatar, String userId) async {
    try {
      print('AuthRepository: Creating profile: $name for user: $userId'); // Debug log
      
      final profileModel = ProfileModel(
        name: name,
        avatar: avatar,
        userId: userId,
        createdAt: DateTime.now(),
      );

      final createdProfile = await localDataSource.createProfile(profileModel);
      print('AuthRepository: Profile created successfully: ${createdProfile.name}'); // Debug log
      return Right(createdProfile);
    } on CacheException catch (e) {
      print('AuthRepository: Failed to create profile: $e'); // Debug log
      return Left(CacheFailure('Failed to create profile: ${e.message}'));
    } catch (e) {
      print('AuthRepository: Exception creating profile: $e'); // Debug log
      return Left(ServerFailure('Failed to create profile: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getProfiles(String userId) async {
    try {
      print('AuthRepository: Getting profiles for user: $userId'); // Debug log
      
      final profiles = await localDataSource.getProfiles(userId);
      print('AuthRepository: Found ${profiles.length} profiles'); // Debug log
      return Right(profiles);
    } on CacheException catch (e) {
      print('AuthRepository: Failed to get profiles: $e'); // Debug log
      return Left(CacheFailure('Failed to get profiles: ${e.message}'));
    } catch (e) {
      print('AuthRepository: Exception getting profiles: $e'); // Debug log
      return Left(ServerFailure('Failed to get profiles: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> selectProfile(int profileId) async {
    try {
      await localDataSource.selectProfile(profileId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure('Failed to select profile: ${e.message}'));
    }
  }

  @override
  Future<Either<Failure, Profile?>> getCurrentProfile() async {
    try {
      final profile = await localDataSource.getCurrentProfile();
      return Right(profile);
    } on CacheException catch (e) {
      return Left(CacheFailure('No profile selected: ${e.message}'));
    }
  }
}
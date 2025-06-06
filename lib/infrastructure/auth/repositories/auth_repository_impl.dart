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
      return Right(userModel);
    } on CacheException {
      return Left(CacheFailure('Failed to save user data'));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure('No user found'));
    }
  }

  @override
  Future<Either<Failure, Profile>> createProfile(String name, String? avatar, String userId) async {
    try {
      final profileModel = ProfileModel(
        name: name,
        avatar: avatar,
        userId: userId,
        createdAt: DateTime.now(),
      );

      final createdProfile = await localDataSource.createProfile(profileModel);
      return Right(createdProfile);
    } on CacheException {
      return Left(CacheFailure('Failed to create profile'));
    }
  }

  @override
  Future<Either<Failure, List<Profile>>> getProfiles(String userId) async {
    try {
      final profiles = await localDataSource.getProfiles(userId);
      return Right(profiles);
    } on CacheException {
      return Left(CacheFailure('Failed to get profiles'));
    }
  }

  @override
  Future<Either<Failure, void>> selectProfile(int profileId) async {
    try {
      await localDataSource.selectProfile(profileId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to select profile'));
    }
  }

  @override
  Future<Either<Failure, Profile?>> getCurrentProfile() async {
    try {
      final profile = await localDataSource.getCurrentProfile();
      return Right(profile);
    } on CacheException {
      return Left(CacheFailure('No profile selected'));
    }
  }
}
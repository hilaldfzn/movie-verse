import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginUser(String username, String password);
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, Profile>> createProfile(String name, String? avatar, String userId);
  Future<Either<Failure, List<Profile>>> getProfiles(String userId);
  Future<Either<Failure, void>> selectProfile(int profileId);
  Future<Either<Failure, Profile?>> getCurrentProfile();
}
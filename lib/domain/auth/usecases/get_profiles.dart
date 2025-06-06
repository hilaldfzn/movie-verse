import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/profile.dart';
import '../repositories/auth_repository.dart';

class GetProfiles {
  final AuthRepository repository;

  GetProfiles(this.repository);

  Future<Either<Failure, List<Profile>>> call(GetProfilesParams params) async {
    return await repository.getProfiles(params.userId);
  }
}

class GetProfilesParams extends Equatable {
  final String userId;

  const GetProfilesParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
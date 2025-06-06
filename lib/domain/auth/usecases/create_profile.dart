import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../entities/profile.dart';
import '../repositories/auth_repository.dart';

class CreateProfile {
  final AuthRepository repository;

  CreateProfile(this.repository);

  Future<Either<Failure, Profile>> call(CreateProfileParams params) async {
    return await repository.createProfile(
      params.name,
      params.avatar,
      params.userId,
    );
  }
}

class CreateProfileParams extends Equatable {
  final String name;
  final String? avatar;
  final String userId;

  const CreateProfileParams({
    required this.name,
    this.avatar,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, avatar, userId];
}
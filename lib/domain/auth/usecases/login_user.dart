import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, User>> call(String username, String password) async {
    return await repository.loginUser(username, password);
  }
}
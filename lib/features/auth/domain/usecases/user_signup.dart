// ignore_for_file: public_member_api_docs, sort_constructors_first
//is independent of data layer, usecases must have rules of either return types or params

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UseCaseSignUp({
    required this.authRepository,
  });
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  UserSignUpParams({
    required this.name,
    required this.email, 
    required this.password,
  });
}


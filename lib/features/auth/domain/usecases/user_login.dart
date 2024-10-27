import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UseCaseLogin({
    required this.authRepository,
  });
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    try {
      return await authRepository.loginWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
      //return right(user);
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}

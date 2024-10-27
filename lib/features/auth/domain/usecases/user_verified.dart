
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserCaseVerified implements UseCase<User, NoParams>{
  final AuthRepository authRepository;

  UserCaseVerified({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    try{
      return await authRepository.isUserVerified();
    }
    catch(e){
      return left(Failure(e.toString(),),);
    }
  }

}
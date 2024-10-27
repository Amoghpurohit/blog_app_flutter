import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({         //we are going to get data from supabase in the future and need to handle both success and failure of this action
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> isUserVerified();
}

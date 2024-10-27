// implements the repo interface in domain layer

import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource; //dependency injection
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.connectionChecker});

  @override
  Future<Either<Failure, User>> isUserVerified() async {
    try {
      if (!await (connectionChecker.isConnectedToInternet)) {
        final session = remoteDataSource.currentUserSession;
        if (session != null) {
          return right(
            UserModel(
              id: session.user.id,
              name: '',
              email: session.user.email!,
            ),
          );
        }
        return left(
          Failure(
            'User not logged in',
          ),
        );
      }
      final verifiedUserData = await remoteDataSource.getVerifiedUser();

      if (verifiedUserData == null) {
        return left(
          Failure('No user data found'),
        );
      }
      return right(verifiedUserData);
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpData(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginData(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnectedToInternet)) {
        return left(
          Failure(
            Constants.internetConnectionErrorMessage,
          ),
        );
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}

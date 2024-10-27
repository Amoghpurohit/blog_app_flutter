
import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, NoParams>{
  Future<Either<Failure, SuccessType>> call(NoParams params);
}

class NoParams{}
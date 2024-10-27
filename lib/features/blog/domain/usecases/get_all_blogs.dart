
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

class UseCaseGetAllBlogs implements UseCase<List<Blog>, NoParams>{
  final BlogRepository blogRepository;

  UseCaseGetAllBlogs({required this.blogRepository});

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    try{  
      return await blogRepository.fetchAllBlogs();
    }catch(e){
      return left(Failure(e.toString(),),);
    }
  }
  
}
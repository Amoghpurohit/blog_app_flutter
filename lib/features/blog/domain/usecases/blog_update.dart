
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseBlogUpdate implements UseCase<void, BlogUpdateParams> {
  final BlogRepository blogRepository;

  UseCaseBlogUpdate({required this.blogRepository});

  @override
  Future<Either<Failure, void>> call(BlogUpdateParams params) async {
    try {
      await blogRepository.updateBlog(
        id: params.id,
        title: params.title,
        content: params.content,
        bloggerId: params.bloggerId,
        imageUrl: params.image,
        updatedAt: params.updatedAt,
        topics: params.topics,
      );

      return right(null);
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}

class BlogUpdateParams {
  final String id;
  final String title;
  final String content;
  final String bloggerId;
  final String image;
  final List<String> topics;
  final DateTime updatedAt;

  BlogUpdateParams({
    required this.id,
    required this.title,
    required this.content,
    required this.bloggerId,
    required this.image,
    required this.topics,
    required this.updatedAt,
  });
}

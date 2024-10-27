// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UseCaseBlogUpload implements UseCase<Blog, BlogUploadParams> {
  final BlogRepository blogRepository;

  UseCaseBlogUpload({required this.blogRepository});

  @override
  Future<Either<Failure, Blog>> call(BlogUploadParams params) async {
    try {
      return await blogRepository.uploadingBlogToRemoteDb(
        image: params.image,
        title: params.title,
        content: params.content,
        bloggerId: params.bloggerId,
        topics: params.topics,
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}

class BlogUploadParams {
  final File image;
  final String title;
  final String content;
  final String bloggerId;
  final List<String> topics;
  BlogUploadParams({
    required this.image,
    required this.title,
    required this.content,
    required this.bloggerId,
    required this.topics,
  });
}

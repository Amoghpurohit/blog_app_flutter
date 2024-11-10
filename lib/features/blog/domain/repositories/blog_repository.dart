
import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository{

  Future<Either<Failure, Blog>> uploadingBlogToRemoteDb({
    required File image,
    required String title,
    required String content,
    required String bloggerId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> fetchAllBlogs();

  Future<Either<Failure, void>> updateBlog({
    required String id,
    required String title,
    required String content,
    required String bloggerId,
    required String imageUrl,
    required DateTime updatedAt,
    required List<String> topics,
  });
}
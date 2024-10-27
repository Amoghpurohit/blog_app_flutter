import 'dart:io';

import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/error/server_exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;

  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.connectionChecker,
    required this.blogLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Blog>>> fetchAllBlogs() async {
    try{    
      if(!await(connectionChecker.isConnectedToInternet)){
        final localBlogs = blogLocalDataSource.getAllBlogsFromLocal();           //converted to Model when retrieving from local
        return right(localBlogs);
      }
      final allBlogs = await blogRemoteDataSource.fetchAllBlogs();
      blogLocalDataSource.uploadBlogsToLocal(allBlogs);                        //converted to map when uploading to local

      return right(allBlogs);
    } on ServerException catch(e){
      return left(Failure(e.message,),);
    }
  }

  @override
  Future<Either<Failure, Blog>> uploadingBlogToRemoteDb({
    required File image,
    required String title,
    required String content,
    required String bloggerId,
    required List<String> topics,
  }) async {
    try {
      if(!await(connectionChecker.isConnectedToInternet)){
        return left(Failure(Constants.internetConnectionErrorMessage),);
      }
      BlogModel blog = BlogModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        bloggerId: bloggerId,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(image, blog);

      blog = blog.copyWith(imageUrl: imageUrl);
      final res = await blogRemoteDataSource.uploadBlog(blog);

      return right(res);
    } on ServerException catch (e) {
      return left(
        Failure(
          e.message,
        ),
      );
    }
  }
}

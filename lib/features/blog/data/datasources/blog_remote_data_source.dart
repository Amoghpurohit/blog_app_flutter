import 'dart:io';

import 'package:blog_app/core/error/server_exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);

  Future<String> uploadBlogImage(File image, BlogModel blog);

  Future<List<BlogModel>> fetchAllBlogs(); //will be getting a map from external source and then convert an return a model which will be used in show in UI
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<BlogModel>> fetchAllBlogs() async {
    try {
      final allBlogs =
          await supabaseClient.from('blog').select('*, profiles(name)');
      //print(allBlogs);
      return allBlogs
          .map(
              (e) => BlogModel.fromMap(e).copyWith(name: e['profiles']['name']))
          .toList(); //have to send a complete blog model with name(which was joint to blogmodel)
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final uploadedBlog =
          await supabaseClient.from('blog').insert(blog.toMap()).select();

      return BlogModel.fromMap(uploadedBlog.first);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<String> uploadBlogImage(File image, BlogModel blog) async {
    try {
      await supabaseClient.storage.from('blog_img').upload(blog.id, image);

      return supabaseClient.storage.from('blog_img').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}

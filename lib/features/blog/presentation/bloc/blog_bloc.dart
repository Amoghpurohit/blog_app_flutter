import 'dart:io';

import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_update.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UseCaseBlogUpload _useCaseBlogUpload;
  final UseCaseGetAllBlogs _useCaseGetAllBlogs;
  final UseCaseBlogUpdate _useCaseBlogUpdate;
  BlogBloc({
    required UseCaseBlogUpload useCaseBlogUpload,
    required UseCaseGetAllBlogs useCaseGetAllBlogs,
    required UseCaseBlogUpdate useCaseBlogUpdate,
  })  : _useCaseBlogUpload = useCaseBlogUpload,
        _useCaseGetAllBlogs = useCaseGetAllBlogs,
        _useCaseBlogUpdate = useCaseBlogUpdate,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(
        BlogLoading(),
      );
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onBlogDisplay);
    on<BlogUpdate>(_onBlogUpdate);
  }

  void _onBlogUpdate(BlogUpdate event, Emitter<BlogState> emit) async {
    final res = await _useCaseBlogUpdate(
      BlogUpdateParams(
        id: event.id,
        title: event.title,
        content: event.content,
        bloggerId: event.bloggerId,
        image: event.image,
        topics: event.topics,
        updatedAt: event.updatedAt,
      ),
    );
    res.fold((l) => emit(BlogFailure(message: l.message)), (r) => emit(BlogUpdateSuccess()),);

  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _useCaseBlogUpload(
      BlogUploadParams(
        image: event.image,
        title: event.title,
        content: event.content,
        bloggerId: event.bloggerId,
        topics: event.topics,
      ),
    );
    res.fold(
      // we have to resolve the states i.e failure or success
      (l) => emit(BlogFailure(message: l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogDisplay(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _useCaseGetAllBlogs(
      NoParams(),
    );

    res.fold(
      (l) => emit(
        BlogFailure(
          message: l.message,
        ),
      ),
      (r) => emit(
        BlogFetchSuccess(blogs: r),
      ),
    );
  }
}

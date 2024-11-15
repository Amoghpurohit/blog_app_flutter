part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState{}

final class BlogFailure extends BlogState{
  final String message;

  BlogFailure({required this.message});
}

final class BlogUploadSuccess extends BlogState{}

final class BlogFetchSuccess extends BlogState{
  final List<Blog> blogs;

  BlogFetchSuccess({required this.blogs});
}

final class BlogUpdateSuccess extends BlogState{}
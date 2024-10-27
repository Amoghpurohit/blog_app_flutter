part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogUpload extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String bloggerId;
  final List<String> topics;

  BlogUpload({
    required this.image,
    required this.title,
    required this.content,
    required this.bloggerId,
    required this.topics,
  });

}

class BlogGetAllBlogs extends BlogEvent{
  
}

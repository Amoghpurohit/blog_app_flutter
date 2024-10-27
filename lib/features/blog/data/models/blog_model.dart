import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.bloggerId,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.name,
  });

  BlogModel copyWith({
    String? id,
    String? title,
    String? content,
    String? bloggerId,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? name,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      bloggerId: bloggerId ?? this.bloggerId,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'blogger_id': bloggerId,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      bloggerId: map['blogger_id'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(
        (map['topics'] ?? []),
      ),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(
              map['updated_at'],
            ),
    );
  }
}

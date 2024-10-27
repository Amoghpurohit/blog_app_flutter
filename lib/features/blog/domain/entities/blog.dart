// ignore_for_file: public_member_api_docs, sort_constructors_first

class Blog {
  final String id;
  final String title;
  final String content;
  final String bloggerId;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? name;
  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.bloggerId,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.name,
  });

}
  

//   String toJson() => json.encode(toMap());

//   factory Blog.fromJson(String source) => Blog.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'Blog(title: $title, content: $content, blogger_id: $blogger_id, image_url: $image_url, topics: $topics)';
//   }

//   @override
//   bool operator ==(covariant Blog other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.title == title &&
//       other.content == content &&
//       other.blogger_id == blogger_id &&
//       other.image_url == image_url &&
//       listEquals(other.topics, topics);
//   }

//   @override
//   int get hashCode {
//     return title.hashCode ^
//       content.hashCode ^
//       blogger_id.hashCode ^
//       image_url.hashCode ^
//       topics.hashCode;
//   }
// }

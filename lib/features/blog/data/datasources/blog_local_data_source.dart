import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogsToLocal(List<BlogModel> blogs);  

  List<BlogModel> getAllBlogsFromLocal();          //these are not futures because we are accessing data offline, not making any http requests 
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl({required this.box});
  @override
  List<BlogModel> getAllBlogsFromLocal() {
    final List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(
          BlogModel.fromMap(box.get(
            i.toString(),
          )),
        );
      }
    });

    return blogs;
  }

  @override
  void uploadBlogsToLocal(List<BlogModel> blogs) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toMap());
      }
    });
  }
}

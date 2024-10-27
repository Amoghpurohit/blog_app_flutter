import 'package:blog_app/core/device/device_dimensions.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
  const BlogViewPage({
    super.key,
    required this.blog,
  });
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewPage(
          blog: blog,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'By ${blog.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${formatDateTodMMMYYYY(blog.updatedAt)} , ${calculateReadingTime(blog.content)} min',
                  style: const TextStyle(color: AppPallete.greyColor, fontSize: 17),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    blog.imageUrl,
                    height: DeviceResolution.getDeviceHeight(context) * 0.2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    //scale: 3,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(blog.content, style: const TextStyle(fontSize: 18, height: 2),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

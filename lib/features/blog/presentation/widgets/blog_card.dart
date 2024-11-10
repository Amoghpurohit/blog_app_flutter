import 'package:blog_app/core/device/device_dimensions.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  //accept blogmodel via constructor
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeviceResolution.getDeviceHeight(context) * 0.25,
      margin: const EdgeInsets.all(16).copyWith(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: blog.topics.length,
                itemBuilder: (context, index) {
                  final chip = blog.topics[index];
                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Chip(
                      label: Text(chip),
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            blog.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${calculateReadingTime(blog.content)} min',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, AddNewBlogPage.route(blog),);
                  print(blog.id);
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(
          BlogGetAllBlogs(),
        ); //event added at the start of the app(initial state)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Blogs'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AddNewBlogPage.route2(),
              );
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(           //use blocConsumer or blocBuilder inside body of page, not required wot wrap around scaffold
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogFetchSuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return GestureDetector(onTap: (){
                  Navigator.push(context, BlogViewPage.route(blog));
                }, child: BlogCard(blog: blog, color: index % 2 ==0 ? AppPallete.gradient1 : AppPallete.gradient2,));
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

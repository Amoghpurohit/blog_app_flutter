import 'dart:io';

import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/device/device_dimensions.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File? image;

  void selectedImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
    return null;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  List<String> blogCategories = Constants.topics;

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  image != null &&
                  selectedCategories.isNotEmpty) {
                context.read<BlogBloc>().add(
                      BlogUpload(
                        image: image!,
                        title: titleController.text.trim(),
                        content: contentController.text.trim(),
                        bloggerId: (context.read<AppUserCubit>().state
                                as AppUserVerified)
                            .user
                            .id,
                        topics: selectedCategories,
                      ),
                    );
              }
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if(state is BlogFailure){
            showSnackBar(context, state.message);
          }
          else if(state is BlogUploadSuccess){
            Navigator.pushAndRemoveUntil(context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if(state is BlogLoading){
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        onTap: selectedImage,
                        child: image != null
                            ? SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                radius: const Radius.circular(9),
                                dashPattern: const [10, 4],
                                strokeWidth: 3,
                                color: AppPallete.borderColor,
                                borderType: BorderType.RRect,
                                child: SizedBox(
                                  height: DeviceResolution.getDeviceHeight(
                                          context) *
                                      0.25,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select your image',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: DeviceResolution.getDeviceHeight(context) * 0.015,
                    ),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                          //shrinkWrap: true,          //used to make the listview.builder to take up only the required space
                          scrollDirection: Axis.horizontal,
                          itemCount: blogCategories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7),
                              child: GestureDetector(
                                onTap: () {
                                  if (!selectedCategories.contains(
                                    blogCategories[index],
                                  )) {
                                    selectedCategories
                                        .add(blogCategories[index]);
                                    print(selectedCategories);
                                  } else {
                                    selectedCategories
                                        .remove(blogCategories[index]);
                                    print(selectedCategories);
                                  }
                                  setState(() {});
                                },
                                child: Chip(
                                    label: Text(blogCategories[index]),
                                    side: selectedCategories
                                            .contains(blogCategories[index])
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor),
                                    color: selectedCategories
                                            .contains(blogCategories[index])
                                        ? const MaterialStatePropertyAll(
                                            AppPallete.gradient1)
                                        : null //use null if u have a default value in theme
                                    ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: DeviceResolution.getDeviceHeight(context) * 0.015,
                    ),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog Title',
                    ),
                    SizedBox(
                      height: DeviceResolution.getDeviceHeight(context) * 0.025,
                    ),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog Content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const BlogEditor({super.key, required this.controller, required this.hintText,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      validator: (value){
        if(value!.trim().isEmpty){
          return '$hintText cannot be empty';
        }
        else{
          return null;
        }
      },
    );
  }
}
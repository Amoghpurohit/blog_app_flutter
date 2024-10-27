
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool isObscured;
  final TextEditingController controller;
  const AuthField({super.key, required this.hintText, required this.controller}) : isObscured = false;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: hintText == 'Password' ? true : false,
      validator: (value){
        if(value!.trim().isEmpty){
          return '$hintText cannot be empty';
        }
        return null;
      },
    );
  }
}
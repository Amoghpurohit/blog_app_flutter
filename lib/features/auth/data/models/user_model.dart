// ignore_for_file: empty_constructor_bodies

import 'package:blog_app/core/common/entities/user_entity.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}

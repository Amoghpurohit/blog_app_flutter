import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUserAndState(User? user) {
    if (user == null) {
      emit(
        AppUserInitial(),
      );
    } else {
      emit(
        AppUserVerified(
          user: user,
        ),
      );
    }
  }
}
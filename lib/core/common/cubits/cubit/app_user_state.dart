part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserVerified extends AppUserState {
  final User user;

  AppUserVerified({
    required this.user,
  });
}

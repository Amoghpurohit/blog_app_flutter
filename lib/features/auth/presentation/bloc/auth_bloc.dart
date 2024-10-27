// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/usercases/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_verified.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UseCaseSignUp _useCaseSignUp;    //we pass use cases to state mangement and its a private variable so that use case is not exposed
  final UseCaseLogin _useCaseLogin;
  final UserCaseVerified _userCaseVerified;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UseCaseSignUp useCaseSignUp, // we take a new use case from constructor and pass it to authbloc keeping the instance variable private
    required UseCaseLogin useCaseLogin,
    required UserCaseVerified userCaseVerified,
    required AppUserCubit appUserCubit,
  })  : _useCaseSignUp = useCaseSignUp,
        _useCaseLogin = useCaseLogin,
        _userCaseVerified = userCaseVerified,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit)=>emit(AuthLoading(),),);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserVerified>(_onAuthIsUserVerified);
  }

  void _onAuthIsUserVerified(
      AuthIsUserVerified event, Emitter<AuthState> emit) async {
  
    final isUserVerified = await _userCaseVerified(
      NoParams(),
    );

    isUserVerified.fold(
      (l) => emit(AuthFailure(message: l.message),),
      (r) => _onAppUserVerifiedSuccess(r, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
  
    //_useCaseSignUp.call(UserSignUpParams(name: event.name, email: event.email, password: event.password),); OR
    final signUpEventResponse = await _useCaseSignUp(
      UserSignUpParams(
          name: event.name, email: event.email, password: event.password),
    );

    signUpEventResponse.fold(
      (l) => emit(
        AuthFailure(message: l.message),
      ),
      (r) => _onAppUserVerifiedSuccess(r, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    
    final loginEventRespose = await _useCaseLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    loginEventRespose.fold(
      (l) => emit(
        AuthFailure(message: l.message),
      ),
      (r) => _onAppUserVerifiedSuccess(r, emit),
    );
  }

  void _onAppUserVerifiedSuccess(User user, Emitter<AuthState> emit){
    _appUserCubit.updateUserAndState(user);
    emit(AuthSuccess(user: user,),);
  }
}

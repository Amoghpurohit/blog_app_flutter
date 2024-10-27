// here we are going to create user and get user id from supabase(remote data source)

import 'package:blog_app/core/error/server_exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {

  Session? get currentUserSession;

  Future<UserModel> signUpData({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginData({
    required String email,
    required String password,
  });

  Future<UserModel?> getVerifiedUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getVerifiedUser() async {                  //while fetching logged in user its possbile that user is not logged in and we get a null UserModel hence the ?
    if(supabaseClient.auth.currentUser == null){
      throw ServerException(message: 'Not a verified user');
    }
    final dbResp = await supabaseClient.from('profiles').select().eq('id', supabaseClient.auth.currentUser!.id);
    
    return UserModel.fromMap(dbResp.first);
  }

  @override
  Future<UserModel> signUpData({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final resp = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});

      if (resp.user == null) {
        throw ServerException(message: 'User is null');
      }
      print(resp);
      return UserModel.fromMap(resp.user!.toJson());
    } on AuthException catch(e){
      throw ServerException(message: e.message);
    } catch (e) {
      print('Error: ${e.toString()}');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> loginData({
    required String email,
    required String password,
  }) async {
    try {
      final loginResp = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (loginResp.user == null) {
        throw ServerException(message: 'Unknown user, Please sign up first');
      }
      return UserModel.fromMap(
        loginResp.user!.toJson(),
      ); //
    } on AuthException catch(e){
      throw ServerException(message: e.message);
    }
    catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}

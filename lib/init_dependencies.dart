import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/supabase_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/features/auth/domain/usecases/user_verified.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// all initializations will happen here

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: SupabaseSecrets.projectUrl,
    anonKey: SupabaseSecrets.anonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  //core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      internetConnection: serviceLocator(),
    ),
  );
}

void _initAuth() {
  //Data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        connectionChecker: serviceLocator(),
        remoteDataSource: serviceLocator(),
      ),
    )
    //Usecases
    ..registerFactory(
      () => UseCaseSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UseCaseLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserCaseVerified(
        authRepository: serviceLocator(),
      ),
    )
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        useCaseSignUp: serviceLocator(),
        useCaseLogin: serviceLocator(),
        userCaseVerified: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        box: serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogLocalDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
        blogRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UseCaseBlogUpload(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UseCaseGetAllBlogs(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        useCaseBlogUpload: serviceLocator(),
        useCaseGetAllBlogs: serviceLocator(),
      ),
    );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/local_post_datasource.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/get_posts.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'presentation/blocs/profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/firestore_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<FirestoreService>(FirestoreService.instance);
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(FirebaseAuth.instance, getIt()),
  );
  getIt.registerLazySingleton<BiometricService>(BiometricService.new);
  getIt.registerLazySingleton<LocalPostDataSource>(LocalPostDataSource.new);
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      PostDataSourceFactory.create(
        useRemote: true,
        firestore: getIt(),
        cache: getIt(),
      ),
      getIt(),
    ),
  );
  getIt.registerLazySingleton<GetPosts>(() => GetPosts(getIt()));
  getIt.registerLazySingleton<CreatePost>(() => CreatePost(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<PostCubit>(() => PostCubit(getIt(), getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt(), getIt()));
}

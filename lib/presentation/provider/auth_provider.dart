import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/application/usecase/sign_in_usecase.dart';
import 'package:three_o/application/usecase/sign_up_usecase.dart';
import 'package:three_o/domain/model/app_user/app_user.dart';
import 'package:three_o/domain/repository/auth_repository.dart';
import 'package:three_o/infrastructure/repository/auth_repository_impl.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

part 'auth_provider.g.dart';

@riverpod
firebase.FirebaseAuth firebaseAuth(Ref ref) {
  return firebase.FirebaseAuth.instance;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<firebase.User?> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

@riverpod
SignUpUseCase signUpUseCase(Ref ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
SignInUseCase signInUseCase(Ref ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
}

@riverpod
Stream<AppUser?> appUserStream(Ref ref) {
  // 修正前 (これはAsyncValueを返すためエラーになる)
  // final authStateStream = ref.watch(authStateChangesProvider);

  // 修正後：
  // 1. まず、リポジトリのインスタンスを取得する
  final authRepository = ref.watch(authRepositoryProvider);

  // 2. リポジトリから、生のStream<User?>を取得する
  final authStream = authRepository.authStateChanges();

  // 3. 本物のStreamに対してなら、asyncMapが使える
  return authStream.asyncMap((user) async {
    // ログインしていない場合
    if (user == null) {
      return null;
    }

    // ログインしている場合、uidを使ってプロフィール情報を取得
    // ここは .future を付けるのが確実
    final userProfile = await ref.watch(userProfileProvider(user.uid).future);

    // Auth情報とProfile情報をマージして、新しいAppUserオブジェクトを返す
    return AppUser(
      uid: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
      name: userProfile?.name,
      industry: userProfile?.industry,
      age: userProfile?.age,
      gender: userProfile?.gender,
    );
  });
}

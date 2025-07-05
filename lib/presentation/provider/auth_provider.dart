import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/application/usecase/request_deletion_usecase.dart';
import 'package:three_o/application/usecase/sign_in_usecase.dart';
import 'package:three_o/application/usecase/sign_up_usecase.dart';
import 'package:three_o/domain/model/app_user/app_user.dart';
import 'package:three_o/domain/repository/auth_repository.dart';
import 'package:three_o/domain/repository/deletion_request_repository.dart';
import 'package:three_o/infrastructure/repository/auth_repository_impl.dart';
import 'package:three_o/infrastructure/repository/deletion_request_repository_impl.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

part 'auth_provider.g.dart';

@riverpod
DeletionRequestRepository deletionRequestRepository(Ref ref) {
  return DeletionRequestRepositoryImpl(ref.watch(firebaseFirestoreProvider));
}

@riverpod
firebase.FirebaseAuth firebaseAuth(Ref ref) => firebase.FirebaseAuth.instance;

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(firebaseAuthProvider));

@riverpod
Stream<firebase.User?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

@riverpod
SignUpUseCase signUpUseCase(Ref ref) =>
    SignUpUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInUseCase signInUseCase(Ref ref) =>
    SignInUseCase(ref.watch(authRepositoryProvider));

@riverpod
RequestDeletionUsecase requestDeletionUsecase(Ref ref) {
  return RequestDeletionUsecase(
    ref.watch(deletionRequestRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
}

@riverpod
Stream<AppUser?> appUserStream(Ref ref) {
  final authStream = ref.watch(authRepositoryProvider).authStateChanges();
  return authStream.asyncMap((user) async {
    if (user == null) return null;
    final userProfile = await ref.watch(userProfileProvider(user.uid).future);
    return AppUser(
      uid: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
      name: userProfile?.name,
      industry: userProfile?.industry,
      birthday: userProfile?.birthday,
      gender: userProfile?.gender,
    );
  });
}

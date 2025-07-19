import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/application/usecase/save_user_profile_usecase.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/domain/repository/user_profile_repository.dart';
import 'package:three_o/infrastructure/repository/user_profile_repository_impl.dart';

part 'user_profile_provider.g.dart';

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepositoryImpl(ref.watch(firebaseFirestoreProvider));
}

@riverpod
SaveUserProfileUseCase saveUserProfileUseCase(Ref ref) {
  return SaveUserProfileUseCase(ref.watch(userProfileRepositoryProvider));
}

@riverpod
Future<UserProfile?> userProfile(Ref ref, String uid) {
  return ref.watch(userProfileRepositoryProvider).getProfile(uid);
}

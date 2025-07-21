import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/domain/repository/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepositoryImpl(this._firestore);

  CollectionReference<UserProfile> _usersRef() => _firestore
      .collection('users')
      .withConverter<UserProfile>(
        fromFirestore: (snapshot, _) => UserProfile.fromJson(snapshot.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson(),
      );

  @override
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _usersRef().doc(uid).get();
    return doc.data();
  }

  @override
  Future<void> saveProfile(UserProfile userProfile) async {
    // ▼▼▼ タイムスタンプ更新処理を追加 ▼▼▼
    final now = DateTime.now();
    final profileWithTimestamp = userProfile.copyWith(
      createdAt: userProfile.createdAt ?? now,
      updatedAt: now,
    );
    await _usersRef().doc(userProfile.uid).set(profileWithTimestamp);
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
  }
}

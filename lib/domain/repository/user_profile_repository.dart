import 'package:three_o/domain/model/user_profile/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> getProfile(String uid);
  Future<void> saveProfile(UserProfile userProfile);
}

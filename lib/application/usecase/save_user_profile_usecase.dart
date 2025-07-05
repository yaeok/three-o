import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/domain/repository/user_profile_repository.dart';

class SaveUserProfileUseCase {
  final UserProfileRepository _repository;
  SaveUserProfileUseCase(this._repository);
  Future<void> execute(UserProfile userProfile) async {
    await _repository.saveProfile(userProfile);
  }
}

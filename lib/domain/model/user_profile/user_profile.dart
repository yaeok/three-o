import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/agent/agent.dart'; // TimestampConverterのため

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid, // AuthのUser IDと紐付ける
    required String name,
    required String industry,
    @TimestampConverter() required DateTime birthday, // ageから変更
    required String gender,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

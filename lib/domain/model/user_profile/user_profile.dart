import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';
import 'package:three_o/domain/model/resume/resume.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

// ▼▼▼ このアノテーションを追加 ▼▼▼
@JsonSerializable(explicitToJson: true)
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String name,
    required String industry,
    @TimestampConverter() required DateTime birthday,
    required String gender,
    String? email,
    String? phoneNumber,
    String? address,
    @Default([]) List<EducationHistory> educationHistory,
    @Default([]) List<WorkHistory> workHistory,
    String? certifications,
    String? selfPromotion,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

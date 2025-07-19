import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume.freezed.dart';
part 'resume.g.dart';

// --- 履歴書全体のモデル ---
@freezed
class Resume with _$Resume {
  const factory Resume({
    String? id,
    required String userId,
    required String name,
    @TimestampConverter() required DateTime birthday,
    String? email,
    String? phoneNumber,
    String? address,
    @Default([]) List<EducationHistory> educationHistory,
    @Default([]) List<WorkHistory> workHistory,
    String? certifications,
    String? selfPromotion,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Resume;

  // fromJsonファクトリは、コード生成に必要なので残します
  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
}

// --- 学歴のモデル ---
@freezed
class EducationHistory with _$EducationHistory {
  const factory EducationHistory({
    String? id,
    required String schoolName,
    String? faculty,
    @TimestampConverter() required DateTime entranceDate,
    @TimestampConverter() required DateTime graduationDate,
  }) = _EducationHistory;

  // fromJsonファクトリ
  factory EducationHistory.fromJson(Map<String, dynamic> json) =>
      _$EducationHistoryFromJson(json);
}

// --- 職歴のモデル ---
@freezed
class WorkHistory with _$WorkHistory {
  const factory WorkHistory({
    String? id,
    required String companyName,
    String? department,
    String? position,
    @TimestampConverter() required DateTime joiningDate,
    @TimestampConverter() DateTime? leavingDate,
    required String description,
  }) = _WorkHistory;

  // fromJsonファクトリ
  factory WorkHistory.fromJson(Map<String, dynamic> json) =>
      _$WorkHistoryFromJson(json);
}

// TimestampとDateTimeを相互変換するためのコンバーター
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? dateTime) =>
      dateTime == null ? null : Timestamp.fromDate(dateTime);
}

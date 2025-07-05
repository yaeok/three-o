import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/agent/agent.dart'; // TimestampConverterを再利用

part 'resume.freezed.dart';
part 'resume.g.dart';

// --- 履歴書全体のモデル ---
@freezed
class Resume with _$Resume {
  const factory Resume({
    String? id,
    required String userId,
    required String name, // ユーザー名
    @TimestampConverter() required DateTime birthday, // 生年月日
    String? email,
    String? phoneNumber,
    String? address,
    @Default([]) List<EducationHistory> educationHistory,
    @Default([]) List<WorkHistory> workHistory,
    String? certifications, // 資格
    String? selfPromotion, // 自己PR
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Resume;

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
}

// --- 学歴のモデル ---
@freezed
class EducationHistory with _$EducationHistory {
  const factory EducationHistory({
    String? id,
    required String schoolName,
    String? faculty, // 学部・学科
    @TimestampConverter() required DateTime entranceDate, // 入学年月
    @TimestampConverter() required DateTime graduationDate, // 卒業年月
  }) = _EducationHistory;

  factory EducationHistory.fromJson(Map<String, dynamic> json) =>
      _$EducationHistoryFromJson(json);
}

// --- 職歴のモデル ---
@freezed
class WorkHistory with _$WorkHistory {
  const factory WorkHistory({
    String? id,
    required String companyName,
    String? department, // 部署
    String? position, // 役職
    @TimestampConverter() required DateTime joiningDate, // 入社年月
    @TimestampConverter() DateTime? leavingDate, // 退社年月 (任意)
    required String description, // 職務内容
  }) = _WorkHistory;

  factory WorkHistory.fromJson(Map<String, dynamic> json) =>
      _$WorkHistoryFromJson(json);
}

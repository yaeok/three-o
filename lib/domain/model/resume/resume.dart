import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'resume.freezed.dart';
part 'resume.g.dart';

// --- 学歴のモデル ---
@JsonSerializable(explicitToJson: true)
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
@JsonSerializable(explicitToJson: true)
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

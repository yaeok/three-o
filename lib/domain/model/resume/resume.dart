import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'resume.freezed.dart';
part 'resume.g.dart';

// --- 学歴のモデル ---
@freezed
class EducationHistory with _$EducationHistory {
  const EducationHistory._(); // プライベートコンストラクタを追加

  const factory EducationHistory({
    String? id,
    required String schoolName,
    String? faculty,
    @TimestampConverter() required DateTime entranceDate,
    @TimestampConverter() required DateTime graduationDate,
  }) = _EducationHistory;

  factory EducationHistory.fromJson(Map<String, dynamic> json) =>
      _$EducationHistoryFromJson(json);
}

// --- 職歴のモデル ---
@freezed
class WorkHistory with _$WorkHistory {
  const WorkHistory._(); // プライベートコンストラクタを追加

  const factory WorkHistory({
    String? id,
    required String companyName,
    String? department,
    String? position,
    @TimestampConverter() required DateTime joiningDate,
    @TimestampConverter() DateTime? leavingDate,
    required String description,
  }) = _WorkHistory;

  factory WorkHistory.fromJson(Map<String, dynamic> json) =>
      _$WorkHistoryFromJson(json);
}

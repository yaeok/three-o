import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'agent.freezed.dart';
part 'agent.g.dart';

@freezed
class Agent with _$Agent {
  const factory Agent({
    String? id, // FirestoreのドキュメントID
    required String userId, // 作成したユーザーのID
    required String name, // 上司の名前
    required String role, // 役職（部長、先輩など）
    required String personality, // 性格・口調の定義
    required String industryInfo, // 特化させたい業界情報
    @TimestampConverter() DateTime? createdAt, // 作成日時
  }) = _Agent;

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);
}

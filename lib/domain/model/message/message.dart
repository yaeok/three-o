import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    String? id,
    required String text,
    required SenderRole sender, // 送信者がユーザーかAIか
    @TimestampConverter() DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

// 送信者の役割を定義するEnum
enum SenderRole {
  user,
  model; // Geminiモデル（AI）

  @override
  String toString() => name;
}

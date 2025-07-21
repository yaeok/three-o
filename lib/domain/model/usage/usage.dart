import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'usage.freezed.dart';
part 'usage.g.dart';

// ユーザーの利用状況を保持するモデル
@freezed
class Usage with _$Usage {
  const factory Usage({
    required String userId,
    @Default(0) int messageCount, // その日のメッセージ送信回数
    @TimestampConverter() DateTime? lastMessageSentAt, // 最終メッセージ送信日時
  }) = _Usage;

  /// FirestoreのドキュメントスナップショットからUsageオブジェクトを生成します。
  ///
  /// データ内に`userId`フィールドが存在しない場合でも、
  /// ドキュメントのIDを`userId`として代入することで、エラーを防ぎます。
  factory Usage.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    // userIdがnullの場合に、ドキュメントIDで補完する
    data['userId'] = data['userId'] ?? snapshot.id;
    return Usage.fromJson(data);
  }

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);
}

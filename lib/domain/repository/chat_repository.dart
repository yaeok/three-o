import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart';

abstract class ChatRepository {
  // 特定のチャットルームのメッセージ一覧をStreamで取得する
  Stream<List<Message>> getMessages({
    required String userId,
    required String agentId,
  });

  // メッセージを送信する（AIとのやり取りを含む）
  Future<void> sendMessage({
    required String userId,
    required Agent agent, // AIの性格定義に使う
    required List<Message> history, // AIに渡す会話履歴
    required Message message, // ユーザーが送る新しいメッセージ
  });
}

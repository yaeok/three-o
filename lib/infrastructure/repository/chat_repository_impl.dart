import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart';
import 'package:three_o/domain/repository/chat_repository.dart';
import 'package:three_o/domain/repository/usage_repository.dart';
import 'package:three_o/infrastructure/service/gemini_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final GeminiService _geminiService;
  final UsageRepository _usageRepository;

  ChatRepositoryImpl(
    this._firestore,
    this._geminiService,
    this._usageRepository,
  );

  CollectionReference<Message> _messagesRef(String userId, String agentId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('agents')
          .doc(agentId)
          .collection('messages')
          .withConverter<Message>(
            fromFirestore: (snapshot, _) =>
                Message.fromJson(snapshot.data()!).copyWith(id: snapshot.id),
            toFirestore: (message, _) => message.toJson(),
          );

  @override
  Stream<List<Message>> getMessages({
    required String userId,
    required String agentId,
  }) {
    return _messagesRef(userId, agentId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> sendMessage({
    required String userId,
    required Agent agent,
    required List<Message> history,
    required Message message,
  }) async {
    // 1. 利用状況を確認・更新
    final usage = await _usageRepository.getUsage(userId);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastSentDate = usage.lastMessageSentAt != null
        ? DateFormat('yyyy-MM-dd').format(usage.lastMessageSentAt!)
        : null;

    int currentMessageCount = usage.messageCount;

    // 日付が変わっていたらカウントをリセット
    if (lastSentDate != today) {
      currentMessageCount = 0;
    }

    // 上限チェック
    if (currentMessageCount >= 10) {
      throw Exception('本日のメッセージ上限(10回)に達しました。');
    }

    // 2. ユーザーのメッセージをFirestoreに保存
    await _messagesRef(userId, agent.id!).add(message);

    // 3. Gemini APIに応答をリクエスト
    final aiResponseText = await _geminiService.generateResponse(
      agent: agent,
      history: history,
      userMessage: message.text,
    );

    // 4. AIの応答をFirestoreに保存
    final aiMessage = Message(
      text: aiResponseText,
      sender: SenderRole.model,
      createdAt: DateTime.now(),
    );
    await _messagesRef(userId, agent.id!).add(aiMessage);

    // 5. 利用状況を更新
    final updatedUsage = usage.copyWith(
      messageCount: currentMessageCount + 1,
      lastMessageSentAt: DateTime.now(),
    );
    await _usageRepository.updateUsage(updatedUsage);
  }
}

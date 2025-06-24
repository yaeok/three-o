import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart';
import 'package:three_o/domain/repository/chat_repository.dart';
import 'package:three_o/infrastructure/service/gemini_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final GeminiService _geminiService;

  ChatRepositoryImpl(this._firestore, this._geminiService);

  // .../agents/{agentId}/messages コレクションへの参照
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
    // 1. ユーザーのメッセージをFirestoreに保存
    await _messagesRef(userId, agent.id!).add(message);

    // 2. Gemini APIに応答をリクエスト
    final aiResponseText = await _geminiService.generateResponse(
      agent: agent,
      history: history,
      userMessage: message.text,
    );

    // 3. AIの応答をFirestoreに保存
    final aiMessage = Message(
      text: aiResponseText,
      sender: SenderRole.model,
      createdAt: DateTime.now(),
    );
    await _messagesRef(userId, agent.id!).add(aiMessage);
  }
}

import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart';
import 'package:three_o/domain/repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;
  SendMessageUseCase(this._repository);

  Future<void> execute({
    required String userId,
    required Agent agent,
    required List<Message> history,
    required Message message,
  }) async {
    await _repository.sendMessage(
      userId: userId,
      agent: agent,
      history: history,
      message: message,
    );
  }
}

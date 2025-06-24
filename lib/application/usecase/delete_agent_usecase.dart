import 'package:three_o/domain/repository/agent_repository.dart';

class DeleteAgentUseCase {
  final AgentRepository _repository;
  DeleteAgentUseCase(this._repository);
  Future<void> execute({required String userId, required String agentId}) =>
      _repository.deleteAgent(userId: userId, agentId: agentId);
}

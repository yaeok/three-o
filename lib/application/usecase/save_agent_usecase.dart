// 📁 application/usecase/save_agent_usecase.dart
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/repository/agent_repository.dart';

class SaveAgentUseCase {
  final AgentRepository _repository;
  SaveAgentUseCase(this._repository);
  Future<void> execute(Agent agent) => _repository.saveAgent(agent);
}

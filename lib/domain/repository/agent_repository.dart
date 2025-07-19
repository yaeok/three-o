import 'package:three_o/domain/model/agent/agent.dart';

abstract class AgentRepository {
  // 特定ユーザーのエージェント一覧をStreamで取得する
  Stream<List<Agent>> getAgents(String userId);

  // エージェントを保存（新規作成または更新）する
  Future<void> saveAgent(Agent agent);

  // エージェントを削除する
  Future<void> deleteAgent({required String userId, required String agentId});
}

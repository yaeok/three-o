import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/repository/agent_repository.dart';

class AgentRepositoryImpl implements AgentRepository {
  final FirebaseFirestore _firestore;

  AgentRepositoryImpl(this._firestore);

  // users/{userId}/agents コレクションへの参照
  CollectionReference<Agent> _agentsRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('agents')
      .withConverter<Agent>(
        fromFirestore: (snapshot, _) =>
            Agent.fromJson(snapshot.data()!).copyWith(id: snapshot.id),
        toFirestore: (agent, _) => agent.toJson(),
      );

  @override
  Stream<List<Agent>> getAgents(String userId) {
    return _agentsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> saveAgent(Agent agent) async {
    // IDがある場合は更新、ない場合は新規作成
    final agentWithTimestamp = agent.createdAt == null
        ? agent.copyWith(createdAt: DateTime.now())
        : agent;

    if (agent.id != null) {
      await _agentsRef(agent.userId).doc(agent.id).set(agentWithTimestamp);
    } else {
      await _agentsRef(agent.userId).add(agentWithTimestamp);
    }
  }

  @override
  Future<void> deleteAgent({
    required String userId,
    required String agentId,
  }) async {
    await _agentsRef(userId).doc(agentId).delete();
  }
}

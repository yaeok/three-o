import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/application/usecase/delete_agent_usecase.dart';
import 'package:three_o/application/usecase/save_agent_usecase.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/repository/agent_repository.dart';
import 'package:three_o/infrastructure/repository/agent_repository_impl.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

part 'agent_provider.g.dart';

@riverpod
AgentRepository agentRepository(Ref ref) {
  return AgentRepositoryImpl(ref.watch(firebaseFirestoreProvider));
}

@riverpod
SaveAgentUseCase saveAgentUseCase(Ref ref) {
  return SaveAgentUseCase(ref.watch(agentRepositoryProvider));
}

@riverpod
DeleteAgentUseCase deleteAgentUseCase(Ref ref) {
  return DeleteAgentUseCase(ref.watch(agentRepositoryProvider));
}

// ログイン中ユーザーのエージェント一覧をStreamで提供するProvider
@riverpod
Stream<List<Agent>> agentsStream(Ref ref) {
  final appUser = ref.watch(appUserStreamProvider).value;
  if (appUser == null) {
    return Stream.value([]); // ログインしていない場合は空のリスト
  }
  return ref.watch(agentRepositoryProvider).getAgents(appUser.uid);
}

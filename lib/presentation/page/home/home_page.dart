import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/widget/agent_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsyncValue = ref.watch(agentsStreamProvider);

    return agentsAsyncValue.when(
      data: (agents) {
        if (agents.isEmpty) {
          return const Center(child: Text('右下のボタンからAI上司を作成しましょう'));
        }
        return ListView.builder(
          itemCount: agents.length,
          itemBuilder: (context, index) {
            final agent = agents[index];
            return AgentListItem(agent: agent);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
    );
  }
}

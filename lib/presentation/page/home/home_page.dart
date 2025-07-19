import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/widget/agent_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsyncValue = ref.watch(agentsStreamProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return agentsAsyncValue.when(
      data: (agents) {
        if (agents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_comment_outlined,
                  size: 80,
                  color: colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'AI上司がいません',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '右下の「+」ボタンから\n新しいAI上司を作成しましょう',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80), // FABとの余白
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

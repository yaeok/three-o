import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';

class AgentListItem extends ConsumerWidget {
  const AgentListItem({super.key, required this.agent});

  final Agent agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: ValueKey(agent.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete_sweep_outlined,
          color: colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('確認'),
              content: Text('「${agent.name}」を本当に削除しますか？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('キャンセル'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('削除', style: TextStyle(color: colorScheme.error)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        try {
          await ref
              .read(deleteAgentUseCaseProvider)
              .execute(userId: agent.userId, agentId: agent.id!);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('「${agent.name}」を削除しました')));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person_outline,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            agent.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(agent.role, style: theme.textTheme.bodyMedium),
          trailing: Icon(Icons.chevron_right, color: colorScheme.outline),
          onTap: () {
            context.push('/chat/${agent.id}');
          },
        ),
      ),
    );
  }
}

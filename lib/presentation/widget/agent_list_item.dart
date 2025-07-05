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

    Future<void> showDeleteConfirmationDialog() async {
      final bool? confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('削除の確認'),
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

      if (confirmed == true && context.mounted) {
        try {
          await ref
              .read(deleteAgentUseCaseProvider)
              .execute(userId: agent.userId, agentId: agent.id!);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('「${agent.name}」を削除しました')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
        }
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 20,
          top: 12,
          bottom: 12,
          right: 8,
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
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // 編集画面に遷移（Agentオブジェクトを渡す）
              context.push('/agent/update', extra: agent);
            } else if (value == 'delete') {
              showDeleteConfirmationDialog();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('編集'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('削除'),
              ),
            ),
          ],
        ),
        onTap: () {
          context.push('/chat/${agent.id}');
        },
      ),
    );
  }
}

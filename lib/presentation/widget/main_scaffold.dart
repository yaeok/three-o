import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/widget/app_drawer.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // titlesに「履歴書」を追加
    final titles = ['AI上司一覧', '履歴書', 'アカウント'];
    final theme = Theme.of(context);

    final agentsAsyncValue = ref.watch(agentsStreamProvider);
    final agentCount = agentsAsyncValue.value?.length ?? 0;
    final canCreateAgent = agentCount < 3;

    // 現在のタブインデックスを取得
    final currentIndex = navigationShell.currentIndex;

    // FABを表示するかどうかの判定
    final showFab = currentIndex == 0 || currentIndex == 1;

    return Scaffold(
      appBar: AppBar(title: Text(titles[currentIndex])),
      drawer: const AppDrawer(),
      body: navigationShell,
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                if (currentIndex == 0) {
                  // チャットタブ
                  if (canCreateAgent) {
                    context.push('/agent/new');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AI上司は3人まで作成できます。'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else if (currentIndex == 1) {
                  // 履歴書タブ
                  context.push('/resume/history-form');
                }
              },
              backgroundColor: (currentIndex == 0 && !canCreateAgent)
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.primary,
              foregroundColor: (currentIndex == 0 && !canCreateAgent)
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onPrimary,
              elevation: (currentIndex == 0 && !canCreateAgent) ? 0.0 : 6.0,
              // アイコンをタブに応じて変更
              child: Icon(currentIndex == 0 ? Icons.add : Icons.edit_document),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
        // itemsに履歴書タブを追加
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'チャット',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: '履歴書',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'アカウント',
          ),
        ],
      ),
    );
  }
}

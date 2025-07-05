import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(appUserStreamProvider).value;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('three_o', style: theme.textTheme.headlineSmall),
                const Spacer(),
                Text(user?.email ?? '', style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('利用規約'),
            onTap: () {
              Navigator.pop(context);
              context.push('/terms-of-service');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            onTap: () {
              Navigator.pop(context);
              context.push('/privacy-policy');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () {
              Navigator.pop(context);
              ref.read(authRepositoryProvider).signOut();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: colorScheme.error,
            ),
            title: Text(
              'アカウントの削除申請',
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () {
              // Drawerを閉じてからダイアログを表示
              Navigator.pop(context);
              // refを渡さないように変更
              _showDeleteAccountDialog(context, user?.uid, user?.email);
            },
          ),
        ],
      ),
    );
  }

  // ▼▼▼【修正点】メソッドの定義と中身を全面的に修正 ▼▼▼
  void _showDeleteAccountDialog(
    BuildContext context,
    String? userId,
    String? userEmail,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // AlertDialogをConsumerでラップして、安全なrefを取得する
        return Consumer(
          builder: (context, ref, child) {
            return AlertDialog(
              title: const Text('アカウントの削除申請'),
              content: const Text(
                '申請後、あなたのアカウントは自動的にログアウトされます。運営による確認の後、データは完全に削除されます。この操作は元に戻すことはできません。',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('キャンセル'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    if (userId == null || userEmail == null) return;

                    // Consumerから取得した安全なrefを使用する
                    final loadingNotifier = ref.read(loadingProvider.notifier);
                    final usecase = ref.read(requestDeletionUsecaseProvider);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    // ダイアログを閉じてから非同期処理を開始
                    Navigator.pop(dialogContext);

                    loadingNotifier.startLoading();
                    try {
                      await usecase.execute(userId: userId, email: userEmail);
                      // 成功時はGoRouterが自動でリダイレクトするため、ここでは何もしない
                    } catch (e) {
                      if (scaffoldMessenger.mounted) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('アカウントの削除申請に失敗しました: $e')),
                        );
                      }
                    } finally {
                      loadingNotifier.endLoading();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                  ),
                  child: Text(
                    '申請してログアウト',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

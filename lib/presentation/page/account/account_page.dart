import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/usage_provider.dart'; // Usageプロバイダーをインポート

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserStreamProvider).value;
    final usageAsync = ref.watch(usageProvider); // 利用状況を監視
    final theme = Theme.of(context);

    if (appUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- 利用状況カード ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: usageAsync.when(
                data: (usage) {
                  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final lastSentDate = usage.lastMessageSentAt != null
                      ? DateFormat(
                          'yyyy-MM-dd',
                        ).format(usage.lastMessageSentAt!)
                      : null;
                  final count = lastSentDate == today ? usage.messageCount : 0;
                  final remaining = 10 - count;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('本日の利用状況', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AIからの返信 ( $count / 10 回 )'),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: count / 10,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '残り $remaining 回',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 16),
                      // Center(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // TODO: 課金ページへの導線
                      //     },
                      //     child: const Text('プランをアップグレード'),
                      //   ),
                      // ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Text('利用状況の取得に失敗しました'),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- プロフィール情報 ---
          ListTile(
            title: const Text('メールアドレス'),
            subtitle: Text(appUser.email ?? '未設定'),
          ),
          ListTile(
            title: const Text('名前'),
            subtitle: Text(appUser.name ?? '未設定'),
          ),
          // ... 他のプロフィール情報 ...
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.push('/account/update');
            },
            child: const Text('プロフィールを更新'),
          ),
        ],
      ),
    );
  }
}

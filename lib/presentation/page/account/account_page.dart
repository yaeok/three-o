import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserStreamProvider).value;

    if (appUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('メールアドレス'),
            subtitle: Text(appUser.email ?? '未設定'),
          ),
          ListTile(
            title: const Text('名前'),
            subtitle: Text(appUser.name ?? '未設定'),
          ),
          ListTile(
            title: const Text('業界'),
            subtitle: Text(appUser.industry ?? '未設定'),
          ),
          ListTile(
            title: const Text('年齢'),
            subtitle: Text(appUser.age?.toString() ?? '未設定'),
          ),
          ListTile(
            title: const Text('性別'),
            subtitle: Text(appUser.gender ?? '未設定'),
          ),
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

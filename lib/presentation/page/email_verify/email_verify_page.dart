import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  ConsumerState<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  bool _isChecking = false;

  // ユーザーのメール認証状態を再確認するメソッド
  Future<void> _checkVerificationStatus() async {
    setState(() => _isChecking = true);

    // ユーザー情報を再読み込みして最新の状態を取得
    final user = ref.read(firebaseAuthProvider).currentUser;
    await user?.reload();

    // 最新のユーザー情報で`emailVerified`をチェック
    final latestUser = ref.read(firebaseAuthProvider).currentUser;
    if (latestUser != null && latestUser.emailVerified) {
      // 認証済みの場合、Providerを無効化してGoRouterの再評価をトリガーする
      ref.invalidate(appUserStreamProvider);
    } else {
      // 未認証の場合、ユーザーにフィードバック
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('まだメール認証が完了していません。受信トレイをご確認ください。')),
        );
      }
    }

    if (mounted) {
      setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メールアドレスの確認')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
              const Text(
                '確認メールを送信しました。\nメール内のリンクをクリックして、登録を完了してください。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_isChecking)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _checkVerificationStatus,
                  child: const Text('確認完了、次へ進む'),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  ref.read(authRepositoryProvider).sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('確認メールを再送信しました')),
                  );
                },
                child: const Text('確認メールを再送信'),
              ),
              TextButton(
                onPressed: () => ref.read(authRepositoryProvider).signOut(),
                child: const Text('ログアウト'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

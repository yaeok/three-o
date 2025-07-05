import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';

// StatelessWidgetでもProviderを扱えるため、ConsumerWidgetに変更
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    // エラーメッセージはローカルで管理
    final errorMessage = StateProvider<String?>((ref) => null);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> signIn() async {
      // グローバルなローディングを開始
      ref.read(loadingProvider.notifier).startLoading();
      ref.read(errorMessage.notifier).state = null;

      try {
        await ref
            .read(signInUseCaseProvider)
            .execute(
              email: emailController.text,
              password: passwordController.text,
            );
      } catch (e) {
        ref.read(errorMessage.notifier).state = 'メールアドレスまたはパスワードが正しくありません。';
      } finally {
        // 処理完了後、必ずローディングを終了
        ref.read(loadingProvider.notifier).endLoading();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'お帰りなさい',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI上司との対話を再開しましょう',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                if (ref.watch(errorMessage) != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      ref.watch(errorMessage)!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'パスワード',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  // ボタン内のインジケーターは不要に
                  onPressed: signIn,
                  child: const Text('ログイン'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: const Text('アカウントをお持ちでない方はこちら'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

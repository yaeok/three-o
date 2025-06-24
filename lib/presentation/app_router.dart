import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/presentation/page/agent_form/agent_form_page.dart';
import 'package:three_o/presentation/page/chat/chat_page.dart';
import 'package:three_o/presentation/page/email_verify/email_verify_page.dart';
import 'package:three_o/presentation/page/home/home_page.dart';
import 'package:three_o/presentation/page/login/login_page.dart';
import 'package:three_o/presentation/page/register_user_info/register_user_info_page.dart';
import 'package:three_o/presentation/page/signup/signup_page.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // 1. アプリケーションの状態を監視
  final appUserState = ref.watch(appUserStreamProvider);

  return GoRouter(
    // アプリ起動時の初期ページ
    initialLocation: '/login',

    // 画面遷移のたびに、このredirectロジックが実行される
    redirect: (BuildContext context, GoRouterState state) {
      // 2. ローディング中、またはエラー発生時は何もしない
      // UI側でそれぞれの状態に応じた表示を行う
      if (appUserState.isLoading || appUserState.hasError) {
        return null;
      }

      // 3. 認証情報（AppUser）と現在のページパスを取得
      final appUser = appUserState.value;
      final location = state.matchedLocation;

      // 4. ログアウト状態のユーザーに対するリダイレクト処理
      final isLoggedOut = appUser == null;
      // ログアウト状態でもアクセスを許可するページのリスト
      final allowedOnLoggedOut = ['/login', '/signup'];

      if (isLoggedOut) {
        // 許可されたページにいる場合は何もしない。それ以外はログインページへ飛ばす。
        return allowedOnLoggedOut.contains(location) ? null : '/login';
      }

      // 5. ログイン済みユーザーに対するリダイレクト処理（ここから下は appUser != null が確定）

      // 5a. メール未認証の場合
      if (!appUser!.emailVerified) {
        // メール認証ページ以外にいる場合は、認証ページへ飛ばす
        return location == '/verify-email' ? null : '/verify-email';
      }

      // 5b. プロフィール未登録の場合
      if (appUser.name == null) {
        // プロフィール登録ページ以外にいる場合は、登録ページへ飛ばす
        return location == '/register-user-info' ? null : '/register-user-info';
      }

      // 5c. ログイン・プロフィール登録済みのユーザーが、ログインページ等にアクセスした場合
      // ログイン済みユーザーがアクセスする必要のないページのリスト
      final disallowedOnLoggedIn = [
        '/login',
        '/signup',
        '/verify-email',
        '/register-user-info',
      ];
      if (disallowedOnLoggedIn.contains(location)) {
        // ホーム画面へ飛ばす
        return '/';
      }

      // 6. 上記のどの条件にも当てはまらない場合は、リダイレクトしない
      return null;
    },

    // アプリ内の全ページルートの定義
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const EmailVerifyPage(),
      ),
      GoRoute(
        path: '/register-user-info',
        builder: (context, state) => const RegisterUserInfoPage(),
      ),
      GoRoute(
        path: '/agent/new',
        builder: (context, state) => const AgentFormPage(),
      ),
      GoRoute(
        path: '/chat/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return ChatPage(agentId: agentId);
        },
      ),
    ],
  );
}

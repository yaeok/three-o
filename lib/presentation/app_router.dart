import 'dart:async'; // StreamSubscriptionのためにインポート
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/presentation/page/account/account_page.dart';
import 'package:three_o/presentation/page/account/profile_update_page.dart';
import 'package:three_o/presentation/page/agent_form/agent_form_page.dart';
import 'package:three_o/presentation/page/agent_form/agent_update_page.dart';
import 'package:three_o/presentation/page/chat/chat_page.dart';
import 'package:three_o/presentation/page/email_verify/email_verify_page.dart';
import 'package:three_o/presentation/page/home/home_page.dart';
import 'package:three_o/presentation/page/login/login_page.dart';
import 'package:three_o/presentation/page/register_user_info/register_user_info_page.dart';
import 'package:three_o/presentation/page/settings/privacy_policy_page.dart';
import 'package:three_o/presentation/page/settings/terms_of_service_page.dart';
import 'package:three_o/presentation/page/signup/signup_page.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/widget/main_scaffold.dart';

part 'app_router.g.dart';

// 認証状態の変更をGoRouterに通知するためのクラス
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// 認証状態を確認中に表示するシンプルなスプラッシュ画面
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final appUserState = ref.watch(appUserStreamProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // 初期表示をスプラッシュ画面に変更
    initialLocation: '/splash',
    // 認証状態の変更を監視し、変更があればリダイレクトを再評価する
    refreshListenable: GoRouterRefreshStream(
      ref.watch(appUserStreamProvider.stream),
    ),
    redirect: (BuildContext context, GoRouterState state) {
      // 認証状態がまだ確定していない（ローディング中）場合は、何もせずスプラッシュ画面に留まる
      if (appUserState.isLoading || appUserState.hasError) {
        return null;
      }

      final appUser = appUserState.value;
      final location = state.matchedLocation;

      final isGoingToAuth = location == '/login' || location == '/signup';
      final isGoingToSplash = location == '/splash';

      // --- ここからリダイレクトのルール ---

      // 1. ログアウト状態の場合
      if (appUser == null) {
        // ログイン/新規登録画面に向かっている場合を除き、ログイン画面へ強制遷移
        return isGoingToAuth ? null : '/login';
      }

      // 2. ログイン済みだが、メール未認証の場合
      if (!appUser.emailVerified) {
        // メール認証画面以外にいる場合は、認証画面へ強制遷移
        return location == '/verify-email' ? null : '/verify-email';
      }

      // 3. ログイン・認証済みだが、プロフィール未登録の場合
      if (appUser.name == null) {
        // プロフィール登録画面以外にいる場合は、登録画面へ強制遷移
        return location == '/register-user-info' ? null : '/register-user-info';
      }

      // 4. 完全にログインが完了している場合
      // スプラッシュ画面やログイン画面にいるなら、ホーム画面へ強制遷移
      if (isGoingToSplash || isGoingToAuth) {
        return '/';
      }

      // 上記のどのルールにも当てはまらない場合は、リダイレクトしない
      return null;
    },
    routes: [
      // スプラッシュ画面のルートを追加
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),

      // --- ログインフローなど、BottomNavBarを表示しない画面 ---
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
        path: '/terms-of-service',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: '/privacy-policy',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),

      // --- BottomNavBarを表示するメインの画面 ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // --- Branch 1: チャット一覧タブ ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'agent/new',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AgentFormPage(),
                  ),
                  GoRoute(
                    path: 'agent/update',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      // extraで渡されたAgentオブジェクトを受け取る
                      final agent = state.extra as Agent;
                      return AgentUpdatePage(agent: agent);
                    },
                  ),
                  GoRoute(
                    path: 'chat/:agentId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final agentId = state.pathParameters['agentId']!;
                      return ChatPage(agentId: agentId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // --- Branch 2: アカウント管理タブ ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: 'update',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProfileUpdatePage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

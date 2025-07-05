import 'dart:async';
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
import 'package:three_o/presentation/page/resume/history_form_page.dart'; // 新規追加
import 'package:three_o/presentation/page/resume/resume_page.dart'; // 新規追加
import 'package:three_o/presentation/page/settings/privacy_policy_page.dart';
import 'package:three_o/presentation/page/settings/terms_of_service_page.dart';
import 'package:three_o/presentation/page/signup/signup_page.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/widget/main_scaffold.dart';

part 'app_router.g.dart';

// (GoRouterRefreshStreamとSplashPageのコードは変更なし)
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
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(appUserStreamProvider.stream),
    ),
    redirect: (BuildContext context, GoRouterState state) {
      if (appUserState.isLoading || appUserState.hasError) {
        return null;
      }
      final appUser = appUserState.value;
      final location = state.matchedLocation;
      final isGoingToAuth = location == '/login' || location == '/signup';
      final isGoingToSplash = location == '/splash';

      if (appUser == null) {
        return isGoingToAuth ? null : '/login';
      }
      if (!appUser.emailVerified) {
        return location == '/verify-email' ? null : '/verify-email';
      }
      // profileのチェックをbirthdayに変更
      if (appUser.birthday == null) {
        return location == '/register-user-info' ? null : '/register-user-info';
      }
      if (isGoingToSplash || isGoingToAuth) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // --- Branch 1: チャット一覧タブ (変更なし) ---
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

          // --- Branch 2: 履歴書タブ (新規追加) ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/resume',
                builder: (context, state) => const ResumePage(),
                routes: [
                  GoRoute(
                    path: 'history-form',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const HistoryFormPage(),
                  ),
                ],
              ),
            ],
          ),

          // --- Branch 3: アカウント管理タブ (元Branch 2) ---
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/domain/model/usage/usage.dart';
import 'package:three_o/infrastructure/repository/usage_repository_impl.dart';
import 'package:three_o/domain/repository/usage_repository.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

part 'usage_provider.g.dart';

// UsageRepositoryのインスタンスを提供するプロバイダー
@riverpod
UsageRepository usageRepository(Ref ref) {
  return UsageRepositoryImpl(ref.watch(firebaseFirestoreProvider));
}

// ログイン中ユーザーの利用状況(Usage)を提供するプロバイダー
@riverpod
Future<Usage> usage(Ref ref) {
  final userId = ref.watch(appUserStreamProvider).value?.uid;
  if (userId == null) {
    // ログインしていない場合はエラー
    throw Exception('User not logged in');
  }
  // Repository経由でUsageデータを取得
  return ref.watch(usageRepositoryProvider).getUsage(userId);
}

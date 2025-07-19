import 'package:flutter_riverpod/flutter_riverpod.dart';

/// アプリ全体のローディング状態を管理するStateNotifierProvider。
/// UIは、このProviderの状態（trueかfalseか）を監視して、
/// ローディングインジケーターの表示を切り替える。
final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  /// ローディングを開始する。
  /// 非同期処理の開始時に呼び出す。
  void startLoading() {
    state = true;
  }

  /// ローディングを終了する。
  /// 非同期処理が完了または失敗した際に、finallyブロックで呼び出す。
  void endLoading() {
    state = false;
  }
}

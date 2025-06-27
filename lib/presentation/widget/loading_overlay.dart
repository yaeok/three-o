import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';

/// 画面全体を覆うローディングオーバーレイ。
/// [loadingProvider]の状態を監視し、ローディング中のみ表示される。
class LoadingOverlay extends ConsumerWidget {
  const LoadingOverlay({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // グローバルなローディング状態を監視
    final isLoading = ref.watch(loadingProvider);

    return Stack(
      children: [
        // 背景となるメインのコンテンツ
        child,

        // ローディング中のみ、オーバーレイを表示
        if (isLoading)
          // 操作不能にするための半透明バリア
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          // ローディングインジケーター
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

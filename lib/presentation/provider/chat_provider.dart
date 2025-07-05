import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/application/usecase/send_message_usecase.dart';
import 'package:three_o/domain/model/message/message.dart';
import 'package:three_o/domain/repository/chat_repository.dart';
import 'package:three_o/infrastructure/repository/chat_repository_impl.dart';
import 'package:three_o/infrastructure/service/gemini_service.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';
import 'package:three_o/presentation/provider/usage_provider.dart'; // Usageプロバイダーをインポート

part 'chat_provider.g.dart';

@riverpod
GeminiService geminiService(Ref ref) => GeminiService();

@riverpod
ChatRepository chatRepository(Ref ref) => ChatRepositoryImpl(
  ref.watch(firebaseFirestoreProvider),
  ref.watch(geminiServiceProvider),
  ref.watch(usageRepositoryProvider), // UsageRepositoryを注入
);

@riverpod
SendMessageUseCase sendMessageUseCase(Ref ref) =>
    SendMessageUseCase(ref.watch(chatRepositoryProvider));

@riverpod
Stream<List<Message>> messagesStream(Ref ref, String agentId) {
  final userId = ref.watch(appUserStreamProvider).value?.uid;
  if (userId == null) return Stream.value([]);
  return ref
      .watch(chatRepositoryProvider)
      .getMessages(userId: userId, agentId: agentId);
}

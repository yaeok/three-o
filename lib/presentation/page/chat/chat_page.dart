import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/domain/model/message/message.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String agentId;
  const ChatPage({super.key, required this.agentId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isEmpty) return;
    setState(() => _isSending = true);

    final user = ref.read(appUserStreamProvider).value;
    final agents = ref.read(agentsStreamProvider).value ?? [];
    final agent = agents.firstWhere(
      (a) => a.id == widget.agentId,
      orElse: () => throw Exception('Agent not found'),
    );
    final history =
        ref.read(messagesStreamProvider(widget.agentId)).value ?? [];

    if (user == null) {
      if (mounted) setState(() => _isSending = false);
      return;
    }

    final message = Message(
      text: _textController.text,
      sender: SenderRole.user,
      createdAt: DateTime.now(),
    );
    _textController.clear();

    try {
      await ref
          .read(sendMessageUseCaseProvider)
          .execute(
            userId: user.uid,
            agent: agent,
            history: history,
            message: message,
          );
      if (mounted) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('メッセージの送信に失敗しました: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesStreamProvider(widget.agentId));
    final agents = ref.watch(agentsStreamProvider).value ?? [];
    final agent = agents.firstWhere(
      (a) => a.id == widget.agentId,
      orElse: () => const Agent(
        userId: '',
        name: '...',
        role: '',
        personality: '',
        industryInfo: '',
      ),
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(agent.name)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isUser = message.sender == SenderRole.user;

                  // メッセージバブルの角丸を調整
                  const radius = Radius.circular(20);
                  final bubbleBorderRadius = isUser
                      ? const BorderRadius.only(
                          topLeft: radius,
                          topRight: radius,
                          bottomLeft: radius,
                        )
                      : const BorderRadius.only(
                          topLeft: radius,
                          topRight: radius,
                          bottomRight: radius,
                        );

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: bubbleBorderRadius,
                      ),
                      child: Text(
                        message.text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isUser
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('エラー: $e')),
            ),
          ),
          // --- 入力欄のスタイル調整 ---
          Container(
            padding: const EdgeInsets.all(12.0).copyWith(top: 8.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'メッセージを入力...',
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isSending)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  else
                    IconButton.filled(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

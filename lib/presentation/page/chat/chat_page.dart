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
  final _scrollController = ScrollController(); // 1. ScrollControllerを追加
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose(); // 2. ScrollControllerを破棄
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
      // 4. メッセージ送信後にアニメーションを実行
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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

    return Scaffold(
      appBar: AppBar(title: Text(agent.name)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                controller: _scrollController, // 3. ListViewにControllerを適用
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isUser = message.sender == SenderRole.user;
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isUser
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力...',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isSending)
                  const CircularProgressIndicator()
                else
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

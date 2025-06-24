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
  bool _isSending = false;

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

    if (user == null) return;

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
    } catch (e) {
      // エラーハンドリング
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

    return Scaffold(
      appBar: AppBar(title: Text(agent.name)),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) => ListView.builder(
                reverse: true,
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(message.text),
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
                    decoration: const InputDecoration(hintText: 'メッセージを入力...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

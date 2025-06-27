import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';

class AgentUpdatePage extends ConsumerStatefulWidget {
  const AgentUpdatePage({super.key, required this.agent});

  // 編集対象のAgentデータを前の画面から受け取る
  final Agent agent;

  @override
  ConsumerState<AgentUpdatePage> createState() => _AgentUpdatePageState();
}

class _AgentUpdatePageState extends ConsumerState<AgentUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _personalityController;
  late final TextEditingController _industryInfoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 受け取ったAgentデータでフォームの初期値を設定
    _nameController = TextEditingController(text: widget.agent.name);
    _roleController = TextEditingController(text: widget.agent.role);
    _personalityController = TextEditingController(
      text: widget.agent.personality,
    );
    _industryInfoController = TextEditingController(
      text: widget.agent.industryInfo,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _personalityController.dispose();
    _industryInfoController.dispose();
    super.dispose();
  }

  Future<void> _updateAgent() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // フォームの入力内容でAgentデータを更新
    final updatedAgent = widget.agent.copyWith(
      name: _nameController.text,
      role: _roleController.text,
      personality: _personalityController.text,
      industryInfo: _industryInfoController.text,
    );

    try {
      // 保存Usecaseを実行（IDが既にあるため、更新処理となる）
      await ref.read(saveAgentUseCaseProvider).execute(updatedAgent);
      ref.invalidate(agentsStreamProvider); // 一覧を更新
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('AI上司の情報を更新しました')));
        context.pop(); // 前の画面に戻る
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー：更新に失敗しました。$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI上司の編集')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '名前',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: '役職',
                  helperText: '例：部長、先輩、メンター',
                  prefixIcon: Icon(Icons.work_outline),
                ),
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _personalityController,
                decoration: const InputDecoration(
                  labelText: '性格・口調',
                  helperText: '例：穏やかで論理的。あなたの意見を尊重する。',
                  prefixIcon: Icon(Icons.psychology_outlined),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _industryInfoController,
                decoration: const InputDecoration(
                  labelText: '特化させたい業界・知識',
                  helperText: '例：最新のWeb3技術やDAOに詳しい。',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _isLoading ? null : _updateAgent,
                child: _isLoading
                    ? const SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text('この内容で更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

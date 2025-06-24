import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';

class AgentFormPage extends ConsumerStatefulWidget {
  const AgentFormPage({super.key});

  @override
  ConsumerState<AgentFormPage> createState() => _AgentFormPageState();
}

class _AgentFormPageState extends ConsumerState<AgentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _personalityController = TextEditingController();
  final _industryInfoController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveAgent() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(appUserStreamProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);

    final newAgent = Agent(
      userId: user.uid,
      name: _nameController.text,
      role: _roleController.text,
      personality: _personalityController.text,
      industryInfo: _industryInfoController.text,
    );

    try {
      await ref.read(saveAgentUseCaseProvider).execute(newAgent);
      if (mounted) context.pop();
    } catch (e) {
      // エラーハンドリング
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI上司の作成')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '名前'),
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: '役職（例：部長、先輩）'),
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              TextFormField(
                controller: _personalityController,
                decoration: const InputDecoration(
                  labelText: '性格・口調',
                  helperText: '例：穏やかで論理的。あなたの意見を尊重する。',
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              TextFormField(
                controller: _industryInfoController,
                decoration: const InputDecoration(
                  labelText: '特化させたい業界・知識',
                  helperText: '例：最新のWeb3技術やDAOに詳しい。',
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveAgent,
                  child: const Text('保存する'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

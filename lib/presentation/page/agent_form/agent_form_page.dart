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

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _personalityController.dispose();
    _industryInfoController.dispose();
    super.dispose();
  }

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
      ref.invalidate(agentsStreamProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー：保存に失敗しました。$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(pinned: true, title: Text('AI上司の作成')),
          SliverToBoxAdapter(
            child: Padding(
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
                      onPressed: _isLoading ? null : _saveAgent,
                      child: _isLoading
                          ? const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text('この内容で作成'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

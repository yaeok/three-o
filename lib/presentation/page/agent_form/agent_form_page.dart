import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:three_o/domain/model/agent/agent.dart';
import 'package:three_o/presentation/provider/agent_provider.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';

class AgentFormPage extends ConsumerWidget {
  const AgentFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final personalityController = TextEditingController();
    final industryInfoController = TextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> saveAgent() async {
      if (!formKey.currentState!.validate()) return;

      ref.read(loadingProvider.notifier).startLoading();

      final user = ref.read(appUserStreamProvider).value;
      if (user == null) {
        ref.read(loadingProvider.notifier).endLoading();
        return;
      }

      final newAgent = Agent(
        userId: user.uid,
        name: nameController.text,
        role: roleController.text,
        personality: personalityController.text,
        industryInfo: industryInfoController.text,
      );

      try {
        await ref.read(saveAgentUseCaseProvider).execute(newAgent);
        ref.invalidate(agentsStreamProvider);
        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('エラー：保存に失敗しました。$e')));
        }
      } finally {
        ref.read(loadingProvider.notifier).endLoading();
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(pinned: true, title: Text('AI上司の作成')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '名前',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v!.isEmpty ? '必須です' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: roleController,
                      decoration: const InputDecoration(
                        labelText: '役職',
                        helperText: '例：部長、先輩、メンター',
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      validator: (v) => v!.isEmpty ? '必須です' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: personalityController,
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
                      controller: industryInfoController,
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
                      onPressed: saveAgent,
                      child: const Text('この内容で作成'),
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

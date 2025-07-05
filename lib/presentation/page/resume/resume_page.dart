import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/resume/resume.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/resume_provider.dart'; // 後ほど作成

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStreamProvider).value;
    if (user == null) {
      return const Center(child: Text('ユーザー情報がありません'));
    }

    final resumeAsync = ref.watch(resumeStreamProvider(user.uid));
    final theme = Theme.of(context);

    return Scaffold(
      body: resumeAsync.when(
        data: (resume) {
          if (resume == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 80),
                  const SizedBox(height: 16),
                  const Text('履歴書がまだありません'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // ユーザー情報から初期データを作成して保存
                      final initialResume = Resume(
                        userId: user.uid,
                        name: user.name ?? '',
                        birthday: user.birthday!,
                        email: user.email,
                      );
                      ref
                          .read(saveResumeUseCaseProvider)
                          .execute(initialResume);
                    },
                    child: const Text('履歴書を作成する'),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle(theme, '基本情報'),
              _buildInfoTile('氏名', resume.name),
              _buildInfoTile(
                '生年月日',
                DateFormat('yyyy年M月d日').format(resume.birthday),
              ),
              _buildInfoTile('メールアドレス', resume.email ?? '未設定'),
              const Divider(height: 32),
              _buildSectionTitle(theme, '学歴'),
              if (resume.educationHistory.isEmpty)
                const Text('登録された学歴はありません')
              else
                ...resume.educationHistory.map(
                  (e) => _buildHistoryTile(
                    title: e.schoolName,
                    subtitle:
                        '${DateFormat('yyyy年M月').format(e.entranceDate)} - ${DateFormat('yyyy年M月').format(e.graduationDate)}',
                  ),
                ),
              const Divider(height: 32),
              _buildSectionTitle(theme, '職歴'),
              if (resume.workHistory.isEmpty)
                const Text('登録された職歴はありません')
              else
                ...resume.workHistory.map(
                  (e) => _buildHistoryTile(
                    title: e.companyName,
                    subtitle:
                        '${e.position ?? ''} (${DateFormat('yyyy年M月').format(e.joiningDate)} - ${e.leavingDate != null ? DateFormat('yyyy年M月').format(e.leavingDate!) : '現在'})',
                    description: e.description,
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('エラーが発生しました: $e')),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildHistoryTile({
    required String title,
    required String subtitle,
    String? description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

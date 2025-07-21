import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
// ▼▼▼ resume_provider から user_profile_provider に変更 ▼▼▼
import 'package:three_o/presentation/provider/user_profile_provider.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStreamProvider).value;
    if (user == null) {
      return const Center(child: Text('ユーザー情報がありません'));
    }

    // ▼▼▼ resumeStreamProvider から userProfileProvider に変更 ▼▼▼
    final userProfileAsync = ref.watch(userProfileProvider(user.uid));
    final theme = Theme.of(context);

    return Scaffold(
      body: userProfileAsync.when(
        // ▼▼▼ 変数名を resume から userProfile に変更 ▼▼▼
        data: (userProfile) {
          // userProfile自体は登録フローで作成されるため、nullチェックは基本的に不要ですが念のため
          if (userProfile == null) {
            return const Center(child: Text('プロフィール情報が見つかりません。'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionTitle(theme, '基本情報'),
              _buildInfoTile('氏名', userProfile.name),
              _buildInfoTile(
                '生年月日',
                DateFormat('yyyy年M月d日').format(userProfile.birthday),
              ),
              _buildInfoTile('メールアドレス', userProfile.email ?? '未設定'),
              const Divider(height: 32),
              _buildSectionTitle(theme, '学歴'),
              if (userProfile.educationHistory.isEmpty)
                const Text('登録された学歴はありません')
              else
                ...userProfile.educationHistory.map(
                  (e) => _buildHistoryTile(
                    title: e.schoolName,
                    subtitle:
                        '${DateFormat('yyyy年M月').format(e.entranceDate)} - ${DateFormat('yyyy年M月').format(e.graduationDate)}',
                  ),
                ),
              const Divider(height: 32),
              _buildSectionTitle(theme, '職歴'),
              if (userProfile.workHistory.isEmpty)
                const Text('登録された職歴はありません')
              else
                ...userProfile.workHistory.map(
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

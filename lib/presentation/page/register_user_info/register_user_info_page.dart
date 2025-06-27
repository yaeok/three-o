import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

class RegisterUserInfoPage extends ConsumerWidget {
  const RegisterUserInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final selectedIndustry = StateProvider<String?>((ref) => null);
    final selectedGender = StateProvider<String?>((ref) => null);

    final industries = ['IT', 'メーカー', '金融', 'コンサル', 'その他'];
    final genders = ['男性', '女性', 'その他'];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> saveProfile() async {
      if (!formKey.currentState!.validate()) return;

      ref.read(loadingProvider.notifier).startLoading();

      final user = ref.read(appUserStreamProvider).value;
      if (user == null) {
        ref.read(loadingProvider.notifier).endLoading();
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('エラー：ユーザー情報が見つかりません')));
        }
        return;
      }

      final userProfile = UserProfile(
        uid: user.uid,
        name: nameController.text,
        industry: ref.read(selectedIndustry)!,
        age: int.parse(ageController.text),
        gender: ref.read(selectedGender)!,
      );

      try {
        await ref.read(saveUserProfileUseCaseProvider).execute(userProfile);
        ref.invalidate(userProfileProvider(user.uid));
        ref.invalidate(appUserStreamProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('エラー：プロフィールの保存に失敗しました。$e')));
        }
      } finally {
        ref.read(loadingProvider.notifier).endLoading();
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'もう少しです！',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'あなたに合ったサポートのため、プロフィールを教えてください。',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '名前',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: colorScheme.primary,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? '必須です' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: ref.watch(selectedIndustry),
                  decoration: InputDecoration(
                    labelText: '業界',
                    prefixIcon: Icon(
                      Icons.work_outline,
                      color: colorScheme.primary,
                    ),
                  ),
                  items: industries
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) =>
                      ref.read(selectedIndustry.notifier).state = v,
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: '年齢',
                    prefixIcon: Icon(
                      Icons.cake_outlined,
                      color: colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? '必須です' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: ref.watch(selectedGender),
                  decoration: InputDecoration(
                    labelText: '性別',
                    prefixIcon: Icon(
                      Icons.wc_outlined,
                      color: colorScheme.primary,
                    ),
                  ),
                  items: genders
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => ref.read(selectedGender.notifier).state = v,
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: saveProfile,
                  child: const Text('登録して始める'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

class RegisterUserInfoPage extends ConsumerStatefulWidget {
  const RegisterUserInfoPage({super.key});
  @override
  ConsumerState<RegisterUserInfoPage> createState() =>
      _RegisterUserInfoPageState();
}

class _RegisterUserInfoPageState extends ConsumerState<RegisterUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedIndustry;
  String? _selectedGender;
  bool _isLoading = false;

  final _industries = ['IT', 'メーカー', '金融', 'コンサル', 'その他'];
  final _genders = ['男性', '女性', 'その他'];

  Future<void> _saveProfile() async {
    // バリデーションチェック
    if (!_formKey.currentState!.validate()) return;

    // ユーザー情報の取得
    final user = ref.read(appUserStreamProvider).value;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('エラー：ユーザー情報が見つかりません')));
      }
      return;
    }

    setState(() => _isLoading = true);

    // 保存するプロフィールデータを作成
    final userProfile = UserProfile(
      uid: user.uid,
      name: _nameController.text,
      industry: _selectedIndustry!,
      age: int.parse(_ageController.text),
      gender: _selectedGender!,
    );

    try {
      // データの保存
      await ref.read(saveUserProfileUseCaseProvider).execute(userProfile);
      // Providerを無効化してGoRouterの再評価をトリガー
      ref.invalidate(userProfileProvider(user.uid));
      ref.invalidate(appUserStreamProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー：プロフィールの保存に失敗しました。$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // 背景色をテーマに合わせる
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // AppBarを透明にして、ボディと一体感を持たせる
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 左右に一貫したパディングを追加
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- ヘッダー部分 ---
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

                // --- フォーム入力欄 ---
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '名前',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? '必須です' : null,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedIndustry,
                  decoration: InputDecoration(
                    labelText: '業界',
                    prefixIcon: Icon(
                      Icons.work_outline,
                      color: colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _industries
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedIndustry = v),
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: '年齢',
                    prefixIcon: Icon(
                      Icons.cake_outlined,
                      color: colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? '必須です' : null,
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: '性別',
                    prefixIcon: Icon(
                      Icons.wc_outlined,
                      color: colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _genders
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v),
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 40),

                // --- 登録ボタン ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text('登録して始める'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/loading_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

// ConsumerWidget から ConsumerStatefulWidget に変更
class RegisterUserInfoPage extends ConsumerStatefulWidget {
  const RegisterUserInfoPage({super.key});

  @override
  ConsumerState<RegisterUserInfoPage> createState() =>
      _RegisterUserInfoPageState();
}

// Stateクラスを作成
class _RegisterUserInfoPageState extends ConsumerState<RegisterUserInfoPage> {
  // formKeyとControllerをStateのメンバ変数として定義
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  final _industries = ['IT', 'メーカー', '金融', 'コンサル', 'その他'];
  final _genders = ['男性', '女性', 'その他'];

  // StateProviderはローカルステートとして管理
  DateTime? _selectedBirthday;
  String? _selectedIndustry;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // initStateで一度だけ初期化
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    // disposeで必ず破棄
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000), // 初期値を2000年などに変更
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year, // この行を追加
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthday == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('生年月日を選択してください')));
      return;
    }

    ref.read(loadingProvider.notifier).startLoading();

    final user = ref.read(appUserStreamProvider).value;
    if (user == null) {
      ref.read(loadingProvider.notifier).endLoading();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('エラー：ユーザー情報が見つかりません')));
      }
      return;
    }

    final userProfile = UserProfile(
      uid: user.uid,
      name: _nameController.text, // Controllerから値を取得
      industry: _selectedIndustry!,
      birthday: _selectedBirthday!,
      gender: _selectedGender!,
    );

    try {
      await ref.read(saveUserProfileUseCaseProvider).execute(userProfile);
      ref.invalidate(userProfileProvider(user.uid));
      ref.invalidate(appUserStreamProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラー：プロフィールの保存に失敗しました。$e')));
      }
    } finally {
      ref.read(loadingProvider.notifier).endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            key: _formKey,
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
                  controller: _nameController, // Stateで管理しているControllerを使用
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
                  value: _selectedIndustry,
                  decoration: InputDecoration(
                    labelText: '業界',
                    prefixIcon: Icon(
                      Icons.work_outline,
                      color: colorScheme.primary,
                    ),
                  ),
                  items: _industries
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedIndustry = v),
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: '生年月日',
                      prefixIcon: Icon(
                        Icons.cake_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      _selectedBirthday == null
                          ? '選択してください'
                          : DateFormat('yyyy年M月d日').format(_selectedBirthday!),
                    ),
                  ),
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
                  ),
                  items: _genders
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedGender = v),
                  validator: (v) => v == null ? '必須です' : null,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _saveProfile,
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

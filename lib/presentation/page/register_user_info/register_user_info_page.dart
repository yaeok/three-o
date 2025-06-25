import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(appUserStreamProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('エラー：ユーザー情報が見つかりません')));
      return;
    }
    setState(() => _isLoading = true);
    final userProfile = UserProfile(
      uid: user.uid,
      name: _nameController.text,
      industry: _selectedIndustry!,
      age: int.parse(_ageController.text),
      gender: _selectedGender!,
    );
    try {
      await ref.read(saveUserProfileUseCaseProvider).execute(userProfile);
      ref.invalidate(userProfileProvider(user.uid));
      ref.invalidate(appUserStreamProvider);
      if (mounted) context.pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール登録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIndustry,
                decoration: const InputDecoration(labelText: '業界'),
                items: _industries
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedIndustry = v),
                validator: (v) => v == null ? '必須です' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: '年齢'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? '必須です' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: '性別'),
                items: _genders
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedGender = v),
                validator: (v) => v == null ? '必須です' : null,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('登録する'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

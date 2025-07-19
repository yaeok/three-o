import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

class ProfileUpdatePage extends ConsumerStatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  ConsumerState<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends ConsumerState<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  DateTime? _selectedBirthday; // ageControllerから変更
  String? _selectedIndustry;
  String? _selectedGender;
  bool _isLoading = false;

  final _industries = ['IT', 'メーカー', '金融', 'コンサル', 'その他'];
  final _genders = ['男性', '女性', 'その他'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStreamProvider).value;
    _nameController = TextEditingController(text: user?.name);
    _selectedBirthday = user?.birthday; // birthdayをセット
    _selectedIndustry = user?.industry;
    _selectedGender = user?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000), // 初期値を2000年などに変更
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.inputOnly,
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthday == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('生年月日を選択してください')));
      return;
    }
    final user = ref.read(appUserStreamProvider).value;
    if (user == null) return;

    setState(() => _isLoading = true);

    final userProfile = UserProfile(
      uid: user.uid,
      name: _nameController.text,
      industry: _selectedIndustry!,
      birthday: _selectedBirthday!, // ageから変更
      gender: _selectedGender!,
    );

    try {
      await ref.read(saveUserProfileUseCaseProvider).execute(userProfile);
      ref.invalidate(userProfileProvider(user.uid));
      ref.invalidate(appUserStreamProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('プロフィールを更新しました')));
        context.pop();
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
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール更新')),
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
              // --- 年齢入力から生年月日選択に変更 ---
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '生年月日',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  child: Text(
                    _selectedBirthday == null
                        ? '選択してください'
                        : DateFormat('yyyy年M月d日').format(_selectedBirthday!),
                  ),
                ),
              ),
              // ------------------------------------
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
                  onPressed: _updateProfile,
                  child: const Text('更新する'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/resume/resume.dart';
// ▼▼▼ user_profile_provider に変更 ▼▼▼
import 'package:three_o/domain/model/user_profile/user_profile.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart';

class HistoryFormPage extends ConsumerStatefulWidget {
  const HistoryFormPage({super.key});

  @override
  ConsumerState<HistoryFormPage> createState() => _HistoryFormPageState();
}

class _HistoryFormPageState extends ConsumerState<HistoryFormPage> {
  final _formKey = GlobalKey<FormState>();

  // --- 学歴コントローラー ---
  final _elementarySchoolController = TextEditingController();
  DateTime? _elementaryEntranceDate;
  DateTime? _elementaryGraduationDate;
  final _juniorHighSchoolController = TextEditingController();
  DateTime? _juniorHighEntranceDate;
  DateTime? _juniorHighGraduationDate;
  final _highSchoolController = TextEditingController();
  DateTime? _highEntranceDate;
  DateTime? _highGraduationDate;

  bool _isInitialized = false;

  @override
  void dispose() {
    _elementarySchoolController.dispose();
    _juniorHighSchoolController.dispose();
    _highSchoolController.dispose();
    super.dispose();
  }

  void _autoFillEducationDates(DateTime birthday) {
    setState(() {
      _elementaryEntranceDate = DateTime(birthday.year + 6, 4);
      _elementaryGraduationDate = DateTime(birthday.year + 12, 3);
      _juniorHighEntranceDate = DateTime(birthday.year + 12, 4);
      _juniorHighGraduationDate = DateTime(birthday.year + 15, 3);
      _highEntranceDate = DateTime(birthday.year + 15, 4);
      _highGraduationDate = DateTime(birthday.year + 18, 3);
    });
  }

  // ▼▼▼ 引数の型を UserProfile に変更 ▼▼▼
  void _populateForm(UserProfile userProfile) {
    for (var history in userProfile.educationHistory) {
      if (history.schoolName.contains('小学校')) {
        _elementarySchoolController.text = history.schoolName;
        _elementaryEntranceDate = history.entranceDate;
        _elementaryGraduationDate = history.graduationDate;
      } else if (history.schoolName.contains('中学校')) {
        _juniorHighSchoolController.text = history.schoolName;
        _juniorHighEntranceDate = history.entranceDate;
        _juniorHighGraduationDate = history.graduationDate;
      } else if (history.schoolName.contains('高等学校')) {
        _highSchoolController.text = history.schoolName;
        _highEntranceDate = history.entranceDate;
        _highGraduationDate = history.graduationDate;
      }
    }
  }

  // ▼▼▼ 保存ロジックを全面的に変更 ▼▼▼
  Future<void> _saveHistory(UserProfile currentUserProfile) async {
    if (!_formKey.currentState!.validate()) return;

    final educationHistory = [
      if (_elementarySchoolController.text.isNotEmpty)
        EducationHistory(
          schoolName: _elementarySchoolController.text,
          entranceDate: _elementaryEntranceDate!,
          graduationDate: _elementaryGraduationDate!,
        ),
      if (_juniorHighSchoolController.text.isNotEmpty)
        EducationHistory(
          schoolName: _juniorHighSchoolController.text,
          entranceDate: _juniorHighEntranceDate!,
          graduationDate: _juniorHighGraduationDate!,
        ),
      if (_highSchoolController.text.isNotEmpty)
        EducationHistory(
          schoolName: _highSchoolController.text,
          entranceDate: _highEntranceDate!,
          graduationDate: _highGraduationDate!,
        ),
    ];

    final updatedProfile = currentUserProfile.copyWith(
      educationHistory: educationHistory,
    );

    try {
      // ▼▼▼ saveUserProfileUseCaseProvider を使用 ▼▼▼
      await ref.read(saveUserProfileUseCaseProvider).execute(updatedProfile);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('経歴を保存しました')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存に失敗しました: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStreamProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ▼▼▼ resumeStreamProvider から userProfileProvider に変更 ▼▼▼
    final userProfileAsync = ref.watch(userProfileProvider(user.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('経歴の編集')),
      body: userProfileAsync.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(child: Text('プロフィールデータが見つかりません。'));
          }

          if (!_isInitialized) {
            if (userProfile.educationHistory.isEmpty && user.birthday != null) {
              _autoFillEducationDates(user.birthday!);
            } else {
              _populateForm(userProfile);
            }
            _isInitialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('学歴', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildEducationField(
                    label: '小学校',
                    controller: _elementarySchoolController,
                    entranceDate: _elementaryEntranceDate,
                    graduationDate: _elementaryGraduationDate,
                    onEntranceDateChanged: (date) =>
                        setState(() => _elementaryEntranceDate = date),
                    onGraduationDateChanged: (date) =>
                        setState(() => _elementaryGraduationDate = date),
                  ),
                  const SizedBox(height: 16),
                  _buildEducationField(
                    label: '中学校',
                    controller: _juniorHighSchoolController,
                    entranceDate: _juniorHighEntranceDate,
                    graduationDate: _juniorHighGraduationDate,
                    onEntranceDateChanged: (date) =>
                        setState(() => _juniorHighEntranceDate = date),
                    onGraduationDateChanged: (date) =>
                        setState(() => _juniorHighGraduationDate = date),
                  ),
                  const SizedBox(height: 16),
                  _buildEducationField(
                    label: '高等学校',
                    controller: _highSchoolController,
                    entranceDate: _highEntranceDate,
                    graduationDate: _highGraduationDate,
                    onEntranceDateChanged: (date) =>
                        setState(() => _highEntranceDate = date),
                    onGraduationDateChanged: (date) =>
                        setState(() => _highGraduationDate = date),
                  ),
                  const SizedBox(height: 40),
                  // ▼▼▼ 保存ボタンの引数を userProfile に変更 ▼▼▼
                  ElevatedButton(
                    onPressed: () => _saveHistory(userProfile),
                    child: const Text('この内容で保存する'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('データの読み込みに失敗しました: $e')),
      ),
    );
  }

  Widget _buildEducationField({
    required String label,
    required TextEditingController controller,
    DateTime? entranceDate,
    DateTime? graduationDate,
    required ValueChanged<DateTime> onEntranceDateChanged,
    required ValueChanged<DateTime> onGraduationDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: '$label名'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                '入学年月',
                entranceDate,
                onEntranceDateChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                '卒業年月',
                graduationDate,
                onGraduationDateChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    ValueChanged<DateTime> onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
        );
        if (newDate != null) {
          onChanged(newDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
        ),
        child: Text(date == null ? '選択' : DateFormat('yyyy年 M月').format(date)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:three_o/domain/model/resume/resume.dart';
import 'package:three_o/presentation/provider/auth_provider.dart';
import 'package:three_o/presentation/provider/resume_provider.dart'; // 作成したProviderをimport

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

  @override
  void initState() {
    super.initState();
    _autoFillEducationDates();
  }

  // 生年月日から学歴の年月を自動計算する
  void _autoFillEducationDates() {
    final user = ref.read(appUserStreamProvider).value;
    if (user?.birthday == null) return;

    final birthday = user!.birthday!;

    // 小学校: 6歳になる年の4月に入学、12歳になる年の3月に卒業
    _elementaryEntranceDate = DateTime(birthday.year + 6, 4);
    _elementaryGraduationDate = DateTime(birthday.year + 12, 3);

    // 中学校: 12歳になる年の4月に入学、15歳になる年の3月に卒業
    _juniorHighEntranceDate = DateTime(birthday.year + 12, 4);
    _juniorHighGraduationDate = DateTime(birthday.year + 15, 3);

    // 高校: 15歳になる年の4月に入学、18歳になる年の3月に卒業
    _highEntranceDate = DateTime(birthday.year + 15, 4);
    _highGraduationDate = DateTime(birthday.year + 18, 3);
  }

  Future<void> _saveHistory() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(appUserStreamProvider).value;
    final currentResume = ref.read(resumeStreamProvider(user!.uid)).value;
    if (user == null || currentResume == null) return;

    final educationHistory = [
      // 各学校名が入力されていたらリストに追加
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

    final updatedResume = currentResume.copyWith(
      educationHistory: educationHistory,
    );

    try {
      await ref.read(saveResumeUseCaseProvider).execute(updatedResume);
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
    return Scaffold(
      appBar: AppBar(title: const Text('経歴の編集')),
      body: SingleChildScrollView(
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
              // TODO: 職歴入力フォームもここに追加
              ElevatedButton(
                onPressed: _saveHistory,
                child: const Text('保存する'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 学歴入力ウィジェット
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

  // 年月選択ウィジェット
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

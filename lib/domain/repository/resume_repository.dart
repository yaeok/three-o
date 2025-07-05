import 'package:three_o/domain/model/resume/resume.dart';

abstract class ResumeRepository {
  // ユーザーの履歴書データをStreamで取得する
  Stream<Resume?> getResume(String userId);

  // 履歴書を保存（新規作成または更新）する
  Future<void> saveResume(Resume resume);
}

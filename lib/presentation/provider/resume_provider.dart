import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:three_o/domain/model/resume/resume.dart';
import 'package:three_o/domain/repository/resume_repository.dart';
import 'package:three_o/infrastructure/repository/resume_repository_impl.dart';
import 'package:three_o/presentation/provider/user_profile_provider.dart'; // firebaseFirestoreProviderのため

part 'resume_provider.g.dart';

// --- Repository ---
@riverpod
ResumeRepository resumeRepository(Ref ref) {
  // 既存のFirestoreインスタンスを再利用
  return ResumeRepositoryImpl(ref.watch(firebaseFirestoreProvider));
}

// --- UseCase ---

/// 履歴書を保存するためのUsecaseクラス
class SaveResumeUseCase {
  final ResumeRepository _repository;
  SaveResumeUseCase(this._repository);

  /// 履歴書オブジェクトを受け取り、リポジトリ経由で保存する
  Future<void> execute(Resume resume) => _repository.saveResume(resume);
}

@riverpod
SaveResumeUseCase saveResumeUseCase(Ref ref) {
  return SaveResumeUseCase(ref.watch(resumeRepositoryProvider));
}

// --- Data Provider ---
@riverpod
Stream<Resume?> resumeStream(Ref ref, String userId) {
  // userIdに紐づく履歴書データをStreamで監視・提供する
  return ref.watch(resumeRepositoryProvider).getResume(userId);
}

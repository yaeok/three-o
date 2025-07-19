import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/resume/resume.dart';
import 'package:three_o/domain/repository/resume_repository.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final FirebaseFirestore _firestore;

  ResumeRepositoryImpl(this._firestore);

  // users/{userId}/resume/{resumeId} ドキュメントへの参照
  // 履歴書はユーザー1人につき1つと想定し、ドキュメントIDを固定
  DocumentReference<Resume> _resumeRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('resumes')
      .doc('main_resume') // IDを固定
      .withConverter<Resume>(
        fromFirestore: (snapshot, _) =>
            Resume.fromJson(snapshot.data()!).copyWith(id: snapshot.id),
        toFirestore: (resume, _) => resume.toJson(),
      );

  @override
  Stream<Resume?> getResume(String userId) {
    return _resumeRef(userId).snapshots().map((snapshot) => snapshot.data());
  }

  @override
  Future<void> saveResume(Resume resume) async {
    final now = DateTime.now();
    // タイムスタンプを更新して保存
    final resumeWithTimestamp = resume.copyWith(
      createdAt: resume.createdAt ?? now,
      updatedAt: now,
    );
    // setメソッドでドキュメントIDを固定して保存・更新
    await _resumeRef(resume.userId).set(resumeWithTimestamp);
  }
}

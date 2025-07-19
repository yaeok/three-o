import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/usage/usage.dart';
import 'package:three_o/domain/repository/usage_repository.dart';

// UsageRepositoryのFirestore実装
class UsageRepositoryImpl implements UsageRepository {
  final FirebaseFirestore _firestore;

  UsageRepositoryImpl(this._firestore);

  // 'usages'コレクションへの参照
  DocumentReference<Usage> _usageRef(String userId) => _firestore
      .collection('usages')
      .doc(userId)
      .withConverter<Usage>(
        fromFirestore: (snapshot, _) {
          // ドキュメントが存在しない場合は、新しいUsageオブジェクトをデフォルト値で生成
          if (!snapshot.exists) {
            return Usage(userId: userId);
          }
          // ドキュメントが存在する場合は、安全なfromFirestoreファクトリで変換
          return Usage.fromFirestore(snapshot);
        },
        toFirestore: (usage, _) => usage.toJson(),
      );

  @override
  Future<Usage> getUsage(String userId) async {
    final doc = await _usageRef(userId).get();

    // ▼▼▼【修正点】doc.data()がnullの場合のフォールバック処理を追加 ▼▼▼
    // これにより、どんな状況でも必ず有効なUsageオブジェクトが返され、nullエラーを防ぎます。
    return doc.data() ?? Usage(userId: userId);
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
  }

  @override
  Future<void> updateUsage(Usage usage) async {
    // setメソッドはドキュメントが存在しない場合に新規作成するため、安全です。
    await _usageRef(usage.userId).set(usage);
  }
}

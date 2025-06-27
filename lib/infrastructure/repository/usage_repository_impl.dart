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
          if (!snapshot.exists || snapshot.data() == null) {
            return Usage(userId: userId);
          }
          // ★新しいファクトリコンストラクタを使うように変更
          return Usage.fromFirestore(snapshot);
        },
        toFirestore: (usage, _) => usage.toJson(),
      );

  @override
  Future<Usage> getUsage(String userId) async {
    final doc = await _usageRef(userId).get();
    // withConverterでnull非許容にしているため、`!`で安全にアクセス可能
    return doc.data()!;
  }

  @override
  Future<void> updateUsage(Usage usage) async {
    await _usageRef(usage.userId).set(usage);
  }
}

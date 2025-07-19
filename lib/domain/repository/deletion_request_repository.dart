import 'package:three_o/domain/model/deletion_request/deletion_request.dart';

/// 削除申請リポジトリのインターフェース
abstract class DeletionRequestRepository {
  /// 削除申請を保存する
  Future<void> saveRequest(DeletionRequest request);
}

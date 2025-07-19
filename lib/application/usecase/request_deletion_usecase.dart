import 'package:three_o/domain/model/deletion_request/deletion_request.dart';
import 'package:three_o/domain/repository/auth_repository.dart';
import 'package:three_o/domain/repository/deletion_request_repository.dart';

/// アカウント削除を「申請」するUsecase
class RequestDeletionUsecase {
  final DeletionRequestRepository _deletionRequestRepository;
  final AuthRepository _authRepository;

  RequestDeletionUsecase(this._deletionRequestRepository, this._authRepository);

  /// アカウント削除を申請し、ユーザーをログアウトさせます。
  ///
  /// [userId] と [email] を受け取り、タイムスタンプを付与して
  /// Firestoreの`deletionRequests`コレクションに保存します。
  /// その後、ユーザーをセッションからログアウトさせます。
  Future<void> execute({required String userId, required String email}) async {
    // 削除申請オブジェクトを作成
    final request = DeletionRequest(
      userId: userId,
      email: email,
      requestedAt: DateTime.now(),
      status: 'pending', // ステータスを「保留中」として記録
    );

    // 1. Firestoreに削除申請情報を保存
    await _deletionRequestRepository.saveRequest(request);

    // 2. ユーザーをログアウトさせる
    await _authRepository.signOut();
  }
}

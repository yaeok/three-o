import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_o/domain/model/deletion_request/deletion_request.dart';
import 'package:three_o/domain/repository/deletion_request_repository.dart';

/// DeletionRequestRepositoryのFirestore実装
class DeletionRequestRepositoryImpl implements DeletionRequestRepository {
  final FirebaseFirestore _firestore;

  DeletionRequestRepositoryImpl(this._firestore);

  /// 'deletionRequests'コレクションへの参照
  CollectionReference<DeletionRequest> _requestsRef() => _firestore
      .collection('delete_requests')
      .withConverter<DeletionRequest>(
        fromFirestore: (snapshot, _) => DeletionRequest.fromJson(
          snapshot.data()!,
        ).copyWith(id: snapshot.id),
        toFirestore: (request, _) => request.toJson(),
      );

  @override
  Future<void> saveRequest(DeletionRequest request) async {
    await _requestsRef().add(request);
  }
}

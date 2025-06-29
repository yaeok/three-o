import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deletion_request.freezed.dart';
part 'deletion_request.g.dart';

// FirestoreのTimestampとDartのDateTimeを変換するためのコンバーター
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? dateTime) =>
      dateTime == null ? null : Timestamp.fromDate(dateTime);
}

@freezed
class DeletionRequest with _$DeletionRequest {
  const factory DeletionRequest({
    String? id,
    required String userId,
    required String email,
    @Default('pending') String status, // 'pending', 'processed'
    @TimestampConverter() required DateTime requestedAt,
  }) = _DeletionRequest;

  factory DeletionRequest.fromJson(Map<String, dynamic> json) =>
      _$DeletionRequestFromJson(json);
}

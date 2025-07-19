import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/converter/timestamp_converter.dart';

part 'deletion_request.freezed.dart';
part 'deletion_request.g.dart';

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

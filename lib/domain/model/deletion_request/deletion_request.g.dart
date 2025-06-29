// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeletionRequestImpl _$$DeletionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$DeletionRequestImpl(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  email: json['email'] as String,
  status: json['status'] as String? ?? 'pending',
  requestedAt: DateTime.parse(json['requestedAt'] as String),
);

Map<String, dynamic> _$$DeletionRequestImplToJson(
  _$DeletionRequestImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'email': instance.email,
  'status': instance.status,
  'requestedAt': instance.requestedAt.toIso8601String(),
};

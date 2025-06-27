// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsageImpl _$$UsageImplFromJson(Map<String, dynamic> json) => _$UsageImpl(
  userId: json['userId'] as String,
  messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
  lastMessageSentAt: const TimestampConverter().fromJson(
    json['lastMessageSentAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$$UsageImplToJson(_$UsageImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'messageCount': instance.messageCount,
      'lastMessageSentAt': const TimestampConverter().toJson(
        instance.lastMessageSentAt,
      ),
    };

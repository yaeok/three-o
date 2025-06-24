// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AgentImpl _$$AgentImplFromJson(Map<String, dynamic> json) => _$AgentImpl(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  personality: json['personality'] as String,
  industryInfo: json['industryInfo'] as String,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$$AgentImplToJson(_$AgentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'role': instance.role,
      'personality': instance.personality,
      'industryInfo': instance.industryInfo,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

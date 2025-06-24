// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String?,
      text: json['text'] as String,
      sender: $enumDecode(_$SenderRoleEnumMap, json['sender']),
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'sender': _$SenderRoleEnumMap[instance.sender]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$SenderRoleEnumMap = {
  SenderRole.user: 'user',
  SenderRole.model: 'model',
};

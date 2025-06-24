// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      industry: json['industry'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'industry': instance.industry,
      'age': instance.age,
      'gender': instance.gender,
    };

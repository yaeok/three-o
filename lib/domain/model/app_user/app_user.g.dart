// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool,
      name: json['name'] as String?,
      industry: json['industry'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'name': instance.name,
      'industry': instance.industry,
      'age': instance.age,
      'gender': instance.gender,
    };

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:three_o/domain/model/agent/agent.dart'; // TimestampConverterのため

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    // --- Auth由来の情報 ---
    required String uid,
    String? email,
    required bool emailVerified,
    String? name,
    String? industry,
    @TimestampConverter() DateTime? birthday, // ageから変更
    String? gender,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

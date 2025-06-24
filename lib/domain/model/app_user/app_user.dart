import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    // --- Auth由来の情報 ---
    required String uid,
    String? email,
    required bool emailVerified,

    // --- Profile由来の情報 (プロフィール未登録の場合はnullになる) ---
    String? name,
    String? industry,
    int? age,
    String? gender,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

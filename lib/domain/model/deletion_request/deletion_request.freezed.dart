// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deletion_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeletionRequest _$DeletionRequestFromJson(Map<String, dynamic> json) {
  return _DeletionRequest.fromJson(json);
}

/// @nodoc
mixin _$DeletionRequest {
  String? get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'processed'
  @TimestampConverter()
  DateTime get requestedAt => throw _privateConstructorUsedError;

  /// Serializes this DeletionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeletionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeletionRequestCopyWith<DeletionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeletionRequestCopyWith<$Res> {
  factory $DeletionRequestCopyWith(
    DeletionRequest value,
    $Res Function(DeletionRequest) then,
  ) = _$DeletionRequestCopyWithImpl<$Res, DeletionRequest>;
  @useResult
  $Res call({
    String? id,
    String userId,
    String email,
    String status,
    @TimestampConverter() DateTime requestedAt,
  });
}

/// @nodoc
class _$DeletionRequestCopyWithImpl<$Res, $Val extends DeletionRequest>
    implements $DeletionRequestCopyWith<$Res> {
  _$DeletionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeletionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? email = null,
    Object? status = null,
    Object? requestedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestedAt: null == requestedAt
                ? _value.requestedAt
                : requestedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeletionRequestImplCopyWith<$Res>
    implements $DeletionRequestCopyWith<$Res> {
  factory _$$DeletionRequestImplCopyWith(
    _$DeletionRequestImpl value,
    $Res Function(_$DeletionRequestImpl) then,
  ) = __$$DeletionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String userId,
    String email,
    String status,
    @TimestampConverter() DateTime requestedAt,
  });
}

/// @nodoc
class __$$DeletionRequestImplCopyWithImpl<$Res>
    extends _$DeletionRequestCopyWithImpl<$Res, _$DeletionRequestImpl>
    implements _$$DeletionRequestImplCopyWith<$Res> {
  __$$DeletionRequestImplCopyWithImpl(
    _$DeletionRequestImpl _value,
    $Res Function(_$DeletionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeletionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? email = null,
    Object? status = null,
    Object? requestedAt = null,
  }) {
    return _then(
      _$DeletionRequestImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestedAt: null == requestedAt
            ? _value.requestedAt
            : requestedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletionRequestImpl implements _DeletionRequest {
  const _$DeletionRequestImpl({
    this.id,
    required this.userId,
    required this.email,
    this.status = 'pending',
    @TimestampConverter() required this.requestedAt,
  });

  factory _$DeletionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeletionRequestImplFromJson(json);

  @override
  final String? id;
  @override
  final String userId;
  @override
  final String email;
  @override
  @JsonKey()
  final String status;
  // 'pending', 'processed'
  @override
  @TimestampConverter()
  final DateTime requestedAt;

  @override
  String toString() {
    return 'DeletionRequest(id: $id, userId: $userId, email: $email, status: $status, requestedAt: $requestedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletionRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, email, status, requestedAt);

  /// Create a copy of DeletionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletionRequestImplCopyWith<_$DeletionRequestImpl> get copyWith =>
      __$$DeletionRequestImplCopyWithImpl<_$DeletionRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeletionRequestImplToJson(this);
  }
}

abstract class _DeletionRequest implements DeletionRequest {
  const factory _DeletionRequest({
    final String? id,
    required final String userId,
    required final String email,
    final String status,
    @TimestampConverter() required final DateTime requestedAt,
  }) = _$DeletionRequestImpl;

  factory _DeletionRequest.fromJson(Map<String, dynamic> json) =
      _$DeletionRequestImpl.fromJson;

  @override
  String? get id;
  @override
  String get userId;
  @override
  String get email;
  @override
  String get status; // 'pending', 'processed'
  @override
  @TimestampConverter()
  DateTime get requestedAt;

  /// Create a copy of DeletionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletionRequestImplCopyWith<_$DeletionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

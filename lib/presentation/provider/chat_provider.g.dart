// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiServiceHash() => r'ac8ae13e9df652cb0ce3ea0fc17dcc00f6f83daf';

/// See also [geminiService].
@ProviderFor(geminiService)
final geminiServiceProvider = AutoDisposeProvider<GeminiService>.internal(
  geminiService,
  name: r'geminiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$geminiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeminiServiceRef = AutoDisposeProviderRef<GeminiService>;
String _$chatRepositoryHash() => r'f946723a1c44ebd86c2cbc25250d37f7202ad362';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$sendMessageUseCaseHash() =>
    r'55850c09b954fe0a47d8b252a0ff70bb6cd6e22b';

/// See also [sendMessageUseCase].
@ProviderFor(sendMessageUseCase)
final sendMessageUseCaseProvider =
    AutoDisposeProvider<SendMessageUseCase>.internal(
      sendMessageUseCase,
      name: r'sendMessageUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sendMessageUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SendMessageUseCaseRef = AutoDisposeProviderRef<SendMessageUseCase>;
String _$messagesStreamHash() => r'96f25ccf3626eebb16dd5761315afda68ccbfad4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [messagesStream].
@ProviderFor(messagesStream)
const messagesStreamProvider = MessagesStreamFamily();

/// See also [messagesStream].
class MessagesStreamFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [messagesStream].
  const MessagesStreamFamily();

  /// See also [messagesStream].
  MessagesStreamProvider call(String agentId) {
    return MessagesStreamProvider(agentId);
  }

  @override
  MessagesStreamProvider getProviderOverride(
    covariant MessagesStreamProvider provider,
  ) {
    return call(provider.agentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'messagesStreamProvider';
}

/// See also [messagesStream].
class MessagesStreamProvider extends AutoDisposeStreamProvider<List<Message>> {
  /// See also [messagesStream].
  MessagesStreamProvider(String agentId)
    : this._internal(
        (ref) => messagesStream(ref as MessagesStreamRef, agentId),
        from: messagesStreamProvider,
        name: r'messagesStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$messagesStreamHash,
        dependencies: MessagesStreamFamily._dependencies,
        allTransitiveDependencies:
            MessagesStreamFamily._allTransitiveDependencies,
        agentId: agentId,
      );

  MessagesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.agentId,
  }) : super.internal();

  final String agentId;

  @override
  Override overrideWith(
    Stream<List<Message>> Function(MessagesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessagesStreamProvider._internal(
        (ref) => create(ref as MessagesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        agentId: agentId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
    return _MessagesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesStreamProvider && other.agentId == agentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, agentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MessagesStreamRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `agentId` of this provider.
  String get agentId;
}

class _MessagesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>>
    with MessagesStreamRef {
  _MessagesStreamProviderElement(super.provider);

  @override
  String get agentId => (origin as MessagesStreamProvider).agentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

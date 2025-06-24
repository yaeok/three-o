// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$agentRepositoryHash() => r'80dee26419ad91016000f62527e3ff84a3fda271';

/// See also [agentRepository].
@ProviderFor(agentRepository)
final agentRepositoryProvider = AutoDisposeProvider<AgentRepository>.internal(
  agentRepository,
  name: r'agentRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$agentRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AgentRepositoryRef = AutoDisposeProviderRef<AgentRepository>;
String _$saveAgentUseCaseHash() => r'c6f59784921e6bfefd457943989b8ec90e17366b';

/// See also [saveAgentUseCase].
@ProviderFor(saveAgentUseCase)
final saveAgentUseCaseProvider = AutoDisposeProvider<SaveAgentUseCase>.internal(
  saveAgentUseCase,
  name: r'saveAgentUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveAgentUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaveAgentUseCaseRef = AutoDisposeProviderRef<SaveAgentUseCase>;
String _$deleteAgentUseCaseHash() =>
    r'58fe7100202d569981994ea5823a96a7fdd72e53';

/// See also [deleteAgentUseCase].
@ProviderFor(deleteAgentUseCase)
final deleteAgentUseCaseProvider =
    AutoDisposeProvider<DeleteAgentUseCase>.internal(
      deleteAgentUseCase,
      name: r'deleteAgentUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deleteAgentUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteAgentUseCaseRef = AutoDisposeProviderRef<DeleteAgentUseCase>;
String _$agentsStreamHash() => r'8cf002552a466361adf8705ec569522d602197de';

/// See also [agentsStream].
@ProviderFor(agentsStream)
final agentsStreamProvider = AutoDisposeStreamProvider<List<Agent>>.internal(
  agentsStream,
  name: r'agentsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$agentsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AgentsStreamRef = AutoDisposeStreamProviderRef<List<Agent>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

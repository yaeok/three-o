// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'1c5f712b40844b55653244e998cf272e0ac00820';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider =
    AutoDisposeProvider<firebase.FirebaseAuth>.internal(
      firebaseAuth,
      name: r'firebaseAuthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$firebaseAuthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseAuthRef = AutoDisposeProviderRef<firebase.FirebaseAuth>;
String _$authRepositoryHash() => r'ecb57762c434dd85a69909b7ff079b2e85967bdc';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$authStateChangesHash() => r'10d52561b19cc24acdd81ac476b70a9e9815947f';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider =
    AutoDisposeStreamProvider<firebase.User?>.internal(
      authStateChanges,
      name: r'authStateChangesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateChangesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateChangesRef = AutoDisposeStreamProviderRef<firebase.User?>;
String _$signUpUseCaseHash() => r'd1bc720af6903bba68758c86d57e65fcc067602e';

/// See also [signUpUseCase].
@ProviderFor(signUpUseCase)
final signUpUseCaseProvider = AutoDisposeProvider<SignUpUseCase>.internal(
  signUpUseCase,
  name: r'signUpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signUpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignUpUseCaseRef = AutoDisposeProviderRef<SignUpUseCase>;
String _$signInUseCaseHash() => r'c6ac204cf3d8d14a9b5a14afd07c9c51c304a5c8';

/// See also [signInUseCase].
@ProviderFor(signInUseCase)
final signInUseCaseProvider = AutoDisposeProvider<SignInUseCase>.internal(
  signInUseCase,
  name: r'signInUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInUseCaseRef = AutoDisposeProviderRef<SignInUseCase>;
String _$appUserStreamHash() => r'a82d99b370feb0814fc1aae173fad682238bc753';

/// See also [appUserStream].
@ProviderFor(appUserStream)
final appUserStreamProvider = AutoDisposeStreamProvider<AppUser?>.internal(
  appUserStream,
  name: r'appUserStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppUserStreamRef = AutoDisposeStreamProviderRef<AppUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

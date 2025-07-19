import 'package:three_o/domain/repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  SignInUseCase(this._authRepository);
  Future<void> execute({
    required String email,
    required String password,
  }) async {
    await _authRepository.signIn(email: email, password: password);
  }
}

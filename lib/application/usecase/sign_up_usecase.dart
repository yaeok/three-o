import 'package:three_o/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;
  SignUpUseCase(this._authRepository);
  Future<void> execute({
    required String email,
    required String password,
  }) async {
    await _authRepository.signUp(email: email, password: password);
    await _authRepository.sendEmailVerification();
  }
}

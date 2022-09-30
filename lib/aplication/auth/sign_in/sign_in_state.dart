part of 'sign_in_bloc.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState({
    required String email,
    required String password,
    required bool isLoading,
    required bool validateErrors,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required Option<Either<UserFailure, User>> failureOrSuccess,
  }) = _Initial;

  factory SignInState.initial() => SignInState(
        email: '',
        password: '',
        isLoading: false,
        validateErrors: false,
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        failureOrSuccess: none(),
      );
}

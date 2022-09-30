part of 'reset_password_bloc.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    required int actualStep,
    required int totalSteps,
    required bool isLoading,
    required String email,
    required int otpCode,
    required String password,
    required String passwordVerified,
    required TextEditingController emailController,
    required TextEditingController otpCodeController,
    required TextEditingController passwordController,
    required TextEditingController passwordVerifyController,
    required Option<Either<UserFailure, Unit>> failureOrSuccessResetPassword,
    required Option<Either<UserFailure, Unit>> failureOrSuccessOtpValidation,
    required Option<Either<UserFailure, Unit>> failureOrSuccessNewPassword,
  }) = _Initial;
  factory ResetPasswordState.initial() => ResetPasswordState(
        actualStep: 0,
        totalSteps: 2,
        isLoading: false,
        email: "",
        password: '',
        passwordVerified: '',
        otpCode: 0,
        failureOrSuccessResetPassword: none(),
        failureOrSuccessOtpValidation: none(),
        failureOrSuccessNewPassword: none(),
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        otpCodeController: TextEditingController(),
        passwordVerifyController: TextEditingController(),
      );
}

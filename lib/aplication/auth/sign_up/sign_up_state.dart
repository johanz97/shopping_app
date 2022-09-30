part of 'sign_up_bloc.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState({
    required int actualStep,
    required bool isLoading,
    required String email,
    required int otpCode,
    required int optCodeFromServer,
    required String password,
    required String passwordVerified,
    required TextEditingController emailController,
    required TextEditingController otpCodeController,
    required TextEditingController passwordController,
    required TextEditingController passwordVerifyController,
    required Option<Either<UserFailure, User>> failureOrSuccessCreateUser,
    required Option<Either<UserFailure, Unit>> failureOrSuccessOtpValidation,
    required Option<Either<UserFailure, Unit>> failureOrSuccessPasswordCreate,
    required Option<Either<UserFailure, Unit>> failureOrSuccessResendOtpCode,
  }) = _Initial;

  factory SignUpState.initial() => SignUpState(
        actualStep: 0,
        email: '',
        failureOrSuccessCreateUser: none(),
        isLoading: false,
        password: '',
        passwordVerified: '',
        otpCode: 0,
        emailController: TextEditingController(),
        otpCodeController: TextEditingController(),
        passwordController: TextEditingController(),
        passwordVerifyController: TextEditingController(),
        failureOrSuccessOtpValidation: none(),
        failureOrSuccessPasswordCreate: none(),
        optCodeFromServer: 0,
        failureOrSuccessResendOtpCode: none(),
      );
}

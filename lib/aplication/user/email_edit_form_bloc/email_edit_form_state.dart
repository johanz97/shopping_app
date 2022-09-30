part of 'email_edit_form_bloc.dart';

@freezed
class EmailEditFormState with _$EmailEditFormState {
  factory EmailEditFormState({
    required int actualStep,
    required int totalSteps,
    required bool isLoading,
    required String email,
    required int otpCode,
    required int optCodeFromServer,
    required TextEditingController emailController,
    required TextEditingController otpCodeController,
    required Option<Either<UserFailure, User>> failureOrSuccessUpdateEmail,
    required Option<Either<UserFailure, Unit>> failureOrSuccessOtpValidation,
    required Option<Either<UserFailure, Unit>> failureOrSuccessResendOtpCode,
  }) = _Initial;

  factory EmailEditFormState.initial() => EmailEditFormState(
        totalSteps: 2,
        failureOrSuccessResendOtpCode: none(),
        actualStep: 0,
        email: '',
        isLoading: false,
        otpCode: 0,
        emailController: TextEditingController(),
        otpCodeController: TextEditingController(),
        failureOrSuccessOtpValidation: none(),
        optCodeFromServer: 0,
        failureOrSuccessUpdateEmail: none(),
      );
}
